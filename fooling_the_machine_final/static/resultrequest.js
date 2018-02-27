var font, edge, wg, hg;
var store = []
var myW, myH;
var finalnumber, gray;
var drawimage = false;
var count = [];
var resolution = 1;
function preload(){
  font = loadFont('AdobeClean-Bold.otf');

  console.log("print");
  setInterval(function(){
    $.ajax({url: "/ask", success: function(response){

        console.log(response.result);
        if(response.result != -1){

          finalnumber = response.result;
          gray = response.gray;
          console.log(response.gray);
          drawimage = true;
        }
    }});
  }, 3000);

}

function setup(){
  textFont(font)
  myW = windowWidth-3.6;
  myH = windowHeight-3.6;

  var canvas = createCanvas(myW, myH);
  background(0);
  if(myW*0.8*0.2 > myH*0.9*0.5){
    edge = myH * 0.9 * 0.5
  }else{
    edge = myW * 0.9 * 0.2
  }
  wg = (myW - edge*5)/6;
  hg = (myH - edge*2)/3;

  textSize(edge);
  for(var i = 0; i < 10; i++){
    count[i] = 0;
    if(i > 4){
      store[i] = font.textToPoints(i.toString(), wg*(i+1-5)+edge*(i-5+0.25), hg*2+edge*1.8);
    }else{
      // for debugging

      // fill(255, 0, 0);
      // noStroke();
      // rect((wg+edge)*i, 0, wg, 500);
      // fill(25, 200, 0);
      // noStroke();
      // rect((wg+edge)*i+wg, hg, edge, edge);

      store[i] = font.textToPoints(i.toString(), wg*(i+1)+edge*(i+0.25), hg+edge*0.8);
    }
  }


}

function draw(){
  if(drawimage){
    console.log("drawing");
    drawimage = false;
    var c = count[finalnumber];
    console.log(store[finalnumber][c].x);
    strokeWeight(resolution)
    console.log(gray);
    for(var i = 0; i< 28; i++){
      for(var j = 0; j< 28; j++){
        stroke(gray[i][j]);
        point(store[finalnumber][c].x+j*resolution, store[finalnumber][c].y+i*resolution);
      }
    }

    if(count[finalnumber]+3 >= store[finalnumber].length){
      count[finalnumber] = 0;
    }
    else count[finalnumber]+=3;
  }
}
