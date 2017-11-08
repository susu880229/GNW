/**
 * HotspotCoords represents the 4 coordinates of a hotspot (e.g. building)
 */
class HotspotCoords
{
  PVector topLeft;
  PVector topRight;
  PVector bottomRight;
  PVector bottomLeft;

  /**
   * @param x1 This is the x-coordinate of the top-left corner of the building
   * @param y1 This is the y-coordinate of the top-left corner of the building
   * @param x2 This is the x-coordinate of the top-right corner of the building
   * @param y2 This is the y-coordinate of the top-righteft corner of the building
   * @param x3 This is the x-coordinate of the bottom-right corner of the building
   * @param y3 This is the y-coordinate of the bottom-right corner of the building
   * @param x4 This is the x-coordinate of the bottom-left corner of the building
   * @param y4 This is the y-coordinate of the bottom-left corner of the building
   */
  HotspotCoords(int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4)
  {
    topLeft = new PVector(x1, y1);
    topRight = new PVector(x2, y2);
    bottomRight = new PVector(x3, y3);
    bottomLeft = new PVector(x4, y4);
  }

  /**
   * Detect if mouse location is within this quad or not
   * Note: shiftX is referring to global public variable from Main. It tracks the change in x via horizontal scroll.
   */
  boolean contains() {
    //avoid mouseX be subtracted by shiftX when interact with the close instructio button
    int x;
    int y;
    if (start)
    {
      x  = (isOnMap()) ? mouseX - shiftX : mouseX;
    } else
    {
      x = mouseX;
    }
    y  = mouseY;
    PVector[] verts = {  topLeft, topRight, bottomRight, bottomLeft }; 
    PVector pos = new PVector(x, y);
    int i, j;
    boolean c=false;
    int sides = verts.length;
    for (i=0, j=sides-1; i<sides; j=i++) {
      if (( ((verts[i].y <= pos.y) && (pos.y < verts[j].y)) || ((verts[j].y <= pos.y) && (pos.y < verts[i].y))) &&
        (pos.x < (verts[j].x - verts[i].x) * (pos.y - verts[i].y) / (verts[j].y - verts[i].y) + verts[i].x)) {
        c = !c;
      }
    }
    return c;
  }

  /**
   * Draws a white border around the hotspot
   */
  void drawOutline() 
  {
    noFill();
    strokeWeight(10);
    stroke(255);
    quad(topLeft.x, topLeft.y, topRight.x, topRight.y, bottomRight.x, bottomRight.y, bottomLeft.x, bottomLeft.y);
  }
}