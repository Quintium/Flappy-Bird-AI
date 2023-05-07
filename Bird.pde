class Bird {
  int x = 0;
  float y = 310;
  float vy = 0;
  float angle = 0;
  
  float startY = 0;
  
  PImage myImage;
  
  Bird(PImage image_) {
    myImage = image_;
  }
  
  void move() {
    // do the physics
    
    if (vy < 11) {
      vy += 0.7;
    }
    y += vy;
    
    x += 3;
    
    // turn if falling
    if (vy > 7 && angle < PI / 2) {
      angle += 0.08; 
    }
    if (angle > PI / 2) {
      angle = PI / 2; 
    }
  }
    
  boolean checkDeath() {
    if (y < -20) {
      return true;
    } else {
      return false;
    }
  }
   
  void jump() {
    vy = -11;
    angle = -0.3;
  }
  
  void draw() {
    // draw bird at angle
    translate(175 + 30, y + 21);
    rotate(angle);
    
    image(myImage, -30, -21);
    
    rotate(-angle);
    translate(-175 - 30, -y - 21);
  }
  
  boolean checkCollision(ArrayList<Pipe> pipes, Ground ground) {
    // check if bird collides with ground or pipes
    Hitbox hitbox = new Hitbox(x, (int)y, 60, 43);
    
    for (Pipe pipe : pipes) {
      if (hitbox.collide(pipe.hitbox1) || hitbox.collide(pipe.hitbox2)) {
        vy = 0;
        return true; 
      }
    }
    
    if (hitbox.collide(ground.hitbox)) {
      vy = 0;
      return true;
    }
    
    return false;
  }
}
