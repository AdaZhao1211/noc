// Daniel Shiffman
// Nature of Code: Intelligence and Learning
// https://github.com/shiffman/NOC-S17-2-Intelligence-Learning

// Submit button
var submit;
// Show results
var resultP;
var next = false;
var w, h, wg, hg;
var drawing = false;
var down = false;
var font;
var store = [];
var tr = false;
var finalimg, finalnumber;
var count = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
function preload(){
  font = loadFont('AdobeClean-Bold.otf');
}
function setup() {
  textFont(font);
  w = windowWidth;
  h = windowHeight;
  wg = (w-1000)/6;
  hg = (h-800)/6;
  var canvas = createCanvas(w, h);
  resultP = createP(' ');
  submit = createButton('classify');
  // When the button is pressed classify!
  submit.mousePressed(classify);
  background(0);
  stroke(210);
  strokeWeight(5);
  noFill();
  rect(w/2-205, 2*hg-5, 410, 410);
  textSize(200);
  for(var i = 0; i < 10; i++){
    store[i] = [];
  }
  for(var i = 0; i < 5; i++){
    noStroke();
    fill(210);
    rect(wg+i*200+i*wg, 400+4*hg, 200, 200);
    if(i == 1) store[i] = font.textToPoints(i.toString(), wg+i*200+i*wg+60, 570+4*hg);
    else store[i] = font.textToPoints(i.toString(), wg+i*200+i*wg+50, 570+4*hg);
  }
  for(var i = 0; i < 5; i++){
    noStroke();
    fill(210);
    rect(wg+i*200+i*wg, 600+5*hg, 200, 200);
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
        strokeWeight(15);
        line(pmouseX, pmouseY, mouseX, mouseY);
      }
      drawing = true;
    }else{
      drawing = false;
    }
  }
  if(next){
    stroke(210);
    strokeWeight(5);
    fill(0);
    rect(w/2-205, 2*hg-5, 410, 410);
    next = false;
  }
}

// Run the classification
function classify() {
  // Get all the pixels!
  finalimg = get(w/2-200, hg*2, 400, 400);
  // Turn it to a base64 encoded string
  var base64 = finalimg.canvas.toDataURL();
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
      // Display the results in the paragraph element
      resultP.html(finalnumber + '<br/>' + 'confidence: ' + nf(100 * confidence, 2, 1) + '%');
    } else {
      resultP.html('error');
    }
    trans(finalimg, finalnumber);
  }

  function error(reply) {
    resultP.html('error');
  }
}
function trans(img, num){
  next = true;
  if(count[num]+1 == store[num].length){
    count[num] = 0;
  }
  else count[num]+=1;
  var c = count[num];
  image(img, store[num][c].x, store[num][c].y, 10, 10);
}
