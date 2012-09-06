import processing.opengl.*;
import SimpleOpenNI.*;
import ddf.minim.*;

SimpleOpenNI kinect;

float rotation = 0;

Minim minim;
AudioSnippet kick;
AudioSnippet snare;

//hotpoint objects
Hotpoint snareTrigger;
Hotpoint kickTrigger;

float s = 1;

void setup()
{
  size(1024, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  
  minim = new Minim(this);
  snare = minim.loadSnippet("Chick_Cluck.aiff");
  kick = minim.loadSnippet("Zelda64_Alert.mp3");
  
  // inti hotpoints with x,y,z and size
  snareTrigger = new Hotpoint(200, 0, 600, 150);
  kickTrigger = new Hotpoint(-200, 0, 600, 150);
}

void draw()
{
  background(0);
  kinect.update();
  
  translate(width/2, height/2, -1000);
  rotateX(radians(180));
  
  translate(0, 0, 1400);
  rotateY(radians(map(mouseX, 0, width, -180, 180)));
  
  translate(0, 0, s*-1000);
  scale(s);
  
  PVector[] depthPoints = kinect.depthMapRealWorld();
  
  for(int i=0; i<depthPoints.length; i+=10)
  {
    PVector cp = depthPoints[i]; //curentPoint
    
    //have each hotpoint check to see if it includes the cp
    snareTrigger.check(cp);
    kickTrigger.check(cp);
    
    point(cp.x, cp.y, cp.z);
  }
  
  println(snareTrigger.pointsIncluded);
  
  if(snareTrigger.isHit())
  {
    snare.play();
  }
  
  if(!snare.isPlaying())
  {
    snare.rewind();
  }
  
  if(kickTrigger.isHit())
  {
    kick.play();
  }
  
  if(!kick.isPlaying())
  {
    kick.rewind();
  }
  
  // display each hotpoint & clear its points
  snareTrigger.draw();
  snareTrigger.clear();
  
  kickTrigger.draw();
  kickTrigger.clear();
}

void stop()
{
  // ensure players are closed
  kick.close();
  snare.close();
  
  minim.stop();
  super.stop();
}

void keyPressed()
{
  if(keyCode == 38)
  {
     s += 0.01;
  }else if(keyCode == 40)
  {
     s -= 0.01;
  }
}
