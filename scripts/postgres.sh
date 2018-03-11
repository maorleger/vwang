sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update -y
sudo apt-get install postgresql-common -y
sudo apt-get install postgresql-9.5 libpq-dev -y


sudo -u postgres createuser mleger -s

# TODO figure out how to set a default password

