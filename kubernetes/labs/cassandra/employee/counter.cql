create table purchase_by_customer_id (
    id uuid primary key,
    purchases counter
);

update purchase_by_customer_id
   set purchases += 1
 where id = uuid();