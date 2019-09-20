ArrayList<Particle> confetti;

void setup() {
  size(600, 600);
  confetti = new ArrayList<Particle>();
}

void draw() {
  background(0);
  stroke(255);
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
  for (int i=0; i < confetti.size(); i++) {
    Particle p = confetti.get(i);
    if (p.opacity < 50) {
      confetti.remove(i);
    } else {
      p.update();
      p.show();
    }
  }
  
  confetti.add(new Particle(mouseX, mouseY));
}

void mousePressed() {
  for (int i= 0; i < 10; i++) {
    confetti.add(new Particle(mouseX, mouseY));
  }
}
