#!/usr/bin/env python
# -*- coding: utf-8 -*-
from libcloud.compute import providers, deployment
from libcloud.compute.types import Provider
from tabulate import tabulate
import threading
import argh
import ovh
import yaml
from common import get_projects
from utils import memoize, get_environ
import patch  # NOQA


def openstack_client():
    USER = get_environ('OS_USERNAME')
    PASSWORD = get_environ('OS_PASSWORD')
    TENANT_NAME = get_environ('OS_TENANT_NAME')
    AUTH_URL = get_environ('OS_AUTH_URL')
    REGION = get_environ('OS_REGION_NAME')
    OpenStack = providers.get_driver(Provider.OPENSTACK)
    driver = OpenStack(USER, PASSWORD,
                       ex_force_auth_url='{}/tokens'.format(AUTH_URL),
                       ex_force_auth_version='2.0_password',
                       ex_tenant_name=TENANT_NAME,
                       ex_force_service_region=REGION)
    return driver


def config(project_file):
    with open(project_file, 'r') as stream:
        cfg = yaml.load(stream)
        return cfg


def create_network(client, project, name, cidr, first, last, location, vlanId):
    networks = client.get('/cloud/project/{}/network/private'.format(project))
    if name in [net['name'] for net in networks]:
        return

    if not networks:
        print client.post('/cloud/project/{}/network/private'.format(project),
                          name=name,
                          vlanID=vlanId)
        networks = client.get('/cloud/project/{}/network/private'.format(project))
    networkId = networks[0]['id']
    print networks

    subnets = client.get('/cloud/project/{}/network/private/{}/subnet'.format(project, networkId))
    if not subnets:
        print client.post('/cloud/project/{}/network/private/{}/subnet'.format(project, networkId),
                          dhcp=True,
                          start=first,
                          network=cidr,
                          region=location,
                          end=last)
    print subnets


def create_key(cli, name, value):
    if name not in [kp.name for kp in cli.list_key_pairs()]:
        cli.import_key_pair_from_string(name, value)


@memoize
def get_image(cli, name):
    for image in cli.list_images():
        if image.name == name:
            return image


@memoize
def get_sizes(cli, name):
    for size in cli.list_sizes():
        if size.name == name:
            return size


@memoize
def get_network(cli, name):
    for net in cli.ex_list_networks():
        if net.name == name:
            return net
    raise KeyError('Network unknown: {}'.format(name))


def create_node(name, size, image, networks, ssh_key, deploy_steps=[]):
    print 'creating {}'.format(name)
    cli = openstack_client()
    if networks > 1:
        deploy_steps.append(deployment.ScriptDeployment('sudo dhclient ens4'))
    cli.deploy_node(name=name, image=image, size=size, ex_keyname=ssh_key,
                    ssh_username='ubuntu',
                    networks=networks, deploy=deployment.MultiStepDeployment(deploy_steps))


def create_networks(ovh_client, cfg):
    for network_name, net_cfg in cfg['networks'].items():
        create_network(ovh_client, get_projects(cfg['project']).next(), network_name,
                       cidr=net_cfg['cidr'], first=net_cfg['first'],
                       last=net_cfg['last'], location=net_cfg['location'],
                       vlanId=net_cfg['vlan-id'])


def create_keys(cli, cfg):
    for key_name, key_value in cfg['ssh-keys'].items():
        create_key(cli, key_name, key_value)


def create_nodes(cli, cfg):
    threads = []
    for node_name, node_details in cfg['nodes'].items():
        if node_name not in [node.name for node in cli.list_nodes()]:
            networks = [get_network(cli, net) for net in node_details['networks']]
            t = threading.Thread(target=create_node, args=(
                (node_name, get_sizes(cli, node_details['size']),
                 get_image(cli, node_details['image']),
                 networks, node_details['ssh-key'])))
            t.daemon = True
            t.start()
            threads.append(t)
    for t in threads:
        t.join()


def get_first(iterable, default=None):
    if iterable:
        for item in iterable:
            return item
    return default


def list(project_file):
    cli = openstack_client()
    cfg = config(project_file)
    ovh_cli = ovh.Client()
    nodes = [(node.name, get_first(node.public_ips, ''), get_first(node.private_ips, ''), node.state)
             for node in cli.list_nodes() if node.name in cfg['nodes'].keys()]
    print 'nodes:'
    print tabulate(nodes, headers=['name', 'public ip', 'private ip', 'state'])
    keys = [(kp.name, kp.fingerprint) for kp in cli.list_key_pairs() if kp.name in cfg['ssh-keys']]
    if keys:
        print '\nkeys:'
        print tabulate(keys, headers=['name', 'fingerprint'])
    project = get_projects(cfg['project']).next()
    networks = [(network['id'], network['name'], network['type']) for network in ovh_cli.get('/cloud/project/{}/network/private'.format(project))
                if network['name'] in cfg['networks'].keys()]
    if networks:
        print '\nnetworks:'
        print tabulate(networks, headers=['id', 'name', 'type'])
        print '\nsubnets:'
        all_subnets = []
        for network in networks:
            all_subnets.extend([(network[1], subnet['id'], subnet['cidr'], subnet['ipPools'][0]['region'])
                                for subnet in ovh_cli.get('/cloud/project/{}/network/private/{}/subnet'.format(project, network[0]))])
        print tabulate(all_subnets, headers=['network', 'subnet id', 'cidr', 'region'])


def remove(project_file):
    cli = openstack_client()
    cfg = config(project_file)
    nodes = [node for node in cli.list_nodes() if node.name in cfg['nodes'].keys()]
    for node in nodes:
        node.destroy()
        print 'node {} destroyed'.format(node.name)


def create(project_file):
    os_cli = openstack_client()
    cfg = config(project_file)
    ovh_cli = ovh.Client()
    create_keys(os_cli, cfg)
    create_networks(ovh_cli, cfg)
    create_nodes(os_cli, cfg)


def main():
    parser = argh.ArghParser()
    parser.add_commands([list, remove, create])
    parser.dispatch()


if __name__ == '__main__':
    main()
