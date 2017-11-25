#!/bin/bash
#
# IMPORTANT: Change this file only in directory Standalone!

source /opt/bin/functions.sh

export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"

function shutdown {
  kill -s SIGTERM $NODE_PID
  wait $NODE_PID
}

if [ ! -z "$SE_OPTS" ]; then
  echo "appending selenium options: ${SE_OPTS}"
fi

SERVERNUM=$(get_server_num)

rm -f /tmp/.X*lock

necessary=true

while $necessary
do
  xvfb-run -n $SERVERNUM --server-args="-screen 0 $GEOMETRY -ac +extension RANDR" \
    java ${JAVA_OPTS} -jar /opt/selenium/selenium-server-standalone.jar \
    ${SE_OPTS}

  status=$?
  if [ $status -eq 0 ]; then
    echo "clean exit"
    necessary=false
  fi

  if [ $status -eq 130 ]; then
    echo "user hit ctrl+c"
    necessary=false
  fi
done
