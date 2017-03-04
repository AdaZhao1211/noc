function Spring(b1, b2, k, l){
  this.b1 = b1;
  this.b2 = b2;
  this.k = k;
  this.l = l;
  this.display = function(){
    line(this.b1.pos.x, this.b1.pos.y, this.b2.pos.x, this.b2.pos.y);
  }
  this.connect = function(){

  }
}
