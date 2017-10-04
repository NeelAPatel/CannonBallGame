import java.util.ArrayList;

// Backgrounds | initial stuff
PImage bg,bgWall,keyDirections, menu;
PImage cannon1,cannon1_Body;
PImage cannon2,cannon2_Body;
PFont myFont;

//MainMenu | End Game
boolean mainMenu = true, endGame = false;
int charSelected, enemyNum;
String randomEnemy = "";
int winLose = 0;

//Cannons
int cannon1_X, cannon1_Y, cannon1_Angle, cannon1_DMG;
int cannon2_X, cannon2_Y, cannon2_Angle, cannon2_DMG;

// Keys
boolean keyDisabled; // for endGame
boolean aKey, dKey, wKey, sKey, xKey, c1fired; // Player 1  L R Up Dwn Fire | fired
boolean jKey, lKey, iKey, kKey, mKey, c2fired; // Player 2  L R Up Dwn Fire | fired

//Cannonballs
CannonballHandler cHandle1, cHandle2;


void setup()
{
 bg = loadImage("parchment.jpg");
 bgWall = loadImage("BGWall2.png");
 menu = loadImage("Menu.png");
 keyDirections = loadImage("DIRECTIONS.png");
 frame.setTitle("Avatar Cannons | Neel Patel");
  int r = (int) random(4) +1;
  enemyNum = r;
    switch(enemyNum)
    {
      case 1: 
        {
          randomEnemy = "Air Nomads";
          cannon2 = loadImage("Air Cannon_Symbol_Flipped.png");
          cannon2_Body = loadImage("Air Body_Flipped.png");
        }
        break;
      case 2: 
        {
          randomEnemy = "Water Tribe";
          cannon2 = loadImage("Water Cannon_Symbol_Flipped.png");
          cannon2_Body = loadImage("Water Body_Flipped.png");
        }
        break;

      case 3: 
        {
          randomEnemy = "Earth Kingdom";
          cannon2 = loadImage("Earth Cannon_Symbol_Flipped.png");
          cannon2_Body = loadImage("Earth Body_Flipped.png");
        }
        break;
      case 4: 
        {
          randomEnemy = "Fire Nation";
          cannon2 = loadImage("Fire Cannon_Symbol_Flipped.png");
          cannon2_Body = loadImage("Fire Body_Flipped.png"); 
        }
        break;
    }

  size(1200,800);
  background(2355,255,255);
  cHandle1= new CannonballHandler();
  cHandle2 = new CannonballHandler();
}
void draw()
{
  background(255,255,255);
  image(bg,0,0);
  
  if(mainMenu)
  {
    image(menu,0,0);
    myFont = createFont("Slayer", 24);
    textFont(myFont);
    fill(0, 102, 153);
    textAlign(CENTER,CENTER);
    
    text("Long ago, the four nations lived together\nin harmony. But everything changed when the\n "+randomEnemy + " attacked.", width/2, 150);
    String instructions = "Click a character to start the game\n\n\nFirst to 21 wins.\nWatch out, the cannonballs only hit the base of the tank!";
    text(hoverName(),width/2 +5,550);
    textFont(myFont,18);
    line(0,700,1200,700);
    text(instructions,width/2 +5,700);
    textFont(myFont,12);
    text("More characters\ncoming soon...",900,375);
  }
  else
  {
    final int RP_X = 24; //rotational point
    final int RP_Y = cannon1.height/2; //rotational point
    line(0,700,1200,700);
    
    checkEndGame();
    //Play the game
    
    
    if (!endGame)
    {
      image(keyDirections,0,700);
      keyHandle(RP_X,RP_Y);
      cHandle1.update(); //cannonballs from P1
      cannon1_DMG = cHandle1.getDMG(1);
      cHandle2.update(); // Cannonballs from P2
      cannon2_DMG = cHandle2.getDMG(2); // handles keypresses
      drawEverything(RP_X,RP_Y);
      
      textFont(myFont,24);
      textAlign(LEFT);
      text("Score: "+cannon1_DMG,50,650);
      textAlign(RIGHT);
      text("Score: "+cannon2_DMG,1100,650);
    }
    else
    {
      drawEverything(RP_X,RP_Y);
      drawWinLose();
      PImage endShadow = loadImage("endShadow.png");
      image(endShadow,0,0);
    }   
   image(bgWall,0,525);
  }
  

}

// SUB-Draw Methods ====================================== SUB-Draw Methods ======================================
void drawEverything(int RP_X,int RP_Y)
{
  drawTanks(RP_X,RP_Y); // on base layer
    
    pushMatrix(); //For 2x Rotating shapes
    pushMatrix(); // ^
    drawCannon1(RP_X,RP_Y); //Draws Cannon1
    popMatrix();   //pops it back down to Cannon2's layer
    drawCannon2(RP_X,RP_Y); //draws Cannon2
    popMatrix();   // pops it back down to main layer
}

void drawTanks(int RP_X, int RP_Y)
{
  image(cannon1_Body,cannon1_X + RP_X     -47 ,490);
  image(cannon2_Body,cannon2_X + 1200-RP_X-103, 490);
}


void drawCannon1(int RP_X, int RP_Y)  
{
  cannon1.resize(87,41);
  translate(cannon1_X + RP_X,490+RP_Y); // moves plane to desired cannon1 spot
  rotate(radians(cannon1_Angle));      // rotates plane
  translate(-RP_X,-RP_Y);// ROTATES        // moves center of a cannon; cancels rotation offset
  image(cannon1,0,0);                  // draws cannon at top left of the plane
  
  
}

void drawCannon2(int RP_X, int RP_Y)
{  // same thing as before3
  cannon2.resize(87,41);
  translate(cannon2_X+1200-RP_X,  490 + RP_Y); //factors cannon2's X movement as well as rotational point
  rotate(radians(cannon2_Angle));
  translate(-cannon2.width+RP_X,-RP_Y);// Cancels rotation point  
  image(cannon2,0,0);
  
  
}

void drawWinLose()
{
  //player1
  int wpicY = 607, lpicY= 710;
  PImage winner = loadImage(getPicture(charSelected)+".png");
  PImage loser = loadImage(getPicture(enemyNum)+" lose.png");
  if (winLose == 2)
  {
    winner = loadImage(getPicture(enemyNum)+".png");
    loser = loadImage(getPicture(charSelected)+" lose.png");
    wpicY = 710;
    lpicY = 607;
  }
  myFont = createFont("Slayer", 24);
  textFont(myFont);
  fill(0, 102, 153);
  textAlign(CENTER,CENTER);
  text("P1", 50,647);
  text("P2",50,750);
  
  
  //Zuko's lost honor stuff. Just for lols.
  if (charSelected == 4)
    zukosHonor(winLose,wpicY,lpicY);
  else
  {
    text("I lost...",250,lpicY+40);      
    text("I won", 250, wpicY +40);
  }
  
  if (enemyNum == 4)
    zukosHonor(winLose,wpicY,lpicY);
  else
  {
    text("I lost...",250,lpicY+40);
    text("I won", 250, wpicY +40);
  }

  winner.resize(76,80);
  image(winner,100,wpicY);
  loser.resize(76,80);
  image(loser,100,lpicY);
}
void zukosHonor(int winLose, int wpicY, int lpicY)
{
        switch (winLose)
      {
        case 1: 
          text("I have regained my honour.",250,wpicY +40);
          text("I lost...",250,lpicY+40);
        break;
        case 2:
          text("I won", 250, wpicY +40);
          text("I lost my honor again", 250,lpicY+40);
        break;
    
      }
}
String getPicture(int x)
{
  String a = "";
  switch(x)
  {
    case 1: a = "aang";
    break;
    case 2: a = "katara";
    break;
    case 3: a = "toph";
    break; 
    case 4: a = "zuko";
    break;
  }
  return a;
}
// Functions ================ Functions
void checkEndGame()
{
  if (cannon1_DMG > 20)
  {
    endGame = true;
    keyDisabled = true;
    winLose = 1;
  }
  else if(cannon2_DMG > 20)
  {
    endGame = true;
    keyDisabled = true;
    winLose = 2;
  }
}

void fireCannon1(int RP_X, int RP_Y)
{ 
  Cannonball newball = new Cannonball(125,cannon1_Angle,cannon1_X + RP_X,490+RP_Y,1);
  cHandle1.add(newball, 1, RP_X,RP_Y);
}
void fireCannon2(int RP_X, int RP_Y)
{
  Cannonball newball = new Cannonball(-125,cannon2_Angle,cannon2_X+1200-RP_X,490 + RP_Y,2);
  cHandle2.add(newball, 2, RP_X,RP_Y);
}



// Input Manipulation ================================ Input Manipulation ================================
void mouseClicked()
{
  switch (charSelected)
  {
    case 1: 
    {
      cannon1 = loadImage("Air Cannon_Symbol.png");
      cannon1_Body = loadImage("Air Body.png");
      mainMenu = false;
      break;
    }
    case 2: 
    {
      cannon1 = loadImage("Water Cannon_Symbol.png");
      cannon1_Body = loadImage("Water Body.png");
      mainMenu = false;
      break;
    }
    case 3:
   { 
      cannon1 = loadImage("Earth Cannon_Symbol.png");
      cannon1_Body = loadImage("Earth Body.png");
      mainMenu = false;
      break;
   }
    case 4:
   { 
      cannon1 = loadImage("Fire Cannon_Symbol.png");
      cannon1_Body = loadImage("Fire Body.png");
      mainMenu = false;
      break;
   }
    case 0:
      break;
  }
  
}
String hoverName()
{
  String name = "";
  if ((mouseY >= 307) && (mouseY <= 448))
  {
    if ((mouseX >= 187) && (mouseX <= 332)){
        name = "Aang";
        charSelected = 1;
    }
    else if ((mouseX >= 349) && (mouseX <= 479)){
      name = "Katara";
      charSelected = 2;
    }
    else if ((mouseX >= 492) && (mouseX <= 632)){
      name = "Toph";
      charSelected = 3;
    }
    else if ((mouseX >= 646) && (mouseX <= 788)){
      name = "Zuko";
      charSelected = 4;
    }
    else
    {
      name = "";
      charSelected = 0;
    }
      
  }
  else
    {
      name = "";
      charSelected = 0;
    }
  
  return name;
}

// ======================= Key Manipulation  
void keyPressed()
{
  toggle(key,true);
}
void keyReleased()
{
  toggle(key,false);
  c1fired = false;
  c2fired = false;
}

void toggle(char key, boolean set)
{
  if(key == 'a')
    aKey = set;
  else if (key == 'd')
    dKey = set;
  else if (key == 'w')
    wKey = set;
  else if (key == 's')
    sKey = set;
  else if (key == 'x')
    xKey = set;

  if(key == 'j')
    jKey = set;
  else if (key == 'l')
    lKey = set;
  else if (key == 'i')
    iKey = set;
  else if (key == 'k')
    kKey = set;
  else if (key == 'm')
    mKey = set;
}
void keyHandle(int RP_X, int RP_Y)
{
  // =========Player1================
    // LEFT RIGHT
  if ((aKey && !dKey) && (cannon1_X > 0))
      cannon1_X-=4;
  else if ((dKey && !aKey) && (cannon1_X <= 210))
    cannon1_X+=4;
    
  //ANGLE UP DOWN  
  if ((wKey && !sKey) && (cannon1_Angle > -90))
    cannon1_Angle -=2;
  else if ((sKey && !wKey) && (cannon1_Angle < 0 ))
    cannon1_Angle +=2;
     

  
  
  // =========Player2================
    if ((jKey && !lKey) && (cannon2_X>=-210))
    cannon2_X-=4;
  else if ((lKey && !jKey) && ((cannon2_X+1200-36)<1164))
    cannon2_X+=4;
    
    
  if ((iKey && !kKey) && (cannon2_Angle < 90))
    cannon2_Angle += 2;
  else if ((kKey && !iKey) && (cannon2_Angle > 0))
    cannon2_Angle -=2;
    
   // fire
  if ((xKey) &&(c1fired == false)){
    fireCannon1(RP_X, RP_Y);
    c1fired = true;    
  }
  if((mKey)&&(c2fired == false)){
    fireCannon2(RP_X, RP_Y);
    c2fired = true;
  }
    
}

// =========================== Classes =========================== Classes =========================== Classes ===========================


class CannonballHandler
{
  ArrayList<Cannonball> balls;
  int player;
  int c1DMG, c2DMG, RP_X, RP_Y;
  public CannonballHandler()
  {
    balls = new ArrayList <Cannonball>(10000);
  }
  
  void add(Cannonball c, int player, int RP_X, int RP_Y) 
  {
    balls.add(c);
    this.player = player;
    this.RP_X = RP_X;
    this.RP_Y = RP_Y;
  }
  
  void update()
  {
    for (int x = 0; x < balls.size(); x++)
    {
      if (balls.get(x).getLanded() == true)
        balls.remove(x);
      else
      {
        Cannonball c = balls.get(x);
        c.step();
        switch (player)
        {
          case 1:
          //
           if ((c.getHorzPos() > cannon2_X + 1200-RP_X-103)
           && (c.getHorzPos() <  cannon2_X + 1200-RP_X-103+cannon2_Body.width) 
           && (c.getVertPos() > cannon2_Body.height/2 +490)
           && (c.getVertPos() < cannon2_Body.height + 490)){
                c2DMG++;
                c.setLanded(true);
           }
          break;
          case 2:
           if ((c.getHorzPos() > cannon1_X -47) 
           && (c.getHorzPos() <  cannon1_X + cannon1_Body.width -47)
           && (c.getVertPos() > cannon1_Body.height/2 + 490)
           && (c.getVertPos() < cannon1_Body.height  + 490)){
                c1DMG++;
                c.setLanded(true);
           }
          break;
        }
      }//switch
    }//forloop
  }//update
  
  int getDMG(int player)
  {
    if (player == 1)
      return c2DMG;
    if (player == 2)
      return c1DMG;
    
    return -1;
  }
}

class Cannonball 
{
  private static final double DELTA = 0.02; 
  
  private static final double GRAV = 9.81;
  
  
  private double veloX, veloY,distX,distY, t; // current velocity in vertical direction(m/s)
  private double startX, startY;
  private int player;
  boolean landed;

  public Cannonball (double initVelocity, double fireAngle,double startX, double startY, int player)
  {
    if (fireAngle != 90)
      veloX = initVelocity * Math.cos(Math.toRadians(fireAngle));
    else
      veloX = 0;
    
    veloY = initVelocity * Math.sin(Math.toRadians(fireAngle));
    distX = startX;
    distY = startY;
    
    this.startX = startX;
    this.startY = startY;
    this.player = player;
  }

  public void step()
  {
    distX += ((veloX*1.5) * DELTA);
    distY += ((veloY*1.5) * DELTA);
    // veloX is constant until ball hits ground
    veloY += 2 * GRAV * DELTA;
    
    drawballs();
  }

    public void drawballs()
  {
    fill(100);
    ellipse((float)distX,(float)distY,5,5);
    checkLanded();
  }
  
  public float getHorzPos()
  {
    return (float)distX;
  }
  
  public float getVertPos()
  {
    return (float)distY;
  }
  private void checkLanded()
  {
    if ((distX >= 1250) || (distX <=-50) || (distY >= 590))
      landed =true;
  }
  public boolean getLanded()
  {
    return landed;
  }
  
  public void setLanded(boolean x)
  {
    landed = x;
  }
}

