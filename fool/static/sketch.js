// Daniel Shiffman
// Nature of Code: Intelligence and Learning
// https://github.com/shiffman/NOC-S17-2-Intelligence-Learning
var s = function(p){
  // Submit button
  var submit;
  // Show results
  var resultP;

  var next = false;
  var drawing = false;
  p.setup = function() {
    // Create DOM elements
    var canvas = p.createCanvas(200, 200);
    canvas.mousePressed(p.startDrawing);
    canvas.mouseReleased(p.stopDrawing);
    resultP = p.createP(' ');
    submit = p.createButton('classify');
    // When the button is pressed classify!
    submit.mousePressed(p.classify);
    p.background(0);
  };

  // Turn drawing on
  p.startDrawing = function() {
    drawing = true;
    if (next) {
      // Clear the background
      p.background(0);
      next = false;
    }
  };

  // Turn drawing off when you release
  p.stopDrawing = function() {
    drawing = false;
  };

  p.draw = function() {
    // If you are drawing
    if (drawing) {
      p.stroke(255);
      p.strokeWeight(16);
      p.line(p.pmouseX, p.pmouseY, p.mouseX, p.mouseY);
    }
  };

  // Run the classification
  p.classify = function() {
    // Get all the pixels!
    var img = p.get();
    // Turn it to a base64 encoded string
    var base64 = img.canvas.toDataURL();
    // Get rid of the header stuff (should maybe do this in flask)
    var cleaned = base64.replace('data:image/png;base64,', '');
    // Make an object to post
    var data = {
      img: cleaned
    }

    // Post the data!
    p.httpPost('/upload', data, success, error);

    // Here is where we get a reply
    function success(reply) {
      // Parse the reply
      var result = JSON.parse(reply);
      console.log(result);

      // As long as we got something
      if (result.number != undefined) {
        // Look at number and probability (confidence)
        var number = result.number;
        var confidence = result.prediction[number];
        // Display the results in the paragraph element
        resultP.html(number + '<br/>' + 'confidence: ' + p.nf(100 * confidence, 2, 1) + '%');
      } else {
        resultP.html('error');
      }
      next = true;
    }

    function error(reply) {
      console.log(reply);
      resultP.html('error');
    }
  };
}


var myp5 = new p5(s, 'c1');

var t = function(k){
  k.setup = function() {
    k.createCanvas(1000, 400);
    k.background(210);
  };
}
var display = new p5(t, 'c2');
