/*
Boyer Moore Algorithm Implemented in Processing
Author: color·sky
2020/03/14
*/

char[] pattern = "5386714".toCharArray();
String[] raw;
String digits;
char[] pi_str;
int num_chars;
int badchar[];
int m,n;
int idx = 0;
int s = 10374575;
boolean play = true;
int row_num = 1;

void setup(){
  size(350,350);
  background(0);
  raw = loadStrings("Pi.txt");
  digits = raw[0];
  pi_str = digits.toCharArray();
  num_chars = digits.length();
  m = pattern.length;
  n = num_chars;
  idx = 0;
  badchar = new int[num_chars]; 
  badCharHeuristic(pattern, m, badchar); 
}

void draw(){
  if (play){
    background(0);
    if(s <= (n - m)){
      int j = m-1; 
        while(j >= 0 && pattern[j] == pi_str[s+j]) 
            j--; 
        if (j >= 0) {
          s += max(1, j - badchar[pi_str[s+j]]); 
          idx += 1;
        }
        else{
          play = false;
        }
        fill(0);
        int row = 16;
        int col = 36;
        row_num = row_num > row ? row : row_num;
        int middle = int(row*col/2);
        for(int r = 0; r < row_num; r++){
          fill(255);
          String st = digits.substring(s - middle + r * col , s - middle + r * col + col);
          textAlign(LEFT);
          textSize(14);
          text(st, 15, 27 + r * 19);
          
        }
        textAlign(CENTER);
        text("ID: "+str(int(map(idx,0,214,0,10375575))),width/2,335);
    }
  }
  else{
    frameRate(10);
    if(frameCount%2 == 0)
      fill(255,0,0);
    else
      fill(0);
    textAlign(LEFT);
    text("5386714", 15, 27 + 8 * 19);
  }
  row_num += 1;
  //saveFrame("./output/pi_search_######.png");
}

void badCharHeuristic( char []str, int size,int badchar[]) { 
  int i; 
  for (i = 0; i < num_chars; i++) 
       badchar[i] = -1;  
  for (i = 0; i < size; i++) 
       badchar[(int) str[i]] = i; 
} 
