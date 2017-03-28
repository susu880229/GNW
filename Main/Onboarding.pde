/**
 * Onboarding represents the onboarding video to be played upon opening the app
 */
class Onboarding
{
  Movie onBoardingVideo;
  HotspotCoords closeButton;
  HotspotCoords replayButton;
  PImage background;

  Onboarding()
  {  
    onBoardingVideo = new Movie(Main.this, "onboarding.mp4");
    onBoardingVideo.play();

    closeButton = new HotspotCoords(1800, 60, 1970, 60, 1970, 180, 1800, 180);
    replayButton = new HotspotCoords(1460, 1350, 1776, 1350, 1776, 1440, 1460, 1440);
  }

  void playVideo()
  {
    if (onBoardingVideo.available()) {
      onBoardingVideo.read();
    }
    image(onBoardingVideo, 0, 0);
  }

  void selectVideoFunction()
  {
    if (closeButton.contains()) {
      onBoardingVideo.pause();
      onboardingScreen = false;
    } else if (replayButton.contains()) {
      pushMatrix();
      scale(scaleFactor);
      image(onBoardingVideo, 0, 0);
      replayButton.drawOutline();
      onBoardingVideo.play(); //This is for android
      //onBoardingVideo.jump(0); //This is for desktop
      popMatrix();
    }
  }
}