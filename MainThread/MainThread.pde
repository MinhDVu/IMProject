public static ArrayList<Particle> confetti;
public static  Logo logo;
public final int THRESHOLD = 100;

void setup() {
  size(800, 600);
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

  updateLogo();
}

private void updateLogo() {
  logo.update();
  if (logo.x + logo.logo_img.width >= width) {
    logo.xVelocity = -logo.xVelocity;
    logo.x = width - logo.logo_img.width;
    logo.updateColor();
    addConfetti();
  } else if (logo.x <= 0) {
    logo.xVelocity = -logo.xVelocity;
    logo.x = 0;
    logo.updateColor();
    addConfetti();
  }
  if (logo.y + logo.logo_img.height > height) {
    logo.yVelocity = -logo.yVelocity;
    logo.y = height - logo.logo_img.height;
    logo.updateColor();
    addConfetti();
  } else if (logo.y <= 0) {
    logo.yVelocity = -logo.yVelocity;
    logo.y = 0;
    logo.updateColor();
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
  for (int i= 0; i < 50; i++) {
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
