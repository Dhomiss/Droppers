import processing.sound.*;

  TGFramework game;
  
void settings() {
  size(800, 600, P2D);
}

void setup()
{
  noSmooth();
  noCursor();
  frameRate(60);
  game = new TGFramework();
}

void draw()
{
  game.draw();
}
