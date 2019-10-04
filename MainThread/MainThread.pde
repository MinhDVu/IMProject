import de.voidplus.leapmotion.*;
// comment
static ArrayList<Particle> confetti;
static  Logo logo;
LeapMotion leap;
Bone[] bones;

public final int THRESHOLD = 10;

void setup() {
  size(800, 600);
  //fullScreen();
  //frameRate(5);
  confetti = new ArrayList<Particle>();
  logo = new Logo(width/2, height/2);
  leap = new LeapMotion(this);
  reset();
}
void reset() {
  background(0);

 // interactiveCollisions.add(new CollisionParticle(width, height, 
  //    5, 5, 80, 255,255, 255));
}
void leapOnConnect() {
  println("Leap Motion Connected");
}

void draw() {
  background(0);
  drawThreshold();
  updateHands();
  updateLogo();
  updateParticles();
}

private void updateHands() {
  for (Hand hand : leap.getHands ()) {
    //hand.draw();
    PVector handPosition = hand.getPosition();
    visualizePoint(handPosition.x, handPosition.y);

    //Detect interaction between user's hands and the logo. If user is grabbing, call handleInteraction with a true flag
    if (PVector.dist(handPosition, logo.Center) <= logo.r && hand.getGrabStrength() >= 0.5) {
      logo.handleInteraction(handPosition, true);
    }

    for (Finger finger : hand.getFingers()) {
      PVector fingerPosition = finger.getPosition();
      visualizePoint(fingerPosition.x, fingerPosition.y);

      //Get finger bones and visualize them on screen. If joint in bones touches the logo's circle, handle the collision
      bones = new Bone[]{finger.getBone(0), finger.getBone(1), finger.getBone(2), finger.getBone(3)};
      for (Bone bone : bones ) {
        PVector joint = bone.getPrevJoint();
        visualizePoint(joint.x, joint.y);
        if (PVector.dist(joint, logo.Center) < logo.r) {
          logo.handleInteraction(joint, false);
        }
      }
    }
  }
}

void leapOnSwipeGesture(SwipeGesture g, int state) {
  println("swiped");
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
   * |      Center      |
   * |                  |
   * BL----------------BR
   */

  //If lofo hits top left corner
  if (logo.TL.x < THRESHOLD && logo.TL.y < THRESHOLD) {
    addConfetti(logo.TL.x , logo.TL.y);
    logo.Center.x = logo.logo_img.width/2  + THRESHOLD;
    logo.Center.y = logo.logo_img.height/2  + THRESHOLD;
    logo.updateColor();
  }
  //If logo hits top right corner 
  else if (logo.TR.x > width - THRESHOLD && logo.TR.y < THRESHOLD) {
    addConfetti(logo.TR.x , logo.TR.y);
    logo.hitCorner();
    logo.Center.x = width - logo.logo_img.width/2  - THRESHOLD;
    logo.Center.y = logo.logo_img.height/2  + THRESHOLD;
    logo.updateColor();
  }
  //If logo hits bottom left corner 
  else if (logo.BL.x < THRESHOLD && logo.BL.y > height - THRESHOLD ) {
    addConfetti(logo.BL.x , logo.BL.y);
    logo.hitCorner();
    logo.Center.x = logo.logo_img.width/2  + THRESHOLD;
    logo.Center.y = height - logo.logo_img.height/2  - THRESHOLD;
    logo.updateColor();
  }
  //If logo hits bottom right corner 
  else if (logo.BR.x > width - THRESHOLD && logo.BR.y > height - THRESHOLD ) {
    addConfetti(logo.BR.x , logo.BR.y);
    logo.hitCorner();
    logo.Center.x = width - logo.logo_img.width/2 - THRESHOLD;
    logo.Center.y = height - logo.logo_img.height/2 - THRESHOLD;
    logo.updateColor();
  }
  //If logo hits right side of the screen
  else if (logo.TR.x >= width) {
    logo.Velocity.x = -logo.Velocity.x;
    logo.Center.x = width - logo.logo_img.width/2;
    logo.updateColor();

    //If logo hits left side of the screen
  } else if (logo.TL.x <= 0) {
    logo.Velocity.x = -logo.Velocity.x;
    logo.Center.x = logo.logo_img.width/2;
    logo.updateColor();

    //If logo hits bottom side
  } else if (logo.BL.y >= height) {
    logo.Velocity.y = -logo.Velocity.y;
    logo.Center.y = height - logo.logo_img.height/2;
    logo.updateColor();

    //If logo hits top side
  } else if (logo.TL.y <= 0) {
    logo.Velocity.y = -logo.Velocity.y;
    logo.Center.y = logo.logo_img.height/2;
    logo.updateColor();
  }
}

// Emulate collision events when the logo hits the screen
void mousePressed() {
  PVector foo = new PVector(mouseX, mouseY);
  logo.handleInteraction(foo, false);
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
