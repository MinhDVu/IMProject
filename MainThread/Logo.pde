class Logo {

  public float XTL, YTL, XTR, YTR, XBL, YBL, XBR, YBR;
  public float xVelocity, yVelocity;
  public float xCenter, yCenter;
  private color rgb;
  PImage logo_img;

  public Logo(float x, float y) {
    this.XTL = x;
    this.YTL = y;
    xVelocity = yVelocity = random(1, 5);
    this.rgb = color(random(256), random(256), random(256));
    logo_img = loadImage("dvd_logo.png");
  }

  public void reverseDirection() {
    logo.xVelocity = -logo.xVelocity;
    //logo.yVelocity = -logo.yVelocity;
  }

  public void update() {
    XTL += xVelocity;
    YTL -= yVelocity;

    /** 
     * TL----------------TR
     * |                  |
     * |     xyCenter     |
     * |                  |
     * BL----------------BR
     */

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

  public void updateColor() {
    //rgb = color(random(256), random(256), random(256));
    rgb = colorsR2[(int)random(0, colorsR2.length)];
  }

  private void show() {
    tint(this.rgb);
    image(logo_img, XTL, YTL);
    fill(this.rgb);
    noStroke();
    ellipse(XTL, YTL, 10, 10);
    ellipse(XTR, YTR, 10, 10);
    ellipse(XBL, YBL, 10, 10);
    ellipse(XBR, YBR, 10, 10);
  }
}
