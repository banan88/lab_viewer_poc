#!/usr/bin/python

import requests
import json

success_msg = 'success: {0} took {1}ms\n'
failure_msg='failure: {0} took {1}ms: Returned data is different than expected\n'

expected_names = [u'Clab1', u'Clab2', u'Clab3', u'Clab4', u'Clab5']
expected_ids = [1, 2 , 3, 4, 5]
expected_descriptions = [None, u'Clab2 description', None, u'Clab4 description', None]
expected_lab_name = []


def has_all_keys(dict):
    return all (k in dict for k in (u'name', u'id', u'desc') )


def get_all_labs(log_file):
    response = requests.get('http://localhost:8080/labs/')
    list = json.loads( response.text )
    msg = success_msg

    names = []
    ids = []
    descriptions = []

    for dict in list:
        names.append(dict[u'name'])
        ids.append(dict[u'id'])
        descriptions.append(dict[u'desc'])

    if not ( all (x in expected_names for x in names) and
             all (x in expected_descriptions for x in descriptions) and
             all (x in expected_ids for x in ids) ):
        msg=failure_msg

    log_file.write( msg.format(response.url, response.elapsed.total_seconds() * 1000) )


def get_lab_details(log_file):
    response = requests.get('http://localhost:8080/labs/1')
    hash = json.loads( response.text )
    msg = success_msg

    if not (hash[u'id'] == 1 and hash[u'name'] == u'Clab1' and hash[u'desc'] == None):
        msg = failure_msg

    log_file.write( msg.format(response.url, response.elapsed.total_seconds() * 1000) )
