#!/usr/bin/env python

from cassandra.cluster import Cluster

cluster = Cluster(['127.0.0.1'])
session = cluster.connect('hotel')
session.execute("""
  insert into hotels (id, name, phone)
  values (%s, %s, %s)
""",
  ('AZ123', 'Super Hotel at WestWorld', '1-888-999-9999')
)