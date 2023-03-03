CREATE DATABASE initialdb;
\c initialdb;

--CREATE USER replicator ENCRYPTED PASSWORD 'replicator';
--CREATE ROLE replication REPLICATION LOGIN PASSWORD 'replication';
--GRANT ALL PRIVILEGES ON DATABASE initialdb TO replication;

CREATE TABLE tabletest (
    name VARCHAR(255) NOT NULL);

CREATE PUBLICATION pub1 FOR TABLE tabletest;

SELECT pg_create_logical_replication_slot('sub1', 'pgoutput');


--------------------------------------------------------

CREATE DATABASE replicationdb;
\c replicationdb;

--GRANT ALL PRIVILEGES ON DATABASE replicationdb TO replication;


CREATE TABLE tabletest (
    name VARCHAR(255) NOT NULL);

CREATE SUBSCRIPTION sub1
        CONNECTION 'host=localhost dbname=initialdb user=postgres password=postgres'
        PUBLICATION pub1
        WITH (create_slot = false);