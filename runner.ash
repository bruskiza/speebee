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

  if [ "$IP" = "" ]; then
    echo -n `date`
    echo " - ERROR: Could not determine public IP. Please check the Internet connection"
    exit $retVal
  fi

  # get the public IP, we are running from
  echo "IP: $IP" >> $FILE_NAME

  echo -n `date`
  echo " - INFO: Posting to API: '$_SPEEBEE_API'"
  echo -n `date`
  echo " - INFO: Posting to channel: '$_SPEEBEE_CHANNEL'"
  echo -n `date`
  echo " - INFO: Using channel token: '$_SPEEBEE_TOKEN'"
  echo -n `date`
  echo " - INFO: Public IP: $IP"
  echo -n `date`
  echo " - INFO: Starting speed test..."

  export FILE_NAME=$FILE_NAME

  # run the speedtest
  speedtest-cli --simple >> $FILE_NAME
  retVal=$?

  if [ $retVal -ne 0 ]; then
    echo -n `date`
    echo " - ERROR: Could not run speedtest... exiting"
    exit $retVal
  fi

  # post it to the $_SPEEBEE_API
  /app/bin/poster.py $FILE_NAME

  echo -n `date`
  echo " - INFO: Test completed... sleeping for $TIMER seconds..."
  > $FILE_NAME

  sleep $TIMER

done
