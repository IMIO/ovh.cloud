#!/usr/bin/env python
# -*- coding: utf-8 -*-
import ovh


def get_projects(project_name=None):
    client = ovh.Client()
    for project in client.get('/cloud/project'):
        if project_name:
            project_details = client.get('/cloud/project/{}'.format(project))
            if project_name != project_details['description']:
                continue
        yield project
