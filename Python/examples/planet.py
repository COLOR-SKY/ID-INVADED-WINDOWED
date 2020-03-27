from dancywindow import *
import cv2
from math import cos, sin

earth_orbit_radius = 200
sun_orbit_radius = 400

earth = AnimatedSketchWindow("earth", x=winsize[0]/2 - sun_orbit_radius, y=winsize[1] / 2, w=200, h=200)
moon = AnimatedSketchWindow("moon", x=earth.x - earth_orbit_radius, y=winsize[1] / 2, w=120, h=120)
sun = AnimatedSketchWindow("sun", x=winsize[0] / 2, y=winsize[1] / 2, w=300, h=300)

earth_img = cv2.resize(cv2.imread("./assets/earth.jpg"), (200, 200))
moon_img = cv2.resize(cv2.imread("./assets/moon.webp"), (120, 120))
sun_img = cv2.resize(cv2.imread("./assets/sun.png"), (300, 300))

earth.mask_img(ImageMask(image=earth_img, x=earth.x, y=earth.y))
moon.mask_img(ImageMask(image=moon_img, x=moon.x, y=moon.y))
sun.mask_img(ImageMask(image=sun_img, x=sun.x, y=sun.y))

day = 0
while True:
    earthx = sun.x + sun_orbit_radius*cos(day)
    earthy = sun.y + sun_orbit_radius*sin(day)
    earth.draw(earthx, earthy)
    moon.draw(earthx + earth_orbit_radius*cos(day*2), earthy + earth_orbit_radius*sin(day*2))
    sun.draw()
    day+=.01
