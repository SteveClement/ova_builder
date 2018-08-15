#! /usr/bin/env bash

CORTEX_URL="http://127.0.0.1:9001"

set -e
LOG_FILE=$(mktemp)

RED='\033[0;31m'
GREEN='\033[0;32m'
BROWN='\033[0;33m'
NC='\033[0m' # No Color

log() {
  echo "${BROWN}$1 ... ${NC}" | tee -a ${LOG_FILE} >&2
}

ok() {
    # echo "${GREEN}OK${NC}" >&2
    echo "OK" >&2
}

ko() {
    # echo "${RED}KO${NC}" >&2
    echo "KO" >&2
}

#SERVICE=$(service --status-all | grep cortex)


check() {
    expected=$1
    shift
    status_code=$(curl -v "$@" -s -o /dev/stderr -w '%{http_code}' 2>>${LOG_FILE}) || true
    if [ "${status_code}" = "${expected}" ]
    then
      ok
    else
      ko
      echo "got ${status_code}, expected ${expected}" >&2
      echo "see more detail in $LOG_FILE" >&2
      exit 1
    fi
}


# Check service is alive
check_service() {
    echo "--- Checking if Cortex service is running"
    sleep 10
    check 200 "$CORTEX_URL/index.html"
}

create_index() {
    # Create the index
    echo "--- Creating Cortex index"
    check 204 -XPOST "$CORTEX_URL/api/maintenance/migrate"
}

create_superadmin() {
    echo "--- Creating Cortex superadmin user"
    check 201 "$CORTEX_URL/api/user" -H 'Content-Type: application/json' -d '
            {
              "login" : "admin",
              "name" : "admin",
              "roles" : [
                  "superadmin"
               ],
              "preferences" : "{}",
              "password" : "thehive1234",
              "organization": "cortex"
            }'
}

create_training_org() {
    echo "--- Creating Cortex training organization"
    check 201 -u admin:thehive1234 "$CORTEX_URL/api/organization" -H 'Content-Type: application/json' -d '
        {
          "name": "training",
          "description": "training organization"
        }'
}

create_training_thehive() {
    echo "--- Creating thehive user"
    check 201 -u admin:thehive1234 "$CORTEX_URL/api/user" -H 'Content-Type: application/json'  -d '
        {
          "login" : "thehive",
          "name" : "thehive",
          "roles" : [
              "read",
              "analyze",
              "orgadmin"
           ],
          "password" : "thehive1234",
          "organization": "training"
        }'
}




update_thehive_configuration() {
    echo "--- Creating thehive api key"
    key=$(curl -s -u admin:thehive1234 "$CORTEX_URL/api/user/thehive/key/renew" -d '')

    check 200 "$CORTEX_URL/api/user/thehive" -H 'Content-Type: application/json' \
        -H "Authorization: Bearer $key"
    echo "--- Updating thehive configuration with Cortex API key"
    sudo sed  -i'.bak' -E "s|^( *key =).*|\1\"$key\"|" /etc/thehive/application.conf && ok
    [ -f /etc/thehive/application.conf.bak ] &&  sudo rm  /etc/thehive/application.conf.bak
    echo "--- Securing Cortex auth method"
    sudo sed  -i'.bak' -E "s|^( *auth.method.basic.*)|#\1|" /etc/cortex/application.conf && ok
    [ -f /etc/cortex/application.conf.bak ] &&  sudo rm  /etc/cortex/application.conf.bak
}

activate_analyzer() {
    echo "--- Activating $1"
    data='{
            "configuration": {
                "check_tlp": false,
                "max_tlp": 2
            },
            "name": '\"$1\"'
        }'
    status_code=$(curl -s -u thehive:thehive1234 "$CORTEX_URL/api/organization/analyzer/$1" \
        -H 'Content-Type: application/json' -d "$data" -o /dev/stderr -w '%{http_code}')

    if [ "${status_code}" = "201" ]
    then
        ok
    else
        ko
    fi

    }

restart_services() {
    echo "--- Restarting thehive"
    sudo service thehive restart && ok
    echo "--- Restarting Cortex"
    sudo service cortex restart && ok
}

check_service
create_index
create_superadmin
create_training_org
create_training_thehive
update_thehive_configuration
activate_analyzer Abuse_Finder_2_0
activate_analyzer File_Info_2_0
activate_analyzer Msg_Parser_2_0
activate_analyzer MaxMind_GeoIP_3_0
restart_services
