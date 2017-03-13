float count = 0;
int account = 0;
float y;
float oldy = map(noise(0), 0, 1, 100, 300);
void setup(){
  size(400,400);
}
void draw(){
  background(0);
  stroke(100, 200, 255);
  strokeWeight(1);
  noFill();
  beginShape();
  for(int i = 0; i < width; i++){
    y = map(noise(count), 0, 1, 100, 300);
    vertex(i, y);
    stroke(150, 230, 255);
    line(i, map(y, 100, 300, 150, 250), i-1, map(oldy, 100, 300, 150, 250));
    count +=0.01;
    oldy = y;
  }
  account += mouseX/10;
  count = 0.01 * account;
  endShape();
}