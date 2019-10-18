import de.voidplus.leapmotion.*;
import beads.*;
import org.jaudiolibs.beads.*;
import java.math.RoundingMode;
// comment
static ArrayList<Particle> confetti;
static  Logo logo;
static ArrayList <Burst> firework;
LeapMotion leap;
Bone[] bones;

/*SOUND ELEMENT*/
StopWatchTimer sw = new StopWatchTimer();
AudioContext ac;
Gain g;
Envelope rate;
SamplePlayer hit;
SamplePlayer corner;
Glide freqSlider;
float pace = 1.2;

/*SOUND MACROS*/
static float MIN_INTERVAL = 10;
static float MAX_INTERVAL = 300;
static float MIN_PACE = 0.7;
static float MAX_PACE = 1.8;


public final int THRESHOLD = 10;

void setup() {
  size(800, 600);
  //fullScreen();
  //frameRate(5);
  confetti = new ArrayList<Particle>();
  firework = new ArrayList<Burst>();
  logo = new Logo(width/2, height/2);
  leap = new LeapMotion(this);
  sw.start();
}

void leapOnConnect() {
  println("Leap Motion Connected");
}

void draw() { 
  background(0);
  drawThreshold();
  updateHands();
  updateLogo();
  updateConfetti();
  updateFirework();
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

private void updateConfetti() {
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

private void updateFirework() 
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

  //If lofo hits top left corner
  if (logo.TL.x < THRESHOLD && logo.TL.y < THRESHOLD) {
    playCorner(); //play sound effect
    addConfetti(logo.TL.x , logo.TL.y);
    firework.add(new Burst(logo.TL.x, logo.TL.y, int(random(50, 100))));
    logo.hitCorner();
    logo.Center.x = logo.logo_img.width/2  + THRESHOLD;
    logo.Center.y = logo.logo_img.height/2  + THRESHOLD;
    logo.updateColor();
  }
  //If logo hits top right corner 
  else if (logo.TR.x > width - THRESHOLD && logo.TR.y < THRESHOLD) {
    playCorner();  //play sound effect
    addConfetti(logo.TR.x , logo.TR.y);
    firework.add(new Burst(logo.TR.x, logo.TR.y, int(random(50, 100))));
    logo.hitCorner();
    logo.Center.x = width - logo.logo_img.width/2  - THRESHOLD;
    logo.Center.y = logo.logo_img.height/2  + THRESHOLD;
    logo.updateColor();

  }
  //If logo hits bottom left corner 
  else if (logo.BL.x < THRESHOLD && logo.BL.y > height - THRESHOLD ) {
    playCorner();   //play sound effect
    addConfetti(logo.BL.x , logo.BL.y);
    firework.add(new Burst(logo.BL.x, logo.BL.y, int(random(50, 100))));
    logo.hitCorner();
    logo.Center.x = logo.logo_img.width/2  + THRESHOLD;
    logo.Center.y = height - logo.logo_img.height/2  - THRESHOLD;
    logo.updateColor();
  }
  //If logo hits bottom right corner 
  else if (logo.BR.x > width - THRESHOLD && logo.BR.y > height - THRESHOLD ) {
    playCorner();  //play sound effect
    addConfetti(logo.BR.x , logo.BR.y);
    firework.add(new Burst(logo.BR.x, logo.BR.y, int(random(50, 100))));
    logo.hitCorner();
    logo.Center.x = width - logo.logo_img.width/2 - THRESHOLD;
    logo.Center.y = height - logo.logo_img.height/2 - THRESHOLD;
    logo.updateColor();
  }
  //If logo hits right side of the screen
  else if (logo.TR.x >= width) {
    soundEffect(); 
    logo.Velocity.x = -logo.Velocity.x;
    logo.Center.x = width - logo.logo_img.width/2;
    logo.updateColor();

    //If logo hits left side of the screen
  } else if (logo.TL.x <= 0) {
    soundEffect();
    logo.Velocity.x = -logo.Velocity.x;
    logo.Center.x = logo.logo_img.width/2;
    logo.updateColor();

    //If logo hits bottom side
  } else if (logo.BL.y >= height) {
    soundEffect();
    logo.Velocity.y = -logo.Velocity.y;
    logo.Center.y = height - logo.logo_img.height/2;
    logo.updateColor();

    //If logo hits top side
  } else if (logo.TL.y <= 0) {
    soundEffect();
    logo.Velocity.y = -logo.Velocity.y;
    logo.Center.y = logo.logo_img.height/2;
    logo.updateColor();
  }
}

// Emulate collision events when the logo hits the screen
void mousePressed() {
  PVector foo = new PVector(mouseX, mouseY);
  // firework.add(new Burst(mouseX, mouseY, int(random(50, 100)))); 
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


/***********************************************
* SOUND RELATED FUNCTION/HELPER
***********************************************/

void soundEffect(){
  println("Hit Edge");
  float t = sw.milisecond();
  if(t > 300) t = 150;
  pace = (MAX_PACE+0.1) - map(t,MIN_INTERVAL,MAX_INTERVAL,MIN_PACE,MAX_PACE); 
  sw.stop();
  sw.start();
  playHit();
}

void playHit(){
  ac = new AudioContext();
  hit = new SamplePlayer(ac, SampleManager.sample(dataPath("hit.mp3")));
  freqSlider =new Glide(ac, 0, 1000);
  float pan = map(logo.Center.x,0,width,-1,1);
  Panner p = new Panner(ac, pan); 
  g = new Gain(ac, 1, 0.5);
  rate = new Envelope(ac, pace); 
  hit.setRate(rate);
  p.addInput(hit);
  g.addInput(p);
  ac.out.addInput(g);
  ac.start();
  
}

void playCorner(){
  ac = new AudioContext();
  corner = new SamplePlayer(ac, SampleManager.sample(dataPath("fireworks.wav")));
  freqSlider =new Glide(ac, 0, 1000);
  float pan = map(logo.Center.x,0,width,-1,1);
  Panner p = new Panner(ac, pan);
  g = new Gain(ac, 1, 0.5);
  p.addInput(corner);
  g.addInput(p);
  ac.out.addInput(g);
  ac.start();
}
