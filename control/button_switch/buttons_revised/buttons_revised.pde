import processing.io.*;
I2C i2c;

boolean up = false;
boolean down = false;
boolean sky = false;
boolean side = false;
boolean ground = false;

boolean rain = false;
boolean snow = false;
boolean fog = false;

//rain
float[] RainUx = new float[16];
float[] RainUy = new float[16];
float[] RainUx0 = new float[16];
float[] RainUxSpeed = new float[16];
float[] RainUySpeed = new float[16];

float[] RainLx = new float[16];
float[] RainLy = new float[16];
float RainLxSpeed;
float RainLySpeed = 0.8;

float[] RainDchecktime = new float[10];
float[] RainDx = new float[10];
float[] RainDy = new float[10];
boolean RainDinitialTimeCheck = false;

//snow
float[] SnowLx = new float[40];
float[] SnowLy = new float[40]; 
float[] SnowLx0 = new float[40];
float[] SnowLxSpeed = new float[40];
float SnowLySpeed = 0.1;
float[] SnowLsize = new float[40];

float[] SnowUx = new float[25];
float[] SnowUy = new float[25];
float[] SnowUx0 = new float[25];
float[] SnowUxSpeed = new float[25];
float[] SnowUySpeed = new float[25];
float[] SnowUsize = new float[25];

float[] SnowDx = new float[100];
float[] SnowDy = new float[100];
float[] SnowDx0 = new float[100];
float[] SnowDy0 = new float[100];
float[] SnowDx1 = new float[100];
float[] SnowDy1 = new float[100];
float[] SnowDx1Speed = new float[100];
float[] SnowDy1Speed = new float[100];
float[] SnowDsize = new float[100];
float[] SnowDbrightness = new float[100];
float[] SnowDsizeDecrease = new float[100];

//fog
float[] FogUbrightness = new float[1024];
float[] FogUx = new float[32];

float[] FogLbrightness = new float[1024];
float[] FogLx = new float[32];

float[] FogDbrightness = new float[1024];
float[] FogDx = new float[32];
float[] FogDy = new float[32];

void setup() {
  GPIO.pinMode(5, GPIO.INPUT_PULLUP);
  GPIO.pinMode(6, GPIO.INPUT_PULLUP);
  GPIO.pinMode(13, GPIO.INPUT_PULLUP);

  size(32, 32);
  background(0);
  
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

  //rain
  for (int i = 0; i < 16; i++) {
    RainUx[i] = random(31);
    RainUy[i] = random(31);
    RainUx0[i] = RainUx[i];
  }

  for (int i = 0; i < 16; i++) {
    RainLx[i] = random(32);
  }
  for (int i = 0; i < 16; i++) {
    RainLy[i] = random(-25, 0);
  }

  for (int i = 0; i < 10; i++) {
    RainDx[i] = random(31);
    RainDy[i] = random(31);
  }

  //snow
  for (int i = 0; i < 40; i++) {
    SnowLx[i] = random(32);
    SnowLy[i] = random(-30, -1);
    SnowLx0[i] = SnowLx[i];
    SnowLxSpeed[i] = random(-0.1, 0.1);
    SnowLsize[i] = random(0.5, 2);
  }

  for (int i = 0; i < 25; i++) {
    SnowUx[i] = random(31);
    SnowUy[i] = random(31);
    SnowUx0[i] = SnowUx[i];
    SnowUsize[i] = random(0.4, 4);
  }

  for (int i = 0; i<100; i++) {
    SnowDx[i] = random(31);
    SnowDy[i] = random(31);
    SnowDx0[i] = random(-5, 36);
    SnowDy0[i] = random(-5, 36);
    SnowDx1[i] = SnowDx0[i];
    SnowDy1[i] = SnowDy0[i];
    SnowDsize[i] = random(2, 3);
    SnowDbrightness[i] = random(10, 250);
    SnowDsizeDecrease[i] = 0.02;
  }

  //fog
  for (int i = 0; i < 1024; i++) {
    FogUbrightness[i] = random(10, 150);
  }
  for (int i = 0; i < 32; i++) {
    FogUx[i] = i;
  }

  for (int i = 0; i < 1024; i++) {
    FogLbrightness[i] = random(10, 200);
  }
  for (int i = 0; i < 32; i++) {
    FogLx[i] = i;
  }

  for (int i = 0; i < 1024; i++) {
    FogDbrightness[i] = random(10, 120);
  }
  for (int i = 0; i < 32; i++) {
    FogDx[i] = i;
    FogDy[i] = i;
  }
}

void draw() {  
  if (GPIO.digitalRead(5) == GPIO.LOW) {
    rain = true;
    snow = false;
    fog = false;
  }
  if (GPIO.digitalRead(6) == GPIO.LOW) {
    rain = false;
    snow = true;
    fog = false;
  }
  if (GPIO.digitalRead(13) == GPIO.LOW) {
    rain = false;
    snow = false;
    fog = true;
  }

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

 //orientation check
  if (rotX > 20) {
    up = true;
  }
  if (rotX < 20) {
    down = true;
  }

  if ((up)&&(gFZ < -0.8)) {
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
  if ((down)&&(gFY > 0.8)) {
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

  //rain
  if (rain == true) {
    if (sky) {
      println("sky");
      RainDinitialTimeCheck = false;
      background(5);

      for (int i = 0; i < 16; i++) {
        if ((RainUx[i] <= 15)&&(RainUy[i] <= 15)) {
          RainUxSpeed[i] = -0.5;
          RainUySpeed[i] = random(0.5, 2.0)*RainUxSpeed[i];
        }
        if ((RainUx[i] >= 16)&&(RainUy[i] <= 15)) {
          RainUxSpeed[i] = 0.5;
          RainUySpeed[i] = -random(0.75, 1.5)*RainUxSpeed[i];
        }
        if ((RainUx[i] <= 15)&&(RainUy[i] >= 16)) {
          RainUxSpeed[i] = -0.5;
          RainUySpeed[i] = -random(0.5, 2.0)*RainUxSpeed[i];
        }
        if ((RainUx[i] >= 16)&&(RainUy[i] >= 16)) {
          RainUxSpeed[i] = 0.5;
          RainUySpeed[i] = random(0.5, 2.0)*RainUxSpeed[i];
        }

        stroke(250);
        point(RainUx[i], RainUy[i]);
        if (abs(RainUx[i]-RainUx0[i]) >= RainUxSpeed[i]) {
          stroke(125);
          point(RainUx[i]-RainUxSpeed[i], RainUy[i]-RainUySpeed[i]);
          if (abs(RainUx[i]-RainUx0[i]) >= 2*RainUxSpeed[i]) {
            stroke(75) ;
            point(RainUx[i]-2*RainUxSpeed[i], RainUy[i]-2*RainUySpeed[i]);
            if (abs(RainUx[i]-RainUx0[i]) >= 3*RainUxSpeed[i]) {
              stroke(25);
              point(RainUx[i]-3*RainUxSpeed[i], RainUy[i]-3*RainUySpeed[i]);
              if (abs(RainUx[i]-RainUx0[i]) >= 4*RainUxSpeed[i]) {
                stroke(10);
                point(RainUx[i]-4*RainUxSpeed[i], RainUy[i]-4*RainUySpeed[i]);
              }
            }
          }
        }

        RainUx[i] += RainUxSpeed[i];
        RainUy[i] += RainUySpeed[i];
        if (abs(RainUx[i]-RainUx0[i]) > 4) {
          RainUx[i] = random(31);
          RainUy[i] = random(31);
          RainUx0[i] = RainUx[i];
        }
      }
    }

    if (side) {
      println("side");
      RainDinitialTimeCheck = false;
      background(5);
      for (int i = 0; i < 16; i++) {
        stroke(5);
        point(RainLx[i], RainLy[i]);
        stroke(55);
        point(RainLx[i], RainLy[i]+1);
        stroke(105);
        point(RainLx[i], RainLy[i]+2);
        stroke(155);
        point(RainLx[i], RainLy[i]+3);
        stroke(205);
        point(RainLx[i], RainLy[i]+4);
        stroke(250);
        point(RainLx[i], RainLy[i]+5);
      }

      for (int i = 0; i < 16; i++) {
        RainLx[i]+=RainLxSpeed;
        RainLy[i]+=RainLySpeed;
      }
      for (int i = 0; i < 16; i++) {
        if (RainLy[i] >= 32) {
          RainLy[i] = random(-25, 0);
          RainLx[i] = random(32);
        }
      }
    }

    if (ground) {
      println("ground");

      if (!RainDinitialTimeCheck) {
        for (int i = 0; i < 10; i++) {
          RainDchecktime[i] = millis()-random(800);
        }
        RainDinitialTimeCheck = true;
      }


      background(5);
      for (int i = 0; i < 10; i++) {
        if ((millis()-RainDchecktime[i] >= 0)&&(millis()-RainDchecktime[i] < 200)) {
          stroke(250);
          point(RainDx[i], RainDy[i]);
        }
        if ((millis()-RainDchecktime[i] >= 200)&&(millis()-RainDchecktime[i] < 400)) {
          stroke(125);
          noFill();
          ellipse(RainDx[i], RainDy[i], 2, 2);
        }
        if ((millis()-RainDchecktime[i] >= 400)&&(millis()-RainDchecktime[i] < 600)) {
          stroke(75);
          noFill();
          ellipse(RainDx[i], RainDy[i], 4, 4);
        }
        if ((millis()-RainDchecktime[i] >= 600)&&(millis()-RainDchecktime[i] < 800)) {
          stroke(25);
          noFill();
          ellipse(RainDx[i], RainDy[i], 6, 6);
          stroke(75);
          noFill();
          ellipse(RainDx[i], RainDy[i], 3, 3);
        }
        if ((millis()-RainDchecktime[i] >= 800)&&(millis()-RainDchecktime[i] < 1000)) {
          stroke(15);
          noFill();
          ellipse(RainDx[i], RainDy[i], 8, 8);
          stroke(25);
          noFill();
          ellipse(RainDx[i], RainDy[i], 5, 5);
        }
        if ((millis()-RainDchecktime[i] >= 1000)&&(millis()-RainDchecktime[i] < 1200)) {
          stroke(5);
          noFill();
          ellipse(RainDx[i], RainDy[i], 10, 10);
          stroke(10);
          noFill();
          ellipse(RainDx[i], RainDy[i], 3, 3);
          stroke(10);
          noFill();
          ellipse(RainDx[i], RainDy[i], 5, 5);
          RainDchecktime[i] = millis();
          RainDx[i] = random(31);
          RainDy[i] = random(31);
        }
      }
    }
  }

  //snow
  if (snow == true) {
    RainDinitialTimeCheck = false;
    if (sky) {
      println("sky");
      background(5);

      for (int i = 0; i < 25; i++) {
        if ((SnowUx[i] <= 15)&&(SnowUy[i] <= 15)) {
          SnowUxSpeed[i] = -0.1;
          SnowUySpeed[i] = random(0.5, 2.0)*SnowUxSpeed[i];
        }
        if ((SnowUx[i] >= 16)&&(SnowUy[i] <= 15)) {
          SnowUxSpeed[i] = 0.1;
          SnowUySpeed[i] = -random(0.5, 2.0)*SnowUxSpeed[i];
        }
        if ((SnowUx[i] <= 15)&&(SnowUy[i] >= 16)) {
          SnowUxSpeed[i] = -0.1;
          SnowUySpeed[i] = -random(0.5, 2.0)*SnowUxSpeed[i];
        }
        if ((SnowUx[i] >= 16)&&(SnowUy[i] >= 16)) {
          SnowUxSpeed[i] = 0.1;
          SnowUySpeed[i] = random(0.5, 2.0)*SnowUxSpeed[i];
        }

        fill(250);
        noStroke();
        ellipse(SnowUx[i], SnowUy[i], SnowUsize[i], SnowUsize[i]);

        if ((SnowUx[i]>=11)&&(SnowUx[i]<=20)&&(SnowUy[i]>=11)&&(SnowUy[i]<=20)) {  
          SnowUx[i] += SnowUxSpeed[i]/3;
          SnowUy[i] += SnowUySpeed[i]/3;
        } else {
          SnowUx[i] += SnowUxSpeed[i];
          SnowUy[i] += SnowUySpeed[i];
        }

        SnowUsize[i] += 0.05;

        if (SnowUsize[i] >= 3) {
          SnowUx[i] = random(31);
          SnowUy[i] = random(31);
          SnowUx0[i] = SnowUx[i];
          //y0[i] = y[i];
          SnowUsize[i] = random(0.4, 1);
        }
      }
    }
    if (side) {
      println("side");
      background(5);
      for (int i = 0; i < 40; i++) {
        fill(random(80, 250));
        noStroke();
        ellipse(SnowLx[i], SnowLy[i], SnowLsize[i], SnowLsize[i]);
      }
      for (int i = 0; i < 40; i++) {
        SnowLy[i] += SnowLySpeed;
        SnowLx[i] += SnowLxSpeed[i];
        if ((SnowLx[i] >= SnowLx0[i]+4)||(SnowLx[i] <= SnowLx0[i]-4)) {
          SnowLxSpeed[i] = -SnowLxSpeed[i];
        }
      }

      for (int i = 0; i < 40; i++) {
        if (SnowLy[i] >= 32) {
          SnowLy[i] = random(-30, -1);
          SnowLx[i] = random(32);
          SnowLx0[i] = SnowLx[i];
          SnowLsize[i] = random(0.5, 2);
        }
      }
    }
    if (ground) {
      println("ground");
      background(20);
      for (int i = 0; i<100; i++) {
        fill(SnowDbrightness[i]);
        noStroke();
        ellipse(SnowDx[i], SnowDy[i], SnowDsize[i], SnowDsize[i]); 
        SnowDbrightness[i] -= 0.1;
        if (SnowDbrightness[i] <= 20) {
          SnowDbrightness[i] = 20;
        }
      }
      for (int i = 0; i<100; i++) {
        if ((SnowDx0[i] <= 15)&&(SnowDy0[i] <= 15)) {
          SnowDx1Speed[i] = random(0.2, 0.1);
          SnowDy1Speed[i] = random(0.5, 2.0)*SnowDx1Speed[i];
        }
        if ((SnowDx0[i] >= 16)&&(SnowDy0[i] <= 15)) {
          SnowDx1Speed[i] = random(-0.2, -0.1);
          SnowDy1Speed[i] = -random(0.5, 2.0)*SnowDx1Speed[i];
        }
        if ((SnowDx0[i] <= 15)&&(SnowDy0[i] >= 16)) {
          SnowDx1Speed[i] = random(0.2, 0.1);
          SnowDy1Speed[i] = -random(0.5, 2.0)*SnowDx1Speed[i];
        }
        if ((SnowDx0[i] >= 16)&&(SnowDy0[i] >= 16)) {
          SnowDx1Speed[i] = random(-0.2, -0.1);
          SnowDy1Speed[i] = random(0.5, 2.0)*SnowDx1Speed[i];
        }
        fill(SnowDbrightness[i]);
        noStroke();
        ellipse(SnowDx1[i], SnowDy1[i], SnowDsize[i], SnowDsize[i]);
        if ((abs(SnowDx1[i]-SnowDx0[i]) <= 6)&&(abs(SnowDy1[i]-SnowDy0[i]) <= 6)) {
          SnowDx1[i] += SnowDx1Speed[i];
          SnowDy1[i] += SnowDy1Speed[i];
          SnowDsize[i] -= SnowDsizeDecrease[i];
        }
        if ((abs(SnowDx1[i]-SnowDx0[i]) > 6)||(abs(SnowDy1[i]-SnowDy0[i]) > 6)||(SnowDsize[i] <= 0)) {
          SnowDx1Speed[i] = 0;
          SnowDy1Speed[i] = 0;
          SnowDsizeDecrease[i] = 0;
          //ellipse(x1[i], y1[i], size[i], size[i]); 
          SnowDbrightness[i] -= 0.1;
          if (SnowDbrightness[i] < 20) {
            SnowDbrightness[i] = random(200, 250);
            SnowDx0[i] = random(-5, 36);
            SnowDy0[i] = random(-5, 36);
            SnowDx1[i] = SnowDx0[i];
            SnowDy1[i] = SnowDy0[i];
            //x1Speed[i] = random(-0.2, 0.2);
            //y1Speed[i] = random(-0.2, 0.2);
            SnowDsize[i] = random(2, 3);
            SnowDsizeDecrease[i] = 0.02;
          }
        }
      }
    }
  }
  
  //fog
  if (fog == true) {
    RainDinitialTimeCheck = false;
    if (sky) {
      println("sky");
      background(10);
      for (int i = 0; i < 1024; i++) {
        stroke(FogUbrightness[i]);
        point(FogUx[i%32], floor(i/32));
      }
      for (int i = 0; i < 32; i++) {
        FogUx[i] -= 0.1;
        if (FogUx[i] < 0) {
          FogUx[i] = 31;
        }
      }

      //blocks

      //sky
      stroke(10);
      fill(10);

      beginShape();
      vertex(-1, 22);
      bezierVertex(4, 24, 7, 27, 11, 30);
      bezierVertex(9, 30, 4, 31, -1, 32);
      endShape();

      //beginShape();
      //vertex(-1, 16);
      //bezierVertex(5, 14, 10, 15, 19, 12);
      //bezierVertex(16, 24, 7, 26, -1, 27);
      //endShape();

      beginShape();
      vertex(8, 26);
      bezierVertex(19, 20, 28, 18, 34, 25);
      bezierVertex(27, 27, 16, 25, 7, 28);
      endShape();

      beginShape();
      vertex(15, 22);
      bezierVertex(19, 15, 22, 18, 25, 20);
      bezierVertex(27, 16, 29, 17, 37, 16);
      bezierVertex(30, 12, 24, 10, 18, 14);
      endShape();

      beginShape();
      vertex(-1, 12);
      bezierVertex(9, 6, 14, 7, 20, 13);
      bezierVertex(17, 16, 12, 15, -1, 18);
      endShape();

      //beginShape();
      //vertex(-1, 0);
      //bezierVertex(6, -1, 14, -1, 18, -2);
      //bezierVertex(15, 4, 7, 3, -1, 4);
      //endShape();

      beginShape();
      vertex(33, 3);
      bezierVertex(28, 1, 24, -1, 16, -2);
      bezierVertex(18, 6, 22, 8, 29, 4);
      endShape();

      beginShape();
      vertex(10, 3);
      bezierVertex(14, 1, 18, -1, 20, -2);
      bezierVertex(18, 8, 13, 6, 11, 4);
      bezierVertex(10, 5, 9, 6, 8, 3);
      endShape();

      //hill
      stroke(10);
      fill(5);
      beginShape();
      vertex(8, 33);
      bezierVertex(21, 29, 28, 27, 34, 32);
      bezierVertex(27, 30, 16, 29, 7, 31);
      endShape();

      //sun or moon
      noStroke();
      //fill(100);
      //ellipse(8, 8, 10, 10);
      fill(60);
      ellipse(9, 14, 8, 8);
      fill(80);
      ellipse(9, 14, 6, 6);
      fill(100);
      ellipse(9, 14, 5, 5);
      fill(120);
      ellipse(9, 14, 4, 4);
      fill(130);
      ellipse(9, 14, 3, 3);
      fill(140);
      ellipse(9, 14, 2, 2);
      fill(150);
      ellipse(9, 14, 1, 1);

      //stars
      fill(random(120, 200));
      ellipse(29, 3, 1, 1);
      ellipse(17, 4, 1, 1);
      ellipse(21, 15, 1, 1);
      ellipse(8, 10, 1, 1);
      ellipse(26, 24, 1, 1);
      ellipse(3, 26, 1, 1);
      ellipse(2, 5, 1, 1);
      ellipse(16, 28, 1, 1);
      ellipse(23, 28, 1, 1);
      ellipse(7, 14, 1, 1);
    }

    if (side) {
      println("side");
      background(10);
      for (int i = 0; i < 1024; i++) {
        stroke(FogLbrightness[i]);
        point(FogLx[i%32], floor(i/32));
      }
      for (int i = 0; i < 32; i++) {
        FogLx[i] -= 0.5;
        if (FogLx[i] < 0) {
          FogLx[i] = 31;
        }
      }
      stroke(10);
      fill(5);
      beginShape();
      vertex(4, 32);
      bezierVertex(20, 26, 29, 27, 38, 32);
      endShape();

      beginShape();
      vertex(0, 10);
      bezierVertex(3, 6, 15, 9, 22, 17);
      bezierVertex(16, 18, 6, 15, 0, 15);
      endShape();

      beginShape();
      vertex(18, 9);
      bezierVertex(21, 7, 30, 3, 36, 6);
      bezierVertex(29, 11, 21, 9, 18, 10);
      endShape();
    }

    if (ground) {
      println("ground");
      background(10);
      for (int i = 0; i < 1024; i++) {
        stroke(FogDbrightness[i]);
        point(FogDx[i%32], FogDy[floor(i/32)]);
      }
      for (int i = 0; i < 32; i++) {
        if (FogDx[i] <= 15.5) {
          FogDx[i] -= 0.5;
          if (FogDx[i] < 0) {
            FogDx[i] = 15.5;
          }
        }
        if (FogDx[i] > 15.5) {
          FogDx[i] += 0.5;
          if (FogDx[i] > 31) {
            FogDx[i] = 15.6;
          }
        }
        FogDy[i] -= 0.6;
        if (FogDy[i] < 0) {
          FogDy[i] = 31;
        }
      }

      //noStroke();
      //fill(10);
      //ellipse(15, 16, 4, 4);
      //fill(20);
      //ellipse(15, 16, 8, 8);

      ////blocks
      //stroke(10);
      //fill(5);
      //beginShape();
      //vertex(-1, 10);
      //bezierVertex(8, 13, 8, 21, 18, 33);
      //bezierVertex(-3, 30, -4, 24, -4, 4);
      //endShape();

      //beginShape();
      //vertex(14, 24);
      //bezierVertex(20, 17, 27, 14, 33, 20);
      //bezierVertex(29, 24, 22, 22, 16, 26);
      //endShape();

      //beginShape();
      //vertex(5, 8);
      //bezierVertex(11, 2, 15, 1, 17, 11);
      //bezierVertex(17, 15, 15, 13, 8, 14);
      //endShape();
    }
  }
}
