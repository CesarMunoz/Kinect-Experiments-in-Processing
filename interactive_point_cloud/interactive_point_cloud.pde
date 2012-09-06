import processing.opengl.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;

float rotation = 0;

//set box size
int boxSize = 150;
int boxHalf = boxSize/2;
// vector holding the center of the box
PVector boxCenter = new PVector(0, 0, 600);

//this will be used for zooming
// start at normal
float s = 1;

void setup()
{
  size(1024,768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
}

void draw()
{
  background(0);
  kinect.update();
  
  translate(width/2, height/2, -1000);
  rotateX(radians(180));
  
  translate(0, 0, 1400);
  rotateY(radians(map(mouseX, 0, width, -180, 180)));
  
  // zoom in
  translate(0,0,s*-1000);
  scale(s);
  println("s: "+s);
  stroke(255);
  
  PVector[] depthPoints = kinect.depthMapRealWorld();
  
  // init a var for storing the total points
  // we find inside the box on this frame
  int depthPointsInBox = 0;
  
  for(int i=0; i<depthPoints.length; i+=10)
  {
    PVector currentPoint = depthPoints[i];
    
    if(currentPoint.x > boxCenter.x - boxHalf && currentPoint.x < boxCenter.x + boxHalf)
    {
      if(currentPoint.y > boxCenter.y - boxHalf && currentPoint.y < boxCenter.y + boxHalf)
      {
        if(currentPoint.z > boxCenter.z - boxHalf && currentPoint.z < boxCenter.z + boxHalf)
        {
          depthPointsInBox++;
        }
      }
    }
    
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
  
  println("depthPointsInBox: "+depthPointsInBox);
  
  // set box color's transparency
  // 0 is transparent, 1000 points is fully opaque red
  float boxAlpha = map(depthPointsInBox, 0, 1000, 0, 255);
  
  //draw cube
  //move box to center
  translate(boxCenter.x, boxCenter.y, boxCenter.z);
  
  fill(255, 255, 0, boxAlpha);
  //set line color to red
  stroke(255, 0, 0);
  
  // leave box empty
  //noFill();
  
  //draw it
  box(boxSize);
}

// use keys to control zoom
// up zooms in, downs zooms out
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

void mousePressed()
{
  save("touchedPoint.png");
}

