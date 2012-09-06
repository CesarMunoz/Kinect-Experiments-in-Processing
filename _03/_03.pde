import SimpleOpenNI.*;
SimpleOpenNI kinect;

int closestVal;
int closestX;
int closestY;
//int currentDepthValue;

void setup()
{
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
}

void draw()
{
  closestVal = 8000; //set initial val to furthest away
  kinect.update();
  
  //get depth array from kinect
  int[] depthArray = kinect.depthMap();
  
  //for each row in the depth image
  for (int y=0; y<480; y++)
  {
    //examine each pixel
    for (int x=0; x<640; x++)
    {
      int arrayIndex = x+y*640;
      int currentDepthValue = depthArray[arrayIndex];
      
      // if new depth val is less than current, make new val & save X, Y
      if(currentDepthValue > 0 && currentDepthValue < closestVal)
      {
        closestVal = currentDepthValue;
        closestX = x;
        closestY = y;
      }
    }  
  }
  
  
  // draw image on screen
  image(kinect.depthImage(),0,0);

  //draw red circle to interact with at x, y and closest pixel
  fill(255,0,0);
  ellipse(closestX, closestY, 25, 25);
}

