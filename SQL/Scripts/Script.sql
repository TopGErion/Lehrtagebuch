create table account
(
	account_id serial primary key,
	username varchar(50) not null,
	email text unique not null,
	age smallint,
	date_of_birth date,
	registration_date timestamp default current_timestamp,
	is_verified boolean default false
);