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

void setup() {
  size(32, 32);
  background(0);
  
  for (int i = 0; i < 1024; i++) {
    LightningLbrightness[i] = random(20, 60);
  }
}

void draw() {
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
