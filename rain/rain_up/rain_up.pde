float[] Ux = new float[16];
float[] Uy = new float[16];
float[] Ux0 = new float[16];
//float[] y0 = new float[20];
float[] UxSpeed = new float[16];
float[] UySpeed = new float[16];

void setup() {
  size(32, 32);
  for (int i = 0; i < 16; i++) {
    Ux[i] = random(31);
    Uy[i] = random(31);
    Ux0[i] = Ux[i];
    //y0[i] = y[i];
  }
}

void draw() {
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
  
