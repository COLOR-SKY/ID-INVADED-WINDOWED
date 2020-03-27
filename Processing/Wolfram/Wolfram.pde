ArrayList<WolfScanner> scanners = new ArrayList<WolfScanner>();
Cell[][] cells;
int  cellSideLen = 5;
int numScanner = 4;

void setup() {
  size(800, 800);
  background(255);
  cells = new Cell[int(width/cellSideLen)][int(height/cellSideLen)];
  for (int i = 0; i < cells.length; i++)
    for (int j = 0; j <  cells[0].length; j++)
      cells[i][j] = new Cell(i, j, false, cellSideLen);
  for (int i=0; i<numScanner; i++){
    WolfScanner scanner = new WolfScanner(cells.length, cells[0].length);
    cells[scanner.x][scanner.y].isAlive = true;
    scanners.add(scanner);
  }
}

void draw() {
  //background(255);
  for (int i = 0; i < cells.length; i++)
    for (int j = 0; j < cells[0].length; j++)
      cells[i][j].display();
  for (WolfScanner scanner : scanners) {
    scanner.checkCollide(scanners);
    scanner.update();
    //if(scanner.reseted)
      cells[scanner.x][scanner.y].isAlive = true;
    ArrayList<int[]> newGens = scanner.getNextGen(cells);
    for(int[] newGen : newGens)
      cells[newGen[0]][newGen[1]].isAlive = newGen[2] == 1 ? true : false;
  }
  //saveFrame("./wolframe_small_fill/wolframe_small_fill_######.jpg");
  if(frameCount >= 4000) exit();
  println(frameCount);
}
