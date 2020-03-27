class Pixel {
  int x, y;
  ArrayList<PVector> path = new ArrayList<PVector>();
  int minDst = 10;
  int maxDst = 30;
  Keyframe k1, k2;

  Pixel(int xx, int yy) {
    x = xx;
    y = yy;
    path.add(new PVector(x, y));
  }

  void setKeyframes(Keyframe key1, Keyframe key2) {
    k1 = key1;
    k2 = key2;
  }

  void generagePathTo(int targetx, int targety) {
    path = new ArrayList<PVector>();
    path.add(new PVector(x, y));
    PVector curPosition = path.get(path.size()-1);
    targetx = targetx < 0 ? 0 : targetx > width ? width : targetx;
    targety = targety < 0 ? 0 : targety > height ? height : targety;

    while (curPosition.x != targetx || curPosition.y != targety) {
      int dx = targetx - int(curPosition.x);
      int dy = targety - int(curPosition.y);
      int signx = (dx > 0) ? 1 : -1;
      int signy = (dy > 0) ? 1 : -1;

      // 50% move alonge x axis, 50% on y
      int moveDst = int(random(minDst, maxDst));
      PVector moveVect;
      if (random(0, 100) < 50) { // Move alonge x axis
        moveDst = moveDst > abs(dx) ? abs(dx) : moveDst;
        moveVect = new PVector(signx, 0);
      } else { // Move alonge y axis
        moveDst = moveDst > abs(dy) ? abs(dy) : moveDst;
        moveVect = new PVector(0, signy);
      }

      // Append all the positions along the path
      for (int i = 1; i < moveDst + 1; i++) {
        PVector p1 = new PVector(moveVect.x*i, moveVect.y*i);
        PVector p2 = new PVector(curPosition.x + p1.x, curPosition.y + p1.y);
        path.add(p2);
      }
      curPosition = path.get(path.size()-1);
    }
  }

  void drawPath(int from, int to) {
    to = to >= path.size() ? path.size() : to;
    from = from >= path.size() ? path.size() : from;
    if (from >= path.size()-1) from = to - 1;
    if (from <= 0) from = 0;
    for (int i = from; i < to; i++) {
      PVector p = path.get(i);
      stroke(255, 0);
      fill(255, int(map(i, from, to, 0, 100)));
      if (from == to - 1 && to >= path.size()-1) {
        fill(255);
      }
      rect(p.x, p.y, 1, 1);
    }
  }
}
