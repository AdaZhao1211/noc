import controlP5.*;
import toxi.physics3d.*;
import toxi.physics3d.behaviors.*;
import toxi.physics3d.constraints.*;
import toxi.geom.*;
ControlP5 cp5;
VerletPhysics3D phy = new VerletPhysics3D();

//api
String city;
float windsp;
float windspeed;
float windmin;
float winddeg;
float noiseCount = 10.0;
//flag
int row = 41;
int col = 31;
PImage flagimg;
//ball
Ball ball;
PImage ballimg;

Particle[][] ps = new Particle[row][col];
ArrayList<Spring> ss = new ArrayList<Spring>();

void setup() {
  size(800, 600, P3D);
  //...input
  PFont font = createFont("arial", 20);
  cp5 = new ControlP5(this);
  cp5.addTextfield("").setPosition(700, 550).setSize(90, 20).setFont(font).setFocus(false).setColor(255).setColorCursor(250).setColorBackground(100).setAutoClear(false);
  
  //...api call
  //?real-time data?
  /* api not working
  String api_key = "5ca92dceefd25032d317c6e460c1f71a";
  city = "New York";
  String url = "http://api.openweathermap.org/data/2.5/weather?q="+city+"&appid="+api_key;
  JSONObject json = loadJSONObject(url).getJSONObject("wind");
  winddeg = json.getFloat("deg");
  windsp = json.getFloat("speed")/1000;
  */
  winddeg = 320;
  windsp = 0.006;
  windmin = windsp-0.001;
  windsp += 0.001;
  //create a range for the wind to change with noise()
  //println(winddeg);
  
  //...flag
  flagimg = loadImage("flag.jpg");
  //...ball
  ballimg = loadImage("ball.png");
  ball = new Ball(50, 200, 400);
}

void draw(){
  background(210);
  ball.update();
  windspeed = map(noise(noiseCount+=0.001), 0, 1, windmin, windsp);
  println(windspeed);
}