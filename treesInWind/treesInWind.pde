//example from openprocessing
//link: https://www.openprocessing.org/sketch/5386#
float transparency = 150;
color leafColor = color(5,113,3,transparency);
color veinColor = color(5,113,3,transparency/2);
color branchColor = color(30);
color skyColor = color(211,211,255);

int width = 900;
int height = 500;

//branch controls
int nTrees = 1; //the number of trees
int nSegments;
float totalBranchLength;
float maxBranchThickness;
float minBranchThickness; 
float minSpawnDistance; //this controls how far the branch will grow before splitting
float branchSpawnOdds;   //the odds of a branch growing there
float branchSpawnOddsOfSecond; //odds of a second branch growing from the same node
float mindThetaSplit;
float maxdThetaSplit;
float maxdThetaWander;
float dBranchSize; //the new branch may change by 1.0+/- this amount

//leaf controls
float minLength; //leaf length
float maxLength; //leaf length
float minWidth;  //leaf width as a factor of length
float maxWidth;  //leaf width as a factor of length
float maxBranchSizeForLeaves;
float leafSpawnOdds;

branch[] branches;

boolean pauseWind = false;
boolean drawWind = false;
boolean drawVeins = false;
boolean blackLeaves = false;
boolean drawLeaves = true;

//int width = 1680;
//int height = 1050;

void setup(){
  size(900, 500);
  frameRate(30);
  smooth();
  noStroke();

  initializeTreeValues();
  
  windDirection = 0;
  windVelocity = 0;
  defineLeafOutline();
  defineVeins();
  
  generateBranches();
  
  redrawTrees();
}


void draw(){
  if(!pauseWind){
    updateWind();
    
    //move in the wind!
    for(int i = 0; i<nTrees; i++)
      branches[i].rotateDueToWind();
     
    redrawTrees();
    
    //draw the wind line
    if(drawWind)
      drawWindLine();
  }
}

void redrawTrees(){
  background(skyColor);
  drawBranches();
  if(drawLeaves)
    drawLeaves();
}

void drawBranches(){
  stroke(branchColor);
  for(int i = 0; i<nTrees; i++)
    branches[i].drawBranch(new float[]{(1+i)*(width/(1+nTrees)), height});
}

void drawLeaves(){
  noStroke();
  if(blackLeaves)
    fill(0,0,0,transparency);
  else
    fill(leafColor);
  //draw leaves
  for(int i = 0; i<nTrees; i++)
    branches[i].drawLeaves(new float[]{(1+i)*(width/(1+nTrees)), height});
}

void drawWindLine(){
  stroke(0);
  int dx= 100;
  int dy = 100;
  line(dx,dy,dx+50*windVelocity*cos(windDirection),dy+50*windVelocity*sin(windDirection));
  noStroke();
  fill(0);
  ellipse(dx,dy,3,3);
}

void initializeTreeValues(){
  pauseWind = false;
  drawWind = false;
  drawVeins = false;
  blackLeaves = false;
  drawLeaves = true;
  //branch
  nSegments = 15;
  totalBranchLength = 400;
  maxBranchThickness = 10;
  maxBranchSizeForLeaves = 4;
  minBranchThickness = 2; 
  minSpawnDistance = .2;
  branchSpawnOdds = .8; 
  branchSpawnOddsOfSecond = 0;
  mindThetaSplit = PI*.1;
  maxdThetaSplit = PI*.3;
  maxdThetaWander = PI/20;
  dBranchSize = .2;
  //leaves
  minLength = 10;
  maxLength = 30;
  minWidth = .4;
  maxWidth = .5;
  maxBranchSizeForLeaves = 4;
  leafSpawnOdds = .7;
  generateBranches(); 
}

void mouseClicked(){
  generateBranches();
  windDirection = random(TWO_PI);
  redrawTrees();
}

void keyTyped(){
  if(key == 'm'){
    drawWind = !drawWind;
    println(drawWind);
  }
  if(key== 'n')
    drawVeins = !drawVeins;
  if(key=='c')
    blackLeaves = !blackLeaves;
  if(key=='l')
    drawLeaves = !drawLeaves;
    
  if(key == 'p'){
    pauseWind = !pauseWind;
    if(pauseWind)
      windVelocity = 0;
  }

  if(key == '='){
    if(transparency<240){
      transparency +=10;
      leafColor = color(5,113,3,transparency);
    }
    println("transparency: "+transparency);
  }
  if(key == '-'){
    if(transparency>0){
      transparency -=10;
      leafColor = color(5,113,3,transparency);
    }
    println("transparency: "+transparency);
  }
  
  //more/less wiggly
  if(key=='q'){
    if(maxdThetaWander==0)
      maxdThetaWander = .01;
    maxdThetaWander = maxdThetaWander*1.2;
    generateBranches();
  }
  if(key=='a'){
    maxdThetaWander = maxdThetaWander/1.2;
    generateBranches();
  }
  
  //more/less branches
  if(key=='w'){
    if(branchSpawnOdds<1)
      branchSpawnOdds += .1;
    generateBranches();
  }
  if(key=='s'){
    if(branchSpawnOdds>0)
      branchSpawnOdds -= .1;
    generateBranches();    
  }

  
  //fatter/thinner branches
  if(key=='e'){
    maxBranchThickness = maxBranchThickness*1.2;
    maxBranchSizeForLeaves = maxBranchSizeForLeaves*1.2;
    minBranchThickness = minBranchThickness*1.2;
    generateBranches();
  }
  if(key=='d'){
    maxBranchThickness = maxBranchThickness/1.2;
    maxBranchSizeForLeaves = maxBranchSizeForLeaves/1.2;
    minBranchThickness = minBranchThickness/1.2;
    generateBranches();
  }

  //more/less leaves
  if(key=='r'){
    if(leafSpawnOdds<1)
      leafSpawnOdds += .1;
    generateBranches();
  }
  if(key=='f'){
    if(leafSpawnOdds>0)
      leafSpawnOdds -= .1;
    generateBranches();    
  }
  
  //bigger/smaller leaves
  if(key=='t'){
    minLength = minLength*1.2; //leaf length
    maxLength = maxLength*1.2; //leaf length
    generateBranches();
  }
  if(key=='g'){
    minLength = minLength/1.2; //leaf length
    maxLength = maxLength/1.2; //leaf length
    generateBranches();
  }
  
  if(key =='['){
    if(nLeafPoints > 6){
      nLeafPoints-=2;
      defineLeafOutline();
      defineVeins();
      println("nLeafPoints: "+nLeafPoints);
    }
  }
  if(key ==']'){
    nLeafPoints+=2;
    defineLeafOutline();
    defineVeins();
    println("nLeafPoints: "+nLeafPoints);
  }
  
  //reset
  if(key =='1')//natural-ish tree. looks healthy!
    initializeTreeValues();

  //hand-picked tree types!
  if(key =='2'){
    pauseWind = false;
    drawWind = false;
    drawVeins = false;
    blackLeaves = false;
    drawLeaves = true;
    //branch
    nSegments = 15;
    totalBranchLength = 400;
    maxBranchThickness = 10;
    maxBranchSizeForLeaves = 4;
    minBranchThickness = 1; 
    minSpawnDistance = .3;
    branchSpawnOdds = .8; 
    branchSpawnOddsOfSecond = 0;
    mindThetaSplit = PI/2;
    maxdThetaSplit = PI/2;
    maxdThetaWander = 0;
    dBranchSize = 0;
    //leaves
    minLength = 10;
    maxLength = 30;
    minWidth = .4;
    maxWidth = .5;
    leafSpawnOdds = .7;
    generateBranches();
  }
  if(key =='3'){
    pauseWind = false;
    drawWind = false;
    drawVeins = false;
    blackLeaves = false;
    drawLeaves = true;
    //branch
    nSegments = 15;
    totalBranchLength = 400;
    maxBranchThickness = 10;
    maxBranchSizeForLeaves = 4;
    minBranchThickness = 2;
    minSpawnDistance = .2;
    branchSpawnOdds = .8; 
    branchSpawnOddsOfSecond = 0;
    mindThetaSplit = PI/3;
    maxdThetaSplit = PI/3;
    maxdThetaWander = 0;
    dBranchSize = 0;
    //leaves
    minLength = 10;
    maxLength = 30;
    minWidth = .4;
    maxWidth = .5;
    leafSpawnOdds = .7;
    generateBranches();
  }
  if(key =='4'){
    pauseWind = false;
    drawWind = false;
    drawVeins = false;
    blackLeaves = false;
    drawLeaves = true;
    //branch
    nSegments = 15;
    totalBranchLength = 400;
    maxBranchThickness = 10;
    maxBranchSizeForLeaves = 4;
    minBranchThickness = 2;
    minSpawnDistance = .2;
    branchSpawnOdds = .8; 
    branchSpawnOddsOfSecond = 0;
    mindThetaSplit = PI/4;
    maxdThetaSplit = PI/4;
    maxdThetaWander = 0;
    dBranchSize = 0;
    //leaves
    minLength = 10;
    maxLength = 30;
    minWidth = .4;
    maxWidth = .5;
    leafSpawnOdds = .7;
    generateBranches();
  }
  if(key =='5'){
    pauseWind = false;
    drawWind = false;
    drawVeins = false;
    blackLeaves = false;
    drawLeaves = true;
    //branch
    nSegments = 15;
    totalBranchLength = 400;
    maxBranchThickness = 10;
    maxBranchSizeForLeaves = 4;
    minBranchThickness = 2;
    minSpawnDistance = .1;
    branchSpawnOdds = .3; 
    branchSpawnOddsOfSecond = 0;
    mindThetaSplit = 0;
    maxdThetaSplit = PI/4;
    maxdThetaWander = PI/4;
    dBranchSize = .2;
    //leaves
    minLength = 10;
    maxLength = 30;
    minWidth = .4;
    maxWidth = .5;
    leafSpawnOdds = .7;
    generateBranches();
  }
  
  if(key =='6'){
    pauseWind = false;
    drawWind = false;
    drawVeins = false;
    blackLeaves = false;
    drawLeaves = true;
    //branch
    nSegments = 15;
    totalBranchLength = 400;
    maxBranchThickness = 40;
    maxBranchSizeForLeaves = 4;
    minBranchThickness = 2;
    minSpawnDistance = .5;
    branchSpawnOdds = .3; 
    branchSpawnOddsOfSecond = 0;
    mindThetaSplit = 0;
    maxdThetaSplit = PI/2;
    maxdThetaWander = PI/8;
    dBranchSize = 0;
    //leaves
    minLength = 10;
    maxLength = 30;
    minWidth = .4;
    maxWidth = .5;
    leafSpawnOdds = .4;
    generateBranches();
  }
  
  if(key =='7'){
    pauseWind = false;
    drawWind = false;
    drawVeins = false;
    blackLeaves = false;
    drawLeaves = true;
    //branch
    nSegments = 15;
    totalBranchLength = 400;
    maxBranchThickness = 5;
    maxBranchSizeForLeaves = 4;
    minBranchThickness = 2;
    minSpawnDistance = .1;
    branchSpawnOdds = .2; 
    branchSpawnOddsOfSecond = 0;
    mindThetaSplit = 0;
    maxdThetaSplit = .3;
    maxdThetaWander = PI/30;
    dBranchSize = 0;
    //leaves
    minLength = 30;
    maxLength = 60;
    minWidth = .1;
    maxWidth = .2;
    leafSpawnOdds = .7;
    generateBranches();
  }
  
  if(key =='8'){
    pauseWind = false;
    drawWind = false;
    drawVeins = false;
    blackLeaves = false;
    drawLeaves = true;
    //branch
    nSegments = 15;
    totalBranchLength = 400;
    maxBranchThickness = 5;
    maxBranchSizeForLeaves = 1;
    minBranchThickness = .5;
    minSpawnDistance = .7;
    branchSpawnOdds = 1; 
    branchSpawnOddsOfSecond = 0;
    mindThetaSplit = 0;
    maxdThetaSplit = PI/6;
    maxdThetaWander = PI/30;
    dBranchSize = 0;
    //leaves
    minLength = 30;
    maxLength = 60;
    minWidth = .3;
    maxWidth = .5;
    leafSpawnOdds = 1;
    generateBranches();
  }
  
 if(key=='9'){
    pauseWind = false;
    drawWind = false;
    drawVeins = false;
    blackLeaves = true;
    drawLeaves = true;
    //branch
    nSegments = 20;
    totalBranchLength = 400;
    maxBranchThickness = 10;
    maxBranchSizeForLeaves = 4;
    minBranchThickness = 1.5;
    minSpawnDistance = .2;
    branchSpawnOdds = .3; 
    branchSpawnOddsOfSecond = 0;
    mindThetaSplit = PI/7;
    maxdThetaSplit = PI/6;
    maxdThetaWander = PI/10;
    dBranchSize = 0;
    //leaves
    minLength = 10;
    maxLength = 30;
    minWidth = .4;
    maxWidth = .5;
    leafSpawnOdds = .1;
    generateBranches();
 }
  
  redrawTrees();
}