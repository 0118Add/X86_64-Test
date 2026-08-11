#!/bin/sh

/bin/coremark > /tmp/coremark.log

cat /tmp/coremark.log | grep "CoreMark 1.0" | cut -d  "/"  -f 1 | awk '{print $1, $2, $3, int($4)}' > /etc/bench.log
sed -i 's/CoreMark 1.0/ (CpuMark/g'  /etc/bench.log
echo " Scores)" >> /etc/bench.log

if [ -f "/etc/bench.log" ]; then
 sed -i '/coremark/d' /etc/crontabs/root
 crontab /etc/crontabs/root
fi
