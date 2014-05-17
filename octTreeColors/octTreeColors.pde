MyOctTree octTree = new MyOctTree();

void setup()
{
  size(900,900,P3D);
  
insertRandomPos();
//  insertAllColors();
  octTree.countAllNodes();
}

void insertAllColors()
{
  long startTime = millis();
  for(int i = 0; i < 256; i++)
  {
    for(int j = 0; j < 256; j++)
    {
      for(int k = 0; k < 256; k++)
      {
        float pos[] =new float[]{(int)i,(int)j,(int)k};
        octTree.insertData(pos);
      }
    }
    println("I:" + i + " curMillis: " + millis());
  }
  println("Insertion duration (millis): " + (millis()-startTime));
}

void insertRandomPos()
{
  long startTime = millis();
  for(int i = 0; i < 100; i++)
  {
    float pos[] =new float[]{(int)random(255),(int)random(255),(int)(255)};
    println("INSERT! @ " + pos[0]+"," + pos[1]+"," + pos[2] + " curMillis: " + millis());
    octTree.insertData(pos);
//    println("I:" + i + " curMillis: " + millis());
  }
  println("Insertion duration (millis): " + (millis()-startTime));
}

float nearestPos[];
void draw()
{
  pushMatrix();
  float tm = millis()/1000.f;
  float queryPos[] = new float[]{(mouseX*255)/width,(mouseY*255)/height,255};//255*(1+sin(tm/3.33))/2};
  
  background(0);
  fill(255,50);
  translate(width/2,height/2,-200);
  scale(2);
//  rotateY(mouseX*TWO_PI/width);
  octTree.renderTree();
  
  nearestPos = octTree.getNearestNodePos(queryPos);
  
  translate(-127,-127,-127);
  pushMatrix();
  translate(nearestPos[0],nearestPos[1],nearestPos[2]);
  hint(DISABLE_DEPTH_TEST);
  fill(255,255,0);stroke(255,255,0);
  box(7);
  popMatrix();
  
  translate(queryPos[0],queryPos[1],queryPos[2]);
  fill(255,255,0,100);
  box(7);
  hint(ENABLE_DEPTH_TEST);
 
  popMatrix();

 
  drawDebugText();
}

void mouseReleased()
{
//     if(mousePressed)
   {
     println("removing nearest to : "  + nearestPos[0] + "," + nearestPos[1] + "," + nearestPos[2]);
     float pos[] = octTree.findAndRemoveNearestNode(nearestPos);
     if(pos != null)
       println("removed: " + pos[0] + "," + pos[1] + "," + pos[2]);
   }
}

void drawDebugText()
{
  hint(DISABLE_DEPTH_TEST);
  pushMatrix();
  stroke(255);
  fill(255);
  text("framerate: " + frameRate,0,30);
  popMatrix();
  hint(ENABLE_DEPTH_TEST);
}
