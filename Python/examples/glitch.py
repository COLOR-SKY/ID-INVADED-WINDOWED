from dancywindow import *
from random import randint

bound_height = 360
upperbound = winsize[1] / 2 - bound_height / 2
lowerbound = winsize[1] / 2 + bound_height / 2


def create_window(name):
    # Return a window within the specified boundary
    window_h = randint(50, bound_height / 2)
    window_y = randint(upperbound, lowerbound)
    while window_y + window_h / 2 > lowerbound or window_y - window_h / 2 < upperbound:
        window_y = randint(upperbound, lowerbound)

    w = AnimatedSketchWindow(name=f"window_glitch_{name}",
                             x=randint(-50, winsize[0]),
                             y=window_y,
                             w=randint(80, 1000),
                             h=window_h,
                             bg=0)
    w.vx = randint(100, 400)  # Give a random initial x velocity
    w.bg = 0 if randint(0, 100) < 50 else 255  # texture the window randomly with black or white background
    return w


glitch_windows = [create_window(i) for i in range(15)]

while True:
    for window in glitch_windows:
        window.bg = 0 if randint(0, 100) < 50 else 255
        window.draw()
        window.update()
        if window.x >= winsize[0]:
            window.x = randint(-200, -50)
