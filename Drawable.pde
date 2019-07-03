import java.awt.Dimension;

abstract class Drawable
{
  protected static final int WIDTH = 16;
  protected static final int HEIGHT = 16;
  protected static final float ROTATION = 0;
  
  protected int w;
  protected int h;
  protected PVector pos;
  protected PVector offset;
  protected float rot;
  protected PGraphics gfx;
  protected boolean visible;
  
  public Drawable()
  {
    this.w = WIDTH;
    this.h = HEIGHT;
    this.pos = new PVector();
    this.offset = new PVector();
    this.rot = ROTATION;
    this.gfx = createGraphics(this.w, this.h);
    this.visible = true;
  }
  
  public Drawable(float x, float y)
  {
    this();
    this.pos = new PVector(x, y);
  }
  
  public Drawable(Drawable copy)
  {
    this.w = copy.w;
    this.h = copy.h;
    this.pos = copy.pos;
    this.offset = new PVector(copy.offset.x, copy.offset.y);
    this.rot = copy.rot;
    this.gfx = copy.gfx;
    this.visible = copy.visible;
  }
  
  final public void update()
  {
    this.tick();
    this.drawGraphics();
  }
  
  //private final void tick(){}
  protected void tick(){}
  
  protected void drawGraphics()
  {
    this.gfx.beginDraw();
    this.gfx.background(255);
    this.gfx.endDraw();
  }
  
  protected void control(){}
  
  public void setSize(int w, int h) { this.gfx = createGraphics(w, h); }
  public void setPos(PVector pos) { this.pos = pos; }
  public Drawable setPos(float x, float y) { this.pos = new PVector(x, y); return this;}
  public void setRot(float r) { this.rot = r; }
  public void setVisibility(boolean v) {this.visible = v; }
  public void toggleVisibility() {this.visible = !this.visible; }
  
  public Drawable setAnchor(int x)
  {
    switch(x)
    {
      case LEFT:
        this.offset.x = 0;
        break;
      case CENTER:
        this.offset.x = this.gfx.width / 2;
        break;
      case RIGHT:
        this.offset.x = this.gfx.width;
        break;
      default:
        this.offset.x = 0;
        break;
    }
    
    return this;
  }
  
  public Drawable setAnchor(int x, int y)
  {
    this.setAnchor(x);
    
    switch(y)
    {
      case TOP:
        this.offset.y = 0;
        break;
      case CENTER:
        this.offset.y = this.gfx.height / 2;
        break;
      case BOTTOM:
        this.offset.y = this.gfx.height;
        break;
      default:
        this.offset.y = 0;
        break;
    }
    
    return this;
  }
}
