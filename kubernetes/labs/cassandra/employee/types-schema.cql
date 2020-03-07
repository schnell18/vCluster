CREATE TABLE types (
  id           int,
  service_type int,
  code         text,
  name         text,
  dummy        int,
  bit_index    int,
  icon_id      int,
  env          text,
  gmt_created  timestamp,
  gmt_modified timestamp,
  version      int,
  abandoned    int,
  PRIMARY KEY (service_type)
);
