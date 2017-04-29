class Network {
  
  Neuron [] m_input_layer;
  
  Network(int inputs) {
    m_input_layer = new Neuron [inputs];
    for (int i = 0; i < m_input_layer.length; i++) {
      m_input_layer[i] = new Neuron();
    }
  }
  void respond(Card card) {
    for (int i = 0; i < m_input_layer.length; i++) {
      m_input_layer[i].m_output = card.inputs[i];
    }
  }
  void display() {
    for (int i = 0; i < m_input_layer.length; i++) {
      pushMatrix();
      translate((i%14) * height / 20.0 + width * 0.06, (i/14) * height
        / 20.0 + height * 0.16);
      m_input_layer[i].display();
      popMatrix();
    }
  }
}