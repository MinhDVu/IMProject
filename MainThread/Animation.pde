class Char {
  char theChar;
  int x, y;
  Char(int tempX, int tempY) {
    x = tempX;
    y = tempY;
    getRandomChar();
  }

  void show() {
    text(theChar, logo.Center.x, logo.Center.y);
  }

  void getRandomChar() {
    int charType = round(random(1));
    if (charType == 0) {
      int rndChar = round(random(48, 90));
      theChar = char(rndChar);
    } else if (charType == 1) {
      int rndChar = round(random(12449, 12615));
      theChar = char(rndChar);
    }
  }
}


class Stream {
  public Stream()
  {}
  ArrayList<Char>chars;
  int numChar, speed;
  color sColor;
  Stream(int tempX) {
    chars = new ArrayList<Char>();
    numChar = round(random(10, 20));
    speed = round(random(10, 30));
    for (int y = 0; y < numChar * 20; y += 20) {
      chars.add(new Char(tempX, y));
    }
    sColor = color(random(255), random(255), random(255) );
  }

  void update() {
    for (int i = 0; i < chars.size(); i++) {
      float alpha = map(i, 0, chars.size()-1, 0, 255);
      fill(sColor, alpha);
      
      if (i == chars.size() -1) fill(250, 255, 250);
      chars.get(i).show();

      if (frameCount % speed == 0) {
        chars.get(i).y += 20;

        if (i == chars.size() -1) {
          chars.get(i).getRandomChar();
        } else {
          chars.get(i).theChar = chars.get(i+1).theChar;
        }
      }

      if (random(1) < 0.001) {
        chars.get(i).getRandomChar();
      }
    }
    if (chars.get(0).y > height) {
      for (int i = 0; i < chars.size(); i++) {
        chars.get(i).y = ((chars.size() - 1) - i) * -20;
      }
    }
  }
}
