class Cell {
  int x, y, sideLen;
  boolean isAlive;
  Cell(int xx, int yy, boolean alive, int cellSideLen) {
    x = xx; 
    y = yy;
    isAlive = alive;
    sideLen = cellSideLen;
  }
  void display() {
     fill(0);
    stroke(255);
    strokeWeight(1);
    if (isAlive) stroke(0);
    else fill(255);
    rect(x*sideLen, y*sideLen, sideLen, sideLen);

  }
}
