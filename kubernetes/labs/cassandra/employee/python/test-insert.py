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
        port=31392
    )
    session = cluster.connect('employee')
    create_table = '''
    create table python_test(
        id uuid primary key,
        first_name text,
        last_name text
    )
    '''
    session.execute(create_table)
    insert = '''
    insert into python_test(id, first_name, last_name)
    values (uuid(), %s, %s)
    '''
    names = [('bob', 'dylan'), ('jack', 'sparrow'), ('jason', 'boune')]
    for name in names:
        session.execute(insert, name)
    print("Finished")

# vim: set ai nu nobk expandtab ts=4 sw=4 tw=80 syntax=python:
