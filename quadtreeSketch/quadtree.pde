class QuadTree
{
    float value[] = new float[2];
    QuadTree GxGy,GxLy,LxGy,LxLy;
    
    public QuadTree(float[] pt)
    {
        value = pt;
    }
    
    private boolean isValueXGreater(QuadTree q){return value[0]>q.value[0];}
    private boolean isValueYGreater(QuadTree q){return value[1]>q.value[1];}
    
    public void addChild(QuadTree q)
    {
      if(isValueXGreater(q) && isValueYGreater(q))
      { 
        if(GxGy == null)
        {
          GxGy = q;
        }
        else
        {
          GxGy.addChild(q);
        }
      }
      
      if(!isValueXGreater(q) && isValueYGreater(q))
      { 
        if(LxGy == null)
        {
          LxGy = q;
        }
        else
        {
          LxGy.addChild(q);
        }
      }
      if(isValueXGreater(q) && !isValueYGreater(q))
      { 
        if(GxLy == null)
        {
          GxLy = q;
        }
        else
        {
          GxLy.addChild(q);
        }
      }
      if(!isValueXGreater(q) && !isValueYGreater(q))
      { 
        if(LxLy == null)
        {
          LxLy = q;
        }
        else
        {
          LxLy.addChild(q);
        }
      }
    }
    
    void draw()
    {
      
      pushMatrix();
      translate(value[0],value[1]);
//      ellipse(0,0,5,5);
      popMatrix();
      
      if(GxGy!= null){
        stroke(255,255,0);
        line(value[0],value[1],GxGy.value[0],GxGy.value[1]);
        stroke(255);
//        line(value[0],GxGy.value[1],GxGy.value[0],GxGy.value[1]);
//        line(GxGy.value[0],value[1],GxGy.value[0],GxGy.value[1]);        
        GxGy.draw();
      }
      if(GxLy!= null)
      {
        stroke(255,255,0);
        line(value[0],value[1],GxLy.value[0],GxLy.value[1]);
        stroke(255);
//        line(value[0],GxLy.value[1],GxLy.value[0],GxLy.value[1]);
//        line(GxLy.value[0],value[1],GxLy.value[0],GxLy.value[1]); 
        GxLy.draw();
      }
      if(LxGy!=null)
      {
        stroke(255,255,0);
        line(value[0],value[1],LxGy.value[0],LxGy.value[1]);
        stroke(255);
//        line(value[0],LxGy.value[1],LxGy.value[0],LxGy.value[1]);
//        line(LxGy.value[0],value[1],LxGy.value[0],LxGy.value[1]); 
        LxGy.draw();
      }
      if(LxLy!= null)
      {
        stroke(255,255,0);
        line(value[0],value[1],LxLy.value[0],LxLy.value[1]);
        stroke(255);
//        line(value[0],LxLy.value[1],LxLy.value[0],LxLy.value[1]);
//        line(LxLy.value[0],value[1],LxLy.value[0],LxLy.value[1]); 
        LxLy.draw();
      }
    }
}
