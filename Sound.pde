import processing.sound.SoundFile;
import java.util.Iterator;

class SoundHandler
{
  private HashMap<String, SoundFile> sounds;
  
  public SoundHandler()
  {
    this.sounds = new HashMap<String, SoundFile>();
  }
  
  public void add(String label, SoundFile sound)
  {
    this.sounds.put(label, sound);
  }
  
  public void play(String label)
  {
    try
    {
      this.sounds.get(label).play();
    }
    catch (Exception e)
    {
      println("Failed to find sound file:", e);
    }
  }
  
  public void vol(String label, float vol)
  {
    try
    {
      this.sounds.get(label).amp(vol);
    }
    catch (Exception e)
    {
      println("Failed to find music file:", e);
    }
  }
  
  public void rate(String label, float r)
  {
    try
    {
      this.sounds.get(label).rate(r);
    }
    catch (Exception e)
    {
      println("Failed to find music file:", e);
    }
  }
  
  public void stop(String label)
  {
    try
    {
      this.sounds.get(label).stop();
    }
    catch (Exception e)
    {
      println("Failed to find music file:", e);
    }
  }
  
  public void muteAllMusic()
  {
    for (SoundFile s : this.sounds.values())
    {
      if (s instanceof MusicFile)
      {
        s.amp(0);
      }
    }
  }
  
  public void stopAllMusic()
  {
    for (SoundFile s : this.sounds.values())
      s.stop();
  }
}

class MusicFile extends SoundFile
{
  public MusicFile(PApplet theParent, String path)
  {
    super(theParent, path);
  }
  
  public void play(){ loop(); }
}
