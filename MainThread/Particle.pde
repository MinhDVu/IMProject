color jade = color(5, 88, 85);
color blue = color(5, 75, 181);
color purple = color(90, 16, 139);
color orange = color(225, 126, 35);
color colorsP[] = {jade, blue, orange, purple}; 

color salmon = color(255, 154, 162);
color melon = color(255, 183, 178);
color paleOrange = color(255, 218, 193);
color gum = color(226, 240, 203);
color mint = color(181, 234, 215);
color crayola = color(199, 206, 234);
color colorsR[] = {salmon, melon, paleOrange, gum, mint, crayola};

color jasper = color(222, 65, 61);
color buster = color(222, 221, 101);
color green = color(1, 168, 14);
color seaSerpent = color(91, 201, 215);
color palaBlue = color(28, 59, 215);
color amethyst = color(142, 82, 211);
color colorsR2[] = {jasper, buster, green, seaSerpent, palaBlue, amethyst};

enum type {
  ELLIPSE, 
    SQUARE, 
    TRIANGLE
}

type[] shapes = {type.ELLIPSE, type.SQUARE, type.TRIANGLE};

class Particle {
  // Positions, radius, opacity, angle
  float x, y, r, opacity, angle;
  // How much the particle should move horizontally or vertically 
  float xVelocity, yVelocity;
  // Color & shape
  color pColor;
  type shape; 

  // Randomizes the shape, color upon creating the object
  public Particle(float x, float y) {
    this.x = x;
    this.y = y;
    r = random(5, 12);
    opacity = 255;
    pColor = randomColor();
    shape = shapes[(int)random(0, shapes.length)];
    getDirections();
  }

  // Depending on the position of the particle on screen, decide which direction to move
  // i.e: if top panel of the screen, move x randomly but y down
  private void getDirections() {
    // Left panel of the screen
    if (x < THRESHOLD) {
      // Top section
      if (y < THRESHOLD) {
        xVelocity = random(1, 5);
        yVelocity = random(1, 5);
      }
      // Middle section
      else if (y > THRESHOLD && y < height - THRESHOLD) {
        xVelocity = random(1, 5);
        yVelocity = random(-5, 5);
      }
      // Bottom Section
      else {
        xVelocity = random(1, 5);
        yVelocity = random(-5, -1);
      }
      // Middle section of the screen
    } else if (x > THRESHOLD && x < width - THRESHOLD) {
      // Top section
      if (y < THRESHOLD) {
        xVelocity = random(-5, 5);
        yVelocity = random(1, 5);
      }
      // Middle section
      else if (y > THRESHOLD && y < height - THRESHOLD) {
        xVelocity = random(-5, 5);
        yVelocity = random(-5, 5);
      }
      // Bottom section
      else {
        xVelocity = random(-5, 5);
        yVelocity = random(-5, -1);
      }
    }
    // Right panel of the screen
    else {
      // Top section
      if (y < THRESHOLD) {
        xVelocity = random(-5, -1);
        yVelocity = random(1, 5);
      }
      // Middle section
      else if (y > THRESHOLD && y < height - THRESHOLD) {
        xVelocity = random(-5, -1);
        yVelocity = random(-5, 5);
      }
      // Bottom section
      else {
        xVelocity = random(-5, -1);
        yVelocity = random(-5, -1);
      }
    }
  }

  // Add velocity values to x and y to move the object, and decrease radius and opacity
  public void update() {
    x += xVelocity;
    y += yVelocity;
    if (r > 0) {
      r-=0.1;
    }
    opacity-=2;

    // Call show() to reduce the number of functions called in the main thread
    this.show();
  }

  // Rotate and draws the shapes 
  private void show() {
    pushMatrix();
    
    translate(x, y);
    rotate(angle += 0.1);
    
    noStroke();
    fill(pColor, opacity);
    if (shape == type.ELLIPSE) {
      ellipse(0, 0, r*2, r*2);
    } else if (shape == type.SQUARE) {
      rectMode(CENTER);
      square(0, 0, r*2);
    } else if (shape == type.TRIANGLE) {
      triangle(r, r, -r/3*2, r/3*2, r/3*2, -r/3*2);
    }
    //backup just in case random() returns an outofbound object
    else {
      ellipse(x, y, r*2, r*2);
    }

    popMatrix();
  }

  private color randomColor() {
    //Themed colors
    return colorsR2[(int)random(0, colorsR2.length)];
    //Random RGB colors
    //return color(random(256), random(256), random(256));
    //Logo colors
    //return logo.rgb;
  }
}
