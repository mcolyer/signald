FULL_PATH=$(cd "$(dirname "$0")"; pwd)
source $FULL_PATH/lib.sh

begin_test "the thing"
(
     set -e
     echo "hello"
     false
)
end_test
