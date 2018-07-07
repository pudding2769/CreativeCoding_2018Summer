import ddf.minim.analysis.*;
import ddf.minim.*;
import processing.serial.*;

ArrayList myBob;
ArrayList myCloud;

Serial myPort;

Minim minim;
AudioPlayer music;
AudioPlayer music2;
AudioPlayer music3;
AudioPlayer music4;
FFT fft;

PImage sun;
PImage cloud;
PImage moon;
PImage flower1;
PImage pot;
PImage bg_day;
PImage bg_night;
PImage dialogue;

PFont myFont;

float angle;
float y = 0;
int x = 0;
float theta=0.0;
float angle2=PI/2;
int year, month, day, h, m, s;
int soil_wetness = 0;
int length1 = 0;
int length2 = 0;
int length3 = 0;
int distance = 0;
int temp;
int wet;
float ra;

void setup() {
  size(1200, 800);
  //background(0);
  smooth();

  sun = loadImage("contrast.png");
  imageMode(CENTER);
  moon = loadImage("moon.png");
  imageMode(CENTER);
  flower1 = loadImage("tulip.png");
  cloud = loadImage("cloud.png");
  bg_night = loadImage("timg.jpg");
  bg_day = loadImage("day.jpg");
  dialogue = loadImage("5e5b.png");
  pot = loadImage("pot01.png");
  myBob = new ArrayList();
  for (int i = 0; i<30; i++) {
    Bubbles thisBob = new Bubbles(random(width), random(height), random(20, 30));
    myBob.add(thisBob);
  }
  myCloud = new ArrayList();
  for (int i = 0; i < 3; i++) {
    Clouds thisCloud = new Clouds(i*400 + 400, 70 + (int)random(20), (int)random(130, 200));
    myCloud.add(thisCloud);
  }

  myPort = new Serial(this, "COM5", 9600);
  myPort.bufferUntil('\n');

  minim = new Minim(this);
  music = minim.loadFile("tjccxtutu.wav");
  music2 = minim.loadFile("2.mp3");
  music3 = minim.loadFile("3.mp3");
  music4 = minim.loadFile("4.mp3");
  if (mousePressed)
    ra = random(9);
}

void draw() {
  if ((hour()<= 18) && (hour()>= 6) ) {
    bg_day.resize(width, height);
    background(bg_day);
  } else {
    bg_night.resize(width, height);
    background(bg_night);
  }



  //缓缓上升的泡沫
  for (int i = 0; i<myBob.size(); i++) {
    Bubbles oneBob = (Bubbles)myBob.get(i);
    oneBob.run();
  }

  //能平移的云朵
  for (int i = 0; i<myCloud.size(); i++) {
    Clouds oneCloud = (Clouds)myCloud.get(i);
    oneCloud.run();
  }

  //判断系统时间，显示绕自身旋转的太阳或者摇摆的月亮
  if ((hour()<= 18) && (hour()>= 6) ) {
    angle += 0.01;
    pushMatrix();
    translate(170, 150);
    rotate(angle);
    image(sun, 0, 0, 200, 200);
    popMatrix();
  } else {
    pushMatrix();
    translate(170, 150);
    rotate(theta);
    image(moon, 0, 0, 200, 200);
    theta+=sin(angle2)*0.01;
    angle2 +=0.05;
    popMatrix();
  }




  //花盆
  image(pot, width/2, 500, 350, 474);

  //花，当鼠标移动到花上面的时候会摇晃
  if ( (mouseX >= 500) && (mouseX <= 700) && (mouseY >= 350) && (mouseY <= 600)) {
    pushMatrix();
    translate(600, 570);
    rotate(theta);
    image(flower1, 0, -100, 200, 200);
    theta+=sin(angle2)*0.01;
    angle2 +=0.05;
    popMatrix();
    //鼠标点击花时向你问好
    if (mousePressed) {
      image(dialogue, 900, 330, 400, 200);

      if ((second() <= 60) && (second() > 40))
      {
        music2.play();
        fill(0);
        textSize(30);
        text("主人今天想玩什么呢^-^", 740, 300);
      } 
      else if ((second()<=40) && (second()>20)){
        music3.play();
        fill(0);
        textSize(30);
        text("请问 有什么事吗？", 770, 300);
      }
        
      else if ((second()>=0) && (second()<=20) ) {
        music4.play();
        fill(0);
        textSize(30);
        text("这是新的玩法吗^o^", 770, 300);
      }
    }
  } else {
    image(flower1, width/2, height - 330, 200, 200);
  }



  //在屏幕上通过Arduino传入的数值显示出温度和湿度和土壤湿度

  strokeWeight(15);
  stroke(246, 203, 125);
  line(65, 690, 320, 690);
  length1 = (int)map(soil_wetness, 0, 255, 255, 0);
  stroke(126, 246, 238);
  line(65, 690, 65+length1, 690);
  fill(255);
  textSize(25);
  text(length1, 250, 660);
  text("Soil Wetness", 65, 660);
  
  stroke(246, 203, 125);
  line(65, 610, 320, 610);
  length2 = (int)map(wet, 20, 90, 255, 0);
  stroke(126, 246, 238);
  line(65, 610, 65+length2, 610);
  text("Air Wetness", 65, 580);
  text(wet, 250, 580);
  text("%", 280, 580);
  
  stroke(246, 203, 125);
  line(65, 530, 320, 530);
  length3 = (int)map(temp, 0, 50, 255, 0);
  stroke(126, 246, 238);
  line(65, 530, 65+length2, 530);
  text("Tempreture", 65, 500);
  text(temp, 250, 500);
  text("°C", 280, 500);
  
  



  //当人靠近时，发出语音并且问好
  if ( (distance <= 20) && (distance > 0)) {
    music.play();
  } else if (distance >= 60) {
    music.rewind();
    //当人远离时倒带，等待下一次靠近
  }



  //附加功能：时钟，便于查看现在的时间
  s = second();
  m = minute();
  h = hour();
  day = day();
  month = month();
  year = year();
  myFont=createFont("FFScala", 18);    //字体和大小
  myClockDraw();
}



void myClockDraw() {
  translate(130, 370);    //移动原点到坐标中心
  fill(255); 
  stroke(255, 210, 255);   
  strokeWeight(8);
  ellipse(0, 0, 130, 130); 
  textFont(myFont);   //使用上面定义的字体
  fill(0);    
  text("12", -10, -50);//在指定坐标位置显示字符串
  text("3", 53, 6);
  text("6", -7, 63);
  text("9", -63, 6);

  pushMatrix();   
  //把秒数转换为弧度(rotate()范围在0~2*PI之间)
  //基准线为为下面的line()的方向，顺时针为正方向
  rotate(PI*2*s/60+PI);   
  stroke(226, 80, 140);  
  strokeWeight(1);    
  line(0, 0, 0, 70);     
  popMatrix();

  pushMatrix();
  rotate(PI*2*m/60+PI);
  stroke(226, 80, 140);
  strokeWeight(3);
  line(0, 0, 0, 50);     
  popMatrix();

  pushMatrix();
  rotate(PI*2*h/12+PI);
  stroke(226, 80, 140);
  strokeWeight(5);
  line(0, 0, 0, 30);     
  popMatrix();
}


//从arduino串流中读数值
void serialEvent(Serial p) {
  String inString = p.readString();
  print(inString);
  //soil_wetness = inString;
  String[] list = split(inString, ',');
  soil_wetness = int(list[0]);
  distance = int(list[1]);
  wet = int(list[2]);
  temp = int(list[3]);
}
