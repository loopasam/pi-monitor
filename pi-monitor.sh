#!/bin/bash

# LED definitions:
red=0
yellow=1
green=2

# Stores the current LED on
current=0

# Stops all the lights and assigns correct mode for GPIO pins
setup () {
  echo "Setting up..."
  combo
  for i in $red $yellow $green ; do gpio mode  $i out ; done
  for i in $red $yellow $green ; do gpio write $i   0 ; done
}

# Turn-off all the LEDs
turnOn () {
  if [ $1 -ne $current ]; then
  
    # if internet was off and back again - then combo
    if [ $current -eq 0 ]; then
      combo
    fi
      
    gpio write $current 0;
    gpio write $1 1;
    current=$1
  fi
}

# Especiale combos
combo() {
  for i in $red $yellow $green ; do gpio write $i 0 ; done
  for j in 0 1 2 3;
    do for i in $red $yellow $green;
      do gpio write  $i 1 ;
      sleep 0.1 ;
      gpio write  $i 0 ;
    done
  done
}

# Export the log as ZIP file on apache2 server
exportzip () {
  # echo "exporting zip to apache..."
  zip data log.txt
  sudo cp data.zip /var/www/
}

# Ping Google to know whether the Internet is working or not
checkInternet () {
  time=$(ping -c 2 8.8.8.8 | sed -nr 's|.*=.*\/(.*)\..*\/.*\/.*$|\1|p')
  #time=$(ping -c 1 173.194.34.148 | sed -nr 's|.*time=(.*)\..* ms$|\1|p')
  date=$(date)
  # echo $date, $time
  # clearled
  # Checks the time and make a decision
  if [ "$time" == "" ]; then
    # echo "No internet!"
    turnOn $red
    time="100"
  else
    #Handles the light
      if [[ $time -lt 40 ]]; then
        turnOn $green
      else
        turnOn $yellow
      fi
  fi
    
  # Write the report
  report="$date, $time"
  echo $report >> log.txt
  sleep 10
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
