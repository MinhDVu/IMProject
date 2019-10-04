float threshold = 50;

//Instead of having array, lets just have 1 Collision Particle object
CollisionParticle logo;

float g = 0.015;
float dt = 0;
//screens
boolean homescreen = true;
boolean interactiveCollision = true;

int ratio_width,ratio_height;

void setup() {
  size(640,480);  //This is size of the window
  video = new Capture(this, 320, 240);  //when you were changing the size of the window you were also changing the resolution here
  video.start();
  
  //Used to convert the video equivelent to screen size
  ratio_width = this.width/video.width;
  ratio_height = this.height/video.height;    

  // Create an empty image the same size as the video
  prevFrame = createImage(video.width, video.height, RGB);
  reset();
}
void captureEvent(Capture video) {
  // Save previous frame for motion detection!!
  prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0,video.width, video.height);
  prevFrame.updatePixels();  
  video.read();
}
void reset() {
  background(0);

  for (int i = 0; i < 50; i ++) {
    interactiveCollisions.add(new CollisionParticle(random(0, width), random(0, height), 
      random(-5, 5), random(-5, 5), random(10, 80), random(0, 255), random(0, 255), random(0, 255)));
  }
}
void draw() {
  background(0);
  drawAndUpdate();
}

void drawAndUpdate() {
  logo.update();
  logo.display();
}

void collide() {
  if (interactiveCollision == true) {  //If user can interact
    if (interactiveCollisions.size() > 1) {  //If multiple balls
      for (int i = 0; i < interactiveCollisions.size() - 1; i ++) {
        for (int j = i + 1; j < interactiveCollisions.size(); j ++) {   //loop through every combination
        
          //Check if the balls are near each other
          float dx = interactiveCollisions.get(i).x - interactiveCollisions.get(j).x;
          float dy = interactiveCollisions.get(i).y - interactiveCollisions.get(j).y;
          float distance = abs(sqrt(pow(dx,2) + pow(dy,2)));
          float bump = interactiveCollisions.get(i).size/2 + interactiveCollisions.get(j).size/2;  //Distance to the radius of the balls
          if (distance <= bump) {  //if within the radius
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
