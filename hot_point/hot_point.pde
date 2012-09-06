import processing.opengl.*;
import SimpleOpenNI.*;
import ddf.minim.*;

//minim objects
Minim minim;
AudioSnippet player;

SimpleOpenNI kinect;

float rotation = 0;

// used for edge detection
boolean wasJustInBox = false;

int boxSize = 150;
int boxHalf = boxSize/2;
PVector boxCenter = new PVector(0,0,600);

float s = 1;

void setup()
{
  size(1024,768,OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  
  // init Minim && Audio Player
  minim = new Minim(this);
  player = minim.loadSnippet("Chick_Cluck.aiff");
}

void draw()
{
  background(0);
  kinect.update();
  
  translate(width/2, height/2, -1000);
  rotateX(radians(180));
  
  translate(0, 0, -1000);
  rotateY(radians(map(mouseX, 0, width, -180, 180)));
  
  translate(0,0,s*-1000);
  scale(s);
  
  stroke(255);
  
  PVector[] depthPoints = kinect.depthMapRealWorld();
  int depthPointsInBox = 0;
  
  for(int i=0;i<depthPoints.length;i+=10)
  {
    // cp = current point
    PVector cp = depthPoints[i];
    
    if(cp.x > boxCenter.x - boxHalf && cp.x < boxCenter.x + boxHalf)
    {
      if(cp.y > boxCenter.y - boxHalf && cp.y < boxCenter.y + boxHalf)
      {
        if(cp.z > boxCenter.z - boxHalf && cp.z < boxCenter.z + boxHalf)
        {
          depthPointsInBox++;
        }
      }
    }
    point(cp.x, cp.y, cp.z);
  }
  
  float boxAlpha = map(depthPointsInBox, 0, 1000, 0, 255);
  
  //edge detection 
  //are we in the box?
  boolean isInBox = (depthPointsInBox > 0);
  
  // if we just moved in start playing
  if(isInBox && !wasJustInBox)
  {
    player.play();
  }
  
  // if it has played through rewind & pause
  if(!player.isPlaying())
  {
    player.rewind();
    player.pause();
  }
  
  // save current status
  wasJustInBox = isInBox;
  
  translate(boxCenter.x, boxCenter.y, boxCenter.z);
  
  fill(255, 0, 0, 255);
  stroke(255, 0, 0);
  box(boxSize);
}

void stop()
{
  player.close();
  minim.stop();
  super.stop();
}

// keys for zoom
void keyPressed()
{
  if(keyCode == 38)
  {
    s += 0.01;
  }else if (keyCode == 40)
  {
    s -= 0.01;
  }
}
