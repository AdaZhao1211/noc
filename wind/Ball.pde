class Ball{
  int m;
  PVector pos;
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0.5);
  float angle = 0;
  Ball(int _m, float _x, float _y){
     m = _m;
     pos = new PVector(_x, _y);
  }
  void update(){
    if(pos.y > height - m/2){
      vel = new PVector(vel.x, -vel.y*0.7);
      pos = new PVector(pos.x, height-m/2);
    }
    applyForce(new PVector(windspeed/10, 0));
    vel.add(acc);
    pos.add(vel);
    pushMatrix();
    translate(pos.x, pos.y);
    angle += vel.x/m;
    rotate(angle);
    imageMode(CENTER);
    image(ballimg, 0, 0);
    popMatrix();
  }
  void applyForce(PVector force){
    acc.add(force.div(m));
  }
}