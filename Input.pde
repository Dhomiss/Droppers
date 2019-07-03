import java.util.Map;

class InputHandler
{
  protected ArrayList<Integer> keysPressed;
  
  public InputHandler()
  {
    this.keysPressed = new ArrayList<Integer>();
  }
  
  public void addKey(int _key)
  {
    boolean keyFound = false;
    for (int k : this.keysPressed)
      if (_key == k) keyFound = true;
    if (!keyFound)
      this.keysPressed.add(_key);
  }
  
  public void removeKey(int _key)
  {
    int keyFound = -1;
    for (int i = 0; i < this.keysPressed.size(); i++)
    {
      if (_key == this.keysPressed.get(i))
        keyFound = i;
    }
    if (keyFound > -1)
      this.keysPressed.remove(keyFound);
  }
  
  public boolean isPressed(int _key)
  {
    boolean bool = false;
    for (int k : this.keysPressed)
    {
      if (_key == k)
        bool = true;
    }
    return bool;
  }
  
  public String toString()
  {
    return this.keysPressed.toString();
  }
  
  /*public void checkButtons(ArrayList<ButtonView> buttons)
  {
    for (int i = buttons.size() - 1; i >= 0; i--)
    {
      if (buttons.get(i).checkForMouse()) break;
    }
  }*/
}

void keyPressed()
{
  input.addKey(keyCode);
  
  if (focusedView instanceof TextInputView)
  {
    TextInputView tiv = (TextInputView) focusedView;
    tiv.updateContent();
  }
}

void keyReleased()
{
  input.removeKey(keyCode);
}

void mousePressed()
{
  mouseDown = true;
}

void mouseReleased()
{
  mouseDown = false;
}

void mouseClicked()
{
  currentScene.clickHoveredView();
}

void mouseMoved()
{
  View oldHoveredView = hoveredView;
  hoveredView = currentScene.findHoveredView(0, 0);
  if (oldHoveredView != hoveredView)
  {
    hoveredView.hoverEnter();
    oldHoveredView.hoverExit();
  }
}
