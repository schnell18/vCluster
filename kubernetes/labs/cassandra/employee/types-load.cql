copy types (
  id           ,
  service_type ,
  code         ,
  name         ,
  dummy        ,
  bit_index    ,
  icon_id      ,
  env          ,
  gmt_created  ,
  gmt_modified ,
  version      ,
  abandoned
)
from '/work/labs/cassandra/employee/types.csv'
with delimiter='|';