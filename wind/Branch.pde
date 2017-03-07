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
    rotate(windForTree);
    actualDraw(root);
    popMatrix();
  }
  void actualDraw(Node r) {
    strokeWeight(r.len/10);
    stroke(50);
    line(0, 0, 0, -r.len);
    translate(0, -r.len);
    if (r.len > 10) {
      rotate(r.lchild.theta+windForTree);
      actualDraw(r.lchild);
      translate(0, r.lchild.len);
      rotate(r.rchild.theta-r.lchild.theta);
      actualDraw(r.rchild);
      translate(0, r.rchild.len);
      rotate(-r.rchild.theta-windForTree);
    }
  }
}

class Node {
  Node lchild;
  Node rchild;
  float len;
  float theta;
  Node (float _theta, float _len) {
    theta = _theta;
    len = _len;
  }
  void build() {
    float min = len*0.5;
    float max = len*0.8;
    lchild = new Node(random(-PI/6, 0), random(min, max));
    rchild = new Node(random(0, PI/6), random(min, max));
  }
}