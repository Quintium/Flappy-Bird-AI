class Pipe {
  int x;
  int y;
  
  boolean done = false;
  
  int gap = (int)(random(50)) + 150;
  
  PImage myImage1;
  PImage myImage2;
  
  Hitbox hitbox1;
  Hitbox hitbox2;
  
  Pipe(int x_, PImage image1, PImage image2) {
    x = x_;
    y = (int)(50 + random(450 - gap));
    
    hitbox1 = new Hitbox(x, -1000, 95, 1000 + y);
    hitbox2 = new Hitbox(x, y + gap, 95, 650 - (y + gap));
    
    myImage1 = image1;
    myImage2 = image2;
  }
  
  void draw(int birdX) {
    // draw two pipes in comparison to bird
    image(myImage1, x + 172 - birdX, y - 400);
    image(myImage2, x + 172 - birdX, y + gap);
  }
  
  int addScore(int birdX) {
    // returns change in score
    if (!done) {
      if (birdX > x) {
        done = true;
        return 1;
      }
    }
    return 0;
  }
}
