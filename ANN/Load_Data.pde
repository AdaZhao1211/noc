Card[] testing_set;
Card[] training_set;
class Card {
  float [] inputs;
  float [] outputs;
  int label;
  Card() {
    inputs = new float [196];
    outputs = new float[10];
  }
  void imageLoad(){
    // Each image consists of 196 bytes
    // Loading a total of 1,960,000 bytes
  }
  void labelLoad(){
    // Labels are a total of 10,000 bytes, each one representing the
    //label for the card in question 
    // We then then go through the 10 template outputs and       
    //highlight the correct answer within them.
  }
}

// loadData is called outside of our class
void loadData(){ 
  // Uses Processing's inbuilt function "loadBytes()" to load the
  //images and labels  
  // Four out of every five cards is assigned to the training set,  
  //while every fifth card is assigned to the test set instead.
}