class Neuron {
float m_output;
void display() {
   
    // Number is inverted then scaled from 0 to 255 
    // m_output: -1 to 1
    fill(128 * (1 - m_output));
    ellipse(0,0,16,16);
  }
}