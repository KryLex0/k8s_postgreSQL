pg_lsclusters

echo "Do you want to recreate an empty cluster? (y/n)"
read response

if [[ "$response" =~ ^[Yy]$ ]]; then
    ######################################################################
    ########################### Create Cluster ###########################
    ######################################################################

    sudo pg_dropcluster 15 main --stop

    ## Create new cluster
    sudo pg_createcluster 15 main

    echo "wal_level = logical" | sudo tee -a /etc/postgresql/15/main/postgresql.conf

    ## Start postgresql service
    sudo service postgresql restart

    ## Create role user for replication
    # CREATE ROLE user_name REPLICATION LOGIN PASSWORD 'my_pass123';
    ## Alter replication user limit connections
    # ALTER ROLE replication CONNECTION LIMIT -1;

    echo "Cluster created and configured!"
else
  echo "Slave cluster creation canceled"
fi
