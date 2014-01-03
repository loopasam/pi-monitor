from flask import Flask, render_template
from time import gmtime, strftime
import datetime
app = Flask(__name__)

@app.route("/")
def hello():
   tfile = open("/sys/bus/w1/devices/28-000004e50afc/w1_slave")
   text = tfile.read()
   tfile.close()
   secondline = text.split("\n")[1]
   temperaturedata = secondline.split(" ")[9]
   temperature = float(temperaturedata[2:])
   temperature = temperature / 1000
   f = open( "records.csv", "r" )
   dates = []
   temperatures = []
   for line in f:
    date = float(line.split(",")[0]);
    temp = float(line.split(",")[1].strip());
    dates.append(date)
    temperatures.append(temp)
   f.close()
   templateData = {
      'temperature' : temperature,
      'temperatures' : temperatures,
      'dates' : dates
      }
   return render_template('main.html', **templateData)

if __name__ == "__main__":
   app.run(host='0.0.0.0', port=80, debug=True)

