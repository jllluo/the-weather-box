import processing.io.*;
I2C i2c;

boolean up = false;
boolean down = false;
boolean sky = false;
boolean side = false;
boolean ground = false;

void setup() {
  size(50, 50);
  //frameRate(1);
  i2c = new I2C(I2C.list()[0]);
  i2c.beginTransmission(0x68);
  i2c.write(0x6b);
  i2c.write(0);
  i2c.endTransmission();
  i2c.beginTransmission(0x68);
  i2c.write(0x1b);
  i2c.write(0);
  i2c.endTransmission();
  i2c.beginTransmission(0x68);
  i2c.write(0x1c);
  i2c.write(0);
  i2c.endTransmission();
}

void draw() {
  i2c.beginTransmission(0x68);
  i2c.write(0x3b);
  byte[] acce = i2c.read(6);
  float gFX = (acce[0] << 8 | acce[1])/16384.0;
  float gFY = (acce[2] << 8 | acce[3])/16384.0;
  float gFZ = (acce[4] << 8 | acce[5])/16384.0;
  //println("acceX = " + gFX);
  //println("acceY = " + gFY);
  //println("acceZ = " + gFZ);
  i2c.beginTransmission(0x68);
  i2c.write(0x43);
  byte[] gyro = i2c.read(6);
  float rotX = (gyro[0] << 8 | gyro[1])/131.0 + 3.1;
  float rotY = (gyro[2] << 8 | gyro[3])/131.0 - 0.45;
  float rotZ = (gyro[4] << 8 | gyro[5])/131.0 + 0.1;
  //println("rotX = " + rotX);
  //println("rotY = " + rotY);
  //println("rotZ = " + rotZ);
  
  //condition check
  if (rotX > 20) {
    up = true;
  }
  if (rotX < 20) {
    down = true;
  }
  
  if ((up)&&(gFZ<-0.8)) {
    sky = true;
    side = false;
    ground = false;
    up = false;
  }
  if ((up)&&(gFY > 0.8)) {
    side = true;
    sky = false;
    ground = false;
    up = false;
  }
  if ((down)&&(gFY < -0.8)) {
    side = true;
    sky = false;
    ground = false;
    down = false;
  }
  if ((down)&&(gFZ > 0.8)) {
    ground = true;
    sky = false;
    side = false;
    down = false;
  }
 
  if (sky) {
    println("sky");
  }
  if (side) {
    println("side");
  }
  if (ground) {
    println("ground");
  }
  

}
