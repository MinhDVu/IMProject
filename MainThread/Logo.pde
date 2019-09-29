class Logo {
  // Coordinates of the logo's corners TL = Top Left, BL = Bottom Right, etc.
  public PVector Center, TL, TR, BL, BR;
  //Logo's horizontal & vertical velocity and radius
  public float xVelocity, yVelocity, r;
  //Logo's color and images
  private color rgb;
  PImage logo_img;

  public Logo(float x, float y) {
    Center = new PVector(x, y);
    xVelocity = yVelocity = 4;
    this.rgb = color(random(256), random(256), random(256));
    logo_img = loadImage("dvd_logo.png");
    r = logo_img.width;
  }

  // Add velocity to Center and re-calculate the coordinates of the corners
  public void update() {
    Center.x += xVelocity;
    Center.y -= yVelocity;

    /** 
     * TL----------------TR
     * |                  |
     * |     xyCenter     |
     * |                  |
     * BL----------------BR
     */

    //Update logo's left corner location
    TL = new PVector(Center.x - logo_img.width/2, Center.y - logo_img.height/2);

    //Update top right corner of the logo
    TR = new PVector(Center.x + logo_img.width/2, Center.y - logo_img.height/2);

    //Update bottom left corner
    BL = new PVector(Center.x - logo_img.width/2, Center.y + logo_img.height/2);

    //Update bottom right corner
    BR = new PVector(Center.x + logo_img.width/2, Center.y + logo_img.height/2);

    show();
  }

  //Assign a random color for the logo
  public void updateColor() {
    //rgb = color(random(256), random(256), random(256));
    rgb = colorsR2[(int)random(0, colorsR2.length)];
  }
  
  public void handleCollision(float x, float y) {
    
  }

  //Draw the tinted logo and 4 corners
  private void show() {
    tint(this.rgb);
    image(logo_img, TL.x, TL.y);
    noFill();
    stroke(0);
    ellipse(Center.x, Center.y, r, r);
    fill(255, 0, 0);
    noStroke();
    ellipse(TL.x, TL.y, 10, 10);
    ellipse(TR.x, TR.y, 10, 10);
    ellipse(BL.x, BL.y, 10, 10);
    ellipse(BR.x, BR.y, 10, 10);
    ellipse(Center.x, Center.y, 10, 10);
  }
}
