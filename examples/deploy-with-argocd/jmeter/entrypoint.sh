#!/bin/bash
#NOW=$(date +"%Y%m%d-%H%M%S")
. /opt/config
echo "PERFORMANCE TEST EXECUTED AT: ${NOW}"

REPORT_DIR="/opt/jmeter/${PROJECT_NAME}/report-${PROJECT_NAME}"
mkdir -p "${REPORT_DIR}"
chmod -R 777 /opt/jmeter/${PROJECT_NAME}

# Run JMeter
${JMETER_BIN}/jmeter -X -d ${JMETER_HOME} -n -j ${LOG_FILE} -l "${RESULTS_FILE}" ${PARAM_USERS_ARGS} -t "${JMX_FILE}" -e -o "${RESULTS_DIR}/report-${PROJECT_NAME}"
END=$(date +"%Y%m%d-%H%M%S")
echo 'PERFORMANCE TEST ENDED AT : '${END}

# Stay in the bash shell
# exec /bin/bash