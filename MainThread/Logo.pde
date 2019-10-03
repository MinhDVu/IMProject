class Logo {
  // Coordinates of the logo's corners TL = Top Left, BL = Bottom Right, etc.
  public float XTL, YTL, XTR, YTR, XBL, YBL, XBR, YBR;
  //Logo's xy velocity
  public float xVelocity, yVelocity;
  //Reserved var for LeapMotion Integration
  public float xCenter, yCenter, r;
  //Logo's color and images
  private color rgb;
  PImage logo_img;

  public Logo(float XTL, float YTL, float XTR, float YTR) {
    this.XTL = XTL;
    this.YTL = YTL;
    this.XTR = XTR;
    this.YTR = YTR;
    xVelocity = yVelocity = 10 ;
    this.rgb = color(random(256), random(256), random(256));
    logo_img = loadImage("dvd_logo.png");
    r = logo_img.width;
  }
  void edge_check() {
    //If a wall is hit, invert velocities
    if (XTL >= width-1 || XTL <= 0) XTR = -XTR; 
    if (YTL >= height-1 || YTL <= 0) YTR = -YTR;
  }

  // Add velocity to xy, refer to MainThread>draw() method
  public void update() {

    /** 
     * TL----------------TR
     * |                  |
     * |     xyCenter     |
     * |                  |
     * BL----------------BR
     */
    collisionUpdate((int)XTL, (int)YTL );
    collisionUpdate(mouseX, mouseY );
    if (XTR >= width || XTL <= 0 || YBL >= height ||logo.YTL <= 0){
      edge_check();
    }

XTL += xVelocity;
YTL += yVelocity;
//Update logo's center location
xCenter = XTL + logo_img.width/2;
yCenter = YTL + logo_img.height/2;

//Update top right corner of the logo
XTR = XTL + logo_img.width;
YTR = YTL;

//Update bottom left corner
XBL = XTL;
YBL = YTL + logo_img.height;

//Update bottom right corner
XBR = XTL + logo_img.width;
YBR = YTL + logo_img.height;

show();
}


void collisionUpdate(float x_val, float y_val)
{  

  float dist = XBL;
  if (dist >= abs(XTL - x_val) && dist >= abs(YTL - y_val)) {
    float dx = XTL - x_val;
    float dy = YTL - y_val;
    float theta = atan2(dy, dx);
    float endX = XTL + cos(theta)*XBL;
    float endY = YTL + sin(theta)*XBL;
    xVelocity = (endX - x_val)/(XBL);
    yVelocity = (endY - y_val)/(XBL);
  }
  if (XTR > 0) {
    if (XTL >= width-1) {
      if (XTR > 0) {
        XTR = -XTR;
      }
    }
    if (XTL <=0) {
      if (XTR < 0) {
        XTR = XTR;
      }
    }
  } else {
    if (XTL >= width- 1) {
      if (XTR > 0) {
        XTR = XTR;
      }
    }
    if (XTL <=0) {
      if (XTR < 0) {
        XTR = -XTR;
      }
    }
  }
  if (YTR > 0) {
    if (YTL >= height -1) {
      if (YTR > 0) {
        YTR = -YTR;
        YTL = height - 1;
      }
    }
    if (YTL <=0) {
      if (YTR < 0) {
        YTR = YTR;
      }
    }
  } else {
    if (YTL >= height -1) {
      if (YTR > 0) {
        YTR = YTR;
        YTL = height - 1;
      }
    }
  }
  if (YTL <=0) {
    if (YTR < 0) {
      YTR = -YTR;
    }
  }
}




//Assign a random color for the logo
public void updateColor() {
  //rgb = color(random(256), random(256), random(256));
  rgb = colorsR2[(int)random(0, colorsR2.length)];
}


//Draw the tinted logo and 4 corners
private void show() {
  tint(this.rgb);
  image(logo_img, XTL, YTL);
  //noFill();
  //ellipse(xCenter, yCenter, r, r);
  //fill(255, 0, 0);
  //noStroke();
  //ellipse(XTL, YTL, 10, 10);
  //ellipse(XTR, YTR, 10, 10);
  //ellipse(XBL, YBL, 10, 10);
  //ellipse(XBR, YBR, 10, 10);
  //ellipse(xCenter, yCenter, 10, 10);
}

}
