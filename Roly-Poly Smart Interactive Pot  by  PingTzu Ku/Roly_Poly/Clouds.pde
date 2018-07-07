class Clouds{
  int r;
  int x;
  int y;
  int speedX = 1;
  
  Clouds(int x_,int y_,int r_){
    x = x_;
    y = y_;
    r = r_;
  }
  
  void run(){
    display();
    //move();
    side();
  }
  
  void display(){
    image(cloud,x,y,r,r);
  }
  
  //void move(){
  //  x += speedX;
  //}
  
  void side(){
    if(x-cloud.width/2 >= width){
      x = 0;
    }
    else x += speedX;
  }
}
