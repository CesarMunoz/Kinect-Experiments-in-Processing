import SimpleOpenNI.*;
SimpleOpenNI kinect;

int closestVal;
int closestX;
int closestY;

float lastX;
float lastY;

void setup()
{
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  //kinect.setMirror(true);
  kinect.enableDepth();
  
  background(0);
}

void draw()
{
  closestVal = 8000;
  
  kinect.update();
  
  int[] depthValues = kinect.depthMap();
  
  for(int y=0; y<480; y++)
  {
    for(int x=0; x<640; x++)
    {
      // use reversedX by moving in from 
      // right side of the image
      int reversedX = 640-x-1;
      //int i = x+y*640;
      //use reversedX to calculate array index
      int i = reversedX+y*640;
      int currentDepthValues = depthValues[i];
      
      //if(currentDepthValues>0 && currentDepthValues<closestVal)
      //limit depth range
      if(currentDepthValues> 450 && currentDepthValues<1200 && currentDepthValues<closestVal)
      {
        closestVal = currentDepthValues;
        closestX = x;
        closestY = y;
      }
    }
  }
  
  //image(kinect.depthImage(),0,0);
  
  //smooth line out
  float interpolatedX = lerp(lastX, closestX, 0.3f);
  float interpolatedY = lerp(lastY, closestY, 0.3f);
  
  stroke(255,0,0);
  strokeWeight(3);
  line(lastX, lastY, interpolatedX, interpolatedY);
  
  lastX = interpolatedX;
  lastY = interpolatedY;
}

void mousePressed()
{
  //save image
  save("drawing.png");
  background(0);
}
