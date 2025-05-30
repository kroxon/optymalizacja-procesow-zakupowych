#!/bin/bash

DB_NAME="optymalizacja_zakupow"
DB_USER="postgres"
DB_HOST="localhost"
DB_PORT="5432"

SCHEMA_FILE="./src/sql/schema.sql"
PROCEDURES_FILE="./src/sql/procedures.sql"
TRIGGERS_FILE="./src/sql/triggers.sql"
USERS_SCRIPT="./src/sql/users.sql"
INITIAL_DATA_FILE="./src/sql/dane_przykladowe.sql"

echo "Rozpoczynam konfigurację bazy danych '$DB_NAME'..."

# Sprawdzanie, czy baza danych istnieje
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d template1 -c "\l" | grep -q "$DB_NAME"
if [ $? -ne 0 ]; then
    echo "BŁĄD: Baza danych '$DB_NAME' nie istnieje. Proszę najpierw uruchomić reset_db.sh"
    exit 1
fi

psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f $SCHEMA_FILE
if [ $? -ne 0 ]; then
    echo "Nie można załadować schematu."
    exit 1
fi
echo "Schemat załadowany pomyślnie."

if [ -f "$INITIAL_DATA_FILE" ]; then
    psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f $INITIAL_DATA_FILE
    if [ $? -ne 0 ]; then
        echo "Nie można załadować danych początkowych."
        exit 1
    fi
    echo "Dane początkowe zostały załadowane."

fi

psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f $PROCEDURES_FILE
if [ $? -ne 0 ]; then
    echo "Nie można załadować procedur."
    exit 1
fi
echo "Procedury załadowane pomyślnie."

psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f $TRIGGERS_FILE
if [ $? -ne 0 ]; then
    echo "Nie można załadować triggerów."
    exit 1
fi
echo "Triggery załadowane pomyślnie."

psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f $USERS_SCRIPT
if [ $? -ne 0 ]; then
    echo "Nie można załadować użytkowników."
    exit 1
fi
echo "Użytkownicy utworzeni pomyślnie."


echo "Konfiguracja bazy danych '$DB_NAME' zakończona."