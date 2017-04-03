class DNA {
  int[][] genes;
  int cols, rows;
  int fit;
  DNA(int cols, int rows) {
    this.cols = cols;
    this.rows = rows;
    genes = new int[cols][rows];
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        genes[i][j] = int(random(0, 255));
      }
    }
  }

  void fitness(int[][] target) {
    int score = 0;
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (target[i][j] == genes[i][j])score ++;
      }
    }
    this.fit = score;
    println(score);
  }

  DNA crossover(DNA B) {
    DNA child = new DNA(cols, rows);
    // Half from one, half from the other
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if(child.genes[i][j] == target[i][j]){
          continue;
        }
        if(random(1) < 0.5){
          child.genes[i][j] = genes[i][j];
        }else {
          child.genes[i][j] = B.genes[i][j];
        }
      }
    }
    return child;
  }
  void mutate(float mutationRate) {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (random(1) < mutationRate) {
          genes[i][j]= int(random(255));
        }
      }
    }
  }
}