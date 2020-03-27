import java.lang.Integer;

class WolfScanner {
  int x, y, vx, vy,w,h;
  int ruleNum;
  int minDst = 50;
  int effectiveRange;
  int vER = 1;
  
  int[] rules = {0, 0, 0, 0, 0, 0, 0, 0,0,0,54, 94, 126, 150, 182, 45, 73, 57, 149, 121};
  //int[] rules = {222};
  String ruleBinary;
  boolean reseted = false;

  WolfScanner(int ww, int hh) {
    w = ww;
    h = hh;
    reset();
  }

  void reset() {
    reseted = true;
    ruleNum = rules[int(random(0, rules.length))];
    String temp = Integer.toString(ruleNum, 2);
    while(temp.length() !=8)
      temp = "0" + temp;
    ruleBinary = temp;
    x = int(random(0, w));
    y = int(random(0, h));
    int[] varxs = {-1, 0, 1};
    vx = varxs[int(random(0, 3))];
    int[] varys = {-1, 1};
    vy = vx == 0 ? varys[int(random(0, 2))] : 0;
    vER = int(random(1,3));
    effectiveRange = vER;
  }

  void checkCollide(ArrayList<WolfScanner> scanners) {
    for (WolfScanner scanner : scanners) {
      if (this != scanner)
        while (scanner.x == x || scanner.y == y || (scanner.vx == vx && abs(scanner.x - x) <= minDst) || (scanner.vy == vy && abs(scanner.y - y) <= minDst))
          reset();
    }
  }

  void update() {
    effectiveRange += vER;
    reseted = false;
    x += vx;
    y += vy;
    while (0 > x || x >= w || 0 > y || y >= h) {
      reset();
    }
  }

  ArrayList<int[]> getNextGen(Cell[][] cells) {
    ArrayList<int[]> nextGens = new ArrayList<int[]>();
    int maxiter = (vy != 0 && y+vy >= 0 && y+vy < cells[0].length) ? cells.length : cells[0].length;
    
    for (int i = max(0, x - effectiveRange); i< min(x + effectiveRange, maxiter); i++) {
      boolean a=false;
      boolean b=false;
      boolean c=false;
      boolean hasResult=false;
      if (vy != 0 && y+vy >= 0 && y+vy < cells[0].length) { // Is moving on y axis, new gen is on cell[][y+vy]
        a = i-1<0 ? false : cells[i-1][y].isAlive;
        b = cells[i][y].isAlive;
        c = i+1>=cells.length ? false : cells[i+1][y].isAlive;
        hasResult = true;
      } else if (vx != 0 && x+vx >= 0 && x+vx < cells.length) {
        a = i-1<0 ? false : cells[x][i-1].isAlive;
        b = cells[x][i].isAlive;
        c = i+1>=cells[0].length ? false : cells[x][i+1].isAlive;
        hasResult = true;
      }
      if (! hasResult) continue;
      boolean alive = false;
      if      (a == true && b == true && c == true) alive = ruleBinary.charAt(0) == '1' ? true : false;
      else if (a == true && b == true && c == false) alive = ruleBinary.charAt(1) == '1' ? true : false;
      else if (a == true && b == false && c == true) alive = ruleBinary.charAt(2) == '1' ? true : false;
      else if (a == true && b == false && c == false) alive = ruleBinary.charAt(3) == '1' ? true : false;
      else if (a == false && b == true && c == true) alive = ruleBinary.charAt(4) == '1' ? true : false;
      else if (a == false && b == true && c == false) alive = ruleBinary.charAt(5) == '1' ? true : false;
      else if (a == false && b == false && c == true) alive = ruleBinary.charAt(6) == '1' ? true : false;
      else if (a == false && b == false && c == false) alive = ruleBinary.charAt(7) == '1' ? true : false;
      if (vy != 0 && y+vy >= 0 && y+vy < cells[0].length) {
        int[] result = {i, y+vy, alive == true ? 1 : 0};
        nextGens.add(result);
      } else if (vx != 0 && x+vx >= 0 && x+vx < cells.length) {
        int[] result = {x + vx, i, alive == true ? 1 : 0};
        nextGens.add(result);
      }
    }
    //println(x,y,vx,vy);
    //for(int[] g: nextGens)
    //  println(g[0],g[1],g[2]);
    //noLoop();
    return nextGens;
  }

  void display() {
    stroke(0);
    if (vx != 0)
      line(x, 0, x, height);
    else
      line(0, y, width, y);
  }
}
