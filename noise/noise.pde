float nx = 0;
float ny = 0;
float nz = 0;

void setup () {
  size (600, 600);
  colorMode (HSB);
}


void draw () {
  background (0, 0, 100);
  drawStream ();
}

void drawStream () {
  nx = 0;
  for (int i=0; i<width; i += 10) {
    ny = 0;
    for (int j=0; j<width; j += 10) {
      float angle = map (noise (nx, ny, nz), 0, 1.0, 0, TWO_PI);
      colorMode(HSB, 100);
      float cc = map(angle, 0, TWO_PI, 0, 100);
      float x = 50 * cos (angle);
      float y = 50 * sin (angle);
      stroke(cc, 100, 100);
      line (i, j, i+x, j+y);
      ny += 0.05;
    }
    nx += 0.05;
  }
  nz +=0.01;
}