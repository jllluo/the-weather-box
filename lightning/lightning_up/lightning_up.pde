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

void setup() {
  size(32, 32);
  background(0);
  for (int i = 0; i < 1024; i++) {
    LightningUbrightness[i] = random(20, 60);
  }
}

void draw() {
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
