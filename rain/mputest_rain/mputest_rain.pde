import processing.io.*;
I2C i2c;

boolean up = false;
boolean down = false;
boolean sky = false;
boolean side = false;
boolean ground = false;

float[] Ux = new float[16];
float[] Uy = new float[16];
float[] Ux0 = new float[16];
//float[] y0 = new float[20];
float[] UxSpeed = new float[16];
float[] UySpeed = new float[16];

float[] Lx = new float[16];
float[] Ly = new float[16];
float LxSpeed;
float LySpeed = 0.8;

float[] Dchecktime = new float[10];
float[] Dx = new float[10];
float[] Dy = new float[10];
boolean DinitialTimeCheck = false;


void setup() {
  size(32, 32);
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

  for (int i = 0; i < 16; i++) {
    Ux[i] = random(31);
    Uy[i] = random(31);
    Ux0[i] = Ux[i];
    //y0[i] = y[i];
  }

  for (int i = 0; i < 16; i++) {
    Lx[i] = random(32);
  }
  for (int i = 0; i < 16; i++) {
    Ly[i] = random(-25, 0);
  }

  for (int i = 0; i < 10; i++) {
    Dx[i] = random(31);
    Dy[i] = random(31);
    //Dchecktime[i] = random(1000);
  }
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
    DinitialTimeCheck = false;
    background(5);

    for (int i = 0; i < 16; i++) {
      if ((Ux[i] <= 15)&&(Uy[i] <= 15)) {
        UxSpeed[i] = -0.5;
        UySpeed[i] = random(0.5, 2.0)*UxSpeed[i];
      }
      if ((Ux[i] >= 16)&&(Uy[i] <= 15)) {
        UxSpeed[i] = 0.5;
        UySpeed[i] = -random(0.75, 1.5)*UxSpeed[i];
      }
      if ((Ux[i] <= 15)&&(Uy[i] >= 16)) {
        UxSpeed[i] = -0.5;
        UySpeed[i] = -random(0.5, 2.0)*UxSpeed[i];
      }
      if ((Ux[i] >= 16)&&(Uy[i] >= 16)) {
        UxSpeed[i] = 0.5;
        UySpeed[i] = random(0.5, 2.0)*UxSpeed[i];
      }

      stroke(250);
      point(Ux[i], Uy[i]);
      if (abs(Ux[i]-Ux0[i]) >= UxSpeed[i]) {
        stroke(125);
        point(Ux[i]-UxSpeed[i], Uy[i]-UySpeed[i]);
        if (abs(Ux[i]-Ux0[i]) >= 2*UxSpeed[i]) {
          stroke(75) ;
          point(Ux[i]-2*UxSpeed[i], Uy[i]-2*UySpeed[i]);
          if (abs(Ux[i]-Ux0[i]) >= 3*UxSpeed[i]) {
            stroke(25);
            point(Ux[i]-3*UxSpeed[i], Uy[i]-3*UySpeed[i]);
            if (abs(Ux[i]-Ux0[i]) >= 4*UxSpeed[i]) {
              stroke(10);
              point(Ux[i]-4*UxSpeed[i], Uy[i]-4*UySpeed[i]);
            }
          }
        }
      }

      Ux[i] += UxSpeed[i];
      Uy[i] += UySpeed[i];
      if (abs(Ux[i]-Ux0[i]) > 4) {
        Ux[i] = random(31);
        Uy[i] = random(31);
        Ux0[i] = Ux[i];
        //y0[i] = y[i];
      }
    }
  }

  if (side) {
    println("side");
    DinitialTimeCheck = false;
    background(5);
    for (int i = 0; i < 16; i++) {
      stroke(5);
      point(Lx[i], Ly[i]);
      stroke(55);
      point(Lx[i], Ly[i]+1);
      stroke(105);
      point(Lx[i], Ly[i]+2);
      stroke(155);
      point(Lx[i], Ly[i]+3);
      stroke(205);
      point(Lx[i], Ly[i]+4);
      stroke(250);
      point(Lx[i], Ly[i]+5);
    }

    for (int i = 0; i < 16; i++) {
      Lx[i]+=LxSpeed;
      Ly[i]+=LySpeed;
    }
    for (int i = 0; i < 16; i++) {
      if (Ly[i] >= 32) {
        Ly[i] = random(-25, 0);
        Lx[i] = random(32);
      }
    }
  }
  
  if (ground) {
    println("ground");
    
    if (!DinitialTimeCheck) {
      for (int i = 0; i < 10; i++) {
        Dchecktime[i] = millis()-random(1000); 
      }
      DinitialTimeCheck = true;
    }
      
    
    background(5);
    for (int i = 0; i < 10; i++) {
      if ((millis()-Dchecktime[i] >= 0)&&(millis()-Dchecktime[i] < 200)) {
        stroke(250);
        point(Dx[i], Dy[i]);
      }
      if ((millis()-Dchecktime[i] >= 200)&&(millis()-Dchecktime[i] < 400)) {
        stroke(125);
        noFill();
        ellipse(Dx[i], Dy[i], 2, 2);
      }
      if ((millis()-Dchecktime[i] >= 400)&&(millis()-Dchecktime[i] < 600)) {
        stroke(75);
        noFill();
        ellipse(Dx[i], Dy[i], 4, 4);
      }
      if ((millis()-Dchecktime[i] >= 600)&&(millis()-Dchecktime[i] < 800)) {
        stroke(25);
        noFill();
        ellipse(Dx[i], Dy[i], 6, 6);
        stroke(75);
        noFill();
        ellipse(Dx[i], Dy[i], 3, 3);
      }
      if ((millis()-Dchecktime[i] >= 800)&&(millis()-Dchecktime[i] < 1000)) {
        stroke(15);
        noFill();
        ellipse(Dx[i], Dy[i], 8, 8);
        stroke(25);
        noFill();
        ellipse(Dx[i], Dy[i], 5, 5);
      }
      if ((millis()-Dchecktime[i] >= 1000)&&(millis()-Dchecktime[i] < 1200)) {
        stroke(5);
        noFill();
        ellipse(Dx[i], Dy[i], 10, 10);
        stroke(10);
        noFill();
        ellipse(Dx[i], Dy[i], 3, 3);
        stroke(10);
        noFill();
        ellipse(Dx[i], Dy[i], 5, 5);
        Dchecktime[i] = millis();
        Dx[i] = random(31);
        Dy[i] = random(31);
      }
    }
  }
}
