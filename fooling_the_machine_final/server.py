# Daniel Shiffman
# Nature of Code: Intelligence and Learning
# https://github.com/shiffman/NOC-S17-2-Intelligence-Learning

# import everything we need
from flask import Flask, jsonify, request

# Some file reading and image stuff
from io import BytesIO
from PIL import Image
from scipy.misc import imresize
import base64
import matplotlib.pyplot as plt

# ML stuff
import numpy as np
import keras
from keras.models import load_model

# Setup Flask app.
app = Flask(__name__)
# Extra debugging
app.debug = True

# Load in the model
model = load_model('final.h5')

resultsent = True
globalresult = 0
graydata = None
# Routes
# This is root path, use index.html in "static" folder
@app.route('/')
def root():
  return app.send_static_file('index.html')

#result home page
@app.route('/result')
def loadresult():
    return app.send_static_file('result.html')


@app.route('/ask', methods=['GET'])
def askforresult():
    global resultsent
    global globalresult
    global graydata
    # print("global result:"+resultsent)
    if resultsent:
        return jsonify(result=-1);
    else:
        print("result sent false")
        resultsent = True
        return jsonify(result= globalresult, gray=graydata);

# This is a nice way to just serve everything in the "static" folder
@app.route('/<path:path>')
def static_proxy(path):
  # send_static_file will guess the correct MIME type
  return app.send_static_file(path)

# This function converts RGB values to grayscale (1/3rd of each color)
# This is a somewhat silly way to do this but perhaps it's a useful demonstration
# of reshaping data
def rgb2gray(rgb):
    return np.dot(rgb[...,:3], [0.333, 0.333, 0.333])

# This is the new piece
# Here we receive a "base64" encoded image from p5
# via a "POST" request
@app.route('/upload', methods=['POST'])
def upload():
    global resultsent
    global globalresult
    global graydata
    # Get the image data from the POST
    data = request.form['img']
    # This converts it to an image
    img = Image.open(BytesIO(base64.b64decode(data)))
    # Now resize it to 28x28x3
    img = imresize(img, (28,28,3))
    # Run the conversion
    gray = rgb2gray(img)
    # map values to between 0 and 1
    graydata = gray.tolist()
    gray /= 255

    inputs = gray.reshape(1, 28, 28, 1)
    # Probabilities
    prediction = model.predict(inputs);
    # What digit is it? (we could just pull the max prob from above, but showing both options)
    label = model.predict_classes(inputs)
    # Send everything back as JSON

    resultsent = False
    globalresult = label.tolist()[0]
    return jsonify(status='got image',number=globalresult,prediction=prediction.tolist()[0]);

# Run app:
if __name__ == '__main__':
    # Localhost and port 8080
    app.run( host='0.0.0.0', port=8248, debug=False )
    # If you enable debugging, you'll get more info
    # server will restart automatically when code changes, etc.
    # app.run( host='0.0.0.0', port=8080, debug=True )
