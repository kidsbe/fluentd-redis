#!/bin/bash

until nc fluentd 24224 <<< "1"; do
  sleep 0.1
done

body='{"a":"b"}'
echo $body | fluent-cat -h fluentd test.test

len=$(redis-cli -h redis --raw llen fluentd)
res=$(redis-cli -h redis --raw lrange fluentd $(($len-1)) $len)

if [ ! "$res" == "$body" ]; then
  echo results differ:
  echo expected = \"$body\"
  echo actual = \"$res\"
  exit 1;
fi;
