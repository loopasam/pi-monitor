#!/bin/bash

# LED definitions:
red=0
yellow=1
green=2

# Stops all the lights and assigns correct mode for GPIO pins
setup () {
  echo "Setting up..."
  for i in $red $yellow $green ; do gpio mode  $i out ; done
  for i in $red $yellow $green ; do gpio write $i   0 ; done
}

# Turn-off all the LEDs
clearled () {
  for i in $red $yellow $green ; do gpio write $i   0 ; done
}

# Export the log as ZIP file on apache2 server
exportzip () {
  # echo "exporting zip to apache..."
  zip data log.txt
  sudo cp data.zip /var/www/
}

# Ping Google to know whether the Internet is working or not
checkInternet () {
  time=$(ping -c 1 173.194.34.148 | sed -nr 's|.*time=(.*)\..* ms$|\1|p')
  date=$(date)
  # echo $date, $time
  clearled
  # Checks the time and make a decision
  if [ "$time" == "" ]; then
    # echo "No internet!"
    gpio write $red 1
    time="0"
  else
    #Handles the light
      if [[ $time -lt 35 ]]; then
        # echo "fast regime"
        gpio write $green 1
      else
        # echo "slow regime"
        gpio write $yellow 1
      fi
  fi
    
  # Write the report
  report="$date, $time"
  echo $report >> log.txt
  sleep 15
}


#######################################################################
# The main program
#	Checks the Internet and changes the LED output accordingly
#######################################################################
counter=0
setup

while true; do
  checkInternet
  counter=$[$counter+1]
  if [[ $counter -eq 240 ]]; then
    # Export the zip file every hours
    exportzip
    counter=0
  fi
done
