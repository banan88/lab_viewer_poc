#!/usr/bin/python

import os
import setup_suite

def remove_test_db_file():
    print 'removing test db file...'
    self_relative_path = os.path.dirname(__file__)
    os.chdir(self_relative_path)
    self_absolute_path = os.getcwd()
    os.chdir('../../db')
    db_path = os.getcwd()
    os.remove(db_path + '/lab_viewer.db')
    print 'test db file removed.'
    print 'renaming production db file back...'
    os.rename('lab_viewer.db_copy', 'lab_viewer.db')
    print 'production db file renamed to original.'

def stop_server():
    setup_suite.stop_server_if_running()

def close_log_file():
    print 'log file closed'

def teardown():
    stop_server()
    remove_test_db_file()