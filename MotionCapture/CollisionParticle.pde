class CollisionParticle {
  //The logo's Coordinates
  float x, y;
  //Logo's Velocity
  float vx, vy;
  //Logo's radius
  float size;
  //Logos color
  color rgb;

  CollisionParticle(float x, float y, float vx, float vy, float size) {
    this.x = x; 
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.size = size;
    this.rgb = color(random(255), random(255), random(255));
  }

  void update() {
    if (size >= abs(x - mouseX) && size >= abs(y - mouseY)) {
      float dx = x - mouseX;
      float dy = y - mouseY;
      float theta = atan2(dy, dx);
      float endX = x + cos(theta)*size;
      float endY = y + sin(theta)*size;
      vx = (endX - mouseX)/(size);
      vy = (endY - mouseY)/(size);
    }

    if (vx > 0) {
      if (x >= width - size/2) {
        if (vx > 0) {
          vx = -vx;
        }
      }
      if (x <= size/2) {
        if (vx < 0) {
          vx = vx;
        }
      }
    } else {
      if (x >= width - size/2) {
        if (vx > 0) {
          vx = vx;
        }
      }
      if (x <= size/2) {
        if (vx < 0) {
          vx = -vx;
        }
      }
    }
    if (vy > 0) {
      if (y >= height - size/2) {
        if (vy > 0) {
          vy = -vy;
          y = height - size/2;
        }
      }
      if (y <= size/2) {
        if (vy < 0) {
          vy = vy;
        }
      }
    } else {
      if (y >= height - size/2) {
        if (vy > 0) {
          vy = vy;
          y = height - size/2;
        }
      }
    }
    if (y <= size/2) {
      if (vy < 0) {
        vy = -vy;
      }
    }
    x += vx;
    y += vy;
  }


  void display() {
    noStroke();
    fill(rgb);
    ellipse(x, y, size, size);
  }
}
