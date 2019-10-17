import java.util.*;

class Logo {
  public float r;
  //Logo's color and images
  private color rgb;
  PImage logo_img;
  float size;
  float x1;
  float y1;
  float vx;
  float vy;

  public Logo(float x1, float y1, float vx, float vy, float size) {
    this.rgb = color(random(256), random(256), random(256));
    logo_img = loadImage("dvd_logo.png");
    r = logo_img.width;
    this.size = size;
    this.x1 = x1; 
    this.y1 = y1;
    this.vx = vx;
    this.vy = vy;
  }

  // Add velocity to Center and re-calculate the coordinates of the corners
  public void update() {


    //** 
    // * TL----------------TR
    // * |                  |
    // * |     xyCenter     |
    // * |                  |
    // * BL----------------BR
    // */
    updateCollision((float)mouseX,(float)mouseY);
    show();
  }

   void updateCollision( float x_val, float y_val)
  {
    //int flag = 0;
    float dist = size;
    if (dist >= abs(x1 - x_val) && dist >= abs(y1 - y_val)) {
      print("touched ");   
     // flag = 1;
      float dx = x1 - x_val;
      float dy = y1 - y_val;
      float theta = atan2(dy, dx);
      float endX = x1 + cos(theta)*size;
      float endY = y1 + sin(theta)*size;
      vx = (endX - x_val)/(size*0.4);
      vy = (endY - y_val)/(size*0.5);
    } 

    if (vx > 0) {
      if (x1 >= width-1) {
        if (vx > 0) {
          vx = -vx;
        }
      }
      if (x1 <=0) {
        if (vx < 0) {
          vx = vx;
        }
      }
    } else {
      if (x1 >= width- 1) {
        if (vx > 0) {
          vx = vx;
        }
      }
      if (x1 <=0) {
        if (vx < 0) {
          vx = -vx;
        }
      }
    }
    if (vy > 0) {
      if (y1 >= height -1) {
        if (vy > 0) {
          vy = -vy;
          y1 = height - 1;
        }
      }
      if (y1 <=0) {
        if (vy < 0) {
          vy = vy;
        }
      }
    } else {
      if (y1 >= height -1) {
        if (vy > 0) {
          vy = vy;
          y1 = height - 1;
        }
      }
    }
    if (y1 <=0) {
      if (vy < 0) {
        vy = -vy;
      }
    }
    x1 += vx;
    y1 += vy;
  }
  public void hitCorner() {
    this.x1 = -(this.x1);
    this.y1 = -(this.y1);
  }

  //Draw the tinted logo and 4 corners
  private void show() {
    tint(this.rgb);
    image(logo_img, x1, y1);
    noFill();
    stroke(0);

    fill(255, 0, 0);
    noStroke();
 
  }


  //Assign a random color for the logo
  public void updateColor() {
    rgb = colorsR2[(int)random(0, colorsR2.length)];
  }
}
