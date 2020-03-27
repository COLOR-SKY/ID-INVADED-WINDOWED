import java.util.Arrays;

class Cell {
  int health;
  boolean isAlive;
  int x, y;
  ArrayList<PVector> neighborsloc;

  Cell(int xx, int yy, boolean alive) {
    x = xx;
    y = yy;
    health = 20;
    isAlive = alive;
    getNeighborsLoc();
  }

  void getNeighborsLoc() {
    neighborsloc = new ArrayList<PVector>();
    PVector n11 = new PVector(x-1, y-1);
    PVector n12 = new PVector(x, y-1);
    PVector n13 = new PVector(x+1, y-1);
    PVector n21 = new PVector(x-1, y);
    PVector n23 = new PVector(x+1, y);
    PVector n31 = new PVector(x-1, y+1);
    PVector n32 = new PVector(x, y+1);
    PVector n33 = new PVector(x+1, y+1);
    for (PVector n : Arrays.asList(n11, n12, n13, n21, n23, n31, n32, n33)) {
      if (n.x >= 0 && n.x < width && n.y >= 0 && n.y < height)
        neighborsloc.add(n);
    }
  }
}

class Life {
  Cell[][] cells = new Cell[350][350];
  int generation = 0;
  int maxGeneration = 10;

  Life(ArrayList<PVector> liveCells) {
    for (int x = 0; x < 350; x++)
      for (int y = 0; y < 350; y++)
        cells[x][y] = new Cell(x, y, false);
    for (PVector p : liveCells) {
      cells[int(p.x)][int(p.y)].isAlive = true;
      cells[int(p.x)][int(p.y)].health -= 1;
    }
  }

  void update() {
    generation += 1;
    for (int x = 0; x < 350; x++)
      for (int y = 0; y < 350; y++) {
        int liveNeighbors = 0;
        for (PVector n : cells[x][y].neighborsloc) {
          if (cells[int(n.x)][int(n.y)].isAlive)
            liveNeighbors += 1;
        }
        if (liveNeighbors >= int(random(3,8)) || liveNeighbors <=1) {
          cells[int(x)][int(y)].isAlive = false;
          continue;
        }
        if (!cells[int(x)][int(y)].isAlive && liveNeighbors == int(random(2,4))) {
          cells[int(x)][int(y)].isAlive = true;
          continue;
        }
        if (cells[int(x)][int(y)].isAlive) {
          cells[int(x)][int(y)].health-=int(map(generation, 0, maxGeneration, 0, 3));
          if (cells[int(x)][int(y)].health<=0)
            cells[int(x)][int(y)].isAlive = false;
        }
      }
  }

  void display() {
    for (int x = 0; x < 350; x++)
      for (int y = 0; y < 350; y++)
        if (cells[x][y].isAlive) {
          stroke(0, 0);
          fill(255);
          rect(cells[x][y].x, cells[x][y].y, 1, 1);
        }
  }
}
