
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
    //this is usually the standard way to do it btw
    this.x = x; 
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.size = size;
    this.r = r;
    this.g = g;
    this.b = b;
  }

  void edge_check() {
    //If a wall is hit, invert velocities
    if (x >= width-1 || x <= 0) vx = -vx; 
    if (y >= height-1 || y <= 0) vy = -vy;
  }

  void collision_update(int x_val, int y_val) {
    float dist = size;
    if (dist >= abs(x - x_val) && dist >= abs(y - y_val)) {
      float dx = x - x_val;
      float dy = y - y_val;
      float theta = atan2(dy, dx);
      float endX = x + cos(theta)*size;
      float endY = y + sin(theta)*size;
      vx = (endX - x_val)/(size);
      vy = (endY - y_val)/(size);
    }
  }

  void update() {
    //loadPixels(); Dont think you need these
    video.loadPixels();// comment this line to turn off the background
    //prevFrame.loadPixels();

    //image(video,0,0);

    // These are the variables we'll need to find the average X and Y
    float sumX = 0;
    float sumY = 0;
    int motionCount = 0; 
    float colour_threshold = 10;  //How sensative camera is to movement, larger number means less sensative
    int speed_vs_acurracy_index = 8;  //A larger number means fewer processing units. as this number of pixels is skipped per loop. 
    //For safty i would probably loop horizontally first as there are more pixels horizontally, meaning a less chance to skip a movement.

    //Begin loop to walk through every pixel

    //So slow because this is inefficient

    for (int x1 = 0; x1 < video.width; x1+=speed_vs_acurracy_index) {
      for (int y1 = 0; y1 < video.height; y1+=speed_vs_acurracy_index) {
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

        float d_r = abs(r2-r1);
        float d_g = abs(g2-g1);
        float d_b = abs(b2-b1);

        //Ensure there is an appropriate difference between points so every little thing dosnt get selected
        if ((d_r + d_g + d_b) < colour_threshold) {
          break;
        }

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
    //multiply by the ratio so a smaller video can be used on alarger screen. e.g. 720p screen is using 240p camera
    float avgX = (video.width-(sumX / motionCount))*ratio_width; //also minus the width so a left in real life, is a left on the screen.
    float avgY = (sumY / motionCount)*ratio_height; 

    // Draw a circle based on average motion
    smooth();
    noStroke();
    fill(150);
    ellipse(avgX, avgY, 16, 16);

    //Checks the collisoin between either mouse or camera movement
    collision_update(mouseX, mouseY);
    collision_update((int)avgX, (int)avgY);

    //If it has a velocity check if has hit an edge, this jsut reduces processing time as no point checking stationary objects
    if (abs(vx) > 0 || abs(vy) > 0) {
      edge_check();
    }

    //Update position with respect to velocity
    x += vx;
    y += vy;
  }


  void display() {
    stroke(r, g, b);
    fill(r, g, b);
    ellipse(x, y, size, size);
  }
}
