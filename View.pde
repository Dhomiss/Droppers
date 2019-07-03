abstract class View extends Drawable
{
  protected boolean hovered;
  protected boolean focus;
  protected ArrayList<Drawable> drawables;
  protected ArrayList<ButtonView> buttons;
  protected color bgColor;
  protected Runnable hoverEnterBehavior;
  protected Runnable hoverExitBehavior;
  protected Runnable clickBehavior;
  protected Runnable tickBehavior;
  
  View()
  {
    super();
    this.drawables = new ArrayList<Drawable>();
    this.buttons = new ArrayList<ButtonView>();
    this.bgColor = color(0);
    this.hoverEnterBehavior = new Runnable(){ public void run(){} };
    this.hoverExitBehavior = this.hoverEnterBehavior;
    this.clickBehavior = this.hoverEnterBehavior;
    this.tickBehavior = this.hoverEnterBehavior;
  }
  
  View(float x, float y)
  {
    this();
    this.setPos(x, y);
  }
  
  View(float x, float y, int w, int h)
  {
    this(x, y);
    this.setSize(w, h);
  }
  
  View(View copy)
  {
    super(copy);
    this.hovered = copy.hovered;
    this.focus = copy.focus;
    this.drawables = copy.drawables;
    this.buttons = copy.buttons;
    this.bgColor = copy.bgColor;
    this.hoverEnterBehavior = copy.hoverEnterBehavior;
    this.hoverExitBehavior = copy.hoverExitBehavior;
    this.clickBehavior = copy.clickBehavior;
    this.tickBehavior = copy.tickBehavior;
  }
  
  public View setBgColor(color c)
  {
    this.bgColor = c;
    return this;
  }
  
  public void addDrawables(Drawable... drawables)
  {
    for (Drawable d : drawables) this.drawables.add(d);
  }
  
  protected void tick()
  {
    super.tick();
    for (Drawable d : this.drawables)
    {
      if (!(focusedView instanceof TextInputView))
        d.control();
      
      if (d instanceof View)
        d.update();
      else
        d.tick();
    }
    this.tickBehavior.run();
  }
  
  protected void drawGraphics() //need an initialize graphics function probably, ya idiot
  {
    this.gfx.beginDraw();
    this.gfx.background(this.bgColor);
    for (Drawable d : this.drawables)
    {
      if (d.visible)
      {
        this.gfx.pushMatrix();
        this.gfx.translate(d.pos.x, d.pos.y);
        this.gfx.rotate(d.rot);
        this.gfx.image(d.gfx, -d.offset.x, -d.offset.y);
        this.gfx.popMatrix();
      }
    }
    this.gfx.endDraw();
  }
  
  protected View findHoveredView(float parentXPos, float parentYPos) //needs rethinking...
  {
    View viewMousedOver = null;
    
    for (Drawable d : this.drawables)
    {
      if (d instanceof View)
      {
        View v = (View) d;
        float nextXPos = parentXPos + v.pos.x;
        float nextYPos = parentYPos + v.pos.y;
        boolean mouseOverNext = (mouseX > nextXPos - v.offset.x && mouseX < nextXPos - v.offset.x + v.gfx.width &&
          mouseY > nextYPos - v.offset.y && mouseY < nextYPos - v.offset.y + v.gfx.height);
        if (mouseOverNext)
          viewMousedOver = v;
      }
    }
    if (viewMousedOver == null)
      return this;
    else
      return viewMousedOver.findHoveredView(viewMousedOver.pos.x, viewMousedOver.pos.y);
  }
  
  protected void clickHoveredView()
  {
    if (hoveredView == this)
    {
      this.focusEnter();
    }
    else
    {
      this.focusExit();
    }
    
    for (Drawable d : this.drawables)
    {
      if (d instanceof View)
      {
        View v = (View) d;
        v.clickHoveredView();
      }
    }
  }
  
  protected void hoverEnter()
  {
    hoveredView = this;
    this.hovered = true;
    this.hoverEnterBehavior.run();
  }
  
  protected void hoverExit()
  {
    this.hovered = false;
    this.hoverExitBehavior.run();
  }
  
  protected void focusEnter()
  {
    focusedView = this;
    this.focus = true;
    this.clickBehavior.run();
  }
  
  protected void focusExit()
  {
    this.focus = false;
  }
}

abstract class SceneView extends View
{
  SceneView()
  {
    super();
    this.setSize(width, height);
  }
}

class TextView extends View
{
  protected String text;
  protected color textColor;
  protected int fontSize;
  protected int padding;
  protected int border;
  protected color borderColor;
  protected int textAlign;
  protected int textWidth;
  protected int textHeight;
  protected int viewWidth;
  protected int viewHeight;
  protected float textAscent;
  
  public TextView(float x, float y)
  {
    super(x, y);
    this.text = "text";
    this.textColor = color(255);
    this.bgColor = color(0, 0);
    this.padding = 0;
    this.border = 0;
    this.textAlign = LEFT;
    this.viewWidth = 200;
    this.viewHeight = 1;
    this.fontSize = 12;
    this.borderColor = color(255, 0, 0);
    this.resetImageData();
  }
  
  public TextView(TextView copy)
  {
    super(copy);
    this.text = copy.text;
    this.textColor = copy.textColor;
    this.fontSize = copy.fontSize;
    this.padding = copy.padding;
    this.border = copy.border;
    this.textAlign = copy.textAlign;
    this.textWidth = copy.textWidth;
    this.textHeight = copy.textHeight;
    this.viewWidth = copy.viewWidth;
    this.viewHeight = copy.viewHeight;
    this.textAscent = copy.textAscent;
    this.resetImageData();
  }
  
  public TextView setText(String txt)
  {
    this.text = txt;
    this.resetImageData();
    return this;
  }
  
  public TextView setTextSize(int size)
  {
    this.fontSize = size;
    this.resetImageData();
    return this;
  }
  
  public TextView setPadding(int w)
  {
    this.padding = w;
    this.resetImageData();
    return this;
  }
  
  public TextView setBorder(int w)
  {
    this.border = w;
    this.resetImageData();
    return this;
  }
  
  public TextView setBorderColor(color c)
  {
    this.borderColor = c;
    this.resetImageData();
    return this;
  }
  
  public TextView setBgColor(color c)
  {
    this.bgColor = c;
    this.resetImageData();
    return this;
  }
  
  public TextView setViewWidth(int w)
  {
    this.viewWidth = w;
    this.resetImageData();
    return this;
  }
  
  public TextView setViewHeight(int h)
  {
    this.viewHeight = h;
    this.resetImageData();
    return this;
  }
  
  public TextView setTextAlign(int a)
  {
    this.textAlign = a;
    this.resetImageData();
    return this;
  }
  
  public TextView setTextColor(color c)
  {
    this.textColor = c;
    this.resetImageData();
    return this;
  }
  
  protected void resetImageData()
  {
    this.gfx.beginDraw();
    this.textWidth = round(this.gfx.textWidth(this.text + " "));
    this.textHeight = round(this.gfx.textAscent() + this.gfx.textDescent());
    this.textAscent = round(this.gfx.textAscent());
    this.gfx.endDraw();
    this.setSize(this.viewWidth + this.padding * 2 + this.border, this.viewHeight * this.textHeight + this.padding * 2 + this.border);
    this.drawGraphics();
  }
  
  protected void drawGraphics()
  {
    this.gfx.beginDraw();
    this.gfx.background(this.bgColor);
    this.gfx.fill(this.textColor);
    this.gfx.textSize(this.fontSize);
    this.gfx.textAlign(this.textAlign);
    this.gfx.textLeading(this.textHeight);
    this.gfx.text(this.text, this.padding + this.border, this.padding + this.border, this.viewWidth, this.viewHeight * this.textHeight);
    if (this.border > 0)
    {
      this.gfx.stroke(this.borderColor);
      this.gfx.strokeWeight(this.border);
    } else this.gfx.noStroke();
    this.gfx.noFill();
    this.gfx.rect(this.border / 2, this.border / 2, this.gfx.width - this.border, this.gfx.height - this.border);
    this.gfx.endDraw();
  }
}

class ButtonView extends TextView
{
  protected Runnable function;
  protected color hoverColor;
  protected color clickColor;
  protected color idleColor;
  
  ButtonView(float x, float y)
  {
    super(x, y);
    this.setAnchor(CENTER, CENTER);
    this.setText("button");
    this.setBorder(2);
    this.setPadding(5);
    this.setTextSize(20);
    this.setBgColor(127);
    this.setTextAlign(CENTER);
    this.setViewWidth(this.textWidth);
    this.hoverColor = color(180);
    this.clickColor = color(255);
    this.idleColor = color(127);
    this.function = new Runnable()
    {
      public void run() {
         println(this, "pressed");
      }
    };
  }
  
  public ButtonView(ButtonView copy)
  {
    super(copy);
    this.hoverColor = copy.hoverColor;
    this.clickColor = copy.clickColor;
    this.idleColor = copy.idleColor;
    this.function = copy.function;
    this.resetImageData();
  }
  
  public ButtonView setFunc(Runnable f)
  {
    this.function = f;
    return this;
  }
  
  protected void focusEnter()
  {
    super.focusEnter();
    this.function.run();
  }
  
  public ButtonView setText(String txt)
  {
    this.text = txt;
    this.resetImageData();
    this.setViewWidth(this.textWidth);
    return this;
  }
  
  public ButtonView setAnchor(int x, int y)
  {
    super.setAnchor(x, y);
    return this;
  }
  
  public void tick()
  {
    super.tick();
    this.feedback();
  }
  
  private void feedback()
  {
    if (this.hovered && mouseDown)
    {
      this.setBgColor(this.clickColor);
    }
    else if (this.hovered)
    {
      this.setBgColor(this.hoverColor);
    }
    else
    {
      this.setBgColor(this.idleColor);
    }
  }
}

class TextInputView extends TextView
{
  int maxChars;
  
  TextInputView(float x, float y)
  {
    super(x, y);
    this
      .setMaxChars(1000)
      .setText("Enter text")
      .setBorder(1)
      .setBorderColor(color(0))
      .setPadding(2)
      .setTextSize(20)
      .setBgColor(127)
      .setViewWidth(100);
  }
  
  public TextInputView(TextInputView copy)
  {
    super(copy);
    this.maxChars = copy.maxChars;
  }
  
  public TextInputView setMaxChars(int max)
  {
    this.maxChars = max;
    this.resetImageData();
    return this;
  }
  
  protected void updateContent()
  {
    if ((keyCode == 8 || keyCode == 127) && this.text.length() > 0)
    {
      this.setText(this.text.substring(0, this.text.length() - 1));
    }
    else if (keyCode >= 32 && keyCode <= 126 || keyCode == 222)
    {
      this.setText(this.text + key);
    }
    
    if (this.text.length() > this.maxChars)
    {
      this.setText(this.text.substring(0, this.maxChars));
      println(this + " attempted to exceed char limit of: " + this.maxChars);
    }
  }
  
  public String getText(){ return this.text; }
}

class DropperTitleView extends TextView
{
  private float textYPos;
  private float textYVel;
  private int startFrameCount = frameCount;
  
  DropperTitleView(float x, float y)
  {
    super(x, y);
    this.textYPos = this.gfx.height;
  }
  
  protected void tick()
  {
    super.tick();
    this.textYVel = abs(sin(1.15 + (float)(frameCount - startFrameCount) / 100)) * this.gfx.height / 50;
    this.textYPos += this.textYVel;
    this.drawGraphics();
  }
  
  protected void drawGraphics()
  {
    this.gfx.beginDraw();
    this.gfx.background(this.bgColor);
    this.gfx.textSize(this.fontSize);
    this.gfx.textAlign(this.textAlign);
    this.gfx.textLeading(this.textHeight);
    this.gfx.fill(color(0, 0, 255));
    this.gfx.text(this.text, this.padding + this.border, this.padding + this.border + (this.textYPos - (this.textYVel * 15)) % (this.gfx.height * 2) - this.gfx.height, this.viewWidth, this.viewHeight * this.textHeight);
    this.gfx.fill(color(0, 255, 0));
    this.gfx.text(this.text, this.padding + this.border, this.padding + this.border + (this.textYPos - (this.textYVel * 10)) % (this.gfx.height * 2) - this.gfx.height, this.viewWidth, this.viewHeight * this.textHeight);
    this.gfx.fill(color(255, 0, 0));
    this.gfx.text(this.text, this.padding + this.border, this.padding + this.border + (this.textYPos - (this.textYVel * 5)) % (this.gfx.height * 2) - this.gfx.height, this.viewWidth, this.viewHeight * this.textHeight);
    this.gfx.fill(this.textColor);
    this.gfx.text(this.text, this.padding + this.border, this.padding + this.border + this.textYPos % (this.gfx.height * 2) - this.gfx.height, this.viewWidth, this.viewHeight * this.textHeight);
    if (this.border > 0)
    {
      this.gfx.stroke(this.borderColor);
      this.gfx.strokeWeight(this.border);
    } else this.gfx.noStroke();
    this.gfx.noFill();
    this.gfx.rect(this.border / 2, this.border / 2, this.gfx.width - this.border, this.gfx.height - this.border);
    this.gfx.endDraw();
  }
}
