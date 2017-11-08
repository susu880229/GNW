import in.omerjerk.processing.video.android.*;

Movie movie;

void setup() {
  size(1280, 1280, P2D);
  movie = new Movie(this, "onboarding.mp4");
  movie.loop();
  movie.play();
}

void draw() {
  image(movie, 0, 0);
}

void movieEvent(Movie m) {
  m.read();
}