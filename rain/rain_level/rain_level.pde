float[] Lx = new float[16];
float[] Ly = new float[16];
float LxSpeed;
float LySpeed = 0.8;


void setup() {
  size(32, 32);
  background(0);
  for (int i = 0; i < 16; i++) {
    Lx[i] = random(32);
  }
  for (int i = 0; i < 16; i++) {
    Ly[i] = random(-25, 0);
  }
}

void draw() {
  background(5);
  for (int i = 0; i < 16; i++) {
    stroke(5);
    point(Lx[i], Ly[i]);
    stroke(55);
    point(Lx[i], Ly[i]+1);
    stroke(105);
    point(Lx[i], Ly[i]+2);
    stroke(155);
    point(Lx[i], Ly[i]+3);
    stroke(205);
    point(Lx[i], Ly[i]+4);
    stroke(250);
    point(Lx[i], Ly[i]+5);
  }

  for (int i = 0; i < 16; i++) {
    Lx[i]+=LxSpeed;
    Ly[i]+=LySpeed;
  }
  for (int i = 0; i < 16; i++) {
    if (Ly[i] >= 32) {
      Ly[i] = random(-25, 0);
      Lx[i] = random(32);
    }
  }
}
