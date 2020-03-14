#!/usr/bin/env python
# -*- coding: UTF-8 -*-

from cassandra.cluster import Cluster

if __name__ == '__main__':
    cluster = Cluster(
        contact_points=[
            'slave-1.kube.vn',
            'slave-2.kube.vn',
            'slave-3.kube.vn'
        ],
        port=31807
    )
    session = cluster.connect('employee')
    cql = '''
    select * from python_test
    '''
    rows = session.execute(cql)
    for row in rows:
        print("%s %s" % (row.first_name, row.last_name))
    print("Finished")

# vim: set ai nu nobk expandtab ts=4 sw=4 tw=80 syntax=python:
