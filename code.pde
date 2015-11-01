/* @pjs globalKeyEvents="true"; font='fonts/rationale.ttf'; pauseOnBlur="false"; */ 

var myfont = loadFont("fonts/rationale.ttf"); 

ArrayList blocks;
ArrayList stars;
ArrayList parts;
int place = 0;
float bSize = 40;
Boolean canPlace = true;
int editing = 0;
int etype = 0;
int edir = 0;
String[] bname = {"Harvester", "Cable", "Booster", "Charger", "Scrambler", "Laser", "Blaster", "Thruster", "Compass", "Recycler", "Plate"};
String[] tooltip = {
  "Reliable source of energy.",
  "Fast energy transport.",
  "Amplifies energy.",
  "High-power overcharger.",
  "Stalls enemies.",
  "Long-range annihilator.",
  "Mid-range defense.",
  "Take it to space.",
  "Pinpoint a location.",
  "Convert waste into income.",
  "Decorational purposes."
};
String[] editip = {
  "WASD to toggle output. Arrows to move.",
  "WASD to toggle output. Arrows to move.",
  "WASD to toggle output. Arrows to move.",
  "WASD to toggle output. Arrows to move.",
  "WS to toggle range. Arrows to move.",
  "WS to toggle range. Arrows to move.",
  "WS to toggle range. Arrows to move.",
  "WASD to toggle output. Arrows to move.",
  "Cannot edit block.",
  "WS to toggle range. Arrows to move.",
  "WASD to edit shape. Arrows to move."
};
Boolean empty;
Boolean hasFly;
Boolean mout;
Boolean pressed = false;
int funds = 20000;
int[] price = {1900,80,500,1200,1100,3350,1100,3000,600,2200,100};
float[] bmp = {1500,100,500,2000,1000,2000,1000,500,50,800,5};
int[] boc = {0,1,1,0,0,0,1.7,1,1,1,1};
float[] brd = {0,0,0,0,190,500,190,0,0,190,0};
Boolean showtip = false;
Boolean flying = false;
float sx = 0;
float sy = 0;
float svx = 0;
float svy = 0;


void setup() {
    width = window.innerWidth;
    height = window.innerHeight;
    size(width, height);
    pwidth = width;
    pheight = height;
    blocks = new ArrayList();
    stars = new ArrayList();
    parts = new ArrayList();
    textFont(myfont);
    noCursor();
}

Number.prototype.between = function (min, max) {
    return this > min && this < max;
};

void draw() {
    width = window.innerWidth;
    height = window.innerHeight;
    size(width, height);
    background(0);
    
    strokeWeight(15);
    stroke(30);
    fill(35);
    ellipse(width/2 - sx,height/2 - sy,width,width);
    fill(30);
    
    textAlign(CENTER,BOTTOM);
    textSize(width/10);
    text("Station Alpha",width/2 - sx,height/2 - sy);
    textAlign(CENTER,TOP);
    textSize(width/30);
    text("Stealth Shielded Artificial Orbiter",width/2 - sx,height/2 - sy);
    
    if (!empty) {text("Ship Ready to Fly",width/2 - sx,height/4 - sy);} else {
      text("Ship Incomplete",width/2 - sx,height/4 - sy);
    }
    
    strokeWeight(1);
    
    canPlace = true;
    empty = true;
    hasFly = false;
    
    if (random(1) > 0.97 && dist(sx,sy,0,0) > width/2 && stars.size() < blocks.size()*1.7) {stars.add(new Star());}
    
    if (random(1) > 0.995 && dist(sx,sy,0,0) > width/2 && stars.size() < blocks.size()*1.5) {
        for (int i=0; i < blocks.size()*1.7; i++) {
          stars.add(new Star());
        }
    }
    
    if (bSize/2 + round(mouseX/bSize)*bSize + bSize > width || bSize/2 + round(mouseY/bSize)*bSize + bSize > height) {
        mout = true;
    } else {
        mout = false;
    }
    
    /**
    for (int i=blocks.size()-1; i>=0; i--) {
        Particle b = (Block) blocks.get(i);
        if (i == 0) {connected = true;} else {connected = false;}
    }
    **/
    
    for (int i=blocks.size()-1; i>=0; i--) {
        Particle b = (Block) blocks.get(i);
        b.update();
        if (bSize/2 + round(mouseX/bSize)*bSize == b.x && bSize/2 + round(mouseY/bSize)*bSize == b.y) {
          canPlace = false;
          editing = i;
          b.showdir();
          etype = b.type;
        }
        
        if (b.power > 5) {
          empty = false;
        }
        
        if (b.type == 7) {
          hasFly = true;
        }
        /**
        for (int j=blocks.size()-1; j>=0; j--) {
            Particle tb = (Block) blocks.get(j);
            if (b.connected && ((tb.x == b.x && tb.y == b.y + bSize) || (tb.x == b.x - bSize && tb.y == b.y) || (tb.x == b.x && tb.y == b.y - bSize) || (tb.x == b.x + bSize && tb.y == b.y))) {
              tb.connected = true;
            }
          }
    }
    
    for (int i=blocks.size()-1; i>=0; i--) {
        Particle b = (Block) blocks.get(i);
        for (int j=blocks.size()-1; j>=0; j--) {
            Particle tb = (Block) blocks.get(j);
            if (b.connected && ((tb.x == b.x && tb.y == b.y + bSize) || (tb.x == b.x - bSize && tb.y == b.y) || (tb.x == b.x && tb.y == b.y - bSize) || (tb.x == b.x + bSize && tb.y == b.y))) {
              tb.connected = true;
            }
          }
        **/
    }
    
    if (!hasFly) {empty = true;}
    
    /**
    for (int i=blocks.size()-1; i>=0; i--) {
        Particle b = (Block) blocks.get(i);
        if (!b.connected) {empty = true;}
    }
    **/
    
    if (blocks.size() <= 0) {
      sx *= 0.96; sy *= 0.96;
      for (int i=stars.size()-1; i>=0; i--) {stars.remove(i);}
      for (int i=parts.size()-1; i>=0; i--) {parts.remove(i);}
    }
    
    svx *= .96;
    svy *= .96;
    sx += svx;
    sy += svy;
    if (svx < 1 && svy < 1) {flying = false;} else {flying = true;}
    
    for (int i=stars.size()-1; i>=0; i--) {
        Particle s = (Star) stars.get(i);
        s.update();
        if (s.power > 750 || s.hp <= 0 || (s.empty < 0 && s.y > height + 10) || s.y > height + 10) {
          for (int v=0; v<3; v++) {
            parts.add(new Part(s.x,s.y,0,-2,2,-2,2,180));
          }
          if (s.power > 750) {
            for (int j=blocks.size()-1; j>=0; j--) {
              Particle b = (Block) blocks.get(j);
              if (j == editing) {canPlace = true;}
              if (dist(s.x,s.y,b.x + bSize/2,b.y + bSize/2) < bSize && b.shield < 750) {
                for (int v=0; v<8; v++) {
                  parts.add(new Part(b.x + bSize/2,b.y + bSize/2,bSize/2,-2,2,-2,2,180));
                }
                blocks.remove(j);
              }
            }
          }
          stars.remove(i);
        }
    }
    
    for (int i=parts.size()-1; i>=0; i--) {
        Particle p = (Part) parts.get(i);
        p.update();
        if (p.h <= 0) {parts.remove(i);}
    }
    
    fill(50);
    stroke(50);
    rect(0,0,bSize/2,height);
    
    rect(width,0,-bSize/2,height);
    
    rect(0,0,width,bSize/2);
    
    rect(0,height,width,-bSize/2);
    
    fill(255);
    textAlign(CENTER,BOTTOM);
    textSize(bSize/2);
    textAlign(LEFT,BOTTOM);
    text("$" + funds,0,height);
    
    for (int i=0; i < 9; i++) {
      stroke(40);
      fill(30);
      if (mouseX >= width/2 && mout && mouseY.between(10 + height*i/9,height*i/9 + height/9 - 10)) {
        rect(width - bSize/4 - 100,10 + height*i/9,width/2,height/9 - 20);
        fill(255);
        textAlign(LEFT,BOTTOM);
        text(bname[i],width - bSize/4 - 100 + 10,10 + height*i/9 + height/18);
        place = i;
      } else {
        rect(width - bSize/4,10 + height*i/9,width/2,height/9 - 20);
      }
    }
    
    if (!mout) {
      strokeWeight(1);
      fill(0,0);
      stroke(255);
      line(bSize/2 + round(mouseX/bSize)*bSize,bSize/2 + round(mouseY/bSize)*bSize,
           bSize/2 + round(mouseX/bSize)*bSize,bSize/2 + round(mouseY/bSize)*bSize + bSize/4);
      line(bSize/2 + round(mouseX/bSize)*bSize,bSize/2 + round(mouseY/bSize)*bSize,
           bSize/2 + round(mouseX/bSize)*bSize + bSize/4,bSize/2 + round(mouseY/bSize)*bSize);
        
      line(bSize/2 + round(mouseX/bSize)*bSize + bSize,bSize/2 + round(mouseY/bSize)*bSize,
           bSize/2 + round(mouseX/bSize)*bSize + bSize,bSize/2 + round(mouseY/bSize)*bSize + bSize/4);
      line(bSize/2 + round(mouseX/bSize)*bSize + bSize,bSize/2 + round(mouseY/bSize)*bSize,
           bSize/2 + round(mouseX/bSize)*bSize + bSize - bSize/4,bSize/2 + round(mouseY/bSize)*bSize); 
      
      line(bSize/2 + round(mouseX/bSize)*bSize,bSize/2 + round(mouseY/bSize)*bSize + bSize,
           bSize/2 + round(mouseX/bSize)*bSize,bSize/2 + round(mouseY/bSize)*bSize - bSize/4 + bSize);
      line(bSize/2 + round(mouseX/bSize)*bSize,bSize/2 + round(mouseY/bSize)*bSize + bSize,
           bSize/2 + round(mouseX/bSize)*bSize + bSize/4,bSize/2 + round(mouseY/bSize)*bSize + bSize);
        
      line(bSize/2 + round(mouseX/bSize)*bSize + bSize,bSize/2 + round(mouseY/bSize)*bSize + bSize,
           bSize/2 + round(mouseX/bSize)*bSize + bSize,bSize/2 + round(mouseY/bSize)*bSize - bSize/4 + bSize);
      line(bSize/2 + round(mouseX/bSize)*bSize + bSize,bSize/2 + round(mouseY/bSize)*bSize + bSize,
           bSize/2 + round(mouseX/bSize)*bSize + bSize - bSize/4,bSize/2 + round(mouseY/bSize)*bSize + bSize); 
        
        
      //rect(bSize/2 + round(mouseX/bSize)*bSize,bSize/2 + round(mouseY/bSize)*bSize,bSize,bSize);
      if (mouseX < width/2) {
        fill(255);
        textAlign(LEFT,BOTTOM);
        textSize(20);
        if (canPlace) {
          if (!flying) {
            text("Place " + bname[place],bSize/2 + round(mouseX/bSize)*bSize,bSize/2 + round(mouseY/bSize)*bSize - 3);
            textAlign(LEFT,TOP);
            text("-$" + price[place],bSize/2 + round(mouseX/bSize)*bSize,bSize/2 + round(mouseY/bSize)*bSize +bSize + 3);
            if (showtip) {
              text(tooltip[place],bSize/2 + round(mouseX/bSize)*bSize + bSize + 3,bSize/2 + round(mouseY/bSize)*bSize);
              textAlign(LEFT,BOTTOM);
              textSize(15);
              text("Left click to place",bSize/2 + round(mouseX/bSize)*bSize + bSize + 3,bSize/2 + round(mouseY/bSize)*bSize + bSize);
            }
          } else if (showtip) {
            textAlign(LEFT,BOTTOM);
            textSize(15);
            text("You can't place while flying.",bSize/2 + round(mouseX/bSize)*bSize + bSize + 3,bSize/2 + round(mouseY/bSize)*bSize + bSize);
          }
        } else {
          Particle b = (Block) blocks.get(editing);
          text("Edit " + bname[b.type],bSize/2 + round(mouseX/bSize)*bSize,bSize/2 + round(mouseY/bSize)*bSize - 3);
          textAlign(LEFT,TOP);
          if (showtip) {
            text(editip[etype],bSize/2 + round(mouseX/bSize)*bSize + bSize + 3,bSize/2 + round(mouseY/bSize)*bSize);
            textAlign(LEFT,BOTTOM);
            textSize(15);
            text("Right click to salvage",bSize/2 + round(mouseX/bSize)*bSize + bSize + 3,bSize/2 + round(mouseY/bSize)*bSize + bSize);
          }
        }
      } else {
        fill(255);
        textAlign(RIGHT,BOTTOM);
        textSize(20);
        if (canPlace) {
          if (!flying) {
            text("Place " + bname[place],bSize/2 + round(mouseX/bSize)*bSize + bSize,bSize/2 + round(mouseY/bSize)*bSize - 3);
            textAlign(RIGHT,TOP);
            text("-$" + price[place],bSize/2 + round(mouseX/bSize)*bSize + bSize,bSize/2 + round(mouseY/bSize)*bSize +bSize + 3);
            if (showtip) {
              text(tooltip[place],bSize/2 + round(mouseX/bSize)*bSize - 3,bSize/2 + round(mouseY/bSize)*bSize);
              textAlign(RIGHT,BOTTOM);
              textSize(15);
              text("Left click to place",bSize/2 + round(mouseX/bSize)*bSize - 3,bSize/2 + round(mouseY/bSize)*bSize + bSize);
            }
          } else if (showtip) {
              textAlign(RIGHT,BOTTOM);
              textSize(15);
              text("You can't place while flying.",bSize/2 + round(mouseX/bSize)*bSize - 3,bSize/2 + round(mouseY/bSize)*bSize + bSize);
          }
        } else {
          text("Edit " + bname[etype],bSize/2 + round(mouseX/bSize)*bSize + bSize,bSize/2 + round(mouseY/bSize)*bSize - 3);
          textAlign(RIGHT,TOP);
          if (showtip) {
            text(editip[etype],bSize/2 + round(mouseX/bSize)*bSize - 3,bSize/2 + round(mouseY/bSize)*bSize);
            textAlign(RIGHT,BOTTOM);
            textSize(15);
            text("Right click to salvage",bSize/2 + round(mouseX/bSize)*bSize - 3,bSize/2 + round(mouseY/bSize)*bSize + bSize);
          }
        }
      }
    }
    
    fill(255);
    textAlign(CENTER,TOP);
    textSize(bSize/2);
    text("Q-E to scroll between blocks, or use the sidebar to the right",width/2,0);
    
    textAlign(CENTER,BOTTOM);
    
    text("F to toggle help",width/2,height);
    
    pwidth = width;
    pheight = height;
}

void mouseClicked() {
    if (canPlace && mouseButton == LEFT && !mout && stars.size() <= 1 && funds >= price[place]) {
      blocks.add(new Block(mouseX,mouseY,place));
      funds -= price[place];
    }
    if (!canPlace && mouseButton == RIGHT && !mout) {
      Particle b = (Block) blocks.get(editing);
      for (int v=0; v<8; v++) {
        parts.add(new Part(b.x + bSize/2,b.y + bSize/2,bSize/2,-2,2,-2,2,180));
      }
      funds += round(price[b.type]*3/4);
      blocks.remove(editing);
    }
}

void mousePressed() {

}

void keyPressed() {
    if (!canPlace && blocks.size() > editing) {
      Particle b = (Block) blocks.get(editing);
      if (key == CODED) {
        if (keyCode == UP && !pressed) {
          b.y -= bSize;
        }
        if (keyCode == RIGHT && !pressed) {
          b.x += bSize;
        }
        if (keyCode == DOWN && !pressed) {
          b.y += bSize;
        }
        if (keyCode == LEFT && !pressed) {
          b.x -= bSize;
        }
      } else {
        switch(b.type) {
          case 0:
          case 1:
          case 2:
          case 3:
          case 7:
            case 10:
            if ((key == 'w' || key == 'W') && !pressed) {
              if (b.pdir[0] == 0) {b.pdir[0] = 1;} else if (b.pdir[0] == 1) {b.pdir[0] = 0;}
            }
            if ((key == 'd' || key == 'D') && !pressed) {
              if (b.pdir[1] == 0) {b.pdir[1] = 1;} else if (b.pdir[1] == 1) {b.pdir[1] = 0;}
            }
            if ((key == 's' || key == 'S') && !pressed) {
              if (b.pdir[2] == 0) {b.pdir[2] = 1;} else if (b.pdir[2] == 1) {b.pdir[2] = 0;}
            }
            if ((key == 'a' || key == 'A') && !pressed) {
              if (b.pdir[3] == 0) {b.pdir[3] = 1;} else if (b.pdir[3] == 1) {b.pdir[3] = 0;}
            }
            break;
                
          case 4:
          case 5:
          case 6:
          case 9:
            if (key == 'w' || key == 'W') {
              b.radius *= 1.04;
            }
            if (key == 's' || key == 'S') {
              b.radius *= 0.96;
            }
            break;
        }
      }
    }
      
    if (key == 'e' && !pressed) {
      if (place < 9) {place += 1;} else {place = 0;}
    }
    
    if (key == 'q' && !pressed) {
      if (place > 0) {place -= 1;} else {place = 9;}
    }
    
    if (key == 'f' && !pressed) {
      if (showtip) {showtip = false;} else {showtip = true;}
    }
    
    pressed = true;
}

void keyReleased() {pressed = false;}


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
    int shield;
    Boolean attacked;
    float r;
    float tx;
    float ty;
    float radius;
    Boolean connected;
    int overc;

    Block(ox,oy,ot) {
      x = bSize/2 + round(ox/bSize)*bSize;
      y = bSize/2 + round(oy/bSize)*bSize;
      type = ot;
      overc = boc[type];
      for (int i=0; i<4; i++) {
        pdir[i] = 1;
      }
      c = color(10);
      shield = 0;
      if (type == 0) {power = 1000;}
      if (type == 3) {power = 1;}
      if (type == 8) {tx = sx; ty = sy;} else {tx = x; ty = y;}
      radius = brd[type];
      connected = false;
    }
    
    void showdir() {
      switch(type) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 7:
        case 10:
          strokeWeight(1);
          stroke(0,0);
          fill(0,255,0);
          if (pdir[0] == 0) {ellipse(x + bSize/2,y,10,10);}
          if (pdir[1] == 0) {ellipse(x + bSize,y + bSize/2,10,10);}
          if (pdir[2] == 0) {ellipse(x + bSize/2,y + bSize,10,10);}
          if (pdir[3] == 0) {ellipse(x,y + bSize/2,10,10);}
          
          fill(255,0,0);
          if (pdir[0] == 1) {ellipse(x + bSize/2,y,10,10);}
          if (pdir[1] == 1) {ellipse(x + bSize,y + bSize/2,10,10);}
          if (pdir[2] == 1) {ellipse(x + bSize/2,y + bSize,10,10);}
          if (pdir[3] == 1) {ellipse(x,y + bSize/2,10,10);}
          strokeWeight(1);
          break;
              
        case 4:
        case 5:
        case 6:
          strokeWeight(1);
          stroke(255);
          fill(255,10);
          ellipse(x + bSize/2,y + bSize/2,radius*2,radius*2);
          break;
              
        case 9:
          strokeWeight(1);
          stroke(255);
          fill(255,10);
          ellipse(x + bSize/2,y + bSize/2,radius*power/bmp[type]*2,radius*power/bmp[type]*2);
          break;
      }
    }

    void update() {
      if (overc == 1) {
        power = min(power,bmp[type]);
      } else if (overc != 0) {
        power = min(power,bmp[type]*overc);
      }
        
      for (int i=0; i<4; i++) {
        if (pdir[i] > 1) {pdir[i] -= 1;}
      }  
        
      radius = min(radius,brd[type]);
        
      if (power < bmp[type]/3) {c = lerpColor(color(100),color(255,150,100),power/(bmp[type]/3));} else if (power < bmp[type]*2/3) {
        c = lerpColor(color(255,150,100),color(167,225,255),(power-bmp[type]/3)/(bmp[type]/3));
      } else if (power < bmp[type]) {c = lerpColor(color(167,225,255),color(255),(power-bmp[type]*2/3)/(bmp[type]/3));} else {c = color(255);}
      stroke(c);
      fill(c);
        
      if (shield >= 10) {shield -= 10;}
        
      if (type == 5) {if (power >= 1500) {attacked = false;}} else {attacked = false;}
        
      switch(type) {
        case 0:
          for (int i=blocks.size()-1; i>=0; i--) {
            Particle b = (Block) blocks.get(i);
            if (b.x == x && b.y == y + bSize && pdir[2] == 0 && b.pdir[0] > 0) {
              b.pdir[0] = 3;
              if (power > 1 && b.power < bmp[b.type]) {b.power += 1.5; power -= 0.2; attacked = true;}
            } 
            if (b.x == x - bSize && b.y == y && pdir[3] == 0 && b.pdir[1] > 0) {
              b.pdir[1] = 3;
              if (power > 1 && b.power < bmp[b.type]) {b.power += 1.5; power -= 0.2; attacked = true;}
            }
            if (b.x == x && b.y == y - bSize && pdir[0] == 0 && b.pdir[2] > 0) {
              b.pdir[2] = 3;
              if (power > 1 && b.power < bmp[b.type]) {b.power += 1.5; power -= 0.2; attacked = true;}
            }
            if (b.x == x + bSize && b.y == y && pdir[1] == 0 && b.pdir[3] > 0) {
              b.pdir[3] = 3;
              if (power > 1 && b.power < bmp[b.type]) {b.power += 1.5; power -= 0.2; attacked = true;}
            }
          }
          if (!attacked) {
            power += 1;
          }
          strokeWeight(1);
          translate(x + bSize/2,y + bSize/2);
          rotate(radians(power));
          rect(-bSize/4,-bSize/4,bSize/2,bSize/2,7);
          rotate(radians(-power));
          translate(-x - bSize/2,-y - bSize/2);
          break;
              
        case 1:
          for (int i=blocks.size()-1; i>=0; i--) {
            Particle b = (Block) blocks.get(i);
            if (b.x == x && b.y == y + bSize && pdir[2] == 0 && b.pdir[0] > 0) {
              b.pdir[0] = 3;
              if (b.power <= bmp[b.type] - power/10) {b.power += power/10; power -= power/10;}
            } 
            if (b.x == x - bSize && b.y == y && pdir[3] == 0 && b.pdir[1] > 0) {
              b.pdir[1] = 3;
              if (b.power <= bmp[b.type] - power/10) {b.power += power/10; power -= power/10;}
            }
            if (b.x == x && b.y == y - bSize && pdir[0] == 0 && b.pdir[2] > 0) {
              b.pdir[2] = 3;
              if (b.power <= bmp[b.type] - power/10) {b.power += power/10; power -= power/10;}
            }
            if (b.x == x + bSize && b.y == y && pdir[1] == 0 && b.pdir[3] > 0) {
              b.pdir[3] = 3;
              if (b.power <= bmp[b.type] - power/10) {b.power += power/10; power -= power/10;}
            }
          }
          strokeWeight(5);
          line(x + bSize/2,y + bSize/2,x + bSize/2,y + bSize/2);
          if (pdir[0] == 0 || pdir[0] > 1) {line(x + bSize/2,y + bSize/2,x + bSize/2,y);}
          if (pdir[1] == 0 || pdir[1] > 1) {line(x + bSize/2,y + bSize/2,x + bSize,y + bSize/2);}
          if (pdir[2] == 0 || pdir[2] > 1) {line(x + bSize/2,y + bSize/2,x + bSize/2,y + bSize);}
          if (pdir[3] == 0 || pdir[3] > 1) {line(x + bSize/2,y + bSize/2,x,y + bSize/2);}
          strokeWeight(1);
          break;
                   
        case 2:
          for (int i=blocks.size()-1; i>=0; i--) {
            Particle b = (Block) blocks.get(i);
            if (b.x == x && b.y == y + bSize && pdir[2] == 0 && b.pdir[0] > 0) {
              b.pdir[0] = 3;
              if (b.power <= bmp[b.type]) {b.power += power*1.1; attacked = true;}
            } 
            if (b.x == x - bSize && b.y == y && pdir[3] == 0 && b.pdir[1] > 0) {
              b.pdir[1] = 3;
              if (b.power <= bmp[b.type]) {b.power += power*1.1; attacked = true;}
            }
            if (b.x == x && b.y == y - bSize && pdir[0] == 0 && b.pdir[2] > 0) {
              b.pdir[2] = 3;
              if (b.power <= bmp[b.type]) {b.power += power*1.1; attacked = true;}
            }
            if (b.x == x + bSize && b.y == y && pdir[1] == 0 && b.pdir[3] > 0) {
              b.pdir[3] = 3;
              if (b.power <= bmp[b.type]) {b.power += power*1.1; attacked = true;}
            }
          }
          strokeWeight(5);
          translate(x + bSize/2,y + bSize/2);
          rotate(radians(power + 45));
          rect(-bSize/10,-bSize/10,bSize/5,bSize/5,2);
          rotate(radians(-power - 45));
          translate(-x - bSize/2,-y - bSize/2);
          if (pdir[0] == 0 || pdir[0] > 1) {line(x + bSize/2,y + bSize/2,x + bSize/2,y);}
          if (pdir[1] == 0 || pdir[1] > 1) {line(x + bSize/2,y + bSize/2,x + bSize,y + bSize/2);}
          if (pdir[2] == 0 || pdir[2] > 1) {line(x + bSize/2,y + bSize/2,x + bSize/2,y + bSize);}
          if (pdir[3] == 0 || pdir[3] > 1) {line(x + bSize/2,y + bSize/2,x,y + bSize/2);}
          strokeWeight(1);
          if (attacked) {power /= 2;}
          break;
              
        case 3:
          for (int i=blocks.size()-1; i>=0; i--) {
            Particle b = (Block) blocks.get(i);
            if (b.x == x && b.y == y + bSize && pdir[2] == 0 && b.pdir[0] > 0) {
              b.pdir[0] = 3;
              if (power >= 2) {
                attacked = true;
                if (b.power < bmp[b.type]) {b.power += 1; power -= 2;} else {b.power += 0.3;}
              }
            } 
            if (b.x == x - bSize && b.y == y && pdir[3] == 0 && b.pdir[1] > 0) {
              b.pdir[1] = 3;
              if (power >= 2) {
                attacked = true;
                if (b.power < bmp[b.type]) {b.power += 1; power -= 2;} else {b.power += 0.3;}
              }
            }
            if (b.x == x && b.y == y - bSize && pdir[0] == 0 && b.pdir[2] > 0) {
              b.pdir[2] = 3;
              if (power >= 2) {
                attacked = true;
                if (b.power < bmp[b.type]) {b.power += 1; power -= 2;} else {b.power += 0.3;}
              }
            }
            if (b.x == x + bSize && b.y == y && pdir[1] == 0 && b.pdir[3] > 0) {
              b.pdir[3] = 3;
              if (power >= 2) {
                attacked = true;
                if (b.power < bmp[b.type]) {b.power += 1; power -= 2;} else {b.power += 0.3;}
              }
            }
          }
          if (power < 1) {power = 0;}
          if (!attacked) {
              power *= 1.001;
          } else {power += 0.2;}
          strokeWeight(3);
          fill(0,0);
          translate(x + bSize/2,y + bSize/2);
          rotate(radians(power + 45));
          rect(-bSize/4,-bSize/4,bSize/2,bSize/2,2);
          rotate(radians(-power - 45));
          translate(-x - bSize/2,-y - bSize/2);

          break;
       
        case 4:
          for (int i=stars.size()-1; i>=0; i--) {
            Particle s = (Star) stars.get(i);
            if (dist(s.x,s.y,x,y) < radius && power >= 100) {
              strokeWeight(1);
              line(x+bSize/2,y+bSize/2,s.x,s.y);
              if (dist(x+bSize/2,0,s.x + s.vx,0) < dist(x+bSize/2,0,s.x - s.vx,0)) {s.vx *= -1;}
              if (dist(y+bSize/2,0,s.y + s.vy,0) < dist(y+bSize/2,0,s.y - s.vy,0)) {s.vy *= -1;}
              power -= 100;
              attacked = true;
            }
          }
          strokeWeight(3);
          fill(0,0);
          translate(x + bSize/2,y + bSize/2);
          ellipse(0,0,bSize/1.5,bSize/1.5);
          strokeWeight(2);
          translate(-x - bSize/2,-y - bSize/2);
              
          break;
              
        case 5:
          for (int i=stars.size()-1; i>=0; i--) {
            Particle s = (Star) stars.get(i);
            if (dist(s.x,s.y,x,y) < radius && power >= bmp[type]/7 && !attacked) {
              strokeWeight(bSize/3*power/bmp[type]);
              line(x+bSize/2,y+bSize/2,s.x,s.y);
              s.hp = 0;
              power -= bmp[type]/7;
            }
          }
              
          if (power <= bmp[type]/7) {attacked = true;}
              
          fill(0,0);
          strokeWeight(3);
          translate(x + bSize/2,y + bSize/2);
          rotate(radians(720*power/bmp[type]));
          rect(-bSize/4,-bSize/4,bSize/2,bSize/2,2);
          rotate(radians(-720*power/bmp[type]));
          rotate(radians(45));
          rect(-bSize/4,-bSize/4,bSize/2,bSize/2,2);
          rotate(radians(-45));
          ellipse(0,0,(bSize/3)*power/bmp[type],(bSize/3)*power/bmp[type]);
          translate(-x - bSize/2,-y - bSize/2);

          break;
              
        case 6:
          for (int i=stars.size()-1; i>=0; i--) {
            Particle s = (Star) stars.get(i);
            if (dist(s.x,s.y,x,y) < radius && power >= bmp[type]/15) {
              strokeWeight(4*power/bmp[type]);
              line(x+bSize/2,y+bSize/2,s.x,s.y);
              s.hp -= 9*power/bmp[type];
              s.vx *= 0.99;
              s.vy *= 0.99;
              power -= 1;
            }
          }
          strokeWeight(1);
          translate(x + bSize/2,y + bSize/2);
          rotate(radians(45));
          rect(-bSize/4,-bSize/4,bSize/2,bSize/2,2);
          fill(0);
          ellipse(0,0,5,5);
          rotate(radians(-45));
          translate(-x - bSize/2,-y - bSize/2);

          break;
              
        case 7:
          strokeWeight(1);
          translate(x + bSize/2,y + bSize/2);
          if (pdir[0] == 0) {
            svy += (power/bmp[type])*((max(8 - blocks.size(),0)+1)/8);
            rect(-bSize/8,-bSize/2,bSize/4,bSize/4,3);
            if (random(1) < 0.7*power/bmp[type]) {
              parts.add(new Part(x + bSize/2,y,0,-0.5,0.5,-4,-1,80));
            }
            if (power >= 1.5) {power -= 1.5;}
          } 
          if (pdir[1] == 0) {
            svx -= (power/bmp[type])*((max(8 - blocks.size(),0)+1)/8);
            rect(bSize/2 - bSize/4,-bSize/8,bSize/4,bSize/4,3);
            if (random(1) < 0.7*power/bmp[type]) {
              parts.add(new Part(x + bSize,y + bSize/2,0,1,4,-0.5,0.5,80));
            }
            if (power >= 1.5) {power -= 1.5;}
          }
          if (pdir[2] == 0) {
            svy -= (power/bmp[type])*((max(8 - blocks.size(),0)+1)/8);
            rect(-bSize/8,bSize/2 - bSize/4,bSize/4,bSize/4,3);
            if (random(1) < 0.7*power/bmp[type]) {
              parts.add(new Part(x + bSize/2,y + bSize,0,-0.5,0.5,1,4,80));
            }
            if (power >= 1.5) {power -= 1.5;}
          }
          if (pdir[3] == 0) {
            svx += (power/bmp[type])*((max(8 - blocks.size(),0)+1)/8);
            rect(-bSize/2,-bSize/8,bSize/4,bSize/4,3);
            if (random(1) < 0.7*power/bmp[type]) {
              parts.add(new Part(x,y + bSize/2,0,-4,-1,-0.5,0.5,80));
            }
            if (power >= 1.5) {power -= 1.5;}
          }
          strokeWeight(3);
          fill(0,0);
          rotate(radians(45));
          rect(-bSize/4,-bSize/4,bSize/2,bSize/2,7);
          rotate(radians(-45));
          translate(-x - bSize/2,-y - bSize/2);
          break;
              
        case 8:
          r = atan2(ty - sy, tx - sx) / PI * 180;
          strokeWeight(3);
          fill(0,0);
          translate(x + bSize/2,y + bSize/2);
          ellipse(0,0,bSize/1.5,bSize/1.5);
          strokeWeight(3);
          line(0,0,cos(r/180*PI)*(bSize/3)*power/bmp[type],sin(r/180*PI)*(bSize/3)*power/bmp[type]);
          r = atan2(svy, svx) / PI * 180;
          strokeWeight(1);
          line(0,0,cos(r/180*PI)*(bSize/3)*power/bmp[type],sin(r/180*PI)*(bSize/3)*power/bmp[type]);
          translate(-x - bSize/2,-y - bSize/2);
          if (power >= 0.5) {power -= 0.5;}
          break;
              
        case 9:
          for (int i=parts.size()-1; i>=0; i--) {
            Particle p = (Part) parts.get(i);
            if (dist(p.x,p.y,x,y) < radius*power/bmp[type]) {
              if (x + bSize/2 > p.x) {p.vx += random(0.8*power/bmp[type]); p.vx *= .96;};
              if (x + bSize/2 < p.x) {p.vx -= random(0.8*power/bmp[type]); p.vx *= .96;};
              if (y + bSize/2 > p.y) {p.vy += random(0.8*power/bmp[type]); p.vy *= .96;};
              if (y + bSize/2 < p.y) {p.vy -= random(0.8*power/bmp[type]); p.vy *= .96;};
            }
            if (dist(p.x,p.y,x + bSize/2,y + bSize/2) < bSize/3) {
              p.h /= 2;
              funds += 1;
            }
          }
          strokeWeight(3);
          fill(0,0);
          translate(x + bSize/2,y + bSize/2);
          ellipse(0,0,bSize/1.5,bSize/1.5);
          ellipse(0,0,bSize/3,bSize/3);
          strokeWeight(2);
          translate(-x - bSize/2,-y - bSize/2);
          break;
              
        case 10:
          strokeWeight(1);
          r = 0;
          translate(x + bSize/2,y + bSize/2);
          if (pdir[0] == 0) {triangle(0,-bSize/2,bSize/2,-bSize/2,bSize/2,0); r += 1;}
          if (pdir[1] == 0) {triangle(0,bSize/2,bSize/2,bSize/2,bSize/2,0); r += 1;}
          if (pdir[2] == 0) {triangle(0,bSize/2,-bSize/2,bSize/2,-bSize/2,0); r += 1;}
          if (pdir[3] == 0) {triangle(0,-bSize/2,-bSize/2,-bSize/2,-bSize/2,0); r += 1;}
          if (r >= 2) {
            beginShape();
              vertex(0,-bSize/2);  
              vertex(bSize/2,0);
              vertex(0,bSize/2);
              vertex(-bSize/2,0);
            endShape();
          }
          translate(-x - bSize/2,-y - bSize/2);
          break;
            
      }
    }
}

class Star {
    float x;
    float y;
    float vx;
    float vy;
    float[] tx;
    float[] ty;
    float hp;
    int tl;
    float power;
    int t;
    color c;
    
    Star() {
      x = random(-width/2,width*3/2);
      y = random(-height*2);
      vx = 0;
      vy = 0;
      t = round(random(blocks.size()-1));
      power = 0;
      tl = 10;
      tx = new float[tl];
      ty = new float[tl];
      hp = 255;
    }
    
    void update() {
      if (power < 250) {c = lerpColor(color(100),color(255,150,100),power/250);} else if (power < 500) {
        c = lerpColor(color(255,150,100),color(167,225,255),(power-250)/250);
      } else if (power < 750) {c = lerpColor(color(167,225,255),color(255),(power-500)/250);} else {c = color(255);}
      stroke(c);
      fill(c);
        
        
      if (blocks.size() > 0 && !empty) {
        if (t > blocks.size()-1) {
          t = round(random(blocks.size()-1));
        }
        Particle b = (Block) blocks.get(t);
        if (b.power < 2) {
          t = round(random(blocks.size()-1));
        }
          
        if (b.x + bSize/2 + random(-50,50) > x) {vx += random(0.8); vx *= .96;};
        if (b.x + bSize/2 + random(-50,50) < x) {vx -= random(0.8); vx *= .96;};
        if (b.y + bSize/2 + random(-50,50) > y) {vy += random(0.8); vy *= .96;};
        if (b.y + bSize/2 + random(-50,50) < y) {vy -= random(0.8); vy *= .96;};
          
        x += vx - svx;
        y += vy - svy;
        
        if (dist(b.x + bSize/2,b.y + bSize/2,x,y) < bSize/2) {
          if (b.shield >= 10) {
            b.shield -= 10;
            if (power > 0) {power -= 1;}
          } else if (b.power > 1) {
            b.power -= 2;
            power += 2;
          }
        }
      } else {
        if (random(-width/2,width*3/2) > x) {vx += random(0.8); vx *= .96;};
        if (random(-width/2,width*3/2) < x) {vx -= random(0.8); vx *= .96;};
        vy += random(0.8); 
        vy *= .96;
          
        x += vx - svx;
        y += vy - svy;
      }
      for (int i=0; i<tl; i++) {
        if (i != tl-1) {
          tx[i] = tx[i+1];
          ty[i] = ty[i+1];
          strokeWeight(i);
          line(tx[i],ty[i],tx[i+1],ty[i+1]);
        } else {
          tx[i] = x;
          ty[i] = y;
        }
        strokeWeight(1);
      }
    }
}

class Part {
    float x;
    float y;
    float r;
    float vx;
    float vy;
    color c;
    float h;
    float s;
    
    Part(ox,oy,or,ox1,ox2,oy1,oy2,oh) {
      x = ox + random(-or,or);
      y = oy + random(-or,or);
      vx = 0;
      vy = 0;
      vx = random(ox1,ox2);
      vy = random(oy1,oy2);
      r = atan2(vy,vx) / PI * 180;
      s = random(10);
      h = oh;
    }
    
    void update() {
      if (h > 0) {h -= 1;}
      if (h < 60) {c = lerpColor(color(100,0),color(255,150,100,85),h/250);} else if (h < 120) {
        c = lerpColor(color(255,150,100,85),color(167,225,255,170),(h-60)/60);
      } else if (h < 180) {c = lerpColor(color(167,225,255,170),color(255),(h-120)/60);} else {c = color(255);}
      stroke(0,0);
      fill(c);
      vx *= .96;
      vy *= .96;
      x += vx - svx;
      y += vy - svy;
      translate(x,y);
      rotate(r/180*PI); 
      rect(-2,-2,4,4);
      rotate(-r/180*PI); 
      translate(-x,-y);
    }
}
