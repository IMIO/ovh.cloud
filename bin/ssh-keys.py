#!/usr/bin/env python
# -*- coding: utf-8 -*-
import ovh
import argh
from common import get_projects
from utils import log, setup_logging
from argh.decorators import arg


@arg('--project', help='project name')
def list(**kwargs):
    client = ovh.Client()
    project_name = kwargs.get('project')
    for project in get_projects(project_name):
        for key in client.get('/cloud/project/{}/sshkey'.format(project)):
            log.info(key)

if __name__ == "__main__":
    setup_logging()
    parser = argh.ArghParser()
    parser.add_commands([list])
    parser.dispatch()
