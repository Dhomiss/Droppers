class SpriteMaker
{
  public PImage blankSprite(color c, int w, int h)
  {
    PImage img = new PImage(w, h);
    PGraphics gfx = createGraphics(w, h);
    gfx.beginDraw();
    gfx.background(c);
    gfx.endDraw();
    img = gfx.get();
    return img;
  }
  
  public PImage sprite(String path, int w, int h)
  {
    println("Loading image: " + path);
    PImage img = loadImage(path);
    img.resize(w, h);
    return img;
  }
}
