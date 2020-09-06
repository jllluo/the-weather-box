import processing.io.*;
I2C i2c;

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
  println("acceX = " + gFX);
  println("acceY = " + gFY);
  println("acceZ = " + gFZ);
  i2c.beginTransmission(0x68);
  i2c.write(0x43);
  byte[] gyro = i2c.read(6);
  float rotX = (gyro[0] << 8 | gyro[1])/131.0;
  float rotY = (gyro[2] << 8 | gyro[3])/131.0;
  float rotZ = (gyro[4] << 8 | gyro[5])/131.0;
  println("rotX = " + rotX);
  println("rotY = " + rotY);
  println("rotZ = " + rotZ);
    
}
