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
float windForTree;
float startAngle;

void setup() {
  size(800, 600, P3D);
  //...input
  PFont font = createFont("arial", 20);
  cp5 = new ControlP5(this);
  city = "new york";
  cp5.addTextfield("city").setPosition(700, 540).setText(city).setSize(90, 30).setFont(font).setFocus(false).setColor(255).setColorCursor(250).setColorBackground(100).setAutoClear(false);
  //...api, winddata
  //apicall(city);
  winddeg = map(winddeg, 0, 360, 0, TWO_PI);
  windsp = 0.006;
  windmin = windsp-0.001;
  windsp += 0.001;
  //create a range for the wind to change with noise()
  //println(winddeg);
  //...flag
  flagimg = loadImage("flag.jpg");
  Vec3D gravity = new Vec3D(0, 0.05, 0);
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
}

void draw() {
  background(210);
    line(700, 0, 700, 600);

  windspeed = map(noise(noiseCount+=0.001), 0, 1, windmin, windsp);
  
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
      vertex(p2.x, p2.y,0, u, v);
      //particles[i][j].display();

      //float wx = map(noise(xoff, yoff, zoff), 0, 1, -0.1, 1);
      //float wy = map(noise(xoff+5000, yoff+5000, zoff), 0, 1, -0.1, 0.1);
      //float wz = map(noise(xoff+10000, yoff+10000, zoff), 0, 1, -0.1, 0.1);
      Vec3D wind = new Vec3D(windspeed*5, 0, 0);
      p1.addForce(wind);
    }
    endShape();
  }

  popMatrix();
  
   startAngle = map(windspeed, 0, 0.01, 0, PI/10);
   windForTree = map(windspeed, windmin, windsp, startAngle, startAngle*1.3);
   tree.drawTree();
  
  
  ball.update();
  /*
   if(!city.equals(oldcity)){
   apicall(city);
   oldcity = city;
   }
   */
  //strokeWeight(5);
}

void apicall(String _city) {
  println("call api");
  println(_city);
  //...api call
  //?real-time data?
  String api_key = "b1b15e88fa797225412429c1c50c122a1";
  String url = "http://api.openweathermap.org/data/2.5/weather?q="+_city+"&appid="+api_key;
  JSONObject json = loadJSONObject(url).getJSONObject("wind");
  winddeg = json.getFloat("deg");
  windsp = json.getFloat("speed")/1000;
  windmin = windsp-0.0005;
  windsp += 0.0005;
}