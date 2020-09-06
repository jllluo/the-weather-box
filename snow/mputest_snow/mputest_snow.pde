import processing.io.*;
I2C i2c;

boolean up = false;
boolean down = false;
boolean sky = false;
boolean side = false;
boolean ground = false;

float[] Lx = new float[40];
float[] Ly = new float[40]; 
float[] Lx0 = new float[40];
float[] LxSpeed = new float[40];
float LySpeed = 0.1;
float[] Lsize = new float[40];

float[] Ux = new float[25];
float[] Uy = new float[25];
float[] Ux0 = new float[25];
//float[] y0 = new float[20];
float[] UxSpeed = new float[25];
float[] UySpeed = new float[25];
float[] Usize = new float[25];

float[] Dx = new float[100];
float[] Dy = new float[100];
float[] Dx0 = new float[100];
float[] Dy0 = new float[100];
float[] Dx1 = new float[100];
float[] Dy1 = new float[100];
float[] Dx1Speed = new float[100];
float[] Dy1Speed = new float[100];
float[] Dsize = new float[100];
float[] Dbrightness = new float[100];
float[] DsizeDecrease = new float[100];



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
  
  for (int i = 0; i < 40; i++) {
    Lx[i] = random(32);
    Ly[i] = random(-30, -1);
    Lx0[i] = Lx[i];
    LxSpeed[i] = random(-0.1, 0.1);
    Lsize[i] = random(0.5, 2);
  }
  
  for (int i = 0; i < 25; i++) {
    Ux[i] = random(31);
    Uy[i] = random(31);
    Ux0[i] = Ux[i];
    Usize[i] = random(0.4, 4);
    //y0[i] = y[i];
  }
  
  for (int i = 0; i<100; i++) {
    Dx[i] = random(31);
    Dy[i] = random(31);
    Dx0[i] = random(-5, 36);
    Dy0[i] = random(-5, 36);
    Dx1[i] = Dx0[i];
    Dy1[i] = Dy0[i];
    //x1Speed[i] = random(-0.2, 0.2);
    //y1Speed[i] = random(-0.2, 0.2);
    Dsize[i] = random(2, 3);
    Dbrightness[i] = random(10, 250);
    DsizeDecrease[i] = 0.02;
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
      background(5);

  for (int i = 0; i < 25; i++) {
    if ((Ux[i] <= 15)&&(Uy[i] <= 15)) {
      UxSpeed[i] = -0.1;
      UySpeed[i] = random(0.5, 2.0)*UxSpeed[i];
    }
    if ((Ux[i] >= 16)&&(Uy[i] <= 15)) {
      UxSpeed[i] = 0.1;
      UySpeed[i] = -random(0.5, 2.0)*UxSpeed[i];
    }
    if ((Ux[i] <= 15)&&(Uy[i] >= 16)) {
      UxSpeed[i] = -0.1;
      UySpeed[i] = -random(0.5, 2.0)*UxSpeed[i];
    }
    if ((Ux[i] >= 16)&&(Uy[i] >= 16)) {
      UxSpeed[i] = 0.1;
      UySpeed[i] = random(0.5, 2.0)*UxSpeed[i];
    }

    fill(250);
    noStroke();
    ellipse(Ux[i], Uy[i], Usize[i], Usize[i]);

    if ((Ux[i]>=11)&&(Ux[i]<=20)&&(Uy[i]>=11)&&(Uy[i]<=20)) {  
      Ux[i] += UxSpeed[i]/3;
      Uy[i] += UySpeed[i]/3;
    } else {
      Ux[i] += UxSpeed[i];
      Uy[i] += UySpeed[i];
    }
 
    Usize[i] += 0.05;

    if (Usize[i] >= 3) {
      Ux[i] = random(31);
      Uy[i] = random(31);
      Ux0[i] = Ux[i];
      //y0[i] = y[i];
      Usize[i] = random(0.4, 1);
    }
  }
  }
  if (side) {
    println("side");
      background(5);
  for (int i = 0; i < 40; i++) {
    fill(random(80, 250));
    noStroke();
    ellipse(Lx[i], Ly[i], Lsize[i], Lsize[i]);
  }
  for (int i = 0; i < 40; i++) {
    Ly[i] += LySpeed;
    Lx[i] += LxSpeed[i];
    if ((Lx[i] >= Lx0[i]+4)||(Lx[i] <= Lx0[i]-4)) {
      LxSpeed[i] = -LxSpeed[i];
    }
  }

  for (int i = 0; i < 40; i++) {
    if (Ly[i] >= 32) {
      Ly[i] = random(-30, -1);
      Lx[i] = random(32);
      Lx0[i] = Lx[i];
      Lsize[i] = random(0.5, 2);
    }
  }
  }
  if (ground) {
    println("ground");
    background(20);
  for (int i = 0; i<100; i++) {
    fill(Dbrightness[i]);
    noStroke();
    ellipse(Dx[i], Dy[i], Dsize[i], Dsize[i]); 
    Dbrightness[i] -= 0.1;
    if (Dbrightness[i] <= 20) {
      Dbrightness[i] = 20;
      //brightness[i] = random(200, 250);
      //x[i] = random(31);
      //y[i] = random(31);
      //size[i] = random(1, 3);
    }
  }
  for (int i = 0; i<100; i++) {
    if ((Dx0[i] <= 15)&&(Dy0[i] <= 15)) {
      Dx1Speed[i] = random(0.2, 0.1);
      Dy1Speed[i] = random(0.5, 2.0)*Dx1Speed[i];
    }
    if ((Dx0[i] >= 16)&&(Dy0[i] <= 15)) {
      Dx1Speed[i] = random(-0.2, -0.1);
      Dy1Speed[i] = -random(0.5, 2.0)*Dx1Speed[i];
    }
    if ((Dx0[i] <= 15)&&(Dy0[i] >= 16)) {
      Dx1Speed[i] = random(0.2, 0.1);
      Dy1Speed[i] = -random(0.5, 2.0)*Dx1Speed[i];
    }
    if ((Dx0[i] >= 16)&&(Dy0[i] >= 16)) {
      Dx1Speed[i] = random(-0.2, -0.1);
      Dy1Speed[i] = random(0.5, 2.0)*Dx1Speed[i];
    }
    fill(Dbrightness[i]);
    noStroke();
    ellipse(Dx1[i], Dy1[i], Dsize[i], Dsize[i]);
    if ((abs(Dx1[i]-Dx0[i]) <= 6)&&(abs(Dy1[i]-Dy0[i]) <= 6)) {
      Dx1[i] += Dx1Speed[i];
      Dy1[i] += Dy1Speed[i];
      Dsize[i] -= DsizeDecrease[i];
    }
    if ((abs(Dx1[i]-Dx0[i]) > 6)||(abs(Dy1[i]-Dy0[i]) > 6)||(Dsize[i] <= 0)) {
      Dx1Speed[i] = 0;
      Dy1Speed[i] = 0;
      DsizeDecrease[i] = 0;
      //ellipse(x1[i], y1[i], size[i], size[i]); 
      Dbrightness[i] -= 0.1;
      if (Dbrightness[i] < 20) {
        Dbrightness[i] = random(200, 250);
        Dx0[i] = random(-5, 36);
        Dy0[i] = random(-5, 36);
        Dx1[i] = Dx0[i];
        Dy1[i] = Dy0[i];
        //x1Speed[i] = random(-0.2, 0.2);
        //y1Speed[i] = random(-0.2, 0.2);
        Dsize[i] = random(2, 3);
        DsizeDecrease[i] = 0.02;
      }
    }
  }
  }
  

}
