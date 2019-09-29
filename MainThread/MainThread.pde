import de.voidplus.leapmotion.*;

static ArrayList<Particle> confetti;

static  Logo logo;
LeapMotion leap;
Bone[] bones;

public final int THRESHOLD = 10;

void setup() {
  size(800, 600);
  //fullScreen();
  //frameRate(60);
  confetti = new ArrayList<Particle>();
  logo = new Logo(random(width), random(height));
  leap = new LeapMotion(this);
}

void leapOnConnect() {
  println("Leap Motion Connected");
}

void draw() {
  background(0);
  drawThreshold();
  updateParticles();
  updateLogo();
  updateHands();
}

private void updateHands() {
  for (Hand hand : leap.getHands ()) {
    hand.draw();
    PVector handPosition = hand.getPosition();
    visualizePoint(handPosition.x, handPosition.y);

    if (hand.getPinchStrength() >= 0.9 && PVector.dist(handPosition, logo.Center) <= logo.r) {
      logo.Center.x = handPosition.x;
      logo.Center.y = handPosition.y;
    }
    for (Finger finger : hand.getFingers()) {
      PVector fingerPosition = finger.getPosition();
      visualizePoint(fingerPosition.x, fingerPosition.y);
      //Default draw method with 3px in radius for each joints, can't be used for our purpose but good to have during dev process
      //finger.draw();

      bones = new Bone[]{finger.getBone(0), finger.getBone(1), finger.getBone(2), finger.getBone(3)};

      for (Bone bone : bones ) {
        PVector joint = bone.getPrevJoint();
        //TODO: Logo collision detection here
        visualizePoint(joint.x, joint.y);
        
        if (PVector.dist(joint, logo.Center) < logo.r) {
          print("Logo touched !");
          logo.handleCollision(joint.x, joint.y);
        }
      }
    }
  }
}

private void updateParticles() {
  for (int i=0; i < confetti.size(); i++) {
    Particle p = confetti.get(i);
    // Remove particle if they are too small and not visible
    if (p.opacity < 50) {
      confetti.remove(i);
    } else {
      p.update();
    }
  }
}

private void updateLogo() {
  logo.update();

  /** 
   * TL----------------TR
   * |                  |
   * |     xyCenter     |
   * |                  |
   * BL----------------BR
   */

  //Reserved space of corner detection
  if (false) {
  }

  //If logo hits right side of the screen
  else if (logo.TR.x >= width) {
    logo.xVelocity = -logo.xVelocity;
    logo.TL.x = width - logo.logo_img.width;
    logo.updateColor();
    addConfetti(logo.TR.x, logo.TR.y);
    addConfetti(logo.BR.x, logo.BR.y);

    //If logo hits left side of the screen
  } else if (logo.TL.x <= 0) {
    logo.xVelocity = -logo.xVelocity;
    logo.TL.x = 0;
    logo.updateColor();
    addConfetti(logo.TL.x, logo.TL.y);
    addConfetti(logo.BL.x, logo.BL.y);

    //If logo hits bottom side
  } else if (logo.BL.y >= height) {
    logo.yVelocity = -logo.yVelocity;
    logo.BL.y = height - logo.logo_img.height;
    logo.updateColor();
    addConfetti(logo.BL.x, logo.BL.y);
    addConfetti(logo.BR.x, logo.BR.y);

    //If logo hits top side
  } else if (logo.TL.y <= 0) {
    logo.yVelocity = -logo.yVelocity;
    logo.TL.y = 0;
    logo.updateColor();
    addConfetti(logo.TR.x, logo.TR.y);
    addConfetti(logo.TL.x, logo.TL.y);
  }
}

// Emulate collision events when the logo hits the screen
void mousePressed() {
  for (int i= 0; i < 10; i++) {
    confetti.add(new Particle(mouseX, mouseY));
  }
  logo.handleCollision(mouseX, mouseY);
}

public void addConfetti(float x, float y) {
  for (int i= 0; i < 10; i++) {
    confetti.add(new Particle(x, y));
  }
}

private void visualizePoint(float x, float y) {
  fill(255, 0, 0);
  ellipse(x, y, 10, 10);
}


private void drawThreshold() {
  // Divide sections on screen where animations will behave differently
  stroke(255);
  line(THRESHOLD, 0, THRESHOLD, height);
  line(0, THRESHOLD, width, THRESHOLD);
  line(width - THRESHOLD, 0, width - THRESHOLD, height);
  line(0, height - THRESHOLD, width, height - THRESHOLD);
}
