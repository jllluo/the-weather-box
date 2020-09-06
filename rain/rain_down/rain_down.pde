float[] Dchecktime = new float[10];
float[] Dx = new float[10];
float[] Dy = new float[10];


void setup () {
  size(32, 32);
  background(0);
  for (int i = 0; i < 10; i++) {
    Dx[i] = random(31);
    Dy[i] = random(31);
    Dchecktime[i] = random(1000);
  }
}

void draw () {
  background(0);
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
