import SimpleOpenNI.*;
SimpleOpenNI kinect;

PImage depthImage;

float closestVal = 450;
float furthestVal = 1450;

void setup()
{
  size(640, 480);
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
}

void draw()
{
  kinect.update();
  
  int[] depthValues = kinect.depthMap();
  depthImage = kinect.depthImage();
  for(int x=0; x<640; x++)
  {
    for(int y=0; y<480; y++)
    {
      int i = x+y*640;
      int currentDepthVal = depthValues[i];
      if(currentDepthVal<closestVal || currentDepthVal>furthestVal)
      {
        depthImage.pixels[i] = 0;
      }
    }
  }
  
  image(depthImage,0,0);
}
