#!/usr/bin/env python
# -*- coding: utf-8 -*-


def connect(self):
    conninfo = {'hostname': self.hostname,
                'port': self.port,
                'username': self.username,
                'allow_agent': True,
                'look_for_keys': False}

    if self.password:
        conninfo['password'] = self.password

    if self.key_files:
        conninfo['key_filename'] = self.key_files

    if self.key_material:
        conninfo['pkey'] = self._get_pkey_object(key=self.key_material)

    if not self.password and not (self.key_files or self.key_material):
        conninfo['allow_agent'] = True
        conninfo['look_for_keys'] = True

    if self.timeout:
        conninfo['timeout'] = self.timeout

    extra = {'_hostname': self.hostname, '_port': self.port,
             '_username': self.username, '_timeout': self.timeout}
    self.logger.debug('Connecting to server', extra=extra)

    self.client.connect(**conninfo)
    return True

from libcloud.compute.ssh import ParamikoSSHClient
ParamikoSSHClient.connect = connect
