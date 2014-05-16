MyOctTree octTree = new MyOctTree();

void setup()
{
  size(900,900,P3D);
  for(int i = 0; i < 15; i++) 
    octTree.insertData(new float[]{(int)random(255),(int)random(255),(int)random(255)});
}

void draw()
{
  background(0);
  fill(255,50);
  translate(width/2,height/2,-200);
  scale(1.1);
  rotateY(millis()/2000.f);
octTree.renderTree();
}
