#!/bin/bash

if [ -n "$DEBUG_LOOP" ]; then
  while true; do
    sleep 1;
  done;
fi;

until nc fluentd 24224 <<< "1"; do
  sleep 0.1
done

#
# test_existing_timestamp
#

body='{"a":"b","timestamp":"some"}'
echo $body | fluent-cat -h fluentd test.test

len=$(redis-cli -h redis --raw llen fluentd)
res=$(redis-cli -h redis --raw lrange fluentd $(($len-1)) $len)

if [ ! "$res" == "$body" ]; then
  echo results differ:
  echo expected = \'$body\'
  echo actual = \'$res\'
  exit 1;
fi;

#
# test_new_timestamp
#

body='{"a":"b"}'
echo $body | fluent-cat -h fluentd test.test

len=$(redis-cli -h redis --raw llen fluentd)
res=$(redis-cli -h redis --raw lrange fluentd $(($len-1)) $len)

if [ "$(echo $res | jq .a)" != "\"b\"" -o "$(echo $res | jq .timestamp)" == "null" ]; then
  echo invalid result: \'$res\'
fi;