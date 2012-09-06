import ddf.minim.*;

Minim minim;
AudioSnippet player;

void setup ()
{
  minim = new Minim(this);
  player = minim.loadSnippet("Chick_Cluck.aiff");
  player.play();
}

void draw()
{
}

void stop()
{
  player.close();
  minim.stop();
  
  super.stop();
}
