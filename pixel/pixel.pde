PImage img;
int cols = 30;
int rows = int(cols*1.5);
int[][] target = new int[cols][rows];
int[][] datag = new int[cols][rows];
int[][] datab = new int[cols][rows];
int pop = 1000;
float mut = 0.05;
Population pp;
PFont f;

void setup() {
  size(400, 500);
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
    pp.calcFitness();

}
void draw() {
  //background(255);
  pp.calcFitness();
  //pp.naturalSelection();
  //pp.generate();
  //pp.calcFitness();
  //if (pp.finished()) {
  //  println(millis()/1000.0);
  //  noLoop();
  //}
  //DNA temp = pp.getBest();
  //for (int i = 0; i < cols; i++) {
  //  for (int j = 0; j < rows; j++) {
  //    float r = temp.genes[i][j];
  //    float g = datag[i][j];
  //    float b = datab[i][j];
  //    noStroke();
  //    fill(r, g, b);
  //    rect(100+i*5, j*5, 5, 5);
  //  }
  //}
      
  //textFont(f);
  //textAlign(LEFT);
  //fill(0);
  //textSize(18);
  //text("total generations:     " + pp.getGenerations(), 20, 300);
  //text("best score:       " + pp.bestScore(), 20, 350);
  //text("min score:       " + pp.minFit, 20, 380);

}