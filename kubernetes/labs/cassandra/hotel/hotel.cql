create keyspace hotel
    with replication = {'class': 'SimpleStrategy', 'replication_factor': 3};

create type hotel.address (
    street text,
    city text,
    state_or_province text,
    postal_code text,
    country text
);

create table hotel.hotels_by_poi (
    poi_name text,
    hotel_id text,
    name text,
    phone text,
    address frozen<address>,
    primary key ((poi_name), hotel_id)
) with comment = 'Q1. Find hotels near given poi'
and clustering order by (hotel_id asc);

create table hotel.hotels (
    id text primary key,
    name text,
    phone text,
    address frozen<address>,
    pois set<text>
) with comment = 'Q2. Find information about a hotel';

create table hotel.pois_by_hotel (
    poi_name text,
    hotel_id text,
    description text,
    primary key ((hotel_id), poi_name)
) with comment = 'Q3. Find pois near a hotel';

create table hotel.available_rooms_by_hotel_date (
    hotel_id text,
    date date,
    room_number smallint,
    is_available boolean,
    primary key ((hotel_id), date, room_number)
) with comment = 'Q4. Find available rooms by hotel / date';

create table hotel.amenities_by_room (
    hotel_id text,
    room_number smallint,
    amenity_name text,
    description text,
    primary key ((hotel_id, room_number), amenity_name)
) with comment = 'Q5. Find amenities for room';