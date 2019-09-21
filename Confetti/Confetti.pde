ArrayList<Particle> confetti;

void setup() {
  size(600, 600);
  frameRate(30);
  confetti = new ArrayList<Particle>();
}

void draw() {
  background(0);
  stroke(255);
  // Divide sections on screen that animations will behave differently
  line(100, 0, 100, height);
  line(0, 100, width, 100);
  line(width - 100, 0, width - 100, height);
  line(0, height - 100, width, height - 100);
  for (int i=0; i < confetti.size(); i++) {
    Particle p = confetti.get(i);
    // Remove particle if they are too small and not visible
    if (p.opacity < 50) {
      confetti.remove(i);
    } else {
      p.update();
    }
  }

  // Just in case you are tired of mouse clicking
  //  for (int i= 0; i < 5; i++) {
  //  confetti.add(new Particle(mouseX, mouseY));
  //}
}

// Emulate collision events when the logo hits the screen
void mousePressed() {
  for (int i= 0; i < 10; i++) {
    confetti.add(new Particle(mouseX, mouseY));
  }
}
