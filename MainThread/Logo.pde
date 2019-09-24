class Logo {

  public float x, y, xCenter, yCenter;
  private float xVelocity, yVelocity;
  private color rgb;
  PImage logo_img;

  public Logo(float x, float y) {
    this.x = x;
    this.y = y;
    //xVelocity = random(1, 10);
    //yVelocity = random(1, 10);
    xVelocity = yVelocity = 2;
    this.rgb = randomColor();
    logo_img = loadImage("dvd_logo.png");
  }
  
  public void update() {
    checkCollision();

    x += xVelocity;
    y -= yVelocity;

    xCenter = x + logo_img.width/2;
    yCenter = y + logo_img.height/2;

    show();
  }

  private void checkCollision() {
    if (x + logo_img.width >= width) {
      xVelocity = -xVelocity;
      x = width - logo_img.width;
      this.rgb = randomColor();
    } else if (x <= 0) {
      xVelocity = -xVelocity;
      x = 0;
      this.rgb = randomColor();
    }
    if (y + logo_img.height > height) {
      yVelocity = -yVelocity;
      y = height - logo_img.height;
      this.rgb = randomColor();
    } else if (y <= 0) {
      yVelocity = -yVelocity;
      y = 0;
      this.rgb = randomColor();
    }
  }

  private void show() {
    tint(this.rgb);
    image(logo_img, x, y);
  }

  private color randomColor() {
    return color(random(256), random(256), random(256));
  }
}
