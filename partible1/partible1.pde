//random force?
import processing.pdf.*;
ArrayList<Particle> list = new ArrayList<Particle>();
ArrayList<Attractor> l = new ArrayList<Attractor>();
int n = 10000;
int att = 6;
void setup(){
  background(255);
  colorMode(HSB, 100);
  beginRecord(PDF, "test2.pdf");
  //l.add(new Attractor(40, 100));
  //l.add(new Attractor(250, 70));
  //l.add(new Attractor(347, 30));
  
  for(int i = 0; i < att; i++){
    Attractor a = new Attractor(random(0, 400), random(0, 400));
    //println(a.poss.x);
    //println(a.poss.y);
    l.add(a);
    //a.show();
  }
  for(int i = 0; i < n; i++){
    Particle p = new Particle(200, 200);
    p.update(l);
    p.show();
    list.add(p);
  }
  size(400, 400);
}
void draw(){
  for(int i = 0; i < n; i++){
    Particle p = list.get(i);
    p.update(l);
    p.show();
    p.reset();
  }
  saveFrame("output/frames####.png");
}
class Attractor{
  PVector poss = new PVector(0, 0);
  Attractor(float x, float y){
    poss.x = x;
    poss.y = y;
  }
  void show(){
    ellipse(poss.x, poss.y, 10, 10);
  }
}
class Particle{
  PVector pos;
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  PVector prevPos = new PVector(0, 0);
  PVector origin = new PVector();
  Particle(float x, float y){
    pos = new PVector(x, y);
    origin.x = pos.x;
    origin.y = pos.y;
    vel.x = random(-200, 200);
    vel.y = random(-200, 200);
    //c = color(255, 211, 29, random(150));
  }
  void show(){
    stroke(5, 10);
    point(pos.x, pos.y);
    //stroke(color(12, 89, 30, 100-vel.mag()*15));
    //strokeWeight((7-vel.mag())*0.3);
    //line(prevPos.x, prevPos.y, pos.x, pos.y);
    //stroke(color(12, 89, 10, 10));
    //strokeWeight(0.1);
    //line(origin.x, origin.y, pos.x, pos.y);
    //point(pos.x, pos.y);
  }
  void update(ArrayList<Attractor> l){
    //prevPos.x = pos.x;
    //prevPos.y = pos.y;
    for(int i = 0; i < att; i++){
      Attractor a = l.get(i);
      acc = PVector.sub(a.poss, pos);
      acc.setMag(400);
      vel.add(acc);
      pos.add(vel);
      //vel.limit(10);
    }

    //PVector mouse = new PVector(mouseX, mouseY);
    //acc = PVector.sub(mouse, pos);
    
  }
  void reset(){
      vel.setMag(0.1);
  }
}

void keyPressed() {
  if (key == 's') {
    println("yes");
    endRecord();
    //exit();
  }
}