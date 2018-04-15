#!/bin/ash
while :
do
  DATE=`date +%F`
  # get the file for this run
  FILE_NAME=/tmp/speedtest-$DATE

  # If not specified... set the timer to an hour.
  TIMER=${_SPEEBEE_TIMER:-3600}

  # Find the public IP address
  IP=$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')

  # get the public IP, we are running from
  echo "IP: $IP" >> $FILE_NAME

  echo -n `date`
  echo " Public IP: $IP. Starting speed test..."
  export FILE_NAME=$FILE_NAME
  speedtest-cli --simple >> $FILE_NAME
  /app/bin/poster.py $FILE_NAME
  echo -n `date`
  echo " Test completed... sleeping for $TIMER seconds..."
  > $FILE_NAME
  sleep $TIMER
done
