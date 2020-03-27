from dancywindow import *

image = ImageMask(filename="./assets/img1.jpg")
window = AnimatedSketchWindow("textured_static", winsize[0] / 2, winsize[1] / 2, 300, 300)
window.mask_img(image)

while True:
    mousex, mousey = get_mouse_position()
    window.set_position(mousex, mousey)
    window.mask_img(image) # Comment this line to see what is different :)
    window.draw()
