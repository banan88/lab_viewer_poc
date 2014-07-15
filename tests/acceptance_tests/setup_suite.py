#!/usr/bin/python

import os
import shutil
import subprocess
import signal
import time
from system_credentials import pwd


cmd_extract_requests_lib = 'tar -xvzf kennethreitz-requests-v2.3.0-54-g39f0c66.tar.gz'
cmds_install_requests_lib_as_root = ['sudo', '-kS','python', 'setup.py', 'install']


def is_requests_lib_installed():
    is_installed = True
    try:
        import requests
    except ImportError:
        is_installed = False
    return is_installed


def try_to_install_dependencies():
    if not is_requests_lib_installed():
        print 'requests library not available, installing...'
        self_relative_path = os.path.dirname(__file__)
        os.chdir(self_relative_path)
        os.chdir('./resources/test_dependencies/')
        subprocess.Popen(cmd_extract_requests_lib, shell=True, stdout=subprocess.PIPE).wait()
        os.chdir('./kennethreitz-requests-39f0c66')
        proc = subprocess.Popen(cmds_install_requests_lib_as_root, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr= subprocess.PIPE)
        err = proc.communicate(pwd + '\n')
        proc.wait()
        if str(err).find('Finished processing dependencies for requests') == -1:
            raise Exception ('requests lib installation failed: ' + str(err))
        else:
            print 'requests lib installed successfully.'


def stop_server_if_running():
    p1 = subprocess.Popen(['ps', 'aux'], stdout=subprocess.PIPE)
    p2 = subprocess.Popen(['grep', 'lab_viewer_server.pl' ], stdin=p1.stdout, stdout=subprocess.PIPE)
    output_as_list = p2.communicate()[0].split()

    for process_info in list(create_chunks(output_as_list, 12)):
        if 'lab_viewer_server.pl' in process_info[-1] and '/usr/bin/perl' in process_info[-2]:
            print 'killing server...'
            os.kill( int(process_info[1]) , signal.SIGQUIT)
            print 'server killed.'


def create_chunks(list, chunk_size):
    for i in xrange(0, len(list), chunk_size):
        yield list[i:i+chunk_size]


def start_server():
    self_relative_path = os.path.dirname(__file__)
    os.chdir(self_relative_path)
    os.chdir('../../source/')
    subprocess.Popen(['./lab_viewer_server.pl'])
    time.sleep(1)


def prepare_test_db_file():
    print 'replacing production db file with test one...'

    self_relative_path = os.path.dirname(__file__)
    os.chdir(self_relative_path)
    self_absolute_path = os.getcwd()
    os.chdir('../../db')
    db_path = os.getcwd()
    os.rename('lab_viewer.db', 'lab_viewer.db_copy')
    os.chdir(self_absolute_path)
    os.chdir('./resources')
    shutil.copy('lab_viewer.db', db_path)

    print 'production database file replaced.'


def open_log_file():
    self_relative_path = os.path.dirname(__file__)
    os.chdir(self_relative_path)
    return open(os.getcwd() +'/reports/log.txt','w')


def setup():
    try_to_install_dependencies()
    stop_server_if_running()
    prepare_test_db_file()
    start_server()

if __name__ == '__main__':
    setup()

