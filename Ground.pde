class Ground {
  Hitbox hitbox;
  PImage myImage;
  
  Ground(PImage image_) {
    // create infinite hitbox
    hitbox = new Hitbox(-200, 580, 1000000000, 70); 
    myImage = image_;
  }
  
  void draw(int x) {
    // draw moving ground using offset and 3 images
    int offset = -(x % 391) + 391;
    
    image(myImage, offset - 391, 580);
    image(myImage, offset, 580);
    image(myImage, offset + 391, 580);
  }
}
