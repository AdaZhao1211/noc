class Ball {
  int m;
  PVector pos;
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0.5);
  float angle = 0;
  Ball(int _m, float _x, float _y) {
    m = _m;
    pos = new PVector(_x, _y);
  }
  void gravity(float g){
    acc.y = g;
  }
  void update() {
    if (pos.y > height - m/2) {
      vel = new PVector(vel.x, -vel.y*0.7);
      pos = new PVector(pos.x, height-m/2);
    }
    if (pos.x > 650-m/2) {
      if (vel.x > 1) {
        vel = new PVector(-vel.x*0.5, vel.y);
        pos = new PVector(650-m/2, pos.y);
      } else {
        vel = new PVector(0, vel.y);
        pos = new PVector(650-m/2, pos.y);
      }
    }
    applyForce(new PVector(windsp, 0));
    println(windsp);
    vel.add(acc);
    pos.add(vel);
    
  }
  void display(PImage img){
    pushMatrix();
    translate(pos.x, pos.y);
    angle += vel.x/m;
    rotate(angle);
    imageMode(CENTER);
    image(img, 0, 0);
    popMatrix();
  }
  void move(PImage img){
    imageMode(CENTER);
    image(img, pos.x, pos.y);
  }
  void applyForce(PVector force) {
    acc.x = force.x*2/m;
  }
}