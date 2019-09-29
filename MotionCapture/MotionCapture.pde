float threshold = 50;

//lists of objects
ArrayList<CollisionParticle> interactiveCollisions = new ArrayList<CollisionParticle>();
//constants

float g = 0.015;
float dt = 0;

void setup() {
  size(640, 480);
  reset();
}

void reset() {
  background(0);

  interactiveCollisions.add(new CollisionParticle(width, height, 
      5, 5, 80, 255,255, 255));
}
void draw() {
  background(0);
  drawAndUpdate();
}

void drawAndUpdate() {
  for (int i = 0; i < interactiveCollisions.size(); i ++) {
    interactiveCollisions.get(i).update();
    interactiveCollisions.get(i).display();
  }
}
