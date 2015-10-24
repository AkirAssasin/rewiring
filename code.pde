/* @pjs globalKeyEvents="true"; font='fonts/font.ttf'; pauseOnBlur="false"; */ 

var myfont = loadFont("fonts/font.ttf"); 

ArrayList blocks;
ArrayList stars;
ArrayList parts;
int place = 1;
float bSize = 40;
Boolean canPlace = true;
int editing = 0;
int edir = 0;
int nextWave = 10;
String[] bname = {"Engine", "Cable","Delayer", "Charger", "Reflector", "Laser"};
Boolean empty;
Boolean mout;


void setup() {
    width = window.innerWidth;
    height = window.innerHeight;
    size(width, height);
    pwidth = width;
    pheight = height;
    blocks = new ArrayList();
    stars = new ArrayList();
    parts = new ArrayList();
    //textFont(myfont);
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
    
    canPlace = true;
    empty = true;
    
    if (bSize/2 + round(mouseX/bSize)*bSize + bSize > width || bSize/2 + round(mouseY/bSize)*bSize + bSize > height) {
        mout = true;
    } else {mout = false;}
    
    if (blocks.size() == nextWave) {
      for (int i=0; i<nextWave*2; i++) {
        stars.add(new Star());
      }
      nextWave += 10;
    }
    
    for (int i=blocks.size()-1; i>=0; i--) {
        Particle b = (Block) blocks.get(i);
        b.update();
        if (bSize/2 + round(mouseX/bSize)*bSize == b.x && bSize/2 + round(mouseY/bSize)*bSize == b.y) {
          canPlace = false;
          editing = i;
          b.showdir();
        }
        if (b.type == 2 && b.power > 200) {
          blocks.remove(i);
        }
        
        if (b.power > 5) {
          empty = false;
        }
    }
    
    if (empty) {
      nextWave = 10;
    }
    
    for (int i=stars.size()-1; i>=0; i--) {
        Particle s = (Star) stars.get(i);
        s.update();
        if (s.power > 750 || s.hp <= 0 || (s.empty < 0 && s.y > height + 100)) {
          stars.remove(i);
          for (int v=0; v<3; v++) {
            parts.add(new Part(s.x,s.y,0));
          }
          for (int j=blocks.size()-1; j>=0; j--) {
            Particle b = (Block) blocks.get(j);
            if (dist(s.x,s.y,b.x + bSize/2,b.y + bSize/2) < bSize && b.shield < 750) {
              blocks.remove(j);
              for (int v=0; v<8; v++) {
                parts.add(new Part(b.x + bSize/2,b.y + bSize/2,bSize/2));
              }
            }
          }
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
    
    fill(255);
    textAlign(CENTER,BOTTOM);
    textSize(30);
    text((nextWave - blocks.size()) + " Blocks before next wave",width/2,height - 10);
    
    if (!mout) {
      strokeWeight(1);
      fill(0,0);
      if (canPlace) {stroke(255);} else {stroke(255,0,0);}
      rect(bSize/2 + round(mouseX/bSize)*bSize,bSize/2 + round(mouseY/bSize)*bSize,bSize,bSize);
      fill(255);
      textAlign(LEFT,BOTTOM);
      textSize(20);
      text("Place " + bname[place],bSize/2 + round(mouseX/bSize)*bSize,bSize/2 + round(mouseY/bSize)*bSize);
    }
    
    pwidth = width;
    pheight = height;
}

void mouseClicked() {
    if (canPlace && mouseButton == LEFT && !mout && stars.size() <= 1) {
      blocks.add(new Block(mouseX,mouseY,place));
    }
    if (!canPlace && mouseButton == RIGHT && !mout) {
      blocks.remove(editing);
    }
}

void mousePressed() {

}

void keyPressed() {
  if (!canPlace) {
    Particle b = (Block) blocks.get(editing);
    if (key == CODED) {
      if (keyCode == UP) {
        if (b.pdir[0] == 0) {b.pdir[0] = 1;} else if (b.pdir[0] == 1) {b.pdir[0] = 0;}
      }
      if (keyCode == RIGHT) {
        if (b.pdir[1] == 0) {b.pdir[1] = 1;} else if (b.pdir[1] == 1) {b.pdir[1] = 0;}
      }
      if (keyCode == DOWN) {
        if (b.pdir[2] == 0) {b.pdir[2] = 1;} else if (b.pdir[2] == 1) {b.pdir[2] = 0;}
      }
      if (keyCode == LEFT) {
        if (b.pdir[3] == 0) {b.pdir[3] = 1;} else if (b.pdir[3] == 1) {b.pdir[3] = 0;}
      }
    } else {
      if (key == 'w' || key == 'W') {
        if (b.pdir[0] == 0) {b.pdir[0] = 1;} else if (b.pdir[0] == 1) {b.pdir[0] = 0;}
      }
      if (key == 'd' || key == 'D') {
        if (b.pdir[1] == 0) {b.pdir[1] = 1;} else if (b.pdir[1] == 1) {b.pdir[1] = 0;}
      }
      if (key == 's' || key == 'S') {
        if (b.pdir[2] == 0) {b.pdir[2] = 1;} else if (b.pdir[2] == 1) {b.pdir[2] = 0;}
      }
      if (key == 'a' || key == 'A') {
        if (b.pdir[3] == 0) {b.pdir[3] = 1;} else if (b.pdir[3] == 1) {b.pdir[3] = 0;}
      }
    }
  }
    
  if (key == 'e') {
    if (place < 5) {place += 1;} else {place = 0;}
  }
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
    int shield;
    Boolean attacked;

    Block(ox,oy,ot) {
      x = bSize/2 + round(ox/bSize)*bSize;
      y = bSize/2 + round(oy/bSize)*bSize;
      type = ot;
      for (int i=0; i<4; i++) {
        pdir[i] = 1;
      }
      c = color(10);
      shield = 0;
    }
    
    void showdir() {
      switch(type) {
        case 0:
        case 1:
        case 2:
        case 3:
              
        strokeWeight(2);
        stroke(0);
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
      }
    }

    void update() {
      for (int i=0; i<4; i++) {
        if (pdir[i] > 1) {pdir[i] -= 1;}
      }  
        
      if (power < 500) {c = lerpColor(color(100),color(255,150,100),power/500);} else if (power < 1000) {
        c = lerpColor(color(255,150,100),color(167,225,255),(power-500)/500);
      } else if (power < 1500) {c = lerpColor(color(167,225,255),color(255),(power-1000)/500);} else {c = color(255);}
      stroke(c);
      fill(c);
        
      if (shield >= 10) {shield -= 10;}
      attacked = false;
        
      switch(type) {
        case 0:
          for (int i=blocks.size()-1; i>=0; i--) {
            Particle b = (Block) blocks.get(i);
            if (b.x == x && b.y == y + bSize && pdir[2] == 0) {
              b.pdir[0] = 3;
              if (power > 1 && b.power < 1500) {b.power += 1; power -= 1;}
            } 
            if (b.x == x - bSize && b.y == y && pdir[3] == 0) {
              b.pdir[1] = 3;
              if (power > 1 && b.power < 1500) {b.power += 1; power -= 1;}
            }
            if (b.x == x && b.y == y - bSize && pdir[0] == 0) {
              b.pdir[2] = 3;
              if (power > 1 && b.power < 1500) {b.power += 1; power -= 1;}
            }
            if (b.x == x + bSize && b.y == y && pdir[1] == 0) {
              b.pdir[3] = 3;
              if (power > 1 && b.power < 1500) {b.power += 1; power -= 1;}
            }
          }
          strokeWeight(1);
          translate(x + bSize/2,y + bSize/2);
          rotate(radians(power));
          rect(-bSize/4,-bSize/4,bSize/2,bSize/2,7);
          rotate(radians(-power));
          translate(-x - bSize/2,-y - bSize/2);
          power += 1;
          break;
              
        case 1:
          for (int i=blocks.size()-1; i>=0; i--) {
            Particle b = (Block) blocks.get(i);
            if (b.x == x && b.y == y + bSize && pdir[2] == 0) {
              b.pdir[0] = 3;
              if (b.power <= 1500 - power/10) {b.power += power/10; power -= power/10;}
            } 
            if (b.x == x - bSize && b.y == y && pdir[3] == 0) {
              b.pdir[1] = 3;
              if (b.power <= 1500 - power/10) {b.power += power/10; power -= power/10;}
            }
            if (b.x == x && b.y == y - bSize && pdir[0] == 0) {
              b.pdir[2] = 3;
              if (b.power <= 1500 - power/10) {b.power += power/10; power -= power/10;}
            }
            if (b.x == x + bSize && b.y == y && pdir[1] == 0) {
              b.pdir[3] = 3;
              if (b.power <= 1500 - power/10) {b.power += power/10; power -= power/10;}
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
            if (b.x == x && b.y == y + bSize && pdir[2] == 0) {
              b.pdir[0] = 3;
              if (power >= 100 && b.power <= 1500 - power) {b.power += 99; power = 0;}
            } 
            if (b.x == x - bSize && b.y == y && pdir[3] == 0) {
              b.pdir[1] = 3;
              if (power >= 100 && b.power <= 1500 - power) {b.power += 99; power = 0;}
            }
            if (b.x == x && b.y == y - bSize && pdir[0] == 0) {
              b.pdir[2] = 3;
              if (power >= 100 && b.power <= 1500 - power) {b.power += 99; power = 0;}
            }
            if (b.x == x + bSize && b.y == y && pdir[1] == 0) {
              b.pdir[3] = 3;
              if (power >= 100 && b.power <= 1500 - power) {b.power += 99; power = 0;}
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
          break;
              
        case 3:
          for (int i=blocks.size()-1; i>=0; i--) {
            Particle b = (Block) blocks.get(i);
            if (b.x == x && b.y == y + bSize && pdir[2] == 0) {
              b.pdir[0] = 3;
              if (power >= 0.3 && b.power < 1500) {b.power += 1; power -= 0.3; attacked = true;}
            } 
            if (b.x == x - bSize && b.y == y && pdir[3] == 0) {
              b.pdir[1] = 3;
              if (power >= 0.3 && b.power < 1500) {b.power += 1; power -= 0.3; attacked = true;}
            }
            if (b.x == x && b.y == y - bSize && pdir[0] == 0) {
              b.pdir[2] = 3;
              if (power >= 0.3 && b.power < 1500) {b.power += 1; power -= 0.3; attacked = true;}
            }
            if (b.x == x + bSize && b.y == y && pdir[1] == 0) {
              b.pdir[3] = 3;
              if (power >= 0.3 && b.power < 1500) {b.power += 1; power -= 0.3; attacked = true;}
            }
          }
          if (!attacked) {power += 10;}
          strokeWeight(3);
          fill(0);
          translate(x + bSize/2,y + bSize/2);
          rotate(radians(power + 45));
          rect(-bSize/4,-bSize/4,bSize/2,bSize/2,2);
          rotate(radians(-power - 45));
          translate(-x - bSize/2,-y - bSize/2);

          break;
       
        case 4:
          for (int i=stars.size()-1; i>=0; i--) {
            Particle s = (Star) stars.get(i);
            if (dist(s.x,s.y,x,y) < 190 && power >= 10 && !attacked) {
              strokeWeight(1);
              line(x+bSize/2,y+bSize/2,s.x,s.y);
              if (dist(x+bSize/2,0,s.x + s.vx,0) < dist(x+bSize/2,0,s.x - s.vx,0)) {s.vx *= -1;}
              if (dist(y+bSize/2,0,s.y + s.vy,0) < dist(y+bSize/2,0,s.y - s.vy,0)) {s.vy *= -1;}
              power -= 10;
              attacked = true;
            }
          }
          strokeWeight(3);
          fill(0);
          translate(x + bSize/2,y + bSize/2);
          ellipse(0,0,bSize/1.5,bSize/1.5);
          strokeWeight(2);
          translate(-x - bSize/2,-y - bSize/2);

          break;
              
        case 5:
          for (int i=stars.size()-1; i>=0; i--) {
            Particle s = (Star) stars.get(i);
            if (dist(s.x,s.y,x,y) < 190 && power >= 100 && !attacked) {
              strokeWeight(10*power/1500);
              line(x+bSize/2,y+bSize/2,s.x,s.y);
              s.hp -= 20*power/1500;
              power -= 10;
              attacked = true;
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
      x = random(width);
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
          
        x += vx;
        y += vy;
        
        if (dist(b.x + bSize/2,b.y + bSize/2,x,y) < bSize/2) {
          if (b.shield >= 10) {
            b.shield -= 10;
            if (power > 0) {power -= 1;}
          } else if (b.power > 1) {
            b.power -= 2;
            power += 2;
          }
        } else if (power > 0) {power -= 1;}
      } else {
        if (random(width) > x) {vx += random(0.8); vx *= .96;};
        if (random(width) < x) {vx -= random(0.8); vx *= .96;};
        vy += random(0.8); 
        vy *= .96;
          
        x += vx;
        y += vy;
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
    
    Part(ox,oy,or) {
      x = ox + random(-or,or);
      y = oy + random(-or,or);
      vx = 0;
      vy = 0;
      vx = random(-2,2);
      vy = random(-2,2);
      r = atan2(vy,vx) / PI * 180;
      s = random(10);
      h = 180;
    }
    
    void update() {
      if (h > 0) {h -= 1;}
      if (h < 60) {c = lerpColor(color(100,0),color(255,150,100,85),h/250);} else if (h < 120) {
        c = lerpColor(color(255,150,100,85),color(167,225,255,170),(h-60)/60);
      } else if (h < 180) {c = lerpColor(color(167,225,255,170),color(255),(h-120)/60);} else {c = color(255);}
      stroke(0.0);
      fill(c);
      vx *= .96;
      vy *= .96;
      x += vx;
      y += vy;
      translate(x,y);
      rotate(r/180*PI); 
      rect(-2,-2,4,4);
      rotate(-r/180*PI); 
      translate(-x,-y);
    }
}
