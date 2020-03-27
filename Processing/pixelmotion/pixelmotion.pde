/* 
 Animate with pixels OwO
 Author: COLOR·SKY
 03/15/2020
 */
import penner.easing.*;
int displayNum = 0; // 0 = pixelmotion; 1 = conway; 2 = other automata
// Image folder
String dir = "D:\\Python Project\\id_tutorial\\Processing\\pixelmotion\\assets\\";
java.io.File folder = new java.io.File(dataPath(dir));
String[] filenames = folder.list();
int curFileIdx = 0;

// Pixel motion
ArrayList<Pixel> points = new ArrayList<Pixel>();
PImage fillImage;
int keyMaxDuration = 60;

// Conway
Life life;

void setup() {
  size(350, 350);
  background(0);
  resetImage();
}

void draw() {
  background(0);
  if (displayNum == 0) {
    for (Pixel point : points) {
      int from = point.k2.getValue("Quint", "easeIn");
      int to = point.k2.getValue("Quint", "easeInOut");
      point.drawPath(from, to);
    }
  } else if (displayNum == 1) {
    life.update();
    life.display();
  }
  saveFrame("./staff/staff_######.png");
}

void mousePressed() {
  points = new ArrayList<Pixel>();
}

void keyPressed() {
  if (key == ' ') { // Next Image
    points = new ArrayList<Pixel>();
    displayNum = 0;
    curFileIdx += 1;
    curFileIdx %= filenames.length;
    background(0);
    resetImage();
  } else if (key == 49) { // char(49) = 1 Conway current image
    displayNum = 1;
    ArrayList<PVector> aliveCells = new ArrayList<PVector>();
    for (Pixel point : points)
      aliveCells.add(point.path.get(point.path.size()-1));
    life = new Life(aliveCells);
    points = new ArrayList<Pixel>();
  } else if (key == 50) {// char(50) = 2 
    displayNum = 2;
    println("2");
  }
}

PVector randPoint() {
  return new PVector(random(0, width), random(0, height));
}

void resetImage() {
  fillImage = loadImage(dir+filenames[curFileIdx]);
  fillImage.loadPixels();
  for (int x = 0; x < fillImage.width; x++) {
    for (int y = 0; y < fillImage.height; y++) {
      if (fillImage.pixels[x+y*width] == color(255) && random(0, 100)<500) {
        PVector randloc = randPoint();
        Pixel point = new Pixel(int(randloc.x), int(randloc.y));
        point.generagePathTo(x, y);
        int duration = int(random(10, keyMaxDuration));
        Keyframe k1 = new Keyframe(frameCount+int(random(0, 40)), 0, point.path.size(), duration);
        Keyframe k2 = new Keyframe(k1.beginFrame+int(random(8, 20)), 0, point.path.size(), duration);
        point.setKeyframes(k1, k2);
        points.add(point);
      }
    }
  }
}
