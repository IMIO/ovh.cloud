#!/usr/bin/env python
# -*- coding: utf-8 -*-
import argh
import ovh
from argh.decorators import arg
from common import get_projects


@arg('--project', help='project name')
def list(**kwargs):
    cli = ovh.Client()
    project_name = kwargs.get('project')
    project_id = get_projects(project_name).next()
    networks = cli.get('/cloud/project/{}/network/private'.format(project_id))
    print networks


@arg('--project', help='project name')
@arg('--id', help='network id')
def remove(**kwargs):
    cli = ovh.Client()
    project_name = kwargs.get('project')
    network_id = kwargs.get('id')
    project_id = get_projects(project_name).next()
    cli.delete('/cloud/project/{}/network/private/{}'.format(project_id, network_id))


def create():
    pass


def main():
    parser = argh.ArghParser()
    parser.add_commands([list, remove, create])
    parser.dispatch()


if __name__ == '__main__':
    main()
