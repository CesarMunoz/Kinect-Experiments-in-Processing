import SimpleOpenNI.*;
SimpleOpenNI kinect;

// these are the running avg so need to be floats
float closestX;
float closestY;

// array to store closest x,y vals for averaging
int[] recentXValues = new int[3];
int[] recentYValues = new int[3];

// keep track of which current value in the array to be changed
int currentIndex = 0;

void setup()
{
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
}

void draw()
{
  int closestVal = 8000; //set beyond max to ensure closest comparison
  
  kinect.update();
  
  // get depth array
  int[] depthValues = kinect.depthMap();
  
    // scrub each row
    for(int y=0; y<480; y++)
    {
      //scrub each pixel in the row
      for(int x=0; x<640; x++)
      {
        // pull value from depth array
        int i = x+y*640;
        int currentDepthValue = depthValues[i];
        
        // closest pixel?
        if(currentDepthValue > 0 && currentDepthValue < closestVal)
        {
          // set new minimum
          closestVal = currentDepthValue;
          //save x,y position
          recentXValues[currentIndex] = x;
          recentYValues[currentIndex] = y;
        }
      }
    }
    
    // cycle currentIndex
    currentIndex++;
    if(currentIndex>2)
    {
      currentIndex = 0;
    }
    
    //closestX and closestY become averages
    //compared to actual current value
    closestX = (recentXValues[0]+recentXValues[1]+recentXValues[2])/3;
    closestY = (recentYValues[0]+recentYValues[1]+recentYValues[2])/3;
    //closestX = (recentXValues[0]+recentXValues[1]+recentXValues[2]+recentXValues[3]+recentXValues[4]+recentXValues[5]+recentXValues[6]+recentXValues[7]+recentXValues[8]+recentXValues[9])/10;
    //closestY = (recentYValues[0]+recentYValues[1]+recentYValues[2]+recentYValues[3]+recentYValues[4]+recentYValues[5]+recentYValues[6]+recentYValues[7]+recentYValues[8]+recentYValues[9])/10;
    
    //draw depth image
    image(kinect.depthImage(),0,0);
    
    //red circle
    fill(255,0,0);
    ellipse(closestX,closestY,25,25);
}

