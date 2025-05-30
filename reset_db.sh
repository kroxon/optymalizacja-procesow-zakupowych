#!/bin/bash

DB_NAME="optymalizacja_zakupow"
DB_USER="postgres"
DB_HOST="localhost"
DB_PORT="5432"

dropdb -h $DB_HOST -p $DB_PORT -U $DB_USER --if-exists $DB_NAME
if [ $? -ne 0 ]; then
    echo "Nie można usunąć bazy danych."
    exit 1
fi

createdb -h $DB_HOST -p $DB_PORT -U $DB_USER $DB_NAME
if [ $? -ne 0 ]; then
    echo "Nie można utworzyć bazy danych."
    exit 1
fi

echo "Reset bazy danych '$DB_NAME' zakończony."