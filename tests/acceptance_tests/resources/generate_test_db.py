#!/usr/bin/python

import subprocess
import time

remove_existing_test_db = 'rm lab_viewer.db'
create_test_db = 'sqlite3 lab_viewer.db < create_db.sql'
insert_test_data = 'sqlite3 lab_viewer.db < initial_data.sql'

print 'generating test db...'

subprocess.Popen(remove_existing_test_db, shell=True).wait()
subprocess.Popen(create_test_db, shell=True)
time.sleep(2)
subprocess.Popen(insert_test_data, shell=True).wait()

print 'generated test db.'
