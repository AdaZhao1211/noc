// Daniel Shiffman
// Nature of Code: Intelligence and Learning
// https://github.com/shiffman/NOC-S17-2-Intelligence-Learning
// Submit button
var submit;
// Show results
var next = false;
var w, h, wg, hg;
var drawing = false;
var down = false;
var font;
var store = [];
var tr = false;
var finalimg, finalnumber;
var imgs, base64, slider;
var first = true;
var up = true;
function preload(){
  font = loadFont('AdobeClean-Bold.otf');
  imgs = $('body');
}
function setup() {


  textFont(font);
  w = windowWidth-20;
  h = windowHeight-20;
  var canvas = createCanvas(w, h);

  background(0);
  stroke(210);
  strokeWeight(10);
  noFill();
  rect(h*0.05, h/2-h*0.9*0.5, h*0.9, h*0.9);
  strokeWeight(5);
  rect(h, h*0.5, 150, 70);
  textSize(30);
  strokeWeight(1);
  fill(255);
  textAlign(LEFT);
  text("Submit", h+30, h*0.5+40);
  //rect(400, 400, 400, 400);
}

function mousePressed() {
    down = true;
    if(mouseX<h+150 && mouseX>h && mouseY>h*0.5 && mouseY < h*0.5+70){
      classify();
    }
}

function mouseReleased() {
  down = false;
}

function draw() {

  if (down) {

    if(mouseX<h*0.95 && mouseX>h*0.05 && mouseY>h/2-h*0.9*0.5 && mouseY < h/2+h*0.9*0.5){
      if(first){
        document.getElementById("instruction").style.display = 'none';
        first = false;
      }
      if(drawing){
        stroke(255);
        strokeWeight(50);
        if(up){
          up = false;
        }else{
          line(pmouseX, pmouseY, mouseX, mouseY);
        }

      }
      drawing = true;
    }else{
      drawing = false;
    }
  }else{
    up = true;
  }
  if(next){
    first = true;
    stroke(210);
    strokeWeight(10);
    fill(0);
    rect(h*0.05, h/2-h*0.9*0.5, h*0.9, h*0.9);
    strokeWeight(5);
    rect(h, h*0.5, 150, 70);
    textSize(30);
    strokeWeight(1);
    fill(255);
    textAlign(LEFT);
    text("Submit", h+30, h*0.5+40);
    document.getElementById("instruction").style.display = 'block';
    next = false;
  }

}

// Run the classification
function classify() {

  // Get all the pixels!
  finalimg = get(h*0.05+10, h/2-h*0.9*0.5+10, h*0.9-20, h*0.9-20);
  // Turn it to a base64 encoded string
  base64 = finalimg.canvas.toDataURL();
  // Get rid of the header stuff (should maybe do this in flask)
  var cleaned = base64.replace('data:image/png;base64,', '');
  // Make an object to post
  var data = {
    img: cleaned
  }

  // Post the data!
  httpPost('/upload', data, success, error);

  // Here is where we get a reply
  function success(reply) {
    // Parse the reply
    var result = JSON.parse(reply);
    console.log(result);

    // As long as we got something
    if (result.number != undefined) {
      // Look at number and probability (confidence)
      finalnumber = result.number;
      var confidence = result.prediction[finalnumber];

    }
    next = true;
    fill(0);
    noStroke();
    rect(0, 0, w, h);
    textSize(30);
    strokeWeight(1);
    fill(255);
    textAlign(LEFT);
    text("predicted number: "+finalnumber, h, w*0.1);
    text("confidence: "+nf(100 * confidence, 2, 1) + "%", h, w*0.2);

  }
  function error(reply) {
    console.log('error');
  }
}
