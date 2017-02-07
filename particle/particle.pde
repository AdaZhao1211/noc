//Particle p;
import processing.pdf.*;
ArrayList<Particle> list = new ArrayList<Particle>();
int n = 5;
void setup(){
  colorMode(HSB, 100);
  beginRecord(PDF, "test2.pdf");
  //background(255);
  for(int i = 0; i < n; i++){
    Particle p = new Particle(random(100, 300), random(100, 300));
    p.update();
    p.show();
    list.add(p);
  }

  size(400, 400);
}
void draw(){
  //PVector acc = new PVector driven by mouse
  //background(0);
  for(int i = 0; i < n; i++){
    Particle p = list.get(i);
    p.update();
    p.show();
    //list.add(p);
  }
}

class Particle{
  PVector pos;
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  PVector prevPos = new PVector(0, 0);
  PVector origin = new PVector();
  //int hue = 48;
  Particle(float x, float y){
    pos = new PVector(x, y);
    origin.x = pos.x;
    origin.y = pos.y;
    //c = color(255, 211, 29, random(150));
  }
  void show(){
    stroke(color(12, 89, 100-vel.mag()*20));
    strokeWeight(4.5-vel.mag());
    line(prevPos.x, prevPos.y, pos.x, pos.y);
    stroke(color(12, 89, 10));
    strokeWeight(0.01);
    line(origin.x, origin.y, pos.x, pos.y);
    //point(pos.x, pos.y);
  }
  void update(){
    prevPos.x = pos.x;
    prevPos.y = pos.y;

    PVector mouse = new PVector(mouseX, mouseY);
    acc = PVector.sub(mouse, pos);
    acc.setMag(0.1);
    vel.add(acc);
    pos.add(vel);
    vel.limit(3);
  }
}

void keyPressed() {
  if (key == 's') {
    endRecord();
    exit();
  }
}