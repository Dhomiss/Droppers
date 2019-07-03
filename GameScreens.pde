class MenuScreen extends SceneView
{
  View background;
  TextView title;
  ButtonView playButton;
  ButtonView highScoresButton;
  ButtonView helpButton;
  ButtonView exitButton;
  TextView helpText;
  TextView authorshipText;
  
  MenuScreen()
  {
    super();
    
    sound.muteAllMusic();
    sound.vol("menu", 1);
    
    if (game != null)
      game.showCursor = true;
    
    this.drawables.add(background = main_background);
    
    this.drawables.add(
      title = new DropperTitleView(width / 2, height / 4)
        .setTextSize(42)
        .setViewWidth(300)
        .setText("DROPPERS")
        .setTextColor(color(255, 255, 255))
        .setTextAlign(CENTER)
        .setBgColor(color(0, 200))
    );
    title.setAnchor(CENTER, CENTER);
    
    this.drawables.add(
      playButton = new ButtonView(buttonTheme)
        .setText("PLAY")
    );
    playButton.setAnchor(CENTER, CENTER);
    playButton.setPos(width / 2, height / 2);
    playButton.setFunc
    (
      new Runnable()
      {
        public void run()
        {
          setScene(new GameScreen());
        }
      }
    );
    
    this.drawables.add(
      highScoresButton = new ButtonView(buttonTheme)
        .setText("HIGHSCORES")
    );
    highScoresButton.setAnchor(CENTER, CENTER);
    highScoresButton.setPos(width / 2, height / 2 + 50);
    highScoresButton.setFunc
    (
      new Runnable()
      {
        public void run()
        {
          setScene(new HighScoresScreen());
        }
      }
    );
    
    this.drawables.add(
      helpButton = new ButtonView(buttonTheme)
        .setText("HELP")
    );
    helpButton.setAnchor(CENTER, CENTER);
    helpButton.setPos(width / 2, height / 2 + 100);
    helpButton.setFunc
    (
      new Runnable()
      {
        public void run()
        {
          helpText.toggleVisibility();
        }
      }
    );
    
    this.drawables.add(
      exitButton = new ButtonView(buttonTheme)
        .setText("EXIT")
    );
    exitButton.setAnchor(CENTER, CENTER);
    exitButton.setPos(width / 2, height / 2 + 150);
    exitButton.setFunc
    (
      new Runnable()
      {
        public void run()
        {
          exit();
        }
      }
    );
    
    this.drawables.add(
      helpText = new TextView(width / 2, height / 2 + 200)
        .setTextSize(14)
        .setViewWidth(400)
        .setViewHeight(3)
        .setPadding(3)
        .setText("Dodge the falling shapes.\nUse the 'A' and 'D' keys to move side to side.\nHold 'W' to activate double points mode!")
        .setBgColor(color(0, 127))
    );
    helpText
      .setAnchor(CENTER, TOP)
      .setVisibility(false);
      
    this.drawables.add(
      this.authorshipText = new TextView(0, height)
        .setText("Created by Thomas Williams, 2017")
        .setViewWidth(250)
    );
    this.authorshipText.setAnchor(LEFT, BOTTOM);
  }
}

class DroppersBackground extends View
{
  PVector[] droppers;
  
  DroppersBackground()
  {
    super(0, 0, width, height);
    
    this.droppers = new PVector[1000];
    for (int i = 0; i < this.droppers.length; i++)
    {
      this.droppers[i] = new PVector(random(width), random(height));
    }
  }
  
  public void tick()
  {
    for (int i = 0; i < this.droppers.length; i++)
    {
      this.droppers[i].y += 0.3;
      
      if (this.droppers[i].y >= height)
      {
        this.droppers[i] = new PVector(random(width), 0);
      }
    }
  }
  
  public void drawGraphics()
  {
    this.gfx.beginDraw();
    this.gfx.background(0);
    this.gfx.fill(255);
    this.gfx.noStroke();
    for (int i = 0; i < this.droppers.length; i++)
    {
      this.gfx.rect(this.droppers[i].x, this.droppers[i].y, 1, 1);
    }
    this.gfx.endDraw();
  }
}

class GameScreen extends SceneView
{
  Player player;
  ArrayList<Dropper> droppers;
  TextView scoreCounter;
  TextView fpsView;
  color playerColor;
  boolean doubMode;
  boolean lastDoubMode;
  
  public GameScreen()
  {
    super();
    
    game.showCursor = false;
    
    sound.muteAllMusic();
    sound.vol("theme", 1);
    
    this.droppers = new ArrayList<Dropper>();
    this.playerColor = color(random(64, 200), random(64, 200), random(64, 200));
    
    for (int i = 0; i < 50; i++)
    {
      Dropper d = new Dropper(0);
      this.droppers.add(d);
      this.drawables.add(d);
    }
    
    this.addDrawables
    (
      this.player = new Player(width / 2, height - Player.HEIGHT / 2),
      this.scoreCounter = new TextView(10, 10)
        .setTextSize(32)
        .setTextColor(this.playerColor)
        .setBgColor(color(0, 127)),
      this.fpsView = new TextView(width - 10, 10)
        .setTextSize(20)
        .setTextColor(color(255, 0, 0))
        .setViewWidth(100)
        .setBgColor(color(0, 127))
    );
    this.player.setTint(this.playerColor);
    this.fpsView.setAnchor(RIGHT, TOP)
        .setVisibility(false);
  }
  
  public void tick()
  {
    super.tick();
    doubMode = input.isPressed(W) && this.player.isAlive();
    if (input.isPressed(P)) this.fpsView.toggleVisibility();
    
    sound.rate("theme", 1 + (float)floor((float)this.player.getScore() / 100) / 10);
    sound.rate("strong", 1 + (float)floor((float)this.player.getScore() / 100) / 10);
    
    if (doubMode)
    {
      this.setBgColor(color(random(50), 0, 0));
    }
    else
    {
      this.setBgColor(color(0));
    }
    if (this.lastDoubMode != this.doubMode)
    {
      if (player.isAlive())
      {
        sound.vol("theme", doubMode ? 0 : 1);
        sound.vol("strong", doubMode ? 1 : 0);
      }
      
      if (doubMode) 
      {
        this.player.setTint(color(255, 0, 0));
        this.player.setSprite(playerSprites[1]);
      }
      else 
      {
        this.player.setTint(this.playerColor);
        this.player.setSprite(playerSprites[0]);
      }
    }
    this.lastDoubMode = this.doubMode;
    
    for (int i = 0; i < this.drawables.size(); i++)
    {
      Drawable d = this.drawables.get(i);
      
      if (d instanceof Dropper)
      {
        Dropper dr = (Dropper)d;
        
        dr.doubleSpeed = doubMode;
        if (dr.hasHitFloor())
        {
          this.drawables.set(i, new Dropper(this.player.getScore()));
          if (player.isAlive())
            this.player.dodged(this.doubMode);
        }
        if (doubMode)
        {
          dr.rotVel = dr.rotSpeed;
          dr.setTint(color(255, 0, 0));
        }
        else
        {
          dr.setTint(color(255));
        }
        if (dr.hasHit(this.player))
        {
          this.playerDies();
          Thread t = new WaitForFlames(this.drawables, this.player.getScore());
          t.start();
        }
      }
      if (d instanceof Flame)
      {
        Flame f = (Flame)d;
        if (f.fuel < 0)
          this.drawables.remove(i);
      }
    }
      
    this.scoreCounter.setText("Score: " + this.player.getScore());
    this.fpsView.setText("FPS: " + round(frameRate));
  }
  
  private void makeExplosion(float x, float y)
  {
    sound.play("explosion");
    for (int i = 0; i < 100; i++)
    {
      this.drawables.add(new Flame(new PVector(x, y), PVector.fromAngle(random(-PI / 2, PI / 2) - PI / 2).mult(random(5))));
    }
  }
  
  private void playerDies()
  {
    //setScene(new GameOverScreen());
    sound.muteAllMusic();
    this.makeExplosion(player.pos.x, player.pos.y);
    this.player.die();
  }
  
  class WaitForFlames extends Thread //Look into Synchronised methods (?)
  {
    ArrayList<Drawable> draws;
    int score;
    
    WaitForFlames(ArrayList<Drawable> draws, int score)
    {
      this.draws = draws;
      this.score = score;
    }
    
    void start()
    {
      super.start();
    }
    
    void run()
    {
      boolean flameFound = false;
      
      do
      {
        flameFound = false;
        
        Iterator<Drawable> iter = this.draws.iterator();
        while (iter.hasNext())
        {
          if (iter.next() instanceof Flame)
          {
            flameFound = true;
          }
        }
        
        try
        {
          Thread.sleep(100);
        }
        catch (InterruptedException e)
        {
          e.printStackTrace();
        }
      }
      while(flameFound);
      
      try
      {
        Thread.sleep(3000);
      }
      catch (InterruptedException e)
      {
        e.printStackTrace();
      }
      
      setScene(new GameOverScreen(this.score));
    }
  }
}

class GameOverScreen extends SceneView
{
  View background;
  TextView gameOverText;
  int score;
  ButtonView retryBtn;
  ButtonView menuBtn;
  TextView nameText;
  TextInputView nameSubmission;
  ButtonView submitBtn;
  
  public GameOverScreen(int score)
  {
    super();
    this.score = score;
    final GameOverScreen parentScreen = this;
    
    game.showCursor = true;
    
    this.addDrawables(
      background = main_background,
      gameOverText = new TextView(width / 2, height / 4)
        .setText("GAME OVER\nScore: " + this.score)
        .setViewWidth(400)
        .setViewHeight(2)
        .setTextSize(32)
        .setTextAlign(CENTER),
      retryBtn = new ButtonView(buttonTheme)
        .setText("Retry")
        .setFunc(
          new Runnable()
          {
            public void run()
            {
              setScene(new GameScreen());
            }
          }
        ),
      menuBtn = new ButtonView(buttonTheme)
        .setText("Menu")
        .setFunc(
          new Runnable()
          {
            public void run()
            {
              setScene(new MenuScreen());
            }
          }
        ),
      nameText = new TextView(width / 2 - 90, height * .4)
        .setText("Name:")
        .setTextSize(20)
        .setViewHeight(1)
        .setTextAlign(CENTER)
        .setViewWidth(100),
      nameSubmission = new TextInputView(width / 2, height * .4)
        .setMaxChars(8),
      submitBtn = new ButtonView(buttonTheme)
        .setText("Submit")
        .setFunc(
          new Runnable()
          {
            public void run()
            {
              hSHandler.addHighscore(nameSubmission.getText(), parentScreen.score);
              setScene(new HighScoresScreen());
            }
          }
        )
    );
    gameOverText.setAnchor(CENTER, CENTER);
    retryBtn.setPos(width / 2, height * 0.5 + 50);
    retryBtn.setAnchor(CENTER, CENTER);
    submitBtn.setPos(width / 2, height * 0.5);
    submitBtn.setAnchor(CENTER, CENTER);
    menuBtn.setPos(width / 2, height * 0.5 + 100);
    menuBtn.setAnchor(CENTER, CENTER);
    nameText.setAnchor(CENTER, CENTER);
    nameSubmission.setAnchor(CENTER, CENTER);
    nameSubmission.setBorder(3);
    nameSubmission.setBorderColor(255);
    nameSubmission.setText("Player");
    nameSubmission.setBgColor(20);
  }
}

class HighScoresScreen extends SceneView
{
  View background;
  TextView title;
  TextView namesText;
  TextView scoresText;
  ButtonView menuBtn;
  ButtonView playBtn;
  
  HighScoresScreen()
  {
    super();
    
    String scoresString = "";
    String namesString = "";
    XML[] scoresUnsorted = hSHandler.getScores();
    XML[] scores = hSHandler.getScores();
    int largest = 0;
    
    for (int i = 0; i < scores.length; i++)
    {
      for (int j = 0; j < scoresUnsorted.length; j++)
      {
        if (scoresUnsorted[j].getInt("points") > scoresUnsorted[largest].getInt("points"))
        {
          largest = j;
        }
      }
      scores[i] = new XML("score");
      scores[i].setString("name", scoresUnsorted[largest].getString("name"));
      scores[i].setInt("points", scoresUnsorted[largest].getInt("points"));
      scoresUnsorted[largest].setInt("points", -1);
    }
    hSHandler.loadScores();
    
    for (int i = 0; i < scores.length; i++)
    {
      namesString += (i + 1) + ". " + scores[i].getString("name") + "\n";
      scoresString += scores[i].getString("points") + "\n";
    }
    
    this.addDrawables(
      background = main_background,
      title = new TextView(width / 2, height * 0.2)
        .setTextSize(32)
        .setText("HIGHSCORES")
        .setTextAlign(CENTER),
      scoresText = new TextView(width / 2, height * 0.3)
        .setTextSize(16)
        .setText(scoresString)
        .setViewWidth(200)
        .setViewHeight(10)
        .setTextAlign(RIGHT),
      namesText = new TextView(width / 2, height * 0.3)
        .setTextSize(16)
        .setText(namesString)
        .setViewWidth(200)
        .setViewHeight(10)
        .setBgColor(color(255, 0)),
      menuBtn = new ButtonView(buttonTheme)
        .setText("Menu")
        .setFunc(
          new Runnable()
          {
            public void run()
            {
              setScene(new MenuScreen());
            }
          }
        ),
      playBtn = new ButtonView(buttonTheme)
        .setText("Play")
        .setFunc(
          new Runnable()
          {
            public void run()
            {
              setScene(new GameScreen());
            }
          }
        )
    );
    title.setAnchor(CENTER, CENTER);
    scoresText.setAnchor(CENTER, TOP);
    namesText.setAnchor(CENTER, TOP);
    menuBtn.setPos(width * 0.4, height * .8);
    menuBtn.setAnchor(CENTER, CENTER);
    playBtn.setPos(width * 0.6, height * .8);
    playBtn.setAnchor(CENTER, CENTER);
  }
}
