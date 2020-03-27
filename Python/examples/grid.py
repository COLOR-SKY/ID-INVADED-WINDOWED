from dancywindow import *
from math import sin, cos, radians

grid = None

def rotate(origin, point, angle):
    """
    Rotate a point counterclockwise by a given angle around a given origin.
    The angle should be given in radians.
    """
    ox, oy = origin
    px, py = point

    qx = ox + cos(angle) * (px - ox) - sin(angle) * (py - oy)
    qy = oy + sin(angle) * (px - ox) + cos(angle) * (py - oy)
    return qx, qy


class Grid:
    def __init__(self, x=winsize[0] / 2, y=winsize[1] / 2, row=3, col=3, sidelen=120, gap=10):
        self.x, self.y, self.row, self.col, self.sidelen, self.gap = x, y, row, col, sidelen, gap
        self.grids = []
        self.rotation = 0
        self.vrotate = 2
        total_w = (row - 1) * gap + row * sidelen
        total_h = (col - 1) * gap + col * sidelen
        self.rotate_centerx = x
        self.rotate_centery = y
        for i in range(col):
            for j in range(row):
                name = f"grid_{i}_{j}"
                block = AnimatedSketchWindow(
                    name,
                    self.rotate_centerx + gap * j + sidelen * j,
                    self.rotate_centery + gap * i + sidelen * i,
                    sidelen,
                    sidelen
                )
                self.grids.append(block)

    def draw(self, frame_count):
        for block in self.grids:
            newx, newy = rotate((self.rotate_centerx, self.rotate_centery), (block.x, block.y), radians(self.vrotate))
            block.set_position(newx, newy)
            block.update()
            block.draw()

    def destroy_all(self):
        for block in self.grids:
            block.destroy()


def draw_grid(frame_count=0, x=winsize[0] / 2, y=winsize[1] / 2, row=3, col=3, sidelen=120, gap=5):
    global grid
    if not grid:
        grid = Grid(x, y, row, col, sidelen, gap)
    grid.draw(frame_count)



if __name__ == '__main__':
    frame = 0
    while True:
        draw_grid(frame)
        frame += 1
