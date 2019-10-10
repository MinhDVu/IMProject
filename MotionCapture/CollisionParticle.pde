//PImage dvd;
class CollisionParticle {
  float x;
  float y;
  float vx;
  float vy;
  float size;
  float r;
  float g;
  float b;

  CollisionParticle(float x, float y, float vx, float vy, float size, float r, float g, float b) {
    this.x = x; 
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.size = size;
    this.r = r;
    this.g = g;
    this.b = b;
  }

  void update() {
  updateCollision(mouseX, mouseY);
  //dvd = loadImage("dvd_logo");
    // Draw a circle based on average motion
  }
  void edge_check(){
    //If a wall is hit, invert velocities
    if(x >= width-1 || x <= 0) vx = -vx; 
    if(y >= height-1 || y <= 0) vy = -vy;
  }

  void updateCollision( float x_val, float y_val)
  {
    int flag = 0;
    float dist = size;
    if (dist >= abs(x - x_val) && dist >= abs(y - y_val)) {
       
      print("touched ");
   
      float dx = x - x_val;
      float dy = y - y_val;
      float theta = atan2(dy, dx);
      float endX = x + cos(theta)*size;
      float endY = y + sin(theta)*size;
      vx = (endX - x_val)/(size*0.6);
      vy = (endY - y_val)/(size*0.8);
    }
    else {
      x += vx;
      y += vy;
    }

    if (vx > 0) {
      if (x >= width - size/2) {
        if (vx > 0) {
          vx = vx * -1;
        }
      }
      if (x <=0) {
        if (vx < width - size*2 ) {
          vx = +vx;
        }
      }
    } else {
      if (x >= width - size/2) {
        if (vx > 0) {
          vx = +vx;
        }
      }
      if (x <=0) {
        if (vx < 0) {
          vx = vx * -1;
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
      if (y <=0) {
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
    if (y <=0) {
      if (vy < 0) {
        vy = -vy;
      }
    }
   
    x += vx;
    y += vy;
    //if ( y == height )
    //vy = vy +4;
    //if ( x == width )
    //vx = vx +4;
  }
  void display() {
    stroke(r, g, b);
    fill(r, g, b);
    rect(x, y, size+20, size );
    //image(dvd,x,y);
    //ellipse(x, y, size, size);
  }
}
