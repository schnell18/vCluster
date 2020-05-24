create keyspace reservation
    with replication = {'class': 'SimpleStrategy', 'replication_factor': 3};

create type reservation.address (
    street text,
    city text,
    state_or_province text,
    postal_code text,
    country text
);

create table reservation.reservations_by_hotel_date (
    hotel_id text,
    start_date date,
    end_date date,
    room_number smallint,
    confirm_number text,
    guest_id uuid,
    primary key ((hotel_id, start_date), room_number)
) with comment = 'Q7. Find reservations by hotel and date';

create materialized view reservation.reservations_by_confirmation as
    select *
      from reservation.reservations_by_hotel_date
     where confirm_number is not null
       and hotel_id       is not null
       and start_date     is not null
       and room_number    is not null
    primary key (confirm_number, hotel_id, start_date, room_number);

create table reservation.reservations_by_guest (
    guest_last_name text,
    hotel_id text,
    start_date date,
    end_date date,
    room_number smallint,
    confirm_number text,
    guest_id uuid,
    primary key ((hotel_id, start_date), room_number)
) with comment = 'Q8. Find reservations by guest name';

create table reservation.guests (
    guest_id uuid primary key,
    first_name text,
    last_name text,
    title text,
    emails set<text>,
    phone_numbers list<text>,
    addresses map<text, frozen<address>>,
    confirm_number text
) with comment = 'Q9. Find guest by id';
