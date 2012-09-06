import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup()
{
  size(640, 480);
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  
  //turn user tracking on
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
}

void draw()
{
  kinect.update();
  PImage depth = kinect.depthImage();
  image(depth, 0, 0);
  
  //make a vector of ints to store the list of users
  IntVector userList = new IntVector();
  
  //write the list of detected users
  //into our vector
  kinect.getUsers(userList);
  
  //if we find any users
  if(userList.size() > 0)
  {
    //get the first user
    int userID = userList.get(0);
    println("userID: "+userID);
    //if we are successfully calibrated
    if(kinect.isTrackingSkeleton(userID))
    {
      println(" IS TRACKING SKELETON ");
      //make a vector to store left hand
      PVector rightHand = new PVector();
      //put the position of the left hand into that vector
      float confidence = kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_HAND, rightHand);
     
      //kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_HAND, rightHand);
      
      //convert the detected hand position
      //to 'projective' coordinates
      //that will match the depth image
      PVector convertedRightHand = new PVector();
      kinect.convertRealWorldToProjective(rightHand, convertedRightHand);
      //and display it
      fill(255, 0, 0);
      float ellipseSize = map(convertedRightHand.z, 700, 2500, 50, 1);
      if(confidence > 0.5)
      {
        ellipse(convertedRightHand.x, convertedRightHand.y, ellipseSize, ellipseSize);
      }
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
