float[] Lx = new float[40];
float[] Ly = new float[40]; 
float[] Lx0 = new float[40];
float[] LxSpeed = new float[40];
float LySpeed = 0.1;
float[] Lsize = new float[40];

void setup() {
  size(32, 32);
  background(5);
  for (int i = 0; i < 40; i++) {
    Lx[i] = random(32);
    Ly[i] = random(-30, -1);
    Lx0[i] = Lx[i];
    LxSpeed[i] = random(-0.1, 0.1);
    Lsize[i] = random(0.5, 2);
  }
}

void draw() {
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
