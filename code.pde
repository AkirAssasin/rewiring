/* @pjs globalKeyEvents="true"; font='fonts/font.ttf'; pauseOnBlur="false"; */ 

var myfont = loadFont("fonts/font.ttf"); 

ArrayList blocks;
ArrayList stars;
ArrayList parts;
int place = 1;
float bSize = 40;
Boolean canPlace = true;
int editing = 0;

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
    
    if (stars.size() + 20 < blocks.size()) {
      stars.add(new Star());
    }
    
    for (int i=blocks.size()-1; i>=0; i--) {
        Particle b = (Block) blocks.get(i);
        b.update();
        if (round(mouseX/bSize)*bSize == b.x && round(mouseY/bSize)*bSize == b.y) {
          canPlace = false;
          editing = i;
          b.showdir();
        }
        if (b.type == 2 && b.power > 200) {
          blocks.remove(i);
        }
    }
    
    for (int i=stars.size()-1; i>=0; i--) {
        Particle s = (Star) stars.get(i);
        s.update();
        if (s.power > 750) {
          stars.remove(i);
          for (int j=blocks.size()-1; j>=0; j--) {
            Particle b = (Block) blocks.get(j);
            if (dist(s.x,s.y,b.x + bSize/2,b.y + bSize/2) < bSize) {
              blocks.remove(j);
              for (int v=0; v<10; v++) {
                parts.add(new Part(b.x + bSize/2,b.y + bSize/2));
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
    
    fill(255);
    textAlign(CENTER,TOP);
    textSize(30);
    text(place,width/2,10);
    
    fill(0,0);
    if (canPlace) {stroke(255);} else {stroke(255,0,0);}
    rect(round(mouseX/bSize)*bSize,round(mouseY/bSize)*bSize,bSize,bSize);
    pwidth = width;
    pheight = height;
}

void mouseClicked() {
    if (canPlace && mouseButton == LEFT) {
      blocks.add(new Block(mouseX,mouseY,place));
    }
    if (!canPlace && mouseButton == RIGHT) {
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
    if (place < 4) {place += 1;} else {place = 0;}
  }
  
  if (key == 'r') {
    stars.add(new Star());
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

    Block(ox,oy,ot) {
      x = round(ox/bSize)*bSize;
      y = round(oy/bSize)*bSize;
      type = ot;
      for (int i=0; i<4; i++) {
        pdir[i] = 1;
      }
      c = color(10);
      shield = 0;
    }
    
    void showdir() {
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

    void update() {
      for (int i=0; i<4; i++) {
        if (pdir[i] > 1) {pdir[i] -= 1;}
      }  
        
      if (power < 500) {c = lerpColor(color(100),color(255,150,100),power/500);} else if (power < 1000) {
        c = lerpColor(color(255,150,100),color(167,225,255),(power-500)/500);
      } else if (power < 1500) {c = lerpColor(color(167,225,255),color(255),(power-1000)/500);} else {c = color(255);}
      stroke(c);
      fill(c);
        
      shield /= 2;
        
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
          power += 3;
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
          ellipse(x + bSize/2,y + bSize/2,((power + 30)/130)*bSize/2,((power + 30)/130)*bSize/2);
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
              if (power > 3 && b.power < 1499) {b.power += 2; power -= 3;}
            } 
            if (b.x == x - bSize && b.y == y && pdir[3] == 0) {
              b.pdir[1] = 3;
              if (power > 3 && b.power < 1499) {b.power += 2; power -= 3;}
            }
            if (b.x == x && b.y == y - bSize && pdir[0] == 0) {
              b.pdir[2] = 3;
              if (power > 3 && b.power < 1499) {b.power += 2; power -= 3;}
            }
            if (b.x == x + bSize && b.y == y && pdir[1] == 0) {
              b.pdir[3] = 3;
              if (power > 3 && b.power < 1499) {b.power += 2; power -= 3;}
            }
          }
          strokeWeight(3);
          fill(0);
          translate(x + bSize/2,y + bSize/2);
          rotate(radians(power + 45));
          rect(-bSize/4,-bSize/4,bSize/2,bSize/2,2);
          rotate(radians(-power - 45));
          translate(-x - bSize/2,-y - bSize/2);
              
          power *= 1.001;

          break;
       
        case 4:
          for (int i=blocks.size()-1; i>=0; i--) {
            Particle b = (Block) blocks.get(i);
            if (dist(b.x,b.y,x,y) < power/8) {
              b.shield = power;
            }
          }
          strokeWeight(1);
          translate(x + bSize/2,y + bSize/2);
          ellipse(0,0,bSize/1.5,bSize/1.5);
          fill(0);
          rect(-bSize/5,-bSize/5,bSize/2.5,bSize/2.5,2);
          strokeWeight(2);
          fill(red(c),green(c),blue(c),10);
          ellipse(0,0,power/4,power/4);
          translate(-x - bSize/2,-y - bSize/2);
        
          if (power >= 2) {power -= 2;}

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
    int tl;
    float power;
    int t;
    color c;
    
    Star() {
      x = random(width);
      y = random(-height);
      vx = 0;
      vy = 0;
      t = round(random(blocks.size()-1));
      power = 0;
      tl = 10;
      tx = new float[tl];
      ty = new float[tl];
    }
    
    void update() {
      if (power < 250) {c = lerpColor(color(100),color(255,150,100),power/250);} else if (power < 500) {
        c = lerpColor(color(255,150,100),color(167,225,255),(power-250)/250);
      } else if (power < 750) {c = lerpColor(color(167,225,255),color(255),(power-500)/250);} else {c = color(255);}
      stroke(c);
      fill(c);
        
      if (blocks.size() > 0) {
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
        
        if (dist(b.x + bSize/2,b.y + bSize/2,x,y) < bSize/2 && b.power > 1) {
          b.power -= 2;
          power += 2;
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
    
    Part(ox,oy) {
      x = ox + random(-bSize/2,bSize/2);
      y = oy + random(-bSize/2,bSize/2);
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
      if (h < 60) {c = lerpColor(color(100,0),color(255,150,100),h/250);} else if (h < 120) {
        c = lerpColor(color(255,150,100),color(167,225,255),(h-60)/60);
      } else if (h < 180) {c = lerpColor(color(167,225,255),color(255),(h-120)/60);} else {c = color(255);}
      stroke(c);
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
