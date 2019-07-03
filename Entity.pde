class Entity extends Drawable
{
  protected PVector vel;
  protected float rotVel;
  public PImage sprite;
  private color tint;
  private boolean doTint;
  
  Entity(float x, float y)
  {
    super();
    this.pos = new PVector(x, y);
    this.vel = new PVector();
    this.rotVel = 0;
    this.sprite = dropperSprites[floor(random(6))];
    this.tint = color(0);
    this.doTint = false;
    this.drawGraphics();
  }
  
  Entity(Entity copy)
  {
    super(copy);
    this.vel = copy.vel;
    this.rotVel = copy.rotVel;
    this.sprite = copy.sprite;
    this.tint = copy.tint;
    this.doTint = copy.doTint;
    this.drawGraphics();
  }
  
  protected void tick()
  {
    this.pos.add(this.vel);
    this.rot += this.rotVel;
  }
  
  public void force(PVector f)
  {
    this.vel.add(f);
  }
  
  public void rotForce(float f)
  {
    this.rotVel += f;
  }
  
  public void setSprite(PImage s)
  {
    this.sprite = s;
    this.drawGraphics();
  }
  
  public void setTint(color c)
  {
    this.doTint = true;
    this.tint = c;
    this.drawGraphics();
  }
  
  public void disableTint()
  {
    this.doTint = false;
    this.drawGraphics();
  }
  
  protected void drawGraphics()
  {
    this.gfx = createGraphics(this.w, this.h);
    this.gfx.beginDraw();
    this.gfx.tint(this.tint);
    this.gfx.image(this.sprite, 0, 0);
    this.gfx.endDraw();
  }
}

class Player extends Entity
{
  public static final int WIDTH = 20;
  public static final int HEIGHT = 20;
  
  private int score = 0;
  private boolean alive = true;
  
  Player()
  {
    super(0, 0);
    this.setSprite(playerSprites[0]);
    this.w = WIDTH;
    this.h = HEIGHT;
    this.drawGraphics();
    this.setAnchor(CENTER, CENTER);
  }
  
  Player(float x, float y)
  {
    this();
    this.setPos(x, y);
  }
  
  protected void tick()
  {
    super.tick();
    this.pos.x = constrain(this.pos.x, this.w / 2, width - this.w / 2);
    this.vel.mult(0.9);
  }
  
  public void control()
  {
    if (input.isPressed(A)) this.vel.x = -4;
    if (input.isPressed(D)) this.vel.x = 4;
  }
  
  public void dodged(boolean doublePoints)
  {
    this.score += doublePoints ? 2 : 1;
  }
  
  public int getScore()
  {
    return this.score;
  }
  
  public boolean isAlive() { return this.alive; }
  
  public void die()
  {
    this.pos.y += 1000;
    this.alive = false;
  }
}

class Dropper extends Entity
{
  public static final int WIDTH = 20;
  public static final int HEIGHT = 20;
  private float rotSpeed;
  private boolean doubleSpeed;
  
  public Dropper(float score)
  {
    super(0, 0);
    this.w = WIDTH;
    this.h = HEIGHT;
    this.drawGraphics();
    float minSpeed = 1 + score / 200; //Maybe rejig this?
    float maxSpeed = 1 + minSpeed + score / 100;
    this.vel = new PVector(0, random(minSpeed, maxSpeed));
    this.setPos(random(this.w / 2, width - this.w / 2), -random(height));
    this.rotSpeed = random(-0.25, 0.25);
    this.doubleSpeed = false;
    this.rot = random(TAU);
    this.setAnchor(CENTER, CENTER);
  }
  
  public void tick()
  {
    if (this.doubleSpeed)
    {
      this.pos.add(new PVector(this.vel.x, this.vel.y).mult(2));
    }
    else
    {
      this.pos.add(this.vel);
    }
    this.rot += this.rotVel;
    this.rotVel *= 0.9;
  }
  
  public boolean hasHitFloor() { return (this.pos.y > height + this.h); }
  
  boolean hasHit(Drawable dr) { return (this.pos.dist(dr.pos) < this.w); }
}

class Flame extends Entity
{
  public static final int WIDTH = 20;
  public static final int HEIGHT = 20;
  
  private float fuel;
  private color col;
  
  Flame(PVector pos, PVector vel)
  {
    super(pos.x, pos.y);
    this.w = WIDTH;
    this.h = HEIGHT;
    this.fuel = random(0.1, 1);
    this.vel = vel;
    this.col = lerpColor(color(255, 0, 0), color(255, 255, 0), this.fuel);
    this.gfx = createGraphics(this.w, this.h);
  }
  
  protected void tick()
  {
    super.tick();
    this.vel.mult(0.95);
    this.fuel -= 0.01;
    this.col = lerpColor(color(255, 0, 0), color(255, 255, 0), this.fuel);
    
    this.gfx.beginDraw();
    this.gfx.noStroke();
    this.gfx.fill(this.col);
    this.gfx.background(color(255, 0));
    this.gfx.translate(this.w / 2, this.h / 2);
    this.gfx.rect(-this.w / 2 * this.fuel, -this.w / 2 * this.fuel, this.w * this.fuel, this.w * this.fuel);
    this.gfx.endDraw(); //shoulda made an initGraphics function, tsk tsk tsk
  }
}
