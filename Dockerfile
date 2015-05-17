FROM debian:jessie
MAINTAINER Vladislav A. Retivykh <firolunis@riseup.net>
RUN useradd -M -d /home/ofoody ofoody
ADD ofoody /home/ofoody
RUN chown -R ofoody:ofoody /home/ofoody
RUN apt-get update
RUN apt-get install -y nginx postgresql uwsgi uwsgi-plugin-psgi
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf 
RUN cp -f /home/ofoody/conf/pg_hba.conf /etc/postgresql/9.4/main/pg_hba.conf
RUN cp /home/ofoody/conf/ofoody.conf /etc/nginx/sites-enabled/ofoody.conf

CMD service postgresql restart && su -c '/usr/lib/postgresql/9.4/bin/createdb ofoody' postgres && psql -U postgres -h 127.0.0.1 -d ofoody -c "CREATE TABLE IF NOT EXISTS USERS (id serial PRIMARY KEY, username text NOT NULL, review text, ccn text NOT NULL, address text NOT NULL, password text NOT NULL); INSERT INTO USERS VALUES (DEFAULT, 'Cookie Monster', 'Om nom nom nom', '734b12fac1c2875367114a1d42730610', 'The Dark Side of the Moon', 'my_very_secure_password');" && /usr/bin/uwsgi -y /home/ofoody/conf/ofoody.yaml && nginx
