color jade = color(5, 88, 85);
color blue = color(5, 75, 181);
color purple = color(90, 16, 139);
color orange = color(225, 126, 35);
color colorsP[] = {jade, blue, orange, purple}; 

enum direction {
  LEFT, 
    RIGHT, 
    DOWN, 
    UP
}

enum type {
  ELLIPSE, 
    SQUARE, 
    TRIANGLE
}

type[] shapes = {type.ELLIPSE, type.SQUARE, type.TRIANGLE};

class Particle {
  //positions, radius, opacity
  float x, y, r, opacity;
  //how much the particle should move horizontally or vertically 
  float degreeH, degreeV;
  //whether particle is going up or down, left or right
  direction horizontalD, verticalD;
  //color & shape
  color pColor;
  type shape; 

  public Particle(float x, float y) {
    this.x = x;
    this.y = y;
    r = random(5, 10);
    degreeV = random(1, 5);
    degreeH = random(1, 5);
    getDirections();
    opacity = 255;
    pColor = randomColor();
    shape = shapes[(int)random(0, shapes.length)];
  }

  private void getDirections() {
    if (x > width/2) {
      horizontalD = direction.LEFT;
    } else {
      horizontalD = direction.RIGHT;
    }

    if (y > height/2) {
      verticalD = direction.UP;
    } else {
      verticalD = direction.DOWN;
    }
  }

  public void update() {
    if (horizontalD == direction.LEFT) {
      x-= degreeH;
    } else {
      x += degreeH;
    }

    if (verticalD == direction.UP) {
      y -= degreeV;
    } else {
      y += degreeV;
    }
    if (r > 0) {
      r-=0.1;
    }
    opacity-=3;
  }

  public void show() {
    noStroke();
    fill(pColor, opacity);
    if (shape == type.ELLIPSE) {
      ellipse(x, y, r*2, r*2);
    } else if (shape == type.SQUARE) {
      square(x, y, r*2);
    } else if (shape == type.TRIANGLE) {
      triangle(x, y, x-(r*2), y+r, x-(r*2), y-r);
    }
    //backup just in case random() returns an outofbound object
    else {
      ellipse(x, y, r*2, r*2);
    }
  }

  private color randomColor() {
    return colorsP[(int)random(0, colorsP.length)];
  }
}
