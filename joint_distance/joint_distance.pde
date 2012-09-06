import SimpleOpenNI.*;

SimpleOpenNI kinect;

void setup()
{
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  
  size(640, 480);
  stroke(255, 0, 0);
  strokeWeight(5);
  textSize(20);
}

void draw()
{
  kinect.update();
  image(kinect.depthImage(), 0, 0);
  
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  
  if(userList.size() > 0)
  {
    int userID = userList.get(0);
    
    if(kinect.isTrackingSkeleton(userID))
    {
      PVector leftHand = new PVector();
      //println("leftHand: "+leftHand);
      PVector rightHand = new PVector();
      
      kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
      kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
      
      // calculate difference by subtracting one vector from the other
      PVector differenceVector = PVector.sub(rightHand, leftHand);
      
      // calculate the distance & directon of difference vector
      // magnitude is length of vector
      float magnitude = differenceVector.mag();
      differenceVector.normalize();
      
      // draw a line between hands
      kinect.drawLimb(userID, SimpleOpenNI.SKEL_LEFT_HAND, SimpleOpenNI.SKEL_RIGHT_HAND);
      //display
      pushMatrix();
      fill(abs(differenceVector.x)*255, abs(differenceVector.y)*255, abs(differenceVector.z)*255);
      text("m: "+magnitude, 10, 50);
      popMatrix();
    }
  }
}

//user-tracking callbacks
void onNewUser(int userID)
{
  println("start pose detection");
  kinect.startPoseDetection("Psi", userID);
}

void onEndCalibration(int userID, boolean successful)
{
  if(successful)
  {
    println("  User calibrated!!!");
    kinect.startTrackingSkeleton(userID);
  }else{
    println("  Failed to calibrate user!!!");
    kinect.startPoseDetection("Psi", userID);
  }
}

void onStartPose(String pose, int userID)
{
  println("Started pose for user");
  kinect.stopPoseDetection(userID);
  kinect.requestCalibrationSkeleton(userID, true);
}
