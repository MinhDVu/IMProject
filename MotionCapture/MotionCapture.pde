float threshold = 50;

//Instead of having array, lets just have 1 Collision Particle object
CollisionParticle logo;

float g = 0.015;
float dt = 0;

void setup() {
  size(800, 600);
  logo = new CollisionParticle(width, height, 5, 5, 80);
}

void draw() {
  background(0);
  drawAndUpdate();
}

void drawAndUpdate() {
  logo.update();
  logo.display();
}
