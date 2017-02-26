var PY, PX;
var x = [20];
var y = [20];
var segLength = 5;
var attractor;
var parcicle;
var G = 50;
function segment( x, y,  a) {
  strokeWeight(1);
  stroke(0, 0, 0,50);
  push();
  translate(x, y);
  rotate(a);
  line(0, 0, segLength, 0);
  pop();
}

function dragSegment( i,  xin,  yin) {
  var dx = xin - x[i];
  var dy = yin - y[i];
  var angle = atan2(dy, dx);
  x[i] = xin - cos(angle) * segLength;
  y[i] = yin - sin(angle) * segLength;
  segment(x[i], y[i], angle);
}

function setup() {
	//background(255);
	createCanvas(400,400);
	for(var i=0; i<20; i++) {
    	x[i]=1;
  	  y[i]=1;
	}
  attractor = createVector(200, 200);
  particle = new Particle(200, 10);

}

function keyPressed() {
  if (keyCode === DOWN_ARROW) {
    saveFrames("out", "png", 1, 1);
  }
}

function draw() {
  background(255, 1);
  particle.attracted(attractor);
  particle.update();
 PX=particle.pos.x;
 PY=particle.pos.y;
  dragSegment(0, PX, PY);
  for(var i=0; i<x.length-1; i++) {
    dragSegment(i+1, x[i], y[i]);
  }
}

function Particle(x, y){
  this.pos = createVector(x, y);
  this.vel = p5.Vector.random2D();
  this.acc = createVector();
  this.attracted = function(target){
    var force = p5.Vector.sub(target, this.pos);
    var sqr = force.magSq();
    sqr = constrain(sqr, 25, 500);
    force.setMag(G/sqr);
    this.acc = force;
  };
  this.update = function(){
    this.vel.add(this.acc);
    this.pos.add(this.vel);
  }

}
