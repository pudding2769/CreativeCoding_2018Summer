#include <dht.h>

int SH = 0;
const int TrigPin = 2;
const int EchoPin = 3;
float cm = 0.0;

dht DHT;

#define DHT11_PIN 8

void setup() {
  // put your setup code here, to run once:
  pinMode(12, OUTPUT);
  pinMode(TrigPin, OUTPUT);
  pinMode(EchoPin, INPUT);
  Serial.begin(9600);
}

void loop() {
  //自动浇水：检测土壤湿度，低于某一值时自动浇水
  SH = analogRead(A5);
  //Serial.print("soil exploration = ");
  Serial.print(SH / 4);
  Serial.print(",");
  //delay(1000);
  if (SH >= 300)digitalWrite(12, HIGH);
  else digitalWrite(12, LOW);

  //超声波测量距离，感测到人靠近的时候产生互动
  digitalWrite(TrigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(TrigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(TrigPin, LOW);

  cm = pulseIn(EchoPin, HIGH) / 58; //将回波时间换算成cm

  cm = (int(cm * 100)) / 100; //保留两位小数
  Serial.print(cm);
  Serial.print("cm");//串口输出
  Serial.print(","); 
  //delay(1000);

  //测空气温度和湿度并且输出
  int chk = DHT.read11(DHT11_PIN);
  Serial.print(DHT.humidity, 1);
  Serial.print(",");
  Serial.println(DHT.temperature, 1);
  delay(1000);

}
