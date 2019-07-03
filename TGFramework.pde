PApplet thisApp = this;

public SceneView currentScene;
public View main_background;

PImage[] dropperSprites;
PImage[] playerSprites;

View focusedView;
View hoveredView;

boolean mouseDown = false;

final int W = 87;
//final int S = 83;
final int A = 65;
final int D = 68;
final int P = 80;

InputHandler input;
SoundHandler sound;
highScoresXMLHandler hSHandler;

ButtonView buttonTheme;

class TGFramework
{ 
  boolean showCursor;
  
  public TGFramework()
  {
    main_background = new DroppersBackground();
    
    buttonTheme = new ButtonView(0, 0);
    buttonTheme.setBorder(0);
    buttonTheme.idleColor = color(127, 127);
    buttonTheme.hoverColor = color(180, 127);
    buttonTheme.clickColor = color(255, 127);
    
    SpriteMaker sm = new SpriteMaker();
    input = new InputHandler();
    sound = new SoundHandler();
    hSHandler = new highScoresXMLHandler();
    sound.add("theme", new MusicFile(thisApp, "music.wav"));
    sound.add("strong", new MusicFile(thisApp, "music_strong.wav"));
    sound.add("menu", new MusicFile(thisApp, "music_menu.wav"));
    sound.add("explosion", new SoundFile(thisApp, "explosion.wav"));
    sound.play("theme");
    sound.play("strong");
    sound.play("menu");
    sound.muteAllMusic();
    
    dropperSprites = new PImage[]
    {
      sm.sprite("data/dropper_1.png", Dropper.WIDTH, Dropper.HEIGHT),
      sm.sprite("data/dropper_2.png", Dropper.WIDTH, Dropper.HEIGHT),
      sm.sprite("data/dropper_3.png", Dropper.WIDTH, Dropper.HEIGHT),
      sm.sprite("data/dropper_4.png", Dropper.WIDTH, Dropper.HEIGHT),
      sm.sprite("data/dropper_5.png", Dropper.WIDTH, Dropper.HEIGHT),
      sm.sprite("data/dropper_6.png", Dropper.WIDTH, Dropper.HEIGHT),
      sm.sprite("data/dropper_7.png", Dropper.WIDTH, Dropper.HEIGHT)
    };
    playerSprites = new PImage[]
    {
      sm.sprite("data/player.png", Player.WIDTH, Player.HEIGHT),
      sm.sprite("data/player_scared.png", Player.WIDTH, Player.HEIGHT)
    };
    
    setScene(new MenuScreen());
    
    focusedView = currentScene;
    hoveredView = currentScene;
    
    showCursor = true;
  }
  
  public void draw()
  {
    focusedView.control();
    
    currentScene.update();
    image(currentScene.gfx, 0, 0);
    
    if (showCursor)
      this.drawCursor();
  }
  
  private void drawCursor()
  {
    fill(255);
    strokeWeight(1);
    stroke(0);
    beginShape();
    vertex(mouseX, mouseY);
    vertex(mouseX + 10, mouseY + 10);
    vertex(mouseX + 3.5, mouseY + 10);
    vertex(mouseX, mouseY + 15);
    endShape(CLOSE);
  }
}

public void setScene(SceneView scene)
{
  currentScene = scene;
  /*if (scene instanceof MenuScreen)
  {
    sound.vol("menu", 0.1);
  }
  else if (scene instanceof GameScreen)
  {
    sound.vol("theme", 1);
  }*/
}

class highScoresXMLHandler
{
  XML hsXML;
  
  public highScoresXMLHandler()
  {
    this.loadScores();
  }
  
  public void loadScores()
  {
    File hsFile = new File(dataPath("highscores.xml"));
    
    if (!hsFile.exists())
    {
      this.hsXML = new XML("hs");
      for (int i = 0; i < 10; i++)
      {
        XML newChild = hsXML.addChild("score");
        newChild.setString("name", "---");
        newChild.setInt("points", 0);
      }
      
      saveXML(hsXML, "data/highscores.xml");
      
      println("! Created new highscore file !");
    }
    else
    {
      this.hsXML = loadXML("highscores.xml");
    }
  }
  
  public XML[] getScores(){ return this.hsXML.getChildren("score"); }
  
  public void addHighscore(String name, int points)
  {
    XML newChild = this.hsXML.addChild("score");
    newChild.setString("name", name);
    newChild.setInt("points", points);
    
    XML[] scores = this.hsXML.getChildren("score");
    //int lowestScore = Integer.MAX_VALUE;
    XML scoreToDelete = this.hsXML.getChild("score");
    for (XML s : scores)
    {
      if (s.getInt("points") < scoreToDelete.getInt("points")) scoreToDelete = s;
    }
    println("Deleting " + scoreToDelete.getString("name"));
    this.hsXML.removeChild(scoreToDelete);
    
    this.saveHS();
  }
  
  public void saveHS()
  {
    saveXML(this.hsXML, "data/highscores.xml");
    println("Saved highscores...\n" + this.hsXML);
  }
}
