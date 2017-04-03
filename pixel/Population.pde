// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Genetic Algorithm, Evolving Shakespeare

// A class to describe a population of virtual organisms
// In this case, each organism is just an instance of a DNA object

class Population {

  float mutationRate;           // Mutation rate
  DNA[] population;             // Array to hold the current population
  ArrayList<DNA> matingPool;    // ArrayList which we will use for our "mating pool"
  int[][] target;                // Target phrase
  int generations;              // Number of generations
  boolean finished;             // Are we finished evolving?
  int perfectScore;
  int c, r;
  int best;
  int minFit;
  int maxFitness;

  Population(int[][] p, float m, int num, int cols, int rows) {
    target = p;
    mutationRate = m;
    population = new DNA[num];
    c = cols;
    r = rows;
    for (int i = 0; i < population.length; i++) {
      population[i] = new DNA(c, r);
    }
    calcFitness();
    matingPool = new ArrayList<DNA>();
    finished = false;
    generations = 0;

    perfectScore = 1;
  }

  // Fill our fitness array with a value for every member of the population
  void calcFitness() {
    for (int i = 0; i < population.length; i++) {
      population[i].fitness(target);
    }
  }

  // Generate a mating pool
  void naturalSelection() {
    // Clear the ArrayList
    matingPool.clear();

    maxFitness = 0;
    minFit = c *r;
    for (int i = 0; i < population.length; i++) {
      if (population[i].fit > maxFitness) {
        maxFitness = population[i].fit;
        best = i;
      }
      if (population[i].fit < minFit) {
        minFit = population[i].fit;
      }
    }
    //println(population.length);
    if (minFit == 0) minFit = 1;
    for (int i = 0; i < population.length; i++) {
      if (population[i].fit <= minFit) continue;
      float n = map(population[i].fit, minFit, maxFitness, 0, 1);  // Arbitrary multiplier, we can also use monte carlo method
      int nn = int(n*20);
      //println(nn);
      for (int j = 0; j < nn; j++) {              // and pick two random numbers
        matingPool.add(population[i]);
      }
    }
    if (matingPool.size() == 0) {
      for (int j = 0; j < population.length; j++) {              // and pick two random numbers
        matingPool.add(population[j]);
      }
    }
  }

  void generate() {
    // Refill the population with children from the mating pool
    for (int i = 0; i < population.length; i++) {
      int a = int(random(matingPool.size()));
      int b = int(random(matingPool.size()));
      DNA partnerA = matingPool.get(a);
      DNA partnerB = matingPool.get(b);
      DNA child = partnerA.crossover(partnerB);
      child.mutate(mutationRate);
      population[i] = child;
    }
    generations++;
  }


  // Compute the current "most fit" member of the population
  DNA getBest() {
    DNA temp = population[best];
    if (temp.fit == c*r) finished = true;
    return temp;
  }

  boolean finished() {
    return finished;
  }

  int getGenerations() {
    return generations;
  }
  int bestScore() {
    return population[best].fit;
  }
}

// Compute average fitness for the population
//float getAverageFitness() {
//  float total = 0;
//  for (int i = 0; i < population.length; i++) {
//    total += population[i].fitness;
//  }
//  return total / (population.length);
//}

//String allPhrases() {
//  String everything = "";

//  int displayLimit = min(population.length,50);


//  for (int i = 0; i < displayLimit; i++) {
//    everything += population[i].getPhrase() + "\n";
//  }
//  return everything;
//}