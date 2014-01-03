echo "The hardware must be plugged already!"
echo "Set the data connection..."
sudo modprobe w1-gpio
sudo modprobe w1-therm
echo "Stops Apache and starts Flask app..."
sudo service apache2 stop
sudo python monitor.py
