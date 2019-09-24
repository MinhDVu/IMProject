import processing.video.*;
float threshold = 50;
Capture video;
// Previous Frame
PImage prevFrame;
//lists of objects

ArrayList<CollisionParticle> interactiveCollisions = new ArrayList<CollisionParticle>();
//constants
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
  drawAndUpdate();
}
void mousePressed() {
  float xDist = 160;
  float yDist = 40;
  if (homescreen == true) {

    if (abs(mouseX - 320) <= xDist && abs(mouseY - 330) <= yDist) {
      homescreen = false;
      interactiveCollision = true;
    }
  }
  //non home screen
  if (homescreen == false) {
    xDist = 60;
    yDist = 20;
    if (abs(mouseX - 120) <= xDist && abs(mouseY - 40) <= yDist) {

      interactiveCollision = false;
      homescreen = true;
    }
  }
}
void drawAndUpdate() {
  // homescreen
  if (homescreen == true) {
    background(255);


    fill(#5D92DB);
    rect(348, 300, 500, 120, 40);
    fill(0);
    textSize(63);
    text("Assignment 4", 390, 380);

    // sub rects
    float xDist = 160;
    float yDist = 40;
    // interactive collision button
    if (abs(mouseX - 320) <= xDist && abs(mouseY - 330) <= yDist) {
      fill(#48B788);
      rect(440, 570, 320, 80, 40);
      fill(255);
      textSize(56);
      text("Start", 470, 630);
    } else {
      fill(#95EAC0);
      rect(440, 570, 320, 80, 40);
      fill(255);
      textSize(56);
      text("Collisions", 470, 630);
    }
  }

  // update
  if (homescreen == false) {
    backButton();
    if (interactiveCollision == true) {
      //image(video, 0, 0);// show video

      collide();
      for (int i = 0; i < interactiveCollisions.size(); i ++) {
        interactiveCollisions.get(i).update();
        interactiveCollisions.get(i).display();
      }
    }
  }
}
void backButton() {
  float xDist = 60;
  float yDist = 20;
  if (abs(mouseX - 120) <= xDist && abs(mouseY - 40) <= yDist) {
    background(0);
    fill(100); 
    rect(75, 20, 120, 40, 10);
    fill(200);
    textSize(38);
    text("back", 95, 52);
  } else {
    background(0);
    fill(50);
    rect(75, 20, 120, 40, 10);
    fill(100);
    textSize(38);
    text("back", 95, 52);
  }
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
