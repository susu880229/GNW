/**
 * Onboarding represents the onboarding video to be played upon opening the app
 */
class Onboarding
{
  Movie onBoardingVideo;
  HotspotCoords closeButton;
  HotspotCoords replayButton;
  PImage background;
  int videoLengthSeconds = 23;

  Onboarding()
  {  
    onBoardingVideo = new Movie(Main.this, "onboarding.mp4");
    onBoardingVideo.play();

    closeButton = new HotspotCoords(1800, 60, 1970, 60, 1970, 180, 1800, 180);
    replayButton = new HotspotCoords(1460, 1350, 1776, 1350, 1776, 1440, 1460, 1440);
  }

  /**
   * Reads the next available movie frame and displays it. If no more available frames, then show the last one
   */
  void playVideo()
  {
    if (onBoardingVideo.available()) {
      onBoardingVideo.read();
    }
    image(onBoardingVideo, 0, 0);
  }

  /**
   * Handle mouse click on the onboarding video. 
   * If close button is clicked, clear the video and go to actual app. 
   * If repeat button is clicked and it is at the end of the video, play the video from the beginning again. 
   * NOTE: Android and Java mode require different video player library. 
   * The desktop library requires the video to stop before replaying, so make sure line 51 onBoardingVideo.stop();  is uncommented. 
   * The Android library does not have the stop function, so make sure to comment out onBoardingVideo.stop() line. This library also does not require video to stop before replaying. 
   */
  void selectVideoFunction()
  {
    int currentTimeOfVideo = getCurrentTimeSeconds() - onboardingStartTime;

    if (closeButton.contains()) {
      onBoardingVideo = null;
      onboardingScreen = false;
    } else if (currentTimeOfVideo >= videoLengthSeconds && replayButton.contains()) {
      onboardingStartTime = getCurrentTimeSeconds();
      pushMatrix();
      scale(scaleFactor);
      replayButton.drawOutline();

      //onBoardingVideo.stop(); //this line is required for desktop
      onBoardingVideo.play();

      popMatrix();
    }
  }
}