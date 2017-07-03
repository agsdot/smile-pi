#!/usr/bin/python

from sense_hat import SenseHat
from time import sleep
import signal
import sys

#Code to handle system shutdown.
#If shutdown is detected, kill the script
def sigterm_handler(_signo, _stack_frame):
  sense.show_message("Shutdown", scroll_speed=(0.05), text_colour=(255, 0, 0), back_colour=(0, 0,
0))

  sense.show_letter("3")
  sleep(1)
  sense.show_letter("2")
  sleep(1)
  sense.show_letter("1")
  sleep(1)
  sense.set_pixels(sad)
  sys.exit(0)

signal.signal(signal.SIGTERM, sigterm_handler)

if __name__ == "__main__":

  sense = SenseHat()

  # set up the colours (white, green, red, empty)

  w = [150, 150, 150]
  g = [0, 255, 0]
  r = [255, 0, 0]
  e = [0, 0, 0]

  smile = [
  e,e,e,e,e,e,e,e,
  e,g,g,e,e,g,g,e,
  e,g,g,e,e,g,g,e,
  e,e,e,e,e,e,e,e,
  e,e,e,e,e,e,e,e,
  g,e,e,e,e,e,e,g,
  e,g,e,e,e,e,g,e
  e,e,g,g,g,g,e,e
  ]

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

  face1 = [
  e,e,e,e,e,e,e,e,
  e,g,w,e,e,g,g,e,
  e,g,g,e,e,g,w,e,
  e,e,e,e,e,e,e,e,
  e,e,g,g,g,e,e,e,
  e,e,g,e,g,e,e,e,
  e,e,g,g,g,e,e,e,
  e,e,e,e,e,e,e,e
  ]

  face2 = [
  e,e,e,e,e,e,e,e,
  e,g,g,e,e,g,w,e,
  e,r,w,e,e,r,g,e,
  e,e,e,e,e,e,e,e,
  e,e,e,e,e,e,e,e,
  e,e,e,e,e,e,e,e,
  e,g,g,g,g,g,g,e,
  e,e,e,e,e,e,e,e
  ]

  face3 = [
  e,e,e,e,e,e,e,e,
  e,g,g,e,e,w,g,e,
  e,w,g,e,e,g,g,e,
  e,e,e,e,e,e,e,e,
  e,e,e,e,e,e,e,e,
  e,e,e,e,e,e,e,e,
  e,g,g,g,g,g,g,e,
  e,e,e,e,e,e,e,e
  ]

  face4 = [
  e,e,e,e,e,e,e,e,
  e,w,g,e,e,g,g,e,
  e,g,g,e,e,w,g,e,
  e,e,e,e,e,e,e,e,
  e,e,e,e,e,e,e,e,
  e,e,e,e,e,e,e,e,
  e,g,g,g,g,g,g,e,
  e,e,e,e,e,e,e,e
  ]

  sense.set_pixels(smile)

  while True:

    x,y,z = sense.get_accelerometer_raw().values()

    x = round(x, 0)
    y = round(y, 0)

    x_shake = abs(x)
    y_shake = abs(y)
    z_shake = abs(z)

    if x_shake > 1.5 or y_shake > 1.5 or z_shake > 1.5:
        for i in range(3):
          sense.set_pixels(face1)
          sleep(0.5)
          sense.set_pixels(face2)
          sleep(0.5)
          sense.set_pixels(face3)
          sleep(0.5)
          sense.set_pixels(face4)
          sleep(0.5)
          sense.set_pixels(smile)
    else:
      if x == -1:
        sense.set_rotation(180)
      elif y == 1:
        sense.set_rotation(270)
      elif y == -1:
        sense.set_rotation(90)
      elif x == 1:
        sense.set_rotation(0)
      else:
        sense.set_pixels(smile)
