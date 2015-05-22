O'Foody
=======

SibirCTF 2015 O'Foody service

Installation
------------

Required: nginx, postgresql, uwsgi, uwsgi-plugin-psgi

Install dependencies:
```
apt-get update
apt-get install -y nginx postgresql uwsgi uwsgi-plugin-psgi
```

Create user and directory:
```
useradd -M -d /home/ofoody ofoody
```

Place repository content to /home/ofoody and change owner:
```
chown -R ofoody:ofoody /home/ofoody
```

Copy configuration files:
```
cp -f /home/ofoody/conf/pg_hba.conf /etc/postgresql/9.4/main/pg_hba.conf
cp /home/ofoody/conf/ofoody.conf /etc/nginx/sites-enabled/ofoody.conf
```

Create log files:
```
mkdir /home/ofoody/logs
touch /home/ofoody/logs/ofoody.access.log
touch /home/ofoody/logs/ofoody.error.log
```

Run nginx:
```
service nginx restart
```

Run postgresql:
```
service postgresql restart
```

Create ofoody database:
```
/usr/lib/postgresql/9.4/bin/createdb -U postgres -h 127.0.0.1 ofoody
```

Create ofoody table:
```
psql -U postgres -h 127.0.0.1 -d ofoody -c "CREATE TABLE IF NOT EXISTS USERS (id serial PRIMARY KEY, username text NOT NULL, review text, ccn text NOT NULL, address text NOT NULL, password text NOT NULL);"
```

Insert first record:
```
psql -U postgres -h 127.0.0.1 -d ofoody -c "INSERT INTO USERS VALUES (DEFAULT, 'Cookie Monster', 'Om nom nom nom', '734b12fac1c2875367114a1d42730610', 'The Dark Side of the Moon', 'my_very_secure_password');"
```

Run uwsgi:
```
/usr/bin/uwsgi -y /home/ofoody/conf/ofoody.yaml
```

Usage
-----

Start uwsgi:
```
/usr/bin/uwsgi -y /home/ofoody/conf/ofoody.yaml
```

Restart uwsgi:
```
touch /home/ofoody/uwsgi
```

Restart nginx:
```
service postgresql restart
```

Restart postgresql:
```
service postgresql restart
```

Checker
=======

checker.pl

URL
---

http://host:9999

Checker input params
--------------------

```
$1 = CMD
$2 = HOST
$3 = ID
$4 = FLAG
```

Example checker call
--------------------

```
#!/bin/bash

echo "TEST CHECK"
./checker.pl check 127.0.0.1
echo "TEST PUT"
./checker.pl put 127.0.0.1 testuser 734b12fac1c2875367114a1d42730610
echo "TEST GET"
./checker.pl get 127.0.0.1 testuser 734b12fac1c2875367114a1d42730610
```

Exit codes
----------
```
110 - Need more arguments
104 - Host unreachable
103 - Bad answer
102 - Flag not found
101 - OK
```

Credits
-------

Vladislav A. Retivykh

License
-------

You may distribute under the terms of the GNU General Public License
