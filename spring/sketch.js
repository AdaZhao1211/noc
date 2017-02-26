//two springs connected together, moving according to the force
//draw the trace of the connecting point
//force is generated with perlin noise
var b1;
var b2;
var b3;
var count = -90;
var countnoise = 0;

// Spring object
var spring;
var s;

function setup()  {
  createCanvas(800, 800);
  b1 = new Bob(200, 400, 30);
  b2 = new Bob(200, 500, 15);
  b3 = new Bob(200, 600, 30);
  spring = new Spring(100);
  s = new Spring(100);
  spring.displayLine(b1, b2);
  s.displayLine(b3, b2);
  b1.display();
  b2.display();
  b3.display();
}


function draw() {
  angleMode(DEGREES);
  background(250);
  var push = map(noise(countnoise), 0, 1, 0, 5);

  var pushforce = createVector(cos(count)*push, sin(count)*push);
  b1.applyForce(pushforce);
  b1.update();
  // Connect the bob to the spring (this calculates the force)
  spring.update(b1, b2);
  // Constrain spring distance between min and max

  // Update bob
  b1.update();
  spring.update(b2, b1);
  b2.update();
  spring.update(b3, b2);
  b3.update();
  //b2.display();


  var push = map(noise(countnoise+20), 0, 1, 0, 10);

  var pushforce = createVector(cos(180-count)*push, sin(180-count)*push);
  b3.applyForce(pushforce);
  b3.update();
  countnoise += 0.01;
  count ++;
  if(count > 90) count -= 180;

  // Connect the bob to the spring (this calculates the force)
  spring.update(b3, b2);
  // Constrain spring distance between min and max

  // Update bob
  b3.update();

  spring.update(b2, b3);
  b2.update();
  spring.update(b1, b2);
  b1.update();




  //Draw everything
  spring.displayLine(b1, b2); // Draw a line between spring and bob
  b1.display();
  //Draw everything
  spring.displayLine(b3, b2); // Draw a line between spring and bob
  b3.display();
  b2.display();
  // strokeWeight(3);
  // colorMode(HSB, 100);
  // stroke(color(count + 90, 100, 50));
  // point(b2.position.x, b2.position.y);

}



//bob
var Bob = function(x, y, m) {
  this.position = createVector(x,y);
  this.velocity = createVector();
  this.acceleration = createVector();
  this.mass = m;
  // Arbitrary damping to simulate friction / drag
  this.damping = 0.98;
  // For user interaction
  this.dragOffset = createVector();
  this.dragging = false;

  // Standard Euler integration
  this.update = function() {
    this.velocity.add(this.acceleration);
    this.velocity.mult(this.damping);
    this.position.add(this.velocity);
    this.acceleration.mult(0);
  };

  // Newton's law: F = M * A
  this.applyForce = function(force) {
    var f = force.copy();
    f.div(this.mass);
    this.acceleration = f;
  };

  // Draw the bob
  this.display = function() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    if (this.dragging) {
      fill(200);
    }
    ellipse(this.position.x, this.position.y, this.mass*2, this.mass*2);
  };
};

var Spring = function(l, b) {
  this.restLength = l;
  this.k = 0.5;
  //this. bb = b;
  //print(this.b1.position.x);

  this.update = function(b1, b2) {
    var force = p5.Vector.sub(b1.position, b2.position);
    //print(force.mag());
    var d = force.mag() - this.restLength;
    force.normalize();
    force.mult(-1 * this.k * d);
    b1.applyForce(force);
  };


  this.displayLine = function(b1, b2) {
    strokeWeight(2);
    stroke(0);
    line(b1.position.x, b1.position.y, b2.position.x, b2.position.y);
    //print(dist(b1.position.x, b1.position.y, b2.position.x, b2.position.y));
  };
};
