#!/bin/bash
https=http://localhost
content=`curl $https -k -s -f `
# echo "$content"
if [[ $content =~ "das-web" ]]; then
  echo "Web container is up, nothing to do"
  else
  echo "web container is down, getting up ..."
  cd  /home/noroot/code/workspace/docker-compose-laravel
  docker-compose down
  docker-compose up -d
fi


CURRENT=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
THRESHOLD=90
echo "HDD usage: $CURRENT"
if [ "$CURRENT" -gt "$THRESHOLD" ] ; then
  echo "Your root partition remaining free space is critically low."
  # if you want to send a mail uncomment the next lines
  # mail -s 'Disk Space Alert' admin@example.com << EOF
  # Your root partition remaining free space is critically low. Used: $CURRENT%
  # EOF
else
  echo "HDD in under threshold"
fi

cpuuse=$(cat /proc/loadavg | awk '{print $3}'|cut -f 1 -d ".")
SUBJECT=" CPU load is $cpuuse on $(hostname) at $(date) "
echo $SUBJECT
if [ "$cpuuse" -ge 90 ]; then
  echo "CPU current usage is critical > 90%: $cpuuse%"
  # if you want to send a mail uncomment the next lines
  # mail -s 'CPU Alert' admin@example.com << EOF
  # Your CPU is saturated. Used: $CURRENT%
  # EOF
else
  echo "CPU usage is in under threshold"
fi