######################################################################
###################### Configure APT Repository ######################
######################################################################
sudo sh -c 'echo "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo tee /etc/apt/trusted.gpg.d/pgdg.asc &>/dev/null

sudo apt-get update

##install postgreSQL 14
sudo apt-get -y install postgresql-15 postgresql-client-15

echo "PostgreSQL 15 installed successfully!"
 
# echo "Do you want to upgrade from PostgreSQL 14 to 15? (y/n)"
# read responseUpgrade
# if [[ "$responseUpgrade" =~ ^[Yy]$ ]]; then
#   ######################################################################
# 	##################### Upgrade PostgreSQL(14=>15) #####################
# 	######################################################################

# 	##install postgreSQL latest version (15)
# 	sudo apt-get -y install postgresql-15

# 	##list all postgres versions
# 	dpkg --get-selections | grep postgres

# 	##list all clusters
# 	pg_lsclusters

# 	##stop postgres for upgrade
# 	sudo service postgresql stop

# 	##rename cluster
# 	sudo pg_renamecluster 15 main main_pristine

# 	##upgrade old cluster (14=>15)
# 	sudo pg_upgradecluster 14 main

# 	##start postgres
# 	sudo service postgresql start

# 	pg_lsclusters

# 	##drop old and temp clusters
# 	sudo pg_dropcluster 14 main --stop
# 	sudo pg_dropcluster 15 main_pristine --stop
	
# 	echo "PostgreSQL upgrade to version 15 succeed!"
# else
#   echo "PostgreSQL upgrade canceled"
# fi







######################################################################
############################ Manage Users ############################
######################################################################

#Alter default postgres user password
sudo -u postgres psql -U postgres -d postgres -c "ALTER USER postgres WITH PASSWORD 'postgres';"

echo "PostgreSQL default user password changed to 'postgres'"

echo "To connect to psql, use the following command: psql -h localhost -U postgres [-d dbName]"


##access postgres
#sudo -u postgres psql

##for user assigned to DB
#psql -h localhost -U testuser -d testdb

#alter default postgres user password
#ALTER USER postgres PASSWORD 'postgres';

#create new user with password
#sudo -u postgres createuser --login --pwprompt testuser
#CREATE USER testuser WITH ENCRYPTED PASSWORD 'testuser';

#grant privileges on DB
#GRANT ALL PRIVILEGES ON DATABASE testdb TO testuser;



