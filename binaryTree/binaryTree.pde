float windForTree = 0;
Tree tree;
PImage leaf;
void setup(){
  size(800, 600);
  tree = new Tree(120);
  tree.generateTree();
  leaf = loadImage("leaf1.png");
}
void draw(){
    background(190, 210, 230);
    tree.drawTree(400, 600);
}

void mousePressed(){
  tree = new Tree(random(100, 150));
  tree.generateTree();
}