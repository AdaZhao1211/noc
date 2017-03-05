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
  void actualGenerate(Node root){
    if(root.len > 10){
      root.build();
      actualGenerate(root.lchild);
      actualGenerate(root.rchild);
    }
  }
  void drawTree() {
    pushMatrix();
    translate(300, 600);
    rotate(windForTree);
    actualDraw(root);
    popMatrix();
  }
  void actualDraw(Node r){
    strokeWeight(r.len/10);
    line(0, 0, 0, -r.len);
    translate(0, -r.len);
    if(r.len > 10){
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
  void build(){
    lchild = new Node(random(-PI/4, 0), len*0.68);
    rchild = new Node(random(0, PI/4), len*0.68);
  }
}