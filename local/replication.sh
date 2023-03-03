echo "Do you want to create a slave cluster? (y/n)"
read response

if [[ "$response" =~ ^[Yy]$ ]]; then
  ######################################################################
    ############################# Slave Part #############################
    ######################################################################

    ## Stop postgresql service
    sudo service postgresql stop

    ## Create new slave cluster
    sudo pg_createcluster 15 slave

    ## Start postgresql service
    sudo service postgresql start

    ## Create replication user
    # CREATE USER replication REPLICATION LOGIN CONNECTION LIMIT 1 ENCRYPTED PASSWORD 'replication';
    ## Alter replication user limit connections
    # ALTER ROLE replication CONNECTION LIMIT -1;
else
  echo "Slave cluster creation canceled"
fi

######################################################################
############################# Master Part ############################
######################################################################

## Stop postgresql service
sudo service postgresql stop

## Edit configuration file 
echo "listen_addresses = 'localhost,158.245.240.209'
wal_level = replica
max_wal_senders = 10
wal_keep_segments = 64" | sudo tee /etc/postgresql/15/main/postgresql.conf -a

## Edit pg_hba.conf file
echo "host    replication     replication     127.0.0.1/32            md5" | sudo tee /etc/postgresql/15/main/pg_hba.conf -a

## Restart postgresql service
sudo service postgresql restart


######################################################################
############################# Slave Part #############################
######################################################################

## Stop postgresql service
sudo service postgresql stop

## Edit configuration file 
echo "listen_addresses = 'localhost,158.245.240.209'
wal_level = replica
max_wal_senders = 10
wal_keep_segments = 64" | sudo tee /etc/postgresql/15/slave/postgresql.conf -a

## Edit pg_hba.conf file
echo "host    replication     replication     127.0.0.1/32            md5" | sudo tee /etc/postgresql/15/slave/pg_hba.conf -a

## Restart postgresql service
sudo service postgresql restart