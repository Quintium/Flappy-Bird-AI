import java.util.ArrayList;
import java.util.Arrays;

Bird[] birds;
double[] scores;
boolean[] alive;

Ground ground;

ArrayList<Pipe> pipes;

PImage bgImage;
PImage pipeImage1;
PImage pipeImage2;
PImage birdImage;
PFont font;

int score;
int x;
int gen = 1;
boolean[] cooldown;
int population = 100;
int speed = 1;

NeuroEvolution ne = new NeuroEvolution(4, 8, 1, 2, population, 0.5, 0.1, "tanh");

void setup() {
  // load all images and fonts
  ground = new Ground(loadImage("ground.png"));
  bgImage = loadImage("background.jpg");
  pipeImage1 = loadImage("pipe1.png");
  pipeImage2 = loadImage("pipe2.png");
  birdImage = loadImage("bird.png");
  
  font = createFont("font.TTF", 50);
  
  size(500, 650, P2D);
  
  reset();
}

void reset() {
  // reset population
  birds = new Bird[population];
  scores = new double[population];
  alive = new boolean[population];
  cooldown = new boolean[population];
  
  for (int i = 0; i < population; i++) {
    birds[i] = new Bird(birdImage);
    alive[i] = true;
    cooldown[i] = true;
  }
  
  pipes = new ArrayList<Pipe>();
  score = 0;
  
  pipes.add(new Pipe(400, pipeImage1, pipeImage2));
}

void draw() {
  // execute game speed amount of times
  for (int k = 0; k < speed; k++) {
    // change speed
    if (mousePressed) {
      speed = mouseX;
      if (speed < 1) {
        speed = 1;
      }
    }
    
    // check if every bird is dead
    boolean empty = true;
    for (boolean i : alive) {
      if (i) {
        empty = false;
      }
    }
    
    if (empty) {
      ne.evolution(scores);
      reset();
      gen += 1;
    }
    
    for(int i = 0; i < population; i++) {
      if (alive[i]) {
        // move bird
        birds[i].move();
         
        // check next pipe
        Pipe next = null;
        for (Pipe pipe : pipes) {
          if (pipe.x + 100 > birds[i].x) {
            next = pipe;
            break;
          }
        }
         
        // create inputs
        double[] input = new double[4];
        input[0] = birds[i].vy / 10;
        input[1] = (next.x - birds[i].x) / 400;
        input[1] = (next.y - birds[i].y) / 650;
        input[2] = ((next.y + next.gap) - birds[i].y) / 650;
         
        // guess jump
        if (ne.nns[i].guess(input)[0] > 0) {
          if (cooldown[i]) {
            birds[i].jump();
            cooldown[i] = false;
          }
        } else {
          cooldown[i] = true;
        }
           
        // check death
        if (birds[i].checkCollision(pipes, ground)) {
          alive[i] = false;
          scores[i] = birds[i].x;
        }
         
        x = birds[i].x;
      }
    }
      
    // create new pipe if needed
    Pipe lastPipe = pipes.get(pipes.size() - 1);
      
    if (lastPipe.x - x < 100) {      
      Pipe newPipe = new Pipe(x + 400, pipeImage1, pipeImage2);
      pipes.add(newPipe);
    }
      
    // remove pipe if needed
    if (x - pipes.get(0).x > 300) {
      pipes.remove(0); 
    }
    
    // update score
    for (Pipe pipe : pipes) {
      score += pipe.addScore(x); 
    }
  }
  
  // background, pipes, ground and bird
  image(bgImage, 0, 0);
  
  for (Pipe pipe : pipes) {
      pipe.draw(x); 
  }
  
  for (int i = 0; i < population; i++) {
    if (alive[i]) {
      birds[i].draw();
    }
  }
  
  ground.draw(x);
  
  // draw text with outline
  textSize(50);
  textFont(font);
  textAlign(CENTER, CENTER);
  fill(0);
  for(int x = -1; x < 2; x++){
    text(score, 250 + x*5, 100);
    text(score, 250, 100 + x*5);
  }
  
  fill(255);
  text(score, 250, 100);
  
  text("Generation " + gen, 250, 610);
}
