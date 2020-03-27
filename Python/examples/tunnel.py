from dancywindow import *
from math import cos, sin, pi

window_names = []
anime_count = 0


def single_ring(idx, radius, frame_count, speed=0.005, sidelen=400):
    global anime_count
    blocks = []
    for i in range(4):
        block_name = f"swirl_block_{idx}_{str(i)}"
        block = AnimatedSketchWindow(
            block_name,
            winsize[0] / 2 + radius * cos(frame_count * speed + i * pi / 2),
            winsize[1] / 2 + radius * sin(frame_count * speed + i * pi / 2),
            sidelen,
            sidelen,
            bg=0
        )
        window_names.append(block_name)
        blocks.append(block)

    for i, block in enumerate(blocks):
        newx = block.x + radius * cos(frame_count * speed + i * pi / 2)
        newy = block.y + radius * sin(frame_count * speed + i * pi / 2)
        block.set_position(newx, newy)
        block.update()
        block.draw()


def draw_swirl_blocks(framecount, radius=100, num=1, speed=0.005):
    gap = 30
    for i in range(num):
        single_ring(i, radius + gap * i, framecount, speed=speed * (i + 1) * 0.5, sidelen=500 - i * 60)


def main():
    frame_count = 0
    while True:
        draw_swirl_blocks(frame_count, num=8)
        frame_count += 1


if __name__ == '__main__':
    main()
