public static ArrayList<Particle> confetti;
public static  Logo logo;
public final int THRESHOLD = 100;

void setup() {
  size(600, 600);
  //frameRate(30);
  confetti = new ArrayList<Particle>();
  logo = new Logo(random(width), random(height));
}

void draw() {
  background(0);
  stroke(255);
  drawThreshold();
  for (int i=0; i < confetti.size(); i++) {
    Particle p = confetti.get(i);
    // Remove particle if they are too small and not visible
    if (p.opacity < 50) {
      confetti.remove(i);
    } else {
      p.update();
    }
  }

  logo.update();
  
  if (logo.x >= width - THRESHOLD || logo.x <= THRESHOLD || logo.y >= height - THRESHOLD || logo.y <= THRESHOLD) {
    addConfetti();
  }
}

// Emulate collision events when the logo hits the screen
void mousePressed() {
  for (int i= 0; i < 10; i++) {
    confetti.add(new Particle(mouseX, mouseY));
  }
}

public void addConfetti() {
  for (int i= 0; i < 10; i++) {
    confetti.add(new Particle(logo.xCenter, logo.yCenter));
  }
}

private void drawThreshold() {
  // Divide sections on screen where animations will behave differently
  line(100, 0, THRESHOLD, height);
  line(0, THRESHOLD, width, THRESHOLD);
  line(width - THRESHOLD, 0, width - THRESHOLD, height);
  line(0, height - THRESHOLD, width, height - THRESHOLD);
}
