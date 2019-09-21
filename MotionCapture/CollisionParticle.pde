class CollisionParticle {
  float x;
  float y;
  float vx;
  float vy;
  float size;
  float r;
  float g;
  float b;

  CollisionParticle(float x, float y, float vx, float vy, float size, float r, float g, float b) {
    this.x = x; 
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.size = size;
    this.r = r;
    this.g = g;
    this.b = b;
  }

  void update() {
    // These are the variables we'll need to find the average X and Y
    float sumX = 0;
    float sumY = 0;
    int motionCount = 0; 

    // average location is total location divided by the number of motion pixels.
    float avgX = sumX / motionCount; 
    float avgY = sumY / motionCount; 

    // Draw a circle based on average motion
    smooth();
    noStroke();
    fill(150);
    ellipse(avgX, avgY, 16, 16);

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
    if (dist >= abs(x - avgX) && dist >= abs(y - avgY)) {
      float dx = x - avgX;
      float dy = y - avgY;
      float theta = atan2(dy, dx);
      float endX = x + cos(theta)*size;
      float endY = y + sin(theta)*size;
      vx = (endX - avgX)/(size);
      vy = (endY - avgY)/(size);
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
