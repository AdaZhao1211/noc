import controlP5.*;
import toxi.physics3d.*;
import toxi.physics3d.behaviors.*;
import toxi.physics3d.constraints.*;
import toxi.geom.*;
ControlP5 cp5;
VerletPhysics3D phy = new VerletPhysics3D();

//api
String city;
String oldcity = "new york";
float windsp;
float windspeed;
float windmin;
float winddeg;
float noiseCount = 10.0;
//flag
int rows = 41;
int cols = 31;
float w = 3;
PImage flagimg;
Particle[][] ps = new Particle[cols][rows];
ArrayList<Spring> ss = new ArrayList<Spring>();
//ball
Ball ball;
PImage ballimg;
//tree
Tree tree;
Tree t2;
float windForTree;
float startAngle;
float windnoise=0.0;
//balloon
PImage balloonimg;
Ball balloon;
Particle[] bps = new Particle[100];
ArrayList<Spring> bss = new ArrayList<Spring>();
//building
PImage building;

void setup() {
  size(800, 600, P3D);
  //...input
  PFont font = createFont("arial", 20);
  cp5 = new ControlP5(this);
  city = "new york";
  cp5.addTextfield("city").setPosition(700, 540).setText(city).setSize(90, 30).setFont(font).setFocus(false).setColor(255).setColorCursor(250).setColorBackground(100).setAutoClear(false);
  //...api, winddata
  apicall(city);
  //create a range for the wind to change with noise()
  //println(winddeg);
  //...flag
  flagimg = loadImage("flag.jpg");
  Vec3D gravity = new Vec3D(0, 0.01, 0);
  GravityBehavior3D gb = new GravityBehavior3D(gravity);
  phy.addBehavior(gb);
  float x = -cols*w/2;
  for (int i = 0; i < cols; i++) {
    float y = -rows*w/2;
    for (int j = 0; j < rows; j++) {
      Particle p = new Particle(x, y, 0);
      ps[i][j] = p;
      phy.addParticle(p);
      y = y + w;
    }
    x = x + w;
  }

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      Particle a = ps[i][j];
      if (i != cols-1) {
        Particle b1 = ps[i+1][j];
        Spring s1 = new Spring(a, b1);
        ss.add(s1);
        phy.addSpring(s1);
      }
      if (j != rows-1) {
        Particle b2 = ps[i][j+1];
        Spring s2 = new Spring(a, b2);
        ss.add(s2);
        phy.addSpring(s2);
      }
    }
  }

  ps[0][0].lock();
  ps[cols-1][0].lock();
  //...ball
  ballimg = loadImage("ball.png");
  ball = new Ball(50, 200, 400);
  //...tree
  tree = new Tree(130);
  tree.generateTree();
  t2 = new Tree(80);
  t2.generateTree();
  //...building
  building = loadImage("05.jpg");
  //...balloon
  balloonimg = loadImage("balloon.png");
  balloon = new Ball(40, 400, 300);
  balloon.gravity(-0.001);
  w = 1;
  for (int i = 0; i < 100; i++) {
    bps[i] = new Particle(0, i*w, 0);
    phy.addParticle(bps[i]);
  }
  bps[0].lock();
  for (int i = 0; i < 99; i++) {
    Spring s = new Spring(bps[i], bps[i+1]);
    bss.add(s);
    phy.addSpring(s);
  }
}
void newStart() {
  balloon = new Ball(40, 400, 300);
  balloon.gravity(-0.001);
  ball = new Ball(50, 200, 400);
}
void draw() {
  background(210);
  image(building, 650, 0);
  strokeWeight(5);
  line(565, height/2-60, 650, height/2-60);

  tree.drawTree(300, 600);
  t2.drawTree(400, 550);
  windspeed = map(noise(noiseCount+=0.001), 0, 1, windmin, windsp);
  //println(windspeed);
  pushMatrix();
  translate(610, height/2);
  phy.update();
  for (int j = 0; j < rows-1; j++) {
    noStroke();
    beginShape(TRIANGLE_STRIP);
    texture(flagimg);
    for (int i = 0; i < cols; i++) {
      float u = map(i, 0, cols, 0, flagimg.width);
      float v = map(j, 0, rows, 0, flagimg.height);
      Particle p1= ps[i][j];
      vertex(p1.x, p1.y, 0, u, v);
      Particle p2= ps[i][j+1];
      v = map(j+1, 0, rows, 0, flagimg.height);
      vertex(p2.x, p2.y, 0, u, v);
      //particles[i][j].display();

      //float wx = map(noise(xoff, yoff, zoff), 0, 1, -0.1, 1);
      //float wy = map(noise(xoff+5000, yoff+5000, zoff), 0, 1, -0.1, 0.1);
      //float wz = map(noise(xoff+10000, yoff+10000, zoff), 0, 1, -0.1, 0.1);
      Vec3D wind = new Vec3D(windspeed*5*sin(winddeg), windspeed*5*cos(winddeg), 0);
      p1.addForce(wind);
    }
    endShape();
  }

  popMatrix();
  //balloon
  pushMatrix();
  translate(balloon.pos.x, balloon.pos.y+20);
  for (int i = 1; i < 100; i++) {
    Vec3D wind = new Vec3D(windspeed*sin(winddeg), windspeed*cos(winddeg), 0);
    bps[i].addForce(wind);
    stroke(0);
    line(bps[i-1].x, bps[i-1].y, bps[i].x, bps[i].y);
  }
  popMatrix();
  startAngle = map(windspeed, -0.1, 0.1, -PI/10, PI/10);
  windForTree = map(noise(windnoise+=0.01), 0, 1, startAngle/2, startAngle);
  ball.update();
  ball.display(ballimg);
  balloon.update();
  balloon.move(balloonimg);

  if (!city.equals(oldcity)) {
    apicall(city);
    oldcity = city;
    newStart();
  }

  
  imageMode(CORNER);
}

void apicall(String _city) {
  println("call api");
  println(_city);
  String api_key = "5ca92dceefd25032d317c6e460c1f71a";
  String url = "http://api.openweathermap.org/data/2.5/weather?q="+_city+"&appid="+api_key;
  JSONObject json = loadJSONObject(url).getJSONObject("wind");
  winddeg = map(json.getFloat("deg"), 0, 360, 0, TWO_PI);
  windsp = json.getFloat("speed")/100;
  if (winddeg > PI/2 && winddeg < 3*PI/2) {
    windsp = -windsp;
  }
  windmin = windsp-0.005;
  windsp += 0.005;
}