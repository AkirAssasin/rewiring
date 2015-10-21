/* @pjs font='fonts/font.ttf' */ 

var myfont = loadFont("fonts/font.ttf"); 

ArrayList blocks;
int place = 1;
float bSize = 40;
Boolean canPlace = true;

void setup() {
    width = window.innerWidth;
    height = window.innerHeight;
    size(width, height);
    pwidth = width;
    pheight = height;
    blocks = new ArrayList();
    textFont(myfont);
    blocks.add(new Block(width/2,height/2,0));
}

 

Number.prototype.between = function (min, max) {
    return this > min && this < max;
};

void draw() {
    width = window.innerWidth;
    height = window.innerHeight;
    size(width, height);
    background(0);
    
    canPlace = true;
    
    for (int i=blocks.size()-1; i>=0; i--) {
        Particle b = (Block) blocks.get(i);
        b.update();
        if (round(mouseX/bSize)*bSize == b.x && round(mouseY/bSize)*bSize == b.y) {
          canPlace = false;
        }
    }
    
    pwidth = width;
    pheight = height;
    
    fill(0,0);
    if (canPlace) {stroke(255);} else {stroke(255,0,0);}
    rect(round(mouseX/bSize)*bSize,round(mouseY/bSize)*bSize,bSize,bSize);
}

void mouseClicked() {
    blocks.add(new Block(mouseX,mouseY,place));
}

void mousePressed() {

}


void mouseDragged() {

}

void mouseReleased() {

}

class Block {
    float x;
    float y;
    int[] pdir = new int[4];
    float power;
    int type;
    color c;

    Block(ox,oy,ot) {
      x = round(ox/bSize)*bSize;
      y = round(oy/bSize)*bSize;
      type = ot;
      for (int i=0; i<4; i++) {
        pdir[i] = 1;
      }
      c = color(10);
    }

    void update() {
      for (int i=0; i<4; i++) {
        if (pdir[i] > 1) {pdir[i] -= 1;}
      }  
        
      if (power < 500) {c = lerpColor(color(10),color(255,150,0),power/500);} else if (power < 1000) {
        c = lerpColor(color(255,150,0),color(150,150,255),(power-500)/500);
      } else if (power < 1500) {c = lerpColor(color(150,150,255),color(255),(power-1000)/500);} else {c = color(255);}
      stroke(c);
      fill(c);
        
      for (int i=blocks.size()-1; i>=0; i--) {
            Particle b = (Block) blocks.get(i);
            if (b.x == x && b.y == y + bSize) {
              b.pdir[0] = 3;
              if (power > 1 && b.power < 1500) {b.power += 1;}
            } 
            if (b.x == x - bSize && b.y == y) {
              b.pdir[1] = 3;
              if (power > 1 && b.power < 1500) {b.power += 1;}
            }
            if (b.x == x && b.y == y - bSize) {
              b.pdir[2] = 3;
              if (power > 1 && b.power < 1500) {b.power += 1;}
            }
            if (b.x == x + bSize && b.y == y) {
              b.pdir[3] = 3;
              if (power > 1 && b.power < 1500) {b.power += 1;}
            }
          }
        
      switch(type) {
        case 0:
          strokeWeight(1);
          rect(x,y,bSize,bSize);
          power += 1;
          break;
        case 1:
          strokeWeight(5);
          line(x + bSize/2,y + bSize/2,x + bSize/2,y + bSize/2);
          if (pdir[0] == 0 || pdir[0] > 1) {line(x + bSize/2,y + bSize/2,x + bSize/2,y);}
          if (pdir[1] == 0 || pdir[1] > 1) {line(x + bSize/2,y + bSize/2,x + bSize,y + bSize/2);}
          if (pdir[2] == 0 || pdir[2] > 1) {line(x + bSize/2,y + bSize/2,x + bSize/2,y + bSize);}
          if (pdir[3] == 0 || pdir[3] > 1) {line(x + bSize/2,y + bSize/2,x,y + bSize/2);}
          power += 1;
          strokeWeight(1);
          break;
      }
    }
}
