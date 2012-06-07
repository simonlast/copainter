//coop painter
/* @pjs pauseOnBlur="true"; globalKeyEvents="true"; */
color bkg = color(255);

ArrayList<PVector> brush;
float rad = 25;
color col = color(83,119,122);
float[] controlRad = {300,150};
int numColors = 5;
color[] colors = {color(236,208,120),color(217,91,67),color(192,41,66),color(84,36,55),color(83,119,122)};

interface JavaScript {
       void sendStroke(float r, float g, float b, float rad, float[] x, float[] y);
     }
  
   void bindJavascript(JavaScript js) {
      javascript = js;
    }
  
   JavaScript javascript;

 PGraphics buffer;

void setup(){
   size(screenWidth,screenHeight);
   background(255);
   noFill();
   noLoop();
   smooth();
   strokeWeight(rad);
   stroke(col);
    brush = new ArrayList<PVector>();

  buffer = createGraphics(width,height, P2D);
  //buffer.setParent(this);
  //buffer.setPrimary(false);
  buffer.smooth();
  buffer.noStroke();
  buffer.beginDraw();
  buffer.background(255);
  buffer.endDraw();
   
}

void draw(){
if(mousePressed)
 	drawBrush();
 drawControls();
}

void redrawBuffer(){
	image(buffer, 0,0);
	 drawControls();
}

void keyPressed(){
 if(key == 'r'){
  brush = new ArrayList<PVector>();
  background(255);
  redraw();
 } 
}

void mousePressed(){
  float rad1 = dist(mouseX,mouseY,0,0);
  if(rad1 < controlRad[1]/2){
    rad = rad1;
    redraw();
  }else{
    
    float rad2 = dist(mouseX,mouseY,0,height);
    
    if(rad2 < controlRad[0]/2){
      
      int num = (int)((rad2/(controlRad[0]/2))*numColors);

      col = colors[num];
      
    }else{
    
      brush.add(new PVector(mouseX,mouseY));
      loop();
    }
  }
}

void mouseDragged(){
  brush.add(new PVector(mouseX,mouseY));
}

void mouseReleased(){
	float rad1 = dist(mouseX,mouseY,0,0);
	float rad2 = dist(mouseX,mouseY,0,height);
	if((rad1 > controlRad[1]/2) && (rad2 > controlRad[0]/2)){
  sendStroke();
	drawBrushToBuffer();
	redrawBuffer();
  brush = new ArrayList<PVector>();
  noLoop();
}
}

void sendStroke(){
   if(javascript != null){
    float[] x = new float[brush.size()];
    float[] y = new float[brush.size()];
    for(int i=0; i<brush.size(); i++){
      x[i] = brush.get(i).x;
      y[i] = brush.get(i).y;
    }
    
    //println(x);
    //println(y);
    
    javascript.sendStroke(red(col), green(col), blue(col), rad, x, y);
   }
}

void addStroke(float r, float g, float b, float rad, float[] x, float[] y){
	buffer.beginDraw();  
  buffer.stroke(r,g,b);
	buffer.noFill();
  buffer.strokeWeight(rad);
  buffer.beginShape();
  for(int i=0; i<x.length; i++){
     buffer.curveVertex(x[i], y[i]);
  }
  buffer.endShape();
buffer.endDraw();
	redrawBuffer();
  redraw();
  
}

void drawBrush(){
  beginShape();
  stroke(col);
  strokeWeight(rad);
  noFill();
  for(PVector p : brush){
    curveVertex(p.x, p.y);
  }
  endShape();
  
}
void drawBrushToBuffer(){
	buffer.beginDraw();
  buffer.beginShape();
  buffer.stroke(col);
  buffer.strokeWeight(rad);
  buffer.noFill();
  for(PVector p : brush){
    buffer.curveVertex(p.x, p.y);
  }
  buffer.endShape();
buffer.endDraw();
  
}



void drawControls(){
  noStroke();
  for(int x=numColors; x>0; x--){
   fill(colors[x-1]);
   ellipse(0,height,controlRad[0]/5*x,controlRad[0]/5*x);
  }
  
  fill(200);
  ellipse(0,0,controlRad[1],controlRad[1]);
  fill(100);
  ellipse(0,0,rad*2,rad*2);
  
  
  
  
}


