#!/bin/bash
# vim: expandtab:ts=4:sw=4

# ##############################################################################
# this code is based on:
# https://github.com/kamailio/kamailio/blob/master/utils/kamctl/kamdbctl.pgsql
#
# Note the script is not logging the output of the psql command, due to password
# being in the command. If you want to see the output, remove the redirection


# user,db1:table_group1/dbN:table_groupN
users=(
    "kibp,kibpdb_au_anycast1:rw/kibpdb_au_anycast2:rw/kibpdb_eu_anycast1:rw/kibpdb_eu_anycast2:rw/kibpdb_ca_anycast1:rw/kibpdb_ca_anycast2:rw/kibpdb_us_anycast1:rw/kibpdb_us_anycast2:rw/shareddb_ro:ro"
    "kss,kssdb_au:rw/kssdb_eu:rw/kssdb_ca:rw/kssdb_us:rw"
    "rss,kssdb_au:ro/kssdb_eu:ro/kssdb_ca:ro/kssdb_us:ro"
    "sbc,msteamsdb_dr_eu1:rw/msteamsdb_dr_us1:rw/msteamsdb_oc_eu1:rw/msteamsdb_oc_eu2:rw/msteamsdb_oc_us1:rw/msteamsdb_oc_us2:rw"
)

# password needs to be configured independently due to possible special chars
declare -A PASSWORD=(
    ['kibp']="$KIBP_PASSWORD"
    ['kss']="$KSS_PASSWORD"
    ['rss']="$RSS_PASSWORD"
    ['sbc']="$SBC_PASSWORD"
)

# query to check the grants
check="
SELECT grantee AS user, CONCAT(table_schema, '.', table_name) AS table,
    CASE
        WHEN COUNT(privilege_type) = 7 THEN 'ALL'
        ELSE ARRAY_TO_STRING(ARRAY_AGG(privilege_type), ', ')
    END AS grants
FROM information_schema.role_table_grants
WHERE table_schema='public' AND
  grantee != 'postgres'
GROUP BY table_name, table_schema, grantee;
"

scriptfile=$(mktemp)

# Debugging information
echo "#########################################################################"
echo "# Create users                                                           "
echo "#########################################################################"

echo "The script file (with the SQL commands) is $scriptfile."

# Prepare the .sql file.
# The ON_ERROR_STOP is used to make sure that the psql command fails if there's an error.
echo "\set ON_ERROR_STOP true"                                     > $scriptfile

success=false

for user_config in ${users[@]}; do
    # parse the user config as an array
    IFS=',' read -a user_array <<< "$user_config"

    # creare users
    user=${user_array[0]}
    echo "CREATE USER $user WITH PASSWORD '${PASSWORD[$user]}';"  >> $scriptfile

    # parse the user DBs as an array
    IFS='/' read -a db_array <<< "${user_array[1]}"
    for db in ${db_array[@]}; do
        # parse the db config as an array
        IFS=':' read -a db <<< "$db"

        echo "\c ${db[0]}"                                        >> $scriptfile
        # GRANT PRIVILEGES
        if [ ${db[1]} = "rw" ]; then
            echo "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $user;"      >> $scriptfile
            echo "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO $user;"   >> $scriptfile
        else
            echo "GRANT SELECT ON ALL TABLES IN SCHEMA public TO $user;"              >> $scriptfile
            echo "GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO $user;"           >> $scriptfile
        fi

        # Show priveledge per table/user
        echo "$check" >>                                           $scriptfile
    done
done

#&> /dev/null

    # Run the query from the SQL file.
    if psql -U postgres -a -f $scriptfile ; then
        success=true
    fi
    rm $scriptfile


echo "#########################################################################"
if $success; then
    echo "SUCCESS: Granting user privileges was successful!"
else
    echo "WARNING: Granting user privileges was NOT successful!"
fi
echo "#########################################################################"
