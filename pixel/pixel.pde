PImage img;
int cols = 60;
int rows = int(cols*1.5);
int[][] target = new int[cols][rows];
int[][] datag = new int[cols][rows];
int[][] datab = new int[cols][rows];
int pop = 50;
float mut = 0.1;
Population pp;
PFont f;
int pix = 300/cols;
void setup() {
  size(750, 650);
  f = createFont("Courier", 32, true);
  img = loadImage("sample.jpeg");
  background(255);
  //DNA test = new DNA(cols, rows);
  //test.show(300, 0);
  int p = int(img.width/cols);
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int x = int((i+0.5)*p);
      int y = int((j+0.5)*p);
      int loc = x + y*img.width;
      loadPixels();
      int r = (int)red(img.pixels[loc]);
      int g = (int)green(img.pixels[loc]);
      int b = (int)blue(img.pixels[loc]);
      noStroke();
      fill(r, g, b);
      rect(i, j, 1, 1);
      target[i][j] = r;
      datag[i][j] = g;
      datab[i][j] = b;
    }
  }
  pp = new Population(target, mut, pop, cols, rows);
  //pp.calcFitness();
}
void draw() {
  background(255);
  image(img, 50, 50);
  pp.calcFitness();
  pp.naturalSelection();
  pp.generate();
  DNA temp = pp.getBest();

  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float r = temp.genes[i][j];
      noStroke();
      fill(r, 100, 100);
      rect(400+i*pix, 50+j*pix, pix, pix);
    }
  }

  textFont(f);
  textAlign(LEFT);
  fill(0);
  textSize(18);
  //float m = pp.maxFitness/cols/rows;
  text("total generations:     " + pp.getGenerations(), 20, 550);
  text("best score:       " + pp.maxFitness/54+"%", 20, 580);
  //text("min score:       " + pp.minFit/cols/rows, 20, 610);
  if (pp.maxFitness == cols*rows) {
    println(millis()/1000.0);
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        float r = temp.genes[i][j];
        float g = datag[i][j];
        float b = datab[i][j];
        noStroke();
        fill(r, g, b);
        rect(400+i*pix, 50+j*pix, pix, pix);
      }
    }
    noLoop();
  }
  //saveFrame("output/frames####.png");
}