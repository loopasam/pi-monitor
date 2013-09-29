#!/bin/bash

# LED definitions:
red=0
yellow=1
green=2

# Stops all the lights
setup () {
  for i in $red $yellow $green ; do gpio mode  $i out ; done
  for i in $red $yellow $green ; do gpio write $i   0 ; done
}

clearled () {
  for i in $red $yellow $green ; do gpio write $i   0 ; done
}

exportzip () {
  echo "exporting zip to apache..."
  zip data log.txt
  # cp data.zip /apache/repo
}

checkInternet () {
  time=$(ping -c 1 173.194.34.148 | sed -nr 's|.*time=(.*)\..* ms$|\1|p')
  date=$(date)
  echo $date, $time
  clearled
  # Checks the time and make a decision
  if [ "$time" == "" ]; then
    echo "No internet!"
    gpio write $red 1
    time="0"
  else
    #Handles the light
      if [[ $time -lt 33 ]]; then
        echo "fast regime"
        gpio write $green 1
      else
        echo "slow regime"
        gpio write $yellow 1
      fi
  fi
    
  # Write the report
  report="$date, $time"
  echo $report >> log.txt
  sleep 5
}


#######################################################################
# The main program
#	Checks the Internet and changes the LED output accordingly
#######################################################################
counter=0

while true; do
  checkInternet
  counter=$[$counter+1]
  if [[ $counter -eq 5 ]]; then
    exportzip
    counter=0
  fi
done
