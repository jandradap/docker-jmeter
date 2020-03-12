#!/bin/bash
#
# Test the JMeter Docker image using a trivial test plan.

# Example for using User Defined Variables with JMeter
# These will be substituted in JMX test script
# See also: http://stackoverflow.com/questions/14317715/jmeter-changing-user-defined-variables-from-command-line
export TARGET_HOST="www.map5.nl"
export TARGET_PORT="80"
export TARGET_PATH="/kaarten.html"
export TARGET_KEYWORD="Kaartdiensten"

set -e
freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))

if [ -z "$JVM_ARGS" ]; then {
  export JVM_ARGS="-Xmn${n}m -Xms${s}m -Xmx${x}m"
}
fi

echo "START Running Jmeter on `date`"
echo "JVM_ARGS=${JVM_ARGS}"

T_DIR=/tmp/test
R_DIR=${T_DIR}/report

rm -rf ${T_DIR}/* > /dev/null 2>&1
mkdir -p ${R_DIR}

cp /test/test-plan.jmx ${T_DIR}/

jmeter -Dlog_level.jmeter=DEBUG \
	-JTARGET_HOST=${TARGET_HOST} -JTARGET_PORT=${TARGET_PORT} \
	-JTARGET_PATH=${TARGET_PATH} -JTARGET_KEYWORD=${TARGET_KEYWORD} \
	-n -t ${T_DIR}/test-plan.jmx -l ${T_DIR}/test-plan.jtl -j ${T_DIR}/jmeter.log \
	-e -o ${R_DIR}

echo "==== jmeter.log ===="
cat ${T_DIR}/jmeter.log

echo "==== Raw Test Report ===="
cat ${T_DIR}/test-plan.jtl

echo "==== HTML Test Report ===="
echo "See HTML test report in ${R_DIR}/index.html"
