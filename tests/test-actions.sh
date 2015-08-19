. lib.sh

begin_test "the thing"
(
     set -e
     echo "hello"
     false
)
end_test
