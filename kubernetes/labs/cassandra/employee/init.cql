create keyspace employee
    with replication = {'class': 'SimpleStrategy', 'replication_factor': '1'}
    and durable_writes = 'true';

create table employee_by_id(
    id int primary key,
    name text,
    position text
);

insert into employee_by_id(id, name, position)
    values(1, 'John', 'Manager')
;
insert into employee_by_id(id, name, position)
    values(2, 'Bob', 'CEO')
;
insert into employee_by_id(id, name, position)
    values(3, 'Jack', 'CFO')
;
insert into employee_by_id(id, name, position)
    values (4, 'Justin', 'CTO')
;
insert into employee_by_id(id, name, position)
    values (5, 'Jessica', 'Financial Controller')
;
insert into employee_by_id(id, name, position)
    values (6, 'Nick', 'Project Manager')
;
insert into employee_by_id(id, name, position)
    values (7, 'Amy', 'Receptionist')
;
insert into employee_by_id(id, name, position)
    values (8, 'Frank', 'Project Manager')
;

alter table employee_by_id add phone set<text>;

update employee_by_id
   set phone = {'343', '563'}
 where id = 1;

update employee_by_id
 using ttl 60
   set phone = {'433', '653'}
 where id = 2;

update employee_by_id
   set phone = phone + {'555', '666'}
 where id = 1;

update employee_by_id
   set phone = phone - {'555', '666'}
 where id = 1;

update employee_by_id
   set phone -= {'555', '666'}
 where id = 1;

create table employee_by_car_make(
    car_make text,
    id int,
    car_model text,
    primary key(car_make, id)
);

insert into employee_by_car_make(car_make, id, car_model)
    values('BMW', 1, 'Sports Car')
;
insert into employee_by_car_make(car_make, id, car_model)
    values('BMW', 2, 'Sports Car')
;
insert into employee_by_car_make(car_make, id, car_model)
    values('AUDI', 4, 'Truck')
;
insert into employee_by_car_make(car_make, id, car_model)
    values('AUDI', 5, 'Hatchback')
;
insert into employee_by_car_make(car_make, id, car_model)
    values('MERC', 3, 'Saloon')
;
insert into employee_by_car_make(car_make, id, car_model)
    values('MERC', 6, 'Saloon')
;
insert into employee_by_car_make(car_make, id, car_model)
    values('BMW', 7, 'Saloon')
;
insert into employee_by_car_make(car_make, id, car_model)
    values('AUDI', 8, 'Sports Car')
;

create table employee_by_car_make_and_model(
    car_make text,
    id int,
    car_model text,
    name text,
    primary key((car_make, car_model), id)
);

insert into employee_by_car_make_and_model(car_make, car_model, id, name)
    values('BMW','Hatchback', 1, 'John')
;
insert into employee_by_car_make_and_model(car_make, car_model, id)
    values('BMW','Hatchback', 2)
;
insert into employee_by_car_make_and_model(car_make, car_model, id)
    values('BMW','Hatchback', 3)
;
insert into employee_by_car_make_and_model(car_make, car_model, id, name)
    values('BMW','TRUCK', 8, 'Frank')
;
insert into employee_by_car_make_and_model(car_make, car_model, id, name)
    values('AUDI','TRUCK', 7, 'Amy')
;
insert into employee_by_car_make_and_model(car_make, car_model, id, name)
    values('AUDI','Sports Car', 4, 'Tim')
;
insert into employee_by_car_make_and_model(car_make, car_model, id, name)
    values('AUDI','Sports Car', 5, 'Jim')
;
insert into employee_by_car_make_and_model(car_make, car_model, id, name)
    values('AUDI','Sports Car', 8, 'Nick')
;

create table employee_by_car_make_sorted(
    car_make text,
    age int,
    id int,
    name text,
    primary key(car_make, age, id)
);

select * from employee_by_id where id = 1;
select id, name, writetime(position) from employee_by_id where id = 1;

select * from employee_by_id where name = 'Bob' allow filtering;

update employee_by_car_make
   set car_model='TRUCK'
 where car_make='BMW'
   and id = 1;

update employee_by_car_make
 using ttl 60
   set car_model='TRUCK'
 where car_make='BMW'
   and id = 1;

create index on employee_by_id (name);

create table employee_by_uuid(
    id uuid primary key,
    first_name text,
    last_name text
);

insert into employee_by_uuid (id, first_name, last_name)
    values (uuid(), 'tom', 'dunne')
;
insert into employee_by_uuid (id, first_name, last_name)
    values (uuid(), 'tim', 'smith')
;
insert into employee_by_uuid (id, first_name, last_name)
    values (uuid(), 'bob', 'hanson')
;

create table employee_by_timeuuid(
    id timeuuid primary key,
    first_name text,
    last_name text
);

insert into employee_by_timeuuid (id, first_name, last_name)
    values (now(), 'tom', 'dunne')
;
insert into employee_by_timeuuid (id, first_name, last_name)
    values (now(), 'tim', 'smith')
;
insert into employee_by_timeuuid (id, first_name, last_name)
    values (now(), 'bob', 'hanson')
;