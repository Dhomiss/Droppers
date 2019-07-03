import processing.sound.*;

  TGFramework game;

void setup()
{
  size(800, 600, P2D);
  noSmooth();
  noCursor();
  frameRate(60);
  game = new TGFramework();
}

void draw()
{
  game.draw();
}
