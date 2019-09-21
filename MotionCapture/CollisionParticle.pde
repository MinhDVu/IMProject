class CollisionParticle {
  float x;
  float y;
  float vx;
  float vy;
  float size;
  float r;
  float g;
  float b;

  CollisionParticle(float ix, float iy, float ivx, float ivy, float isize, float ir, float ig, float ib) {
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
    loadPixels();
    video.loadPixels();// comment this line to turn off the background
    //backButton();
    prevFrame.loadPixels();

    // These are the variables we'll need to find the average X and Y
    float sumX = 0;
    float sumY = 0;
    int motionCount = 0; 

    // Begin loop to walk through every pixel
    for (int x1 = 0; x1 < video.width; x1++ ) {
      for (int y1 = 0; y1 < video.height; y1++ ) {
        // What is the current color
        color current = video.pixels[x1+y1*video.width];

        // What is the previous color
        color previous = prevFrame.pixels[x1+y1*video.width];

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
          sumX += x1;
          sumY += y1;
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
