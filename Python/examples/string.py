from dancywindow import *
import numpy as np

sidelen = 210
seg_num = 10
t = 0
dt = 0.2

windows = [
    AnimatedSketchWindow(
        name=str(i),
        x=i - sidelen / 2,
        y=winsize[1] / 2 - sidelen / 2,
        w=sidelen,
        h=sidelen
    ) for i in np.linspace(0, winsize[0], num=seg_num)
]

while True:
    amp = abs(winsize[1]/2 - get_mouse_position()[1])
    for i, window in enumerate(windows):
        window.set_position(x=window.x, y=amp*np.sin(t+i) + winsize[1] / 2)
        window.draw()
    t += dt
