class Word{
  PVector pos, vel, acc;
  float r, maxf, maxspeed;
  String word;
  Word(String _text, PVector l, float ms, float mf){
    pos = l;
    r = 4;
    maxspeed = ms;
    maxf = mf;
    acc = new PVector(0, 0);
    vel = new PVector(maxspeed, 0);
    word = _text;
  }
  void follow(Way p){
    PVector predict = vel;
    predict.normalize().mult(50);
    PVector predictPos = pos.add(predict);
    PVector normal = null;
    PVector target = null;
    float worldRecord = 100000;
    for(int i = 0; i < p.points.size()-1; i++){
      PVector a = p.points.get(i);
      PVector b = p.points.get(i+1);
      PVector normalPoint = getNormalPoint(predictPos, a, b);
      if(normalPoint.x < a.x || normalPoint.x > b.x){
        normalPoint = b;
      }
      float distance = PVector.dist(predictPos, normalPoint);
      if(distance < worldRecord){
        worldRecord = distance;
        normal = normalPoint;
        PVector dir = PVector.sub(b, a);
        dir.normalize();
        dir.mult(10);
        target = normalPoint;
        target.add(dir);
      }
    }
    if(worldRecord > p.radius){// the width
      seek(target);
    }
    
  }
  PVector getNormalPoint(PVector p, PVector a, PVector b){
    PVector ap = PVector.sub(p, a);
    PVector ab = PVector.sub(b, a);
    ab.normalize();
    ab.mult(ap.dot(ab));
    PVector normalPoint = PVector.add(a, ab);
    return normalPoint;
  }
  void seek(PVector target){
    PVector desired = PVector.sub(target, pos);
    if(desired.mag() == 0) return;
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxf);
  }
  
  void applyForce(PVector force){
    acc.add(force);
  }
  void update(){
    vel.add(acc);
    vel.limit(maxspeed);
    pos.add(vel);
    acc.mult(0);
   
  }
  void display(){
    ellipse(pos.x, pos.y, 5, 5);
  }
  void run(){
    update();
    display();
  }
}