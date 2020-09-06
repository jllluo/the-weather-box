float[] Ux = new float[25];
float[] Uy = new float[25];
float[] Ux0 = new float[25];
//float[] y0 = new float[20];
float[] UxSpeed = new float[25];
float[] UySpeed = new float[25];
float[] Usize = new float[25];

void setup() {
  size(32, 32);
  for (int i = 0; i < 25; i++) {
    Ux[i] = random(31);
    Uy[i] = random(31);
    Ux0[i] = Ux[i];
    Usize[i] = random(0.4, 4);
    //y0[i] = y[i];
  }
}

void draw() {
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
