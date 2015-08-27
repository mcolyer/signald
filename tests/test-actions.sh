FULL_PATH=$(cd "$(dirname "$0")"; pwd)
source $FULL_PATH/lib.sh

export SIGNALD_QUEUE="/signald-test"

$FULL_PATH/../signald -c $FULL_PATH/config-actions.yml
SIGNALD_PID=$!

set -x
echo -n "Signald starting ..."
for i in `seq 15`; do
  NAME=$(ps -p $SIGNALD_PID -o command)
  if [[ "$NAME" =~ signald:\ primary.* ]]; then
    break
  fi
  sleep 1
done
echo "complete"

rm -f /tmp/signal-activated

begin_test "sending a true signal triggers activation"
(
     set -e
     $FULL_PATH/../bin/signald-send -id=a -value=true

     ret=false
     for i in `seq 15`; do
       if [ -f /tmp/signal-activated ]; then
         ret=true
         break
       fi
       sleep 1
     done
     $ret
)
end_test

rm -f /tmp/signal-deactivated

begin_test "sending a false signal triggers deactivation"
(
     set -e
     $FULL_PATH/../bin/signald-send -id=a -value=false

     ret=false
     for i in `seq 30`; do
       if [ -f /tmp/signal-deactivated ]; then
         ret=true
         break
       fi
       sleep 1
     done
     $ret
)
end_test

kill $SIGNALD_PID >/dev/null 2>/dev/null
