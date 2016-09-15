#!/usr/bin/env python
# -*- coding: utf-8 -*-
import colorlog
import fcntl
import logging
import sys


def setup_logging():
    fileHandler = logging.FileHandler("clean.log")
    logFormatter = logging.Formatter("%(asctime)s %(message)s")
    fileHandler.setFormatter(logFormatter)
    log.addHandler(fileHandler)

    consoleHandler = colorlog.StreamHandler()
    formatter = colorlog.ColoredFormatter('%(log_color)s%(message)s',
                                          reset=True,
                                          log_colors={
                                              'DEBUG': 'cyan',
                                              'INFO': 'green',
                                              'WARNING': 'red',
                                              'ERROR': 'red',
                                              'CRITICAL': 'red,bg_white'})
    consoleHandler.setFormatter(formatter)
    log.addHandler(consoleHandler)


log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)

file_handle = None


def file_is_locked(file_path):
    global file_handle
    file_handle = open(file_path, 'w')
    try:
        fcntl.lockf(file_handle, fcntl.LOCK_EX | fcntl.LOCK_NB)
        return False
    except IOError:
        return True


def memoize(f):
    """ Memoization decorator for functions taking one or more arguments. """

    class memodict(dict):

        def __init__(self, f):
            self.f = f

        def __call__(self, *args):
            return self[args]

        def __missing__(self, key):
            ret = self[key] = self.f(*key)
            return ret
    return memodict(f)


def singleton():
    if file_is_locked('/code/lock'):
        log.warn('another instance is running exiting now')
        sys.exit(1)
