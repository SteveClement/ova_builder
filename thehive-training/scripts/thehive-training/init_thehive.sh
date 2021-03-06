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



add_templates() {
    key=$1
    echo "--- Downloading report templates"
    wget https://dl.bintray.com/thehive-project/binary/report-templates.zip -O /tmp/report-templates.zip
    sleep 10
    [ -f /tmp/report-templates.zip ] && echo "--- templates downloaded"
    [ -f /tmp/report-templates.zip ] && \
    check 200 "$THEHIVE_URL/api/connector/cortex/analyzer/template/_import" -H 'Connection: keep-alive' \
    -F "templates=@/tmp/report-templates.zip" -H "Authorization: Bearer $key"
}

update_thehive_configuration() {
    echo "--- Creating thehive api key"
    key=$(curl -s -u admin@thehive.local:secret "$THEHIVE_URL/api/user/admin/key/renew" -d '')

    check 200 "$THEHIVE_URL/api/user/admin" -H 'Content-Type: application/json' \
        -H "Authorization: Bearer $key"

    add_templates $key

}


restart_services() {
    echo "--- Restarting thehive"
    sudo service thehive restart && ok
    sleep 60
} 
check_service
update_thehive_configuration
restart_services
