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
  background(10);
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
