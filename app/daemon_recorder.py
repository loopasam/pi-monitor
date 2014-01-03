from time import gmtime, strftime
import time

while True:
 tfile = open("/sys/bus/w1/devices/28-000004e50afc/w1_slave")
 text = tfile.read()
 tfile.close()
 secondline = text.split("\n")[1]
 temperaturedata = secondline.split(" ")[9]
 temperature = float(temperaturedata[2:])
 temperature = temperature / 1000
 timeString = strftime("%H.%M", gmtime())
 with open("records.csv", "a") as record:
  record.write(timeString + "," + str(temperature) + "\n")
 time.sleep(60)
