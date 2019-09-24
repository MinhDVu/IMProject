class Logo {

  public float x, y, xCenter, yCenter;
  public float xVelocity, yVelocity;
  private color rgb;
  PImage logo_img;

  public Logo(float x, float y) {
    this.x = x;
    this.y = y;
    //xVelocity = random(1, 10);
    //yVelocity = random(1, 10);
    xVelocity = yVelocity = 2;
    this.rgb = color(random(256), random(256), random(256));
    logo_img = loadImage("dvd_logo.png");
  }
  
  public void update() {
    x += xVelocity;
    y -= yVelocity;

    xCenter = x + logo_img.width/2;
    yCenter = y + logo_img.height/2;

    show();
  }
  
  public void updateColor() {
    //rgb = color(random(256), random(256), random(256));
    rgb = colorsR2[(int)random(0, colorsR2.length)];
  }

  private void show() {
    tint(this.rgb);
    image(logo_img, x, y);
  }
}
