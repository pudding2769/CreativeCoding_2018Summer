class Bubbles {
  float elliX;
  float elliY;
  float elliR;
  

  Bubbles(float elliX_, float elliY_, float elliR_) {
    elliX = elliX_;
    elliY = elliY_;
    elliR = elliR_;
  }
  
  void run(){
    display();
    flow();
  }

  void flow() {
    if(elliY + elliR <= 0)elliY = height;
    else elliY --;
    
  }

  void display() {
    fill(255, 255, 255, 100);
    noStroke();
    ellipse(elliX, elliY, elliR,elliR);
  }
}
