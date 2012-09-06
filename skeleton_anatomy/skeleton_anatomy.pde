import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup()
{
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.setMirror(true);
  //turn user tracking on
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  
  size(640, 480);
  fill(255, 0, 0);
}

void draw()
{
  kinect.update();
  image(kinect.depthImage(), 0, 0);
  
  //make a vector of ints to store the list of users
  IntVector userList = new IntVector();
  
  //write the list of detected users into our vector
  kinect.getUsers(userList);
  
  //if we find any users
  if(userList.size() > 0)
  {
    //get the first user
    int userID = userList.get(0);
    
    //if we are successfully calibrated
    if(kinect.isTrackingSkeleton(userID))
    {
      drawSkeleton(userID);
    }
  }
}

void drawSkeleton(int userID)
{
  stroke(0);
  strokeWeight(5);
  
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);
   
  noStroke();
   
  fill(255, 0, 0);
  drawJoint(userID, SimpleOpenNI.SKEL_HEAD);
  drawJoint(userID, SimpleOpenNI.SKEL_NECK);
  drawJoint(userID, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  drawJoint(userID, SimpleOpenNI.SKEL_LEFT_ELBOW);
  drawJoint(userID, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  drawJoint(userID, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  drawJoint(userID, SimpleOpenNI.SKEL_TORSO);
  drawJoint(userID, SimpleOpenNI.SKEL_LEFT_HIP);
  drawJoint(userID, SimpleOpenNI.SKEL_LEFT_KNEE);
  drawJoint(userID, SimpleOpenNI.SKEL_RIGHT_HIP);
  drawJoint(userID, SimpleOpenNI.SKEL_LEFT_FOOT);
  drawJoint(userID, SimpleOpenNI.SKEL_RIGHT_KNEE);
  drawJoint(userID, SimpleOpenNI.SKEL_LEFT_HIP);
  drawJoint(userID, SimpleOpenNI.SKEL_RIGHT_FOOT);
  drawJoint(userID, SimpleOpenNI.SKEL_RIGHT_HAND);
  drawJoint(userID, SimpleOpenNI.SKEL_LEFT_HAND);
}

void drawJoint(int userID, int jointID)
{
  PVector joint = new PVector();
  
  float confidence = kinect.getJointPositionSkeleton(userID, jointID, joint);
  if(confidence < 0.5)
  {
    return;
  }
  
  PVector convertedJoint = new PVector();
  kinect.convertRealWorldToProjective(joint, convertedJoint);
  ellipse(convertedJoint.x, convertedJoint.y, 5, 5);
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
