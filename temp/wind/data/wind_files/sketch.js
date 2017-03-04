var api_key = '5ca92dceefd25032d317c6e460c1f71a';
var thisInput;
var windSpeed;
var windDegree;
var city;
//flag variables
var row = 5;
var col = 4;
var Bobs = new Array();
var flagimg;
//var Springs= new Array(num-1)
var flagx = 50;
var flagy = 0;
var ball;
var g = 0.5;
var start = false;
var pin;
var ballimg;

function preload(){
  city = "New York";
  //pin???
  pin = loadImage("data/pin.png");
  ballimg = loadImage("data/ball.png");
  flagimg = loadImage("data/flag.jpg");
  thisInput = createInput();

  thisInput.value("New York");

  $.ajax({
    url: "http://api.openweathermap.org/data/2.5/weather?q="+city+"&appid="+api_key,
    type: 'GET',
    dataType: 'json',
    success: function(result){
      windSpeed = result.wind.speed/1000;
      windDegree = result.wind.deg;
      console.log(windSpeed);
      console.log(windDegree);
      start = true;
    },
    error: function (err) {
      console.log(err);
    }
  });
}
function setup(){
  createCanvas(800, 600, WEBGL);
  background(210);
  thisInput.position(660, 580);
  thisInput.changed(newText);
  ball = new Ball(50, 200, 450);
  //construct flag bobs matrix
  for(var temprow = 0; temprow < row; temprow++){
    if(temprow == 0){
      for(var tempcol = 0; tempcol < col; tempcol++){
        if(tempcol == 0){
          Bobs.push(new Array());
        }
        Bobs[temprow].push(new Bob(10, flagx+30*tempcol, flagy+30*temprow, 1));
      }
    }else{
      for(var tempcol = 0; tempcol < col; tempcol++){
        if(tempcol == 0){
          Bobs.push(new Array());
        }
        Bobs[temprow].push(new Bob(10, flagx+30*tempcol, flagy+30*temprow, 0));
      }
    }
  }
  //construct Springs
  for(var temprow = 0; temprow < row; temprow++){
    for(var tempcol = 0; tempcol < col; tempcol++){
      var bob = Bobs[temprow][tempcol];
      if(temprow != row-1){
        var bob1 = Bobs[temprow + 1][tempcol];

      }
      if(tempcol != col-1){
        var bob2 = Bobs[temprow][tempcol + 1];
      }
    }
  }
}
function draw(){

  background(210);
  for(var _row = 0; _row < row-1; _row++){
    for(var _col=0; _col<col; _col++){
      beginShape(LINES);

      var b = Bobs[_row][_col];
      var b2 = Bobs[_row+1][_col];
      fill(0, 0, 0);
      vertex(b.pos.x, b.pos.y, 0);
      vertex(b2.pos.x, b2.pos.y, 0);
      endShape();

    }
  }

  /*ball part done
  if(start){
    background(210);
    ball.update();
    //ball.rotate();
    //ball.display();
    image(pin, 630, 570, 20, 20);
  }
  */
}

function newText(){
  city = thisInput.value();
  $.ajax({
    url: "http://api.openweathermap.org/data/2.5/weather?q="+city+"&appid="+api_key,
    type: 'GET',
    dataType: 'json',
    success: function(result){
      temp = result.wind;
      windSpeed = result.wind.speed/1000;
      windDegree = result.wind.deg;
      console.log(windSpeed);
      console.log(windDegree);
      setup();
    },
    error: function (err) {
      console.log(err);
    }
  });
}
