"""
COLOR·SKY
03/20/2020
"""

import cv2
import numpy as np
import pyautogui
from PIL import ImageGrab
from pywinauto.findwindows import find_window,WindowNotFoundError
from win32gui import SetForegroundWindow

winsize = list(pyautogui.size()) # The resolution of the monitor

def get_mouse_position():
    # Get current mouse position
    return list(pyautogui.position())

def record(direct, name):
    # Make a screenshot
    im = ImageGrab.grab()
    im.save(f"{direct}/{name}.jpg")

def get_intersect(x1, y1, x2, y2, x3, y3, x4, y4):
    """
    :param x1: x position of the first rect's upplerleft point
    :param y1: y position of the first rect's upplerleft point
    :param x2: x position of the first rect's lowerright point
    :param y2: y position of the first rect's lowerright point
    :param x3: x position of the second rect's upplerleft point
    :param y3: y position of the second rect's upplerleft point
    :param x4: x position of the second rect's lowerright point
    :param y4: y position of the second rect's lowerright point
    """
    intersect = True
    if (x1 > x4 or x3 > x2) or (y1 > y4 or y2 < y3):
        return False, 0, 0, 0, 0

    upperleft = (max(x1, x3), max(y1, y3))
    lowerright = (min(x2, x4), min(y2, y4))

    if lowerright[0] - upperleft[0] < 10 or lowerright[1] - upperleft[1] < 10:
        return False, 0, 0, 0, 0

    return intersect, int(upperleft[0]), int(upperleft[1]), int(lowerright[0]), int(lowerright[1])

def constrain(val, min_val, max_val):
    return int(min(max_val, max(min_val, val)))

def map_value(value, leftmin, leftmax, rightmin, rightmax):
    leftspan = leftmax - leftmin
    rightspan = rightmax - rightmin
    valuescaled = float(value - leftmin) / float(leftspan)
    return rightmin + (valuescaled * rightspan)

def increase_brightness(img, value=30):
    """
    Change brightness of a cv2 image
    Reference: https://stackoverflow.com/questions/32609098/how-to-fast-change-image-brightness-with-python-opencv
    """
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    h, s, v = cv2.split(hsv)

    lim = 255 - value
    v[v > lim] = 255
    v[v <= lim] += value

    final_hsv = cv2.merge((h, s, v))
    img = cv2.cvtColor(final_hsv, cv2.COLOR_HSV2BGR)
    return img

class ImageMask:
    def __init__(self, filename=None, image=None, x=winsize[0] / 2, y=winsize[1] / 2, brightness = 0):
        self.image = image
        self.x, self.y = int(x), int(y)
        if image is None:
            self.image = cv2.imread(filename)
        self.h, self.w, _ = self.image.shape
        self.all_black = not np.any(self.image)
        self.brightness = brightness
        if self.brightness != 0:
            self.image = increase_brightness(self.image, self.brightness)

    def get_region(self, ulx, uly, lrx, lry):
        """
        return part of the image enclosed by the rectangle
        """
        image_ulx = int(ulx - (self.x - self.w / 2))
        image_uly = int(uly - (self.y - self.h / 2))
        image_lrx = int(lrx - (self.x - self.w / 2))
        image_lry = int(lry - (self.y - self.h / 2))

        image = self.image[image_uly:image_lry, image_ulx:image_lrx]
        return image

    def get_pixel(self, px, py):
        h, w, c = self.image.shape
        # point px, py is within the image
        if self.x + w / 2 > px > self.x - w / 2 and self.y + h / 2 > py > self.y - h / 2:
            # Convert monitor position to image position
            dx = px - self.x
            dy = py - self.y
            imgx = int(w / 2) + dx
            imgy = int(h / 2) + dy
            return self.image[imgy][imgx]
        else:
            return [0, 0, 0]

class SketchWindow:
    def __init__(self, name, x, y, w, h, bg=255):
        self.name, self.x, self.y, self.w, self.h, self.bg = name, x, y, w, h, bg
        self.z = 0
        self.background = np.zeros((int(self.h), int(self.w), 3), np.uint8)
        self.background.fill(self.bg)
        self.window_scale = 1.0
        self.offsetx = 0
        self.offsety = 0
        self.masked = False
        self.imgidx = 0
        self.imgs = []
        self.imgx = int(winsize[0]/2)
        self.imgy = int(winsize[1]/2)

    def reset_bg(self):
        self.background = np.zeros((int(self.h), int(self.w), 3), np.uint8)
        self.background.fill(self.bg)

    def set_img_seq(self, imgs, imgx=None, imgy=None):
        self.imgs = imgs
        if imgx and imgy:
            self.imgx = imgx
            self.imgy = imgy

    def mask_img(self, img):
        """
        Mask an image at location (imgx, imgy) relative to the monitor
        :param img: ImageMask object
        :param curx: x position
        :param cury: y position
        """
        # if img.all_black:
        #     return
        self.masked = True
        self.background = np.zeros((int(self.h), int(self.w), 3), np.uint8)

        intersect, ulx, uly, lrx, lry = get_intersect(
            self.x - self.w / 2,
            self.y - self.h / 2,
            self.x + self.w / 2,
            self.y + self.h / 2,
            img.x - img.w / 2,
            img.y - img.h / 2,
            img.x + img.w / 2,
            img.y + img.h / 2,
        )
        if not intersect:
            return

        corpped_img = img.get_region(ulx, uly, lrx, lry)
        bgulx = int(ulx - (self.x - self.w / 2))
        bguly = int(uly - (self.y - self.h / 2))
        imgh, imgw, _ = corpped_img.shape

        self.background[bguly:bguly + imgh, bgulx:bgulx + imgw] = corpped_img

    def set_position(self, x, y):
        self.x, self.y = x, y

    def set_size(self, w, h):
        self.w, self.h = w, h

    def set_windowscale(self, scale):
        self.window_scale = scale

    def to_front(self):
        try:
            hwnd = find_window(title=self.name)
            SetForegroundWindow(hwnd)
        except WindowNotFoundError:
            pass

    def destroy(self):
        cv2.destroyWindow(self.name)

class AnimatedSketchWindow(SketchWindow):
    def __init__(self, name, x, y, w, h, bg=255):
        SketchWindow.__init__(self, name, x, y, w, h, bg)
        self.min_w = 120
        self.min_h = 80
        self.max_w = int(w)
        self.max_h = int(h)
        self.scale = 1.0
        self.scalex = 1.0
        self.scaley = 1.0
        self.vscale = 0
        self.vscalex = 0
        self.vscaley = 0
        self.vx = 0
        self.vy = 0
        self.vz = 0
        self.in_transition = False
        self.frame_expired = 0

    def update(self):
        if self.imgs:
            self.imgidx %= (len(self.imgs)-1)
            self.mask_img(ImageMask(self.imgs[self.imgidx],x=self.imgx, y=self.imgy))
            self.imgidx += 1
        else:
            self.masked = False
        self.scale += self.vscale
        self.scalex += self.vscalex
        self.scaley += self.vscaley

        if self.vscale != 0:
            self.w = self.max_w * self.scale
            self.h = self.max_h * self.scale
        else:
            self.w = self.max_w * self.scalex
            self.h = self.max_h * self.scaley


        self.w = constrain(self.w, self.min_w, self.max_w)
        self.h = constrain(self.h, self.min_h, self.max_h)
        self.x += self.vx
        self.y += self.vy
        self.z += self.vz
        if self.w in [self.max_w, self.min_w] and self.h in [self.max_h, self.min_h]:
            self.frame_expired += 1
            self.in_transition = False
        else:
            self.frame_expired = 0
            self.in_transition = True
        if not self.masked:
            self.background = np.zeros((int(self.h), int(self.w), 3), np.uint8)
            self.background.fill(self.bg)

    def to_screen(self):
        if self.z != 0:
            vecx = self.x - winsize[0] / 2
            vecy = self.y - winsize[1] / 2
            vect = np.array([vecx, vecy])
            normv = vect/np.sqrt(np.sum(vect**2))
            normx, normy = normv[0], normv[1]
            return self.x + self.z * normx, self.y + self.z * normy
        else:
            return self.x, self.y

    def draw(self, x=None, y=None, hide = False, destroy = False):
        self.w = constrain(self.w, self.min_w, self.max_w)
        self.h = constrain(self.h, self.min_h, self.max_h)

        if x is None and y is None:
            x, y = int(self.x), int(self.y)
        if self.w == self.min_w and self.h == self.min_h:
            if destroy:
                cv2.destroyWindow(self.name)
                return
            if hide:
                pass
            else:
                return

        if self.z != 0:
            vecx = self.x - winsize[0] / 2
            vecy = self.y - winsize[1] / 2
            vect = np.array([vecx, vecy])
            normv = vect/np.sqrt(np.sum(vect**2))
            normx, normy = normv[0], normv[1]
            x += self.z * normx
            y += self.z * normy

        cv2.namedWindow(self.name, cv2.WINDOW_NORMAL)
        cv2.moveWindow(self.name,
                       int((x - self.w / 2 * self.window_scale + self.offsetx)),
                       int((y - self.h / 2 * self.window_scale + self.offsety)),
                       )
        cv2.resizeWindow(self.name, int(self.w * self.window_scale), int(self.h * self.window_scale))
        if len(self.background) != 0:
            cv2.imshow(self.name, self.background)
            cv2.waitKey(1)