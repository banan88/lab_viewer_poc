#!/usr/bin/python

import traceback
import setup_suite
import teardown_suite
import labs_test

def run_tests(log_file):
    labs_test.get_all_labs(log_file)
    labs_test.get_lab_details(log_file)

if __name__ == '__main__':
    setup_suite.setup()
    log_file = setup_suite.open_log_file()

    try:
        run_tests(log_file)
    except Exception, e:
        traceback.print_exc()

    teardown_suite.teardown()
    log_file.close()


