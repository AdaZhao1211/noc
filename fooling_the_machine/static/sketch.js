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
var count = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
var imgs, base64, slider;
function preload(){
  font = loadFont('AdobeClean-Bold.otf');
  imgs = $('body');

}
function setup() {
  textFont(font);
  w = windowWidth;
  h = windowHeight;
  wg = (w-1000)/6;
  hg = (h-800)/6;
  slider = createSlider(5, 40, 30);
  slider.position(w/2-150, 450+2*hg);
  slider.style('width', '200px');
  var canvas = createCanvas(w, 4*hg+400);
  submit = createButton('submit');

  // When the button is pressed classify!
  submit.mousePressed(classify);
  background(0);
  stroke(210);
  strokeWeight(5);
  noFill();
  rect(w/2-210, 2*hg-10, 420, 420);
  textSize(200);
  stroke(255);
  strokeWeight(5);
  point(w/2-180, 450+2*hg);
  strokeWeight(40);
  point(w/2+80, 450+2*hg);
  for(var i = 0; i < 10; i++){
    store[i] = [];
  }
  for(var i = 0; i < 5; i++){
    if(i == 1) store[i] = font.textToPoints(i.toString(), wg+i*200+i*wg+60, 570+4*hg);
    else store[i] = font.textToPoints(i.toString(), wg+i*200+i*wg+50, 570+4*hg);
  }
  for(var i = 0; i < 5; i++){
    if(i == 2) store[i+5] = font.textToPoints((i+5).toString(), wg+i*200+i*wg+60, 770+5*hg);
    else store[i+5] = font.textToPoints((i+5).toString(), wg+i*200+i*wg+50, 770+5*hg);
  }
}

function mousePressed() {
    down = true;
}

function mouseReleased() {
  down = false;
}

function draw() {
  if (down) {
    if(mouseX<w/2+200 && mouseX>w/2-200 && mouseY>hg*2 && mouseY < hg*2+400){
      if(drawing){
        stroke(255);
        strokeWeight(slider.value());
        line(pmouseX, pmouseY, mouseX, mouseY);
      }
      drawing = true;
    }else{
      drawing = false;
    }
  }
  if(next){
    stroke(210);
    strokeWeight(10);
    fill(0);
    rect(w/2-210, 2*hg-10, 420, 420);
    next = false;
  }
}

// Run the classification
function classify() {
  // Get all the pixels!
  finalimg = get(w/2-200, hg*2, 400, 400);
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
    //console.(result);

    // As long as we got something
    if (result.number != undefined) {
      // Look at number and probability (confidence)
      finalnumber = result.number;
      var confidence = result.prediction[finalnumber];

    }
    next = true;
    if(count[finalnumber]+1 == store[finalnumber].length){
      count[finalnumber] = 0;
    }
    else count[finalnumber]+=1;
    var c = count[finalnumber];
    var i = new Image();
    i.src=base64;
    i.style.position = "absolute";
    i.width = 20;
    i.height = 20;
    i.style.left = store[finalnumber][c].x;
    i.style.top = store[finalnumber][c].y;
    imgs.append(i).fadeIn();
    noStroke();
    fill(0);
    rect(w/2+210, 0, w/2-210, 4*hg+400);
    image(finalimg, w/2+300, 2*hg, 200, 200);
    textSize(30);
    strokeWeight(1);
    fill(255);
    text("predicted number: "+finalnumber, w/2+300, 2*hg+250);
    text("confidence: "+nf(100 * confidence, 2, 1) + "%", w/2+300, 2*hg+350);

  }
  function error(reply) {
    console.log('error');
  }
}
