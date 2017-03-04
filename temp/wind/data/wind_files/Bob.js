function Ball(m, x, y){
  this.m = m;
  this.pos = createVector(x, y);
  this.vel = createVector(0, 0);
  this.acc = createVector(0, g);
  this.old = 0;
  this.update = function(){
    //wind and gravity
    if(this.pos.y > 600-m/2){
      this.vel = createVector(this.vel.x, -this.vel.y*0.7);
      this.pos = createVector(this.pos.x, 600-m/2);
    }
    this.applyForce(createVector(windSpeed, 0));
    this.vel.add(this.acc);
    this.pos.add(this.vel);
    push();
    translate(this.pos.x, this.pos.y);
    this.old+=this.vel.x/m;
    rotate(this.old);
    imageMode(CENTER);
    image(ballimg, 0, 0);
    pop();
  }
  this.applyForce = function(force){
    this.acc.add(force.div(m));
  }
}

function Bob(m, x, y, b){
  this.m = m;
  this.pos = createVector(x, y);
  this.vel = createVector(0, 0);
  this.acc = createVector(0, g);
  if(b == 1){
    this.acc.y = 0;
  }
  this.display = function(){
    ellipse(this.pos.x, this.pos.y, this.m, this.m);
  }
  this.update = function(){
    this.vel.add(this.acc);
    this.pos.add(this.vel);
  }
  this.applyForce = function(force){
    this.acc.add(force);
  }
}
