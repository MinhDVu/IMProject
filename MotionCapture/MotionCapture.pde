import de.voidplus.leapmotion.*;
float threshold = 50;
LeapMotion leap;
Bone[] bones;

//lists of objects
ArrayList<CollisionParticle> interactiveCollisions = new ArrayList<CollisionParticle>();
//constants

float g = 0.015;
float dt = 0;

void setup() {
  size(1920, 1080);
  reset();
  leap = new LeapMotion(this);
}

void reset() {
  background(0);

  interactiveCollisions.add(new CollisionParticle(width, height, 
    5, 5, 80, 255, 255, 255));
}
void draw() {
  background(0);
  drawAndUpdate();
}
private void updateHands() {
  for (Hand hand : leap.getHands ()) {
    hand.draw();
    PVector handPosition = hand.getPosition();
    visualizePoint(handPosition.x, handPosition.y);

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

      
          interactiveCollisions.get(0).updateCollision(joint.x, joint.y);
        
      }
    }
  }
}
private void visualizePoint(float x, float y) {
  fill(255, 0, 0);
  ellipse(x, y, 10, 10);
}


void drawAndUpdate() {
  for (int i = 0; i < interactiveCollisions.size(); i ++) {
    interactiveCollisions.get(i).update();
    interactiveCollisions.get(i).display();
  }
}
