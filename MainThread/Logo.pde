import java.util.*;

class Logo {
  // Coordinates of the logo's corners TL = Top Left, BL = Bottom Right, etc.
  public PVector Center, TL, TR, BL, BR;
  //Logo's horizontal & vertical velocity
  public PVector Velocity;
  // Radius of the circle around the logo
  public float r;
  //Logo's color and images
  private color rgb;
  PImage logo_img;

  public Logo(float x, float y) {
    Center = new PVector(x, y);
    //Velocity = new PVector(random(-5, 5), random(-5, 5));
    Velocity = new PVector(4, 4);
    this.rgb = color(random(256), random(256), random(256));
    logo_img = loadImage("dvd_logo.png");
    r = logo_img.width;
  }

  // Add velocity to Center and re-calculate the coordinates of the corners
  public void update() {

    //Stablizes the movement speed of the logo
    if (Velocity.x > 3) { 
      Velocity.x -= 0.1;
    } else if (Velocity.x < -3) {
      Velocity.x += 0.1;
    }
    if (Velocity.y > 3) { 
      Velocity.y-= 0.1;
    } else if (Velocity.y < -3) {
      Velocity.y += 0.1;
    }

    Center.add(Velocity);

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

  //Handle the interation between user's hand and the logo(being held and being swipped)
  public void handleInteraction(PVector collisionPoint, boolean isBeingHeld) {
    if (isBeingHeld) {
      Center = collisionPoint;
      Velocity = new PVector(0, 0);
    } else {
      /**
       List<Float> list = new LinkedList<Float>();
       list.add(PVector.dist(collisionPoint, TL));
       list.add(PVector.dist(collisionPoint, TR));
       list.add(PVector.dist(collisionPoint, BL));
       list.add(PVector.dist(collisionPoint, BR));
       float min = Collections.min(list);
       
       // Switch case for processing closest corner
       if (min == list.get(0)) {
       println("touched top left corner");
       }
       else if (min == list.get(1)) {
       println("touched top right corner");
       }
       else if (min == list.get(2)) {
       println("touched bottom left corner");
       }
       else if (min == list.get(3)) {
       println("touched bottom right corner");
       }
       */

      //Increase the logo's velocity by 3 after being hit
      if (Velocity.x > 0 && Velocity.x < 10) {
        Velocity.x += 3;
      } else if (Velocity.x > -10) {
        Velocity.x -= 3;
      }
      if (Velocity.y > 0 && Velocity.y < 10) {
        Velocity.y += 3;
      } else if (Velocity.y > -10) {
        Velocity.y -= 3;
      }

      //Constructs a squared triangle with the vector from Center to collisionPoint as the hypotenuse
      //By calculating the tan of the 2 sides, we can determine from which angle/radiant the logo was interacted with
      float a = Center.x - collisionPoint.x;
      float b = Center.y - collisionPoint.y;
      //atan2() returns from -PI to PI. Top of the circle is 0, left side is 0->PI counter-clockwise, right side is 0->-PI clockwise
      float tan = atan2(a, b);

      //If the logo was hit from the left
      if (tan > 0) {
        //Divide the half-circle into 3 parts and decide the direction of movements based on the tan radiants
        if (tan < Math.PI/3) {
          Velocity = new PVector(abs(Velocity.x), abs(Velocity.y));
        } else if (tan > Math.PI/3 && tan < Math.PI*2/3) {
          Velocity = new PVector(abs(Velocity.x), Velocity.y);
        } else {
          Velocity = new PVector(abs(Velocity.x), -abs(Velocity.y));
        }
        //If the logo was hit from the right
      } else {
        if (tan > Math.PI/3) {
          Velocity = new PVector(-abs(Velocity.x), abs(Velocity.y));
        } else if (tan < Math.PI/3 && tan > Math.PI*(-2)/3) {
          Velocity = new PVector(-abs(Velocity.x), Velocity.y);
        } else {
          Velocity = new PVector(-abs(Velocity.x), -abs(Velocity.y));
        }
      }
    }
  }
  
  public void hitCorner() {
    this.Velocity.x = -(this.Velocity.x);
    this.Velocity.y = -(this.Velocity.y);
  }

  //Draw the tinted logo and 4 corners
  private void show() {
    tint(this.rgb);
    image(logo_img, TL.x, TL.y);
    noFill();
    stroke(0);
    //ellipse(Center.x, Center.y, r, r);
    fill(255, 0, 0);
    noStroke();
    ////TODO: Remove these points
    //ellipse(TL.x, TL.y, 10, 10);
    //ellipse(TR.x, TR.y, 10, 10);
    //ellipse(BL.x, BL.y, 10, 10);
    //ellipse(BR.x, BR.y, 10, 10);
    //ellipse(Center.x, Center.y, 10, 10);
  }
}
