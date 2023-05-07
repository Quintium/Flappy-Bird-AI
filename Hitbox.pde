class Hitbox {
  int left;
  int right;
  int top;
  int bottom;
  
  Hitbox(int x, int y, int w, int h) {
    left = x;
    right = x + w;
    
    top = y;
    bottom = y + h;
  }
  
  boolean collide(Hitbox hitbox) {
    // check if two hitboxes intersect
    if (bottom < hitbox.top || hitbox.bottom < top) {
      return false;
    }
     
    if (right < hitbox.left || hitbox.right < left) {
      return false;
    }
     
    return true;
  }
}
