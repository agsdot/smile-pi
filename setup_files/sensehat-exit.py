#!/usr/bin/python

from sense_hat import SenseHat
from time import sleep
import signal
import sys

w = [150, 150, 150]
g = [0, 255, 0]
r = [255, 0, 0]
e = [0, 0, 0]
          
sad = [
e,e,e,e,e,e,e,e,
e,r,r,e,e,r,r,e,
e,r,r,e,e,r,r,e,
e,e,e,e,e,e,e,e,
e,e,e,e,e,e,e,e,
e,e,r,r,r,r,e,e,
e,r,e,e,e,e,r,e,
r,e,e,e,e,e,e,r
]

sense = SenseHat()

sense.show_message("Shutdown", scroll_speed=(0.05), text_colour=(255, 0, 0), back_colour=(0, 0, 0))

sense.show_letter("3")
sleep(1)
sense.show_letter("2")
sleep(1)
sense.show_letter("1")
sleep(1)
sense.set_pixels(sad)
sys.exit(0)

