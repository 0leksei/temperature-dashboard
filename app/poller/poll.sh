#!/bin/sh

xml=$(curl --silent https://www.ilmateenistus.ee/ilma_andmed/xml/observations.php |\
  xmllint --xpath '//station[name="Tallinn-Harku"]/airtemperature/text()' -)

cat <<EOF | curl --data-binary @- http://pushgateway:9091/metrics/job/temperature/instance/tallinn
# TYPE temperature gauge
temperature $xml
EOF
