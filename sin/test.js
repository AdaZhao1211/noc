var PY, PX;
var x = [20];
var y = [20];
var segLength = 5;
var d = 5;
var n = 4;
var canvas;
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
	canvas = createCanvas(400,400);
	for(var i=0; i<20; i++) {
    	x[i]=1;
  	  y[i]=1;
	}
  angleMode(DEGREES);
  //attractor = createVector(200, 200);
  //particle = new Particle(200, 100);
  for(var i = 0; i < 360*n; i+=1){
    var r = 200*cos(d/n*i);
    var xx = r * cos(i)+200;
    var yy = r * sin(i)+200;
    PX=xx;
    PY=yy;
    dragSegment(0, PX, PY);
    for(var i=0; i<x.length-1; i++) {
      dragSegment(i+1, x[i], y[i]);
    }
  }

}

function keyPressed() {
  if (keyCode === DOWN_ARROW) {
    saveCanvas(canvas, "test", 'jpg');
  }

}
