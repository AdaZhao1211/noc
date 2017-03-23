import processing.pdf.*;

int d = 20;
int t1, t2;
void setup() {
  beginRecord(PDF, "test.pdf"); 
  size(450, 450);  
  for (int i = 0; i < 11; i++) {
    int a = i+1;
    if (a < 7) {
      t1 = 1;
      t2 = a-1;
    } else {
      t2 = 6;
      t1 = a-6;
    }
    stroke(0, 0, 0, i*25-30);
    fill(130+a*10);
    while (t2 > 0 && t1 < 7) {
      beginShape();
      //println(t2);
      for (int j = 0; j < i; j++) {
        float x = t2*d*3;
        float y = t1*d*3;
        x += d/2*cos(TWO_PI*j/i);
        y += d/2*sin(TWO_PI*j/i);
        vertex(x, y);
      }
      endShape(CLOSE);
      t1 ++;
      t2 --;
    }
  }
  endRecord();
}
void draw() {
}