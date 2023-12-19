CREATE DATABASE kamailio;
\c kamailio
\i /docker-entrypoint-initdb.d/standard-create.sql.inc
\i /docker-entrypoint-initdb.d/topos-create.sql.inc
