#!/usr/bin/env python
# -*- coding: utf-8 -*-
import ovh
import argh
import pprint
from common import get_projects
from utils import log, setup_logging
from argh.decorators import arg


@arg('--project', help='project name')
def list(**kwargs):
    client = ovh.Client()
    project_name = kwargs.get('project')
    for project in get_projects(project_name):
        for instance in client.get('/cloud/project/{}/instance'.format(project)):
            instance_details = client.get('/cloud/project/{}/instance/{}'.format(project, instance['id']))
            log.info(pprint.pformat(instance_details))


@arg('--project', help='project name')
def remove_all(**kwargs):
    project_name = kwargs.get('project')
    client = ovh.Client()
    for project in get_projects(project_name):
        for instance in client.get('/cloud/project/{}/instance'.format(project)):
            log.warn('Removing instance {}'.format(instance['name']))
            client.delete('/cloud/project/{}/instance/{}'.format(project, instance['id']))


if __name__ == "__main__":
    setup_logging()
    parser = argh.ArghParser()
    parser.add_commands([list, remove_all])
    parser.dispatch()
