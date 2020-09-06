import processing.io.*;
I2C i2c;

boolean up = false;
boolean down = false;
boolean sky = false;
boolean side = false;
boolean ground = false;

boolean rain = false;
boolean snow = true;
boolean lightning = false;

long orientationTimeCheck;

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

//lightning
//up
float[] LightningUbrightness = new float[1024];
float LightningUcloud1 = 60;
float LightningUcloud2 = 90;
float LightningUcloud3 = 70;
float LightningUcloud4 = 60;
float LightningUcloud5 = 80;
float LightningUhighB = 180;
float LightningUlowB = 140;
float LightningUflash;
float LightningUx0 = 20;
float LightningUy0 = 17;
long LightningUinterval = 1000;
long LightningUduration = 500;
long LightningUlastFinishTime = 0;
long LightningUstartTime = 1000;
boolean LightningUinitialized = false;

//side
float[] LightningLbrightness = new float[1024];
float LightningLcloud1 = 60;
float LightningLcloud2 = 90;
float LightningLcloud3 = 70;
float LightningLcloud4 = 60;
float LightningLcloud5 = 80;
float LightningLcloudPoint = 110;
float LightningLhighB = 200;
float LightningLlowB = 160;
float LightningLflash;
float LightningLx0 = 14;
float LightningLy0 = 4;
long LightningLinterval = 1000;
long LightningLduration = 500;
long LightningLlastFinishTIme = 0;
long LightningLstartTime = 1000;
boolean LightningLinitialized = false;

//down
float[] LightningDbrightness = new float[7];
long LightningDinterval = 2000;
long LightningDduration = 500;
long LightningDlastFinishTime = 0;
long LightningDstartTime = 1000;
boolean LightningDinitialized = false;


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

  //lightning
  //up
  for (int i = 0; i < 1024; i++) {
    LightningUbrightness[i] = random(20, 60);
  }

  //side
  for (int i = 0; i < 1024; i++) {
    LightningLbrightness[i] = random(20, 60);
  }

  //down
  for (int i = 0; i < 7; i++) {
    LightningDbrightness[i] = random(20, 50);
  }
}

void draw() {  
  //if (GPIO.digitalRead(5) == GPIO.LOW) {
  //  println("rain");
  //  rain = true;
  //  snow = false;
  //  lightning = false;
  //}
  //if (GPIO.digitalRead(6) == GPIO.LOW) {
  //  println("snow");
  //  rain = false;
  //  snow = true;
  //  lightning = false;
  //}
  //if (GPIO.digitalRead(13) == GPIO.LOW) {
  //  println("lightning");
  //  rain = false;
  //  snow = false;
  //  lightning = true;
  //}


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

  if (millis() - orientationTimeCheck > 1000) {
    if (abs(rotY) > 100||abs(rotZ) > 100) {
      if (rain) {
        snow = true;
        rain = false;
        lightning = false;
      } else if (snow) {
        lightning = true;
        rain = false;
        snow = false;
      } else if (lightning) {
        rain = true;
        snow = false;
        lightning = false;
      }
      orientationTimeCheck = millis();
    }
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

  //lightning
  if (lightning == true) {
    RainDinitialTimeCheck = false;
    if (sky) {
      println("sky");
      background(10);
      for (int i = 0; i < 1024; i++) {
        stroke(LightningUbrightness[i]);
        noFill();
        point(i%32, floor(i/32));
      }


      stroke(20+(LightningUcloud1-20)/2);
      fill(LightningUcloud1);
      beginShape();
      vertex(0, -3);
      bezierVertex(7, -3, 10, 1, 18, 0);
      bezierVertex(16, 11, 9, 5, 2, 8);
      bezierVertex(1, 9, 0, 2, -2, 11);
      endShape();

      stroke(20+(LightningUcloud2-20)/2);
      fill(LightningUcloud2);
      beginShape();
      vertex(16, 2);
      bezierVertex(22, -1, 27, 5, 32, 4);
      bezierVertex(29, 15, 24, 13, 18, 12);
      bezierVertex(18, 17, 16, 12, 15, 7);
      endShape();

      stroke(20+(LightningUcloud3-20)/2);
      fill(LightningUcloud3);
      beginShape();
      vertex(23, 10);
      bezierVertex(30, 12, 34, 9, 36, 8);
      bezierVertex(32, 23, 30, 21, 22, 17);
      endShape();

      stroke(20+(LightningUcloud4-20)/2);
      fill(LightningUcloud4);
      beginShape();
      vertex(2, 11);
      bezierVertex(7, 13, 16, 9, 22, 15);
      bezierVertex(25, 20, 18, 15, 14, 24);
      bezierVertex(11, 21, 5, 19, -1, 23);
      endShape();

      stroke(20+(LightningUcloud5-20)/2);
      fill(LightningUcloud5);
      beginShape();
      vertex(6, 23);
      bezierVertex(15, 22, 18, 19, 23, 25);
      bezierVertex(28, 33, 20, 35, 15, 32);
      bezierVertex(12, 33, 7, 32, 5, 28);
      endShape();

      stroke(20+(LightningUcloud1-20)/2);
      fill(LightningUcloud1);
      beginShape();
      vertex(21, 3);
      bezierVertex(19, 13, 11, 24, 24, 2);
      bezierVertex(22, 1, 12, 24, 25, 27);
      endShape();

      stroke(20+(LightningUcloud2-20)/2);
      fill(LightningUcloud2);
      beginShape();
      vertex(23, 4);
      bezierVertex(3, 15, 20, 10, 23, 23);
      bezierVertex(26, 13, 0, 21, 27, 17);
      endShape();


      //lightning
      if (millis() - LightningUlastFinishTime >= LightningUinterval) {
        if (!LightningUinitialized) {
          LightningUx0 = random(31);
          LightningUy0 = random(31);
          LightningUhighB = random(160, 200);
          LightningUlowB = random(120, 160);
          LightningUstartTime = millis();
          LightningUinitialized = true;
        }
        if (millis() - LightningUstartTime <= LightningUduration) {
          stroke(LightningUhighB);
          line(LightningUx0, LightningUy0, LightningUx0+random(-5, 5), LightningUy0+random(-5, 5));
          line(LightningUx0+random(-5, 5), LightningUy0+random(-5, 5), LightningUx0+random(-5, 5), LightningUy0+random(-5, 5));
          line(LightningUx0+random(-5, 5), LightningUy0+random(-5, 5), LightningUx0+random(-5, 5), LightningUy0+random(-5, 5));
          line(LightningUx0+random(-5, 5), LightningUy0+random(-5, 5), LightningUx0+random(-5, 5), LightningUy0+random(-5, 5));    

          stroke(LightningUlowB);
          line(LightningUx0+random(-5, 5), LightningUy0+random(-5, 5), LightningUx0+random(-5, 5), LightningUy0+random(-5, 5));
          line(LightningUx0+random(-5, 5), LightningUy0+random(-5, 5), LightningUx0+random(-5, 5), LightningUy0+random(-5, 5));

          //brightness change
          LightningUflash = random(-50, 50);
          if (LightningUhighB + LightningUflash <= 220 && LightningUlowB + LightningUflash > 120) {
            LightningUhighB += LightningUflash;
            LightningUlowB += LightningUflash;
            LightningUcloud1 += 3*LightningUflash/4;
            LightningUcloud2 += 3*LightningUflash/4;
            LightningUcloud3 += 3*LightningUflash/4;
            LightningUcloud4 += 3*LightningUflash/4;
            LightningUcloud5 += 3*LightningUflash/4;
            if (LightningUhighB + LightningUflash == 220) {
              LightningUhighB = 250;
              LightningUlowB = 250;
              LightningUcloud1 = 210;
              LightningUcloud2 = 240;
              LightningUcloud3 = 220;
              LightningUcloud4 = 210;
              LightningUcloud5 = 230;
            }
          }
        }
        if (millis() - LightningUstartTime > LightningUduration) {
          LightningUlastFinishTime = millis();
          LightningUinitialized = false;
          LightningUinterval = floor(random(500, 1500));
          LightningUduration = floor(random(100, 600));
          LightningUcloud1 = 60;
          LightningUcloud2 = 90;
          LightningUcloud3 = 70;
          LightningUcloud4 = 60;
          LightningUcloud5 = 80;
          LightningUhighB = 180;
          LightningUlowB = 140;
        }
      }
    }

    if (side) {
      println("side");
      background(10);
      for (int i = 0; i < 1024; i++) {
        stroke(LightningLbrightness[i]);
        noFill();
        point(i%32, floor(i/32));
      }

      stroke(20+(LightningLcloud1-20)/2);
      fill(LightningLcloud1);
      beginShape();
      vertex(0, -3);
      bezierVertex(7, -3, 10, 1, 18, 0);
      bezierVertex(25, -2, 30, 4, 35, 2);
      bezierVertex(29, 12, 28, 6, 22, 9);
      bezierVertex(16, 11, 9, 5, 2, 6);
      endShape();

      stroke(20+(LightningLcloud2-20)/2);
      fill(LightningLcloud2);
      beginShape();
      vertex(0, 5);
      bezierVertex(8, 2, 15, 9, 23, 8);
      bezierVertex(30, 11, 34, 7, 36, 7);
      bezierVertex(32, 12, 30, 15, 22, 14);
      bezierVertex(14, 12, 19, 11, 12, 10);
      endShape();

      stroke(20+(LightningLcloud3-20)/2);
      fill(LightningLcloud3);
      beginShape();
      vertex(-1, 13);
      bezierVertex(4, 8, 13, 14, 22, 13);
      bezierVertex(28, 15, 24, 9, 36, 14);
      bezierVertex(32, 20, 26, 15, 20, 20);
      bezierVertex(13, 21, 8, 16, 5, 16);
      endShape();

      stroke(20+(LightningLcloud4-20)/2);
      fill(LightningLcloud4);
      beginShape();
      vertex(7, 18);
      bezierVertex(13, 17, 19, 23, 26, 22);
      bezierVertex(35, 21, 33, 16, 43, 18);
      bezierVertex(39, 29, 33, 26, 27, 26);
      bezierVertex(23, 23, 16, 26, 11, 24);
      endShape();

      stroke(20+(LightningLcloud5-20)/2);
      fill(LightningLcloud5);
      beginShape();
      vertex(-1, 24);
      bezierVertex(5, 24, 11, 29, 17, 26);
      bezierVertex(25, 25, 26, 30, 30, 28);
      bezierVertex(28, 28, 18, 27, 16, 30);
      bezierVertex(7, 33, 5, 30, -1, 31);
      endShape();

      stroke(20+(LightningLcloud1-20)/2);
      fill(LightningLcloud1);
      beginShape();
      vertex(27, 27);
      bezierVertex(21, 22, 7, 17, 2, 25);
      bezierVertex(7, 20, 12, 13, 19, 29);
      endShape();

      stroke(20+(LightningLcloud2-20)/2);
      fill(LightningLcloud2);
      beginShape();
      vertex(7, 18);
      bezierVertex(2, 13, 3, 20, 18, 10);
      bezierVertex(4, 17, 15, 13, 28, 15);
      endShape();


      //lightning
      if (millis() - LightningLlastFinishTIme >= LightningLinterval) {
        if (!LightningLinitialized) {
          LightningLx0 = random(31);
          LightningLy0 = random(0, 12);
          LightningLhighB = random(180, 220);
          LightningLlowB = random(140, 180);
          LightningLcloudPoint = random(100, 120);
          LightningLstartTime = millis();
          LightningLinitialized = true;
        }
        if (millis() - LightningLstartTime <= LightningLduration) {

          noStroke();
          fill(LightningLcloudPoint);
          ellipse(LightningLx0, LightningLy0, 5, 4);

          stroke(LightningLhighB);
          line(LightningLx0, LightningLy0, LightningLx0+random(-3, 3), LightningLy0+random(0, 5));
          line(LightningLx0+random(-3, 3), LightningLy0+random(0, 5), LightningLx0+random(-3, 3), LightningLy0+random(5, 10));
          line(LightningLx0+random(-3, 3), LightningLy0+random(5, 10), LightningLx0+random(-3, 3), LightningLy0+random(10, 15));
          line(LightningLx0+random(-3, 3), LightningLy0+random(10, 15), LightningLx0+random(-3, 3), LightningLy0+random(15, 20));
          line(LightningLx0+random(-3, 3), LightningLy0+random(15, 20), LightningLx0+random(-3, 3), LightningLy0+random(20, 25));

          stroke(LightningLlowB);
          line(LightningLx0+random(-3, 3), LightningLy0+random(5, 10), LightningLx0+random(-6, 6), LightningLy0+random(8, 13));
          line(LightningLx0+random(-3, 3), LightningLy0+random(10, 15), LightningLx0+random(-6, 6), LightningLy0+random(13, 18));
          line(LightningLx0+random(-3, 3), LightningLy0+random(15, 20), LightningLx0+random(-6, 6), LightningLy0+random(18, 23));


          //brightness change
          LightningLflash = random(-50, 50);
          if (LightningLhighB + LightningLflash <= 250 && LightningLcloudPoint + LightningLflash > 110) {        
            LightningLcloud1 += 3*LightningLflash/4;
            LightningLcloud2 += 3*LightningLflash/4;
            LightningLcloud3 += 3*LightningLflash/4;
            LightningLcloud4 += 3*LightningLflash/4;
            LightningLcloud5 += 3*LightningLflash/4;

            LightningLcloudPoint += LightningLflash;
            LightningLhighB += LightningLflash;
            LightningLlowB += LightningLflash;

            if (LightningLhighB + LightningLflash >= 250) {
              fill(250);
              noStroke();
              rect(0, 0, 32, 32);
            }
          }
        }
        if (millis() - LightningLstartTime > LightningLduration) {
          LightningLlastFinishTIme = millis();
          LightningLinitialized = false;
          LightningLinterval = floor(random(500, 1500));
          LightningLduration = floor(random(100, 600));
          LightningLcloud1 = 60;
          LightningLcloud2 = 90;
          LightningLcloud3 = 70;
          LightningLcloud4 = 60;
          LightningLcloud5 = 80;
        }
      }
    }

    if (ground) {
      println("ground");
      background(10);
      noStroke();
      fill(LightningDbrightness[0], 100);
      rect(0, 0, 25, 25);
      fill(LightningDbrightness[1], 80);
      rect(15, 6, 10, 15);
      fill(LightningDbrightness[2], 90);
      rect(3, 7, 30, 30);
      fill(LightningDbrightness[3], 100);
      rect(-5, 2, 15, 15);
      fill(LightningDbrightness[4], 80);
      rect(6, -1, 20, 20);
      fill(LightningDbrightness[5], 90);
      rect(0, 20, 15, 15);
      fill(LightningDbrightness[6], 100);
      rect(25, -1, 10, 10);

      if (millis() - LightningDlastFinishTime >= LightningDinterval) {
        if (!LightningDinitialized) {
          LightningDstartTime = millis();
          LightningDinitialized = true;
        }
        if (millis() - LightningDstartTime <= LightningDduration) {
          for (int i = 0; i < 7; i++) {
            LightningDbrightness[i] = random(100, 200);
          }
        }
        if (millis() - LightningDstartTime > LightningDduration) {
          LightningDlastFinishTime = millis();
          LightningDinitialized = false;
          LightningDinterval = floor(random(1000, 2500));
          LightningDduration = floor(random(100, 600));
          for (int i = 0; i < 7; i++) {
            LightningDbrightness[i] = random(20, 50);
          }
        }
      }
    }
  }
}
