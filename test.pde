//Clay theme
color backgroundC = color(58, 56, 61);
color red = color(171, 68, 81);
color pink = color(227, 188, 190);
color clay = color(177, 92, 87);
color nude = color(232, 202, 172);
color colorsC[] = {backgroundC, clay, nude, pink, red}; 

//Peacock Theme
color backgroundP = color(58, 56, 61);
color jade = color(5, 88, 85);
color blue = color(5, 75, 181);
color purple = color(90, 16, 139);
color orange = color(225, 126, 35);
color colorsP[] = {jade, blue, orange, purple}; 

ArrayList<Bubble> bubbles;

void setup() {
  size(960, 760);
  smooth();
  bubbles = new ArrayList<Bubble>();
}

void draw() {
  background(backgroundP);
  if (bubbles.size() < 200) {
    bubbles.add(new Bubble(mouseX, mouseY));
  }



  //Handle animations for bubbles
  for (int i = 0; i < bubbles.size(); i++) {
    Bubble b = (Bubble) bubbles.get(i);
    b.grow();
    b.show();
    if (b.alpha <= 10) {
      bubbles.remove(i);
    }
  }
}

//Bubble newBubble() {
//  //Add new bubbles to the array
//  for (int i = 0; i < bubbles.size(); i++) {
//    Bubble b = bubbles.get(i);
//    float x = random(width);
//    float y = random(width);
//    float dist = dist(b.x, b.y, x, y);
//  }
//}






class Bubble {
  float x;
  float y;
  float r;
  color bubbleColor;
  int alpha = 255;

  public Bubble(float x, float y) {
    this.x = x;
    this.y = y;
    r = random(1, 5);
    bubbleColor = randomColor();
  }

  void show() {
    noStroke();
    fill(bubbleColor, alpha);
    ellipse(x, y, r*2, r*2);
  }

  void grow() {
    alpha -= 1;
    if (r < 100 && !touchEdges()) {
      r++;
    }
  }

  //Utility functions
  color randomColor() {
    return colorsP[(int)random(0, colorsP.length)];
  }

  boolean touchEdges() {
    return (x + r > width || x - r < 0 || y + r > height || y - r < 0);
  }
}

void mousePressed() {
  bubbles.add(new Bubble(mouseX, mouseY));
}
