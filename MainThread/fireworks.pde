class Burst{
  float gravity;
  ArrayList particles;

  Burst(float x, float y, int qty){
    particles = new ArrayList();
    gravity = 0.5; 
    color c = color(random(100, 255), random(120, 255), random(150, 255));

    for (int i = 0; i < qty; i++){       
      float vx = random(-10, 10); 
      float vy = random(0, 10); 
      if (random(1) < 0.8) 
        vy *= -1.5; 
      particles.add(new ParticleFire(x, y, vx, vy, c));
    }
  }

  boolean update(){ 
    for (int i = particles.size() - 1; i >= 0; i--){
      ParticleFire p = (ParticleFire)particles.get(i);
      p.accelerate(gravity);
      if (p.update()) particles.remove(i);
    }    
    return particles.size() == 0;
  }
}
class ParticleFire { 
  float x, y;
  float vx, vy;
  color c; 

  ParticleFire(float x, float y, float vx, float vy, color c) { 
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.c = c; 
  }

  void accelerate(float a) {
    vy += a;
  }

  boolean update() { 
    float px = x;
    float py = y;
    x += vx;
    y += vy;
    stroke(c); 
    line(px, py, x, y);
    return y > height || x < 0 || x > width;
  }
}
