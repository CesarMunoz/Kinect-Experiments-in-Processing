class SkeletonRecorder {
  SimpleOpenNI context;
  int jointID;
  int userID;
  ArrayList<PVector> frames;
  int currentFrame = 0;
  
  SkeletonRecorder(SimpleOpenNI tempContext, int tempJointID){
    context = tempContext;
    jointID = tempJointID;
    frames = new ArrayList();
  }
  
  void setUser(int tempUserID){
    userID = tempUserID;
  }
  
  void recordFrame(){
    PVector position = new PVector();
    context.getJointPositionSkeleton(userID, jointID, position);
    frames.add(position);
  }
  
  PVector getPosition(){
    return frames.get(currentFrame);
  }
  
  void nextFrame(){
    currentFrame++;
    if(currentFrame == frames.size()){
      currentFrame = 0;
    } 
  }
}
