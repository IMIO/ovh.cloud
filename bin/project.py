#!/usr/bin/env python
# -*- coding: utf-8 -*-
import ovh
import argh
from common import get_projects
from utils import setup_logging, log
from argh.decorators import arg


@arg('--project', help='project name')
def create(**kwargs):
    client = ovh.Client()
    project_name = kwargs.get('project')
    if not get_projects(project_name):
        log.info(client.post('/cloud/createProject', description=project_name))


def list(**kwargs):
    client = ovh.Client()
    for project in get_projects():
        project_details = client.get('/cloud/project/{}'.format(project))
        log.info(project_details)


@arg('--project', help='project name')
def remove(**kwargs):
    client = ovh.Client()
    project_name = kwargs.get('project')
    for project in get_projects(project_name):
        client.post('/cloud/project/{}/terminate'.format(project))
        log.info('Removed project {}'.format(project_name))


if __name__ == "__main__":
    setup_logging()
    parser = argh.ArghParser()
    parser.add_commands([create, list, remove])
    parser.dispatch()
