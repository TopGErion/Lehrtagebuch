insert into account(
	-- account_id, --Serial = Automatisch generiert 
	username, --Not null = muss existieren
	email, --Not null = muss auch existieren 
	age, --Kann existieren
	date_of_birth, --Kann auch existieren
	-- registration_date, -- Default = current_time
	is_verified -- Default = false
)

values(
	'maxmustermann', -- = Username
	'muster@mustermail.com', -- = email
	28, --age
	'2005-07-14', -- date_of-birth
	true --is_verified
);

insert into account(
	username,
	email,
	is_verified
)

values(
	'lamsilke', -- = Username
	'lamsilke@silke.com', -- = email
	true --is_verified
);

insert into account(
	username,
	email,
	age,
	date_of_birth,
	is_verified
)

values(
	'riadh', -- = Username
	'riadh@silke.com', -- = email
	15,
	'2011-07-06',
	true --is_verified
);