from dancywindow import *
from os import listdir

img_seq = [f"./assets/img_seq/{filename}" for filename in listdir("./assets/img_seq")]
print(img_seq)
window = AnimatedSketchWindow("textured_static", winsize[0] / 2, winsize[1] / 2, 800, 800)
window.set_img_seq(img_seq)

while True:
    mousex, mousey = get_mouse_position()
    window.set_position(mousex, mousey)
    window.update()
    window.draw()