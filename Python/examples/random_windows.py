from dancywindow import *
from random import randint
scale_velocity = 0.2
num_win = 25
destroy = False # Whether a window should be destroyed when it reaches minimum size
xmin, xmax, ymin, ymax = 0, winsize[0], 0, winsize[1]  # Area where a window can spawn
windows = [AnimatedSketchWindow(name = str(i),
                                x = randint(xmin, xmax),
                                y = randint(ymin, ymax),
                                w=0, h=0, bg=0) for i in range(num_win)]

# Initialize windows
for i in range(len(windows)):
    windows[i].scale = 0
    windows[i].max_h = randint(80, 400)
    windows[i].max_w = randint(120, 400)
    windows[i].vz = 3

def draw_windows():
    for i in range(len(windows)):
        windows[i].update()
        if not windows[i].in_transition and windows[i].frame_expired >= randint(5, 15):
            if randint(0, 100) < 80:
                if windows[i].w == windows[i].max_w:
                    windows[i].vscale = - scale_velocity
                else:
                    windows[i].vscale = scale_velocity

        screenx, screeny = windows[i].to_screen()
        if 0 > screenx or screenx > winsize[0] or \
                0 > screeny or screeny > winsize[1] or \
                (destroy and windows[i].w == windows[i].min_w and windows[i].h == windows[i].min_h):
            windows[i].x = randint(xmin, xmax)
            windows[i].y = randint(ymin, ymax)
            windows[i].vscale = scale_velocity
            windows[i].z = 0
            windows[i].max_h = randint(80, 400)
            windows[i].max_w = randint(120, 400)
        windows[i].draw(hide=True, destroy=destroy)

while True:
    draw_windows()