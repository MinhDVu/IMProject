float threshold = 50;

//lists of objects
ArrayList<CollisionParticle> interactiveCollisions = new ArrayList<CollisionParticle>();
//constants

float g = 0.015;
float dt = 0;
//screens

boolean interactiveCollision = true;

void setup() {
  size(640, 480);
  reset();
}

void reset() {
  background(0);

  for (int i = 0; i < 20; i ++) {
    interactiveCollisions.add(new CollisionParticle(random(0, width), random(0, height), 
      random(-5, 5), random(-5, 5), random(10, 80), random(0, 255), random(0, 255), random(0, 255)));
  }
}
void draw() {
  background(0);
  drawAndUpdate();
}

void drawAndUpdate() {
    if (interactiveCollision == true) {
      collide();
      for (int i = 0; i < interactiveCollisions.size(); i ++) {
        interactiveCollisions.get(i).update();
        interactiveCollisions.get(i).display();
      }
    }
}

void collide() {
  if (interactiveCollision == true) {
    if (interactiveCollisions.size() > 1) {
      for (int i = 0; i < interactiveCollisions.size() - 1; i ++) {
        for (int j = i + 1; j < interactiveCollisions.size(); j ++) { 
          float dx = interactiveCollisions.get(i).x - interactiveCollisions.get(j).x;
          float dy = interactiveCollisions.get(i).y - interactiveCollisions.get(j).y;
          float distance = abs(sqrt(dx*dx + dy*dy));
          float bump = interactiveCollisions.get(i).size/2 + interactiveCollisions.get(j).size/2;
          if (distance <= bump) {
            float theta = atan2(dy, dx);
            float endX = interactiveCollisions.get(i).x + cos(theta)*bump;
            float endY = interactiveCollisions.get(i).y + sin(theta)*bump;
            interactiveCollisions.get(i).vx = (endX - interactiveCollisions.get(j).x)/(interactiveCollisions.get(i).size);
            interactiveCollisions.get(i).vy = (endY - interactiveCollisions.get(j).y)/(interactiveCollisions.get(i).size);
            interactiveCollisions.get(j).vx = (interactiveCollisions.get(j).x - endX)/(interactiveCollisions.get(j).size);
            interactiveCollisions.get(j).vy = (interactiveCollisions.get(j).y - endY)/(interactiveCollisions.get(j).size);
          }
        }
      }
    }
  }
  if (interactiveCollision == true) {
    if (interactiveCollisions.size() > 1) {
      for (int i = 0; i < interactiveCollisions.size() - 1; i ++) {
        for (int j = i + 1; j < interactiveCollisions.size(); j ++) { 
          float dx = interactiveCollisions.get(i).x - interactiveCollisions.get(j).x;
          float dy = interactiveCollisions.get(i).y - interactiveCollisions.get(j).y;
          float distance = abs(sqrt(dx*dx + dy*dy));
          float bump = interactiveCollisions.get(i).size/2 + interactiveCollisions.get(j).size/2;
          if (distance <= bump) {
            float theta = atan2(dy, dx);
            float endX = interactiveCollisions.get(i).x + cos(theta)*bump;
            float endY = interactiveCollisions.get(i).y + sin(theta)*bump;
            interactiveCollisions.get(i).vx = (endX - interactiveCollisions.get(j).x)/(interactiveCollisions.get(i).size);
            interactiveCollisions.get(i).vy = (endY - interactiveCollisions.get(j).y)/(interactiveCollisions.get(i).size);
            interactiveCollisions.get(j).vx = (interactiveCollisions.get(j).x - endX)/(interactiveCollisions.get(j).size);
            interactiveCollisions.get(j).vy = (interactiveCollisions.get(j).y - endY)/(interactiveCollisions.get(j).size);
          }
        }
      }
    }
  }
}
