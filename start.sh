#!/bin/bash

psql -U postgres -h 127.0.0.1 -d ofoody -c "CREATE TABLE IF NOT EXISTS USERS (id serial PRIMARY KEY, username text NOT NULL, review text, ccn text NOT NULL, address text NOT NULL, password text NOT NULL);"
/usr/lib/postgresql/9.4/bin/createdb -U postgres -h 127.0.0.1 ofoody
