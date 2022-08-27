#!/bin/bash

DKL_DIR=$(pwd)
WORK_DIR="$(cd "$(dirname "$0")" && pwd)"

source $WORK_DIR/_functions.sh

################ ~ ENVIRONEMENT FILE
ENV_TEMPLATE=.env.template 

if [ ! -f .env ]; then
    echo ""
    print_info "- Creating environement file;"
    cp $ENV_TEMPLATE .env
fi

source .env

# Update the package list and upgrade any already-installed packages
print_info "- Updating package list;"
sudo apt update -y

################ ~ SETTING UP POSTGRESQL
print_info "- Setting up postgresql;"
sudo apt install -y libpq-dev python3-dev build-essential
sudo apt install -y postgresql postgresql-14-postgis-3 postgresql-contrib postgresql-client postgresql-server-dev-all

function _psql {
    sudo -u postgres -i psql -c "$1"
}

# Grab database info from .env file
if [ -f .env ]; then
    source .env 
else
    print_error "!! Don't found environnement file: .env"
    exit 1;
fi

# Creating database if not already exists
# https://stackoverflow.com/questions/14549270/check-if-database-exists-in-postgresql-using-shell
if sudo -u postgres -i psql -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
    # database exists
    # $? is 0
    print_info "DELETING OLD $DB_NAME DB"
    _psql "DROP DATABASE $DB_NAME;"
fi

print_info "CREATING A NEW $DB_NAME DB"
_psql "CREATE DATABASE $DB_NAME;"

# https://stackoverflow.com/questions/8546759/how-to-check-if-a-postgres-user-exists
if sudo -u postgres -i psql -t -c '\du' | cut -d \| -f 1 | grep -qw $DB_USER; then
    # user exists
    # $? is 0
    print_info "DELETING OLD $DB_USER USER"
    _psql "DROP USER $DB_USER;"
fi

print_info "CREATING A NEW $DB_USER USER"
_psql "CREATE USER $DB_USER WITH ENCRYPTED PASSWORD '$DB_PASSWORD';"

print_info "GRANTING $DB_USER TO $DB_NAME DB"
_psql "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"
_psql "\connect $DB_NAME;"
_psql "ALTER USER $DB_USER WITH SUPERUSER;" 

################ ~ Verifying installation
if sudo -u postgres -i psql -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; \
    sudo -u postgres -i psql -t -c '\du' | cut -d \| -f 1 | grep -qw $DB_USER; then
    # database exists, user exists and is granted to it
    print_info "INSTALLATION RÉUSSIE"
else
    print_error "IL Y A PEUT-ETRE UN PROBLEME AVEC L'INSTALLATION, VERIFIEZ VOTRE BASE DE DONNEES !!!"
    exit 1;
fi
