#! /usr/bin/env bash

THEHIVE_URL="http://127.0.0.1:9000"

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
    echo "--- Checking if TheHive service is running"
    sleep 120
    check 200 "$THEHIVE_URL/index.html"
}

create_index() {
    # Create the index
    echo "--- Creating TheHive index"
    check 204 -XPOST "$THEHIVE_URL/api/maintenance/migrate" 
}

create_admin() {
    echo "--- Creating TheHive admin user"
    check 201 "$THEHIVE_URL/api/user" -H 'Content-Type: application/json' -d '
            {
              "login" : "admin",
              "name" : "admin",
              "roles" : [
                  "read",
                  "write",
                  "admin"
               ],
              "password" : "thehive1234"
            }'
}

add_templates() {
    key=$1
    echo "--- Downloading report templates"
    wget https://dl.bintray.com/cert-bdf/thehive/report-templates.zip -O /tmp/report-templates.zip
    sleep 10
    [ -f /tmp/report-templates.zip ] && echo "--- templates downloaded"
    [ -f /tmp/report-templates.zip ] && \
    check 100 "$THEHIVE_URL/api/connector/cortex/report/template/_import" -H 'Connection: keep-alive' \
    -F "templates=@/tmp/report-templates.zip" -H "Authorization: Bearer $key"
}

update_thehive_configuration() {
    echo "--- Creating thehive api key"
    key=$(curl -s -u admin:thehive1234 "$THEHIVE_URL/api/user/admin/key/renew" -d '')

    check 200 "$THEHIVE_URL/api/user/admin" -H 'Content-Type: application/json' \
        -H "Authorization: Bearer $key"

    add_templates $key

    echo "--- Securing TheHive auth method"
    sudo sed  -i'.bak' -E "s|^( *method.basic.*)|#\1|" /etc/thehive/application.conf && ok
    [ -f /etc/thehive/application.conf.bak ] &&  sudo rm  /etc/thehive/application.conf.bak
}


restart_services() {
    echo "--- Restarting thehive"
    sudo service thehive restart && ok
} 
check_service
create_index
create_admin
update_thehive_configuration
restart_services
