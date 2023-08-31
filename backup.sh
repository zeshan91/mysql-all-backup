#!/bin/bash

# Prompt for MySQL credentials
read -p "Enter MySQL username: " DB_USER
read -s -p "Enter MySQL password: " DB_PASS
echo

# Create backup directory with current date
CURRENT_DATE=$(date +%Y%m%d%H%M%S)
BACKUP_DIR="./$CURRENT_DATE"
mkdir -p "$BACKUP_DIR"

# Get a list of all databases
DATABASES=$(mysql -u "$DB_USER" -p"$DB_PASS" -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql)")

# Loop through each database and create backups
for DB in $DATABASES; do
    BACKUP_FILE="$BACKUP_DIR/$DB.sql"
    mysqldump -u "$DB_USER" -p"$DB_PASS" --routines "$DB" > "$BACKUP_FILE"
    if [ $? -eq 0 ]; then
        echo "Backup of database $DB completed successfully."
    else
        echo "Error backing up database $DB."
    fi
done

echo "All database backups completed. Backup files are stored in: $BACKUP_DIR"

