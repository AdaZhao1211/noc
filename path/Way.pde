class Way{
  ArrayList<PVector> points;
  float radius;
  Way(){
    radius = 20;
    points =new ArrayList<>();
  }
  void addPoint(float x, float y){
    points.add(new PVector(x, y));
  }
  PVector getStart(){
    return points.get(0);
  }
  PVector getEnd(){
    return points.get(points.size()-1);
  }
  void display(){
    stroke(175);
    strokeWeight(radius*2);
    noFill();
    beginShape();
    for(PVector v : points){
      vertex(v.x, v.y);
    }
    endShape();
  }
}