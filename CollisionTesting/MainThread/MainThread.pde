import de.voidplus.leapmotion.*;
// comment
static ArrayList<Particle> confetti;
static  Logo logo;
static ArrayList <Burst> firework;
LeapMotion leap;
Bone[] bones;

public final int THRESHOLD = 10;

void setup() {
  size(800, 600);
  //fullScreen();
  //frameRate(5);
  confetti = new ArrayList<Particle>();
  logo = new Logo(width/2, height/2,5,5,80);
  leap = new LeapMotion(this);
  firework = new ArrayList();
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
  updateParticlesFire();
}

private void updateHands() {
  for (Hand hand : leap.getHands ()) {
    hand.draw();
    PVector handPosition = hand.getPosition();
    visualizePoint(handPosition.x, handPosition.y);

    for (Finger finger : hand.getFingers()) {
      PVector fingerPosition = finger.getPosition();
      visualizePoint(fingerPosition.x, fingerPosition.y );
      //Default draw method with 3px in radius for each joints, can't be used for our purpose but good to have during dev process
      //finger.draw();

      bones = new Bone[]{finger.getBone(0), finger.getBone(1), finger.getBone(2), finger.getBone(3)};

      for (Bone bone : bones ) {
        PVector joint = bone.getPrevJoint();
        //TODO: Logo collision detection here
        visualizePoint(joint.x, joint.y);
        logo.updateCollision( handPosition.x, handPosition.y);
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
private void updateParticlesFire() 
{
  for (int i = firework.size() - 1; i >= 0; i--) {
    Burst b = (Burst)firework.get(i);
    if (b.update()) firework.remove(i);
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
  // Logo chanegs color when it hit the screen edges
  if (logo.x1 >= width-1 || logo.x1 <= 0){
    logo.updateColor();
  }
  if (logo.y1 >= height-1 || logo.y1 <= 0){
    logo.updateColor();
  }
  
  
  // Fireworks and particles appear when the logo hit the corner of the screen
  if (logo.x1 < THRESHOLD && logo.y1 < THRESHOLD)
  {
    addConfetti(logo.x1 , logo.y1);
    firework.add(new Burst(logo.x1, logo.y1, int(random(50, 100))));
  }
   else if (logo.x1 > width - THRESHOLD && logo.y1 < THRESHOLD) {
     addConfetti(logo.x1 , logo.y1);
     firework.add(new Burst(logo.x1, logo.y1, int(random(50, 100))));
   }
   else if (logo.x1 < THRESHOLD && logo.y1 > height - THRESHOLD ){
      addConfetti(logo.x1 , logo.y1);
      firework.add(new Burst(logo.x1, logo.y1, int(random(50, 100))));
    }
   else if (logo.x1 > width - THRESHOLD && logo.y1 > height - THRESHOLD ){
     addConfetti(logo.x1 , logo.y1);
     firework.add(new Burst(logo.x1, logo.y1, int(random(50, 100))));
   }
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
