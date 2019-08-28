import processing.video.*;
float threshold = 50;
Capture video;
// Previous Frame
PImage prevFrame;
//lists of objects

ArrayList<interactiveCollisionParticles> interactiveCollisions = new ArrayList<interactiveCollisionParticles>();
//constants
float g = 0.015;
float dt = 0;
//screens
boolean homescreen = true;
boolean interactiveCollision = false;
void setup() {
  size(640, 480);
   video = new Capture(this, width, height);
  video.start();

  // Create an empty image the same size as the video
  prevFrame = createImage(video.width, video.height, RGB);
  reset();
}
void captureEvent(Capture video) {
  // Save previous frame for motion detection!!
  prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
  prevFrame.updatePixels();  
  video.read();
}
void reset() {
  background(0);

  for (int i = 0; i < 30; i ++) {
    interactiveCollisions.add(new interactiveCollisionParticles(random(0, width), random(0, height), 
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
  image(video, 0, 0);
  loadPixels();
  video.loadPixels();// comment this line to turn off the background
  //backButton();
  prevFrame.loadPixels();

  // These are the variables we'll need to find the average X and Y
  float sumX = 0;
  float sumY = 0;
  int motionCount = 0; 

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      // What is the current color
      color current = video.pixels[x+y*video.width];

      // What is the previous color
      color previous = prevFrame.pixels[x+y*video.width];

      // Step 4, compare colors (previous vs. current)
      float r1 = red(current); 
      float g1 = green(current);
      float b1 = blue(current);
      float r2 = red(previous); 
      float g2 = green(previous);
      float b2 = blue(previous);

      // Motion for an individual pixel is the difference between the previous color and current color.
      float diff = dist(r1, g1, b1, r2, g2, b2);

      // If it's a motion pixel add up the x's and the y's
      if (diff > threshold) {
        sumX += x;
        sumY += y;
        motionCount++;
      }
    }
  }

  // average location is total location divided by the number of motion pixels.
  float avgX = sumX / motionCount; 
  float avgY = sumY / motionCount; 

  // Draw a circle based on average motion
  smooth();
  noStroke();
  fill(150);
  ellipse(avgX, avgY, 16, 16);
  
  
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



class interactiveCollisionParticles {
  float x;
  float y;
  float vx;
  float vy;
  float size;
  float r;
  float g;
  float b;

  interactiveCollisionParticles(float ix, float iy, float ivx, float ivy, float isize, float ir, float ig, float ib) {
    x = ix; 
    y = iy;
    vx = ivx;
    vy = ivy;
    size = isize;
    r = ir;
    g = ig;
    b = ib;
  }

  void update() {
    float dist = size;
    if (dist >= abs(x - mouseX) && dist >= abs(y - mouseY)) {
      float dx = x - mouseX;
      float dy = y - mouseY;
      float theta = atan2(dy, dx);
      float endX = x + cos(theta)*size;
      float endY = y + sin(theta)*size;
      vx = (endX - mouseX)/(size);
      vy = (endY - mouseY)/(size);
    }
    if (vx > 0) {
      if (x >= width-1) {
        if (vx > 0) {
          vx = -vx;
        }
      }
      if (x <=0) {
        if (vx < 0) {
          vx = vx;
        }
      }
    } else {
      if (x >= width- 1) {
        if (vx > 0) {
          vx = vx;
        }
      }
      if (x <=0) {
        if (vx < 0) {
          vx = -vx;
        }
      }
    }
    if (vy > 0) {
      if (y >= height -1) {
        if (vy > 0) {
          vy = -vy;
          y = height - 1;
        }
      }
      if (y <=0) {
        if (vy < 0) {
          vy = vy;
        }
      }
    } else {
      if (y >= height -1) {
        if (vy > 0) {
          vy = vy;
          y = height - 1;
        }
      }
    }
    if (y <=0) {
      if (vy < 0) {
        vy = -vy;
      }
    }
    x += vx;
    y += vy;
  }


  void display() {
    stroke(r, g, b);
    fill(r, g, b);
    ellipse(x, y, size, size);
  }
}
