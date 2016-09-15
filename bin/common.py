#!/usr/bin/env python
# -*- coding: utf-8 -*-
import ovh
from utils import memoize


@memoize
def get_projects(project_name=None):
    client = ovh.Client()
    for project in client.get('/cloud/project'):
        project_details = client.get('/cloud/project/{}'.format(project))
        if project_name:
            if project_name != project_details['description']:
                continue
        if project_details['status'] == 'ok':
            yield project
