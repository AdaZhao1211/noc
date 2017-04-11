var cmajor = {
  'C': 60,
  'D': 62,
  'E': 64,
  'F': 65,
  'G': 67,
  'A': 69,
  'B': 71,
}

var training = [{
    note: 'C',
    x: 100,
    y: 100
  },
  {
    note: 'D',
    x: 400,
    y: 100
  },
  {
    note: 'E',
    x: 500,
    y: 200
  }, {
    note: 'F',
    x: 400,
    y: 400
  }, {
    note: 'G',
    x: 100,
    y: 400
  }
]



// What is k
// This example will work by definition with a k of 1
var k = 1;

// All the training data
var data;

var osc;

var radio;
var flip = true;
var xx = 0;
var yy = 100;
var x = 300;
var y = 300;

function setup() {
  createCanvas(600, 600);
  osc = new p5.Oscillator();
  osc.setType('sine');
  osc.start();
  osc.amp(0);

  radio = createRadio();
  radio.option('classification');
  radio.option('regression');
  radio.value('classification');

  var playpause = createButton('play');
  playpause.mousePressed(function() {
    var amp = osc.amp();
    if (amp.value == 0.5) {
      osc.amp(0, 0.1);
      playpause.html('play');
    } else {
      osc.amp(0.5, 0.1);
      playpause.html('stop');
    }
  });
}


function draw() {
  background(0);

  x += (noise(xx)-0.5)*5;
  y += (noise(yy)-0.5)*5;
  xx+=0.01;
  yy+=0.01;
  fill(155);
  ellipse(x, y, 20, 20);
  if(x > 600) x = 0;
  if(x < 0) x = 600;
  if(y > 600) y = 0;
  if(y < 0) y = 600;

  // Nearest Neighbor Classification!
  if (radio.value() == 'classification') {

    // Simple KNN algorithm with K = 1 for classification
    var note = null;
    var recordD = Infinity;
    for (var i = 0; i < training.length; i++) {
      var point = training[i];
      // Euclidean distance to this neighbor
      var d = dist(x, y, point.x, point.y);
      if (d < recordD) {
        note = point.note;
        recordD = d;
      }
    }

    var midi = cmajor[note];
    var freq = translateMIDI(midi);
    osc.freq(freq);

  } else if (radio.value() == 'regression') {

    // KNN regression! K is just everything weighted according to distance
    var sumWeights = 0;
    for (var i = 0; i < training.length; i++) {
      var point = training[i];
      var d = dist(x, y, point.x, point.y);
      point.weight = 1 / (d * d);
      sumWeights += point.weight;
    }

    var sum = 0;
    for (var i = 0; i < training.length; i++) {
      var point = training[i];
      var note = cmajor[point.note];
      var freq = translateMIDI(note);
      sum += freq * point.weight;
    }

    var freq = sum / sumWeights;
    osc.freq(freq);
  }
  if(random() < 0.01 && flip){
    var obj = {
      note: String.fromCharCode(random(65, 72)),
      x: random(600),
      y: random(600)
    }
    training.push(obj);
    flip = false;
  }else{
    flip = true;
  }
  // Now draw all the training data to see how it looks
  for (var i = 0; i < training.length; i++) {
    var point = training[i];
    noStroke();
    fill(50, 50, (cmajor[point.note]-50)*10);
    ellipse(point.x, point.y, 24, 24);
  }

}

function translateMIDI(note) {
  return pow(2, ((note - 69) / 12.0)) * 440;
}
