class Tree {
  float len;
  Node root;
  Tree (float _len) {
    len = _len;
  }
  void generateTree() {
    root = new Node(0, len);
    actualGenerate(root);
  }
  void actualGenerate(Node root) {
    if (root.len > 10) {
      root.build();
      actualGenerate(root.lchild);
      actualGenerate(root.rchild);
    }
  }
  void drawTree(int x, int y) {
    pushMatrix();
    translate(x, y);
    actualDraw(root);
    popMatrix();
  }
  void actualDraw(Node r) {
    imageMode(CENTER);
    strokeWeight(r.len/10);
    stroke(50);
    line(0, 0, 0, -r.len);
    if(r.len < 30){
      image(leaf, 0, -r.len);
      tint(255, 250-r.len*6); 
    }
    translate(0, -r.len);
    if (r.len > 10) {
      r.lchild.n += 0.01;
      float lnoise = -noise(r.lchild.n)/10;
      r.rchild.n += 0.01;
      float rnoise = noise(r.rchild.n)/10;
      rotate(r.lchild.theta+lnoise);
      actualDraw(r.lchild);
      translate(0, r.lchild.len);
      rotate(r.rchild.theta-r.lchild.theta-lnoise+rnoise);
      actualDraw(r.rchild);
      translate(0, r.rchild.len);
      rotate(-r.rchild.theta-rnoise);
    }
  }
}

class Node {
  Node lchild;
  Node rchild;
  float len;
  float theta;
  float n;
  Node (float _theta, float _len) {
    theta = _theta;
    len = _len;
    n = random(0, 10);
  }
  void build() {
    float min = len*0.6;
    float max = len*0.8;
    lchild = new Node(random(-PI/6, -PI/10), random(min, max));
    rchild = new Node(random(PI/10, PI/6), random(min, max));
  }
}