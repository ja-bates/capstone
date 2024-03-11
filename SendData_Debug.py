# Debug file, not for demo use

import serial
import time

arduino = serial.Serial('/dev/cu.usbserial-AI02Q766', 115200, timeout=1)
time.sleep(2) # short delay to initialize

body = 'Testing Testing Love'

arduino.write(body.encode('utf-8'))
arduino.flush() 

print(body)