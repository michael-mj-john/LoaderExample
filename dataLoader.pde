/* DataLoader demo
by MJ
11/30/18
Demonstrates how to integrate realtime tweaking into your game
allowing you to tweak gameplay variables without having to restart
the software.
*/

BufferedReader reader;
String line;

//because this is going to be a pretty big performance hit, I want to be 
//able to switch it on and off easily using this boolean (in C++ I would do 
//this with the preprocessor)
boolean debug = true; 
int loadInterval = 5; //seconds before reloading params file
int lastLoad;

//basic "move ball" demo
Ball ball;
int xSpeed;
int ySpeed;
int[] parameters;

void setup() {
  size( 800, 600 ); 
  ball = new Ball();
  readFromFile(); //I'll load the parameters first, even when not in debug mode  
}

void draw() {
  
  ball.update( xSpeed, ySpeed );
  ball.render();
  
  //I definitely don't want to do this every frame. This demo uses
  //a five second load interval
  if( debug ) {
    if( millis() > (lastLoad + loadInterval*1000) ) {
      readFromFile();
    }
  }
  
}


/*This function loads gameplay parameters from a file called "data.txt"
"data.txt" must be in the same directory as the .pde file
Error handling could be better. 
Note that data.txt format is name/value pairs, tab separated
*/
void readFromFile() {
  reader = createReader("data.txt"); 
  if( reader == null ) { 
    println( "open failure" ); 
    return;
  }
  //must re-size this array depending on how many parameters you are using (an ArrayList would be better)
  int parameterArray[] = new int[2]; 
  int i=0;

 // this is one of the rare places where a "do" loop is called for
 do {
   //'try/catch' is Java's exception handling. I am not an expert in this, 
   //this is based on example code. When you hit the end of the file,
   //it throws an exception, which is "caught" and the program moves on.
   //(it seems like there should be a more elegant way to do this)
   try {
      line = reader.readLine(); // this is a "buffered read", a Processing feature
    } 
    catch (IOException e) {
      e.printStackTrace(); //not really a necessary line
      line = null;
    }
    if( line != null ) {
      String[] params = split( line, TAB ); //"split" is a common String function. note that this means your data file must be TAB separated fields
      println( params[0], params[1] ); //just a debug feature
      parameterArray[i++] = Integer.valueOf(params[1]);//inserting file values into my parameters array
    }
  }
  while (line != null); // end of "do-while" loop
  
  // assign loaded parameters to gameplay variables 
  xSpeed = parameterArray[0];
  ySpeed = parameterArray[1];
  
  lastLoad = millis();
  
}

/*
simple 'Ball' class just to create an interactive demo
to show loading parameters from a file.
*/
class Ball {
  PVector position;
  
  Ball() {
    position = new PVector( width/2, height/2 );
  }
  
  void update( int xSpeed, int ySpeed ) {
    if( keyPressed ) {
      switch( key ) {
        case 'd':
          position.x += xSpeed;
          break;
        case 'a':
          position.x -= xSpeed;
          break;
        case 'w':
          position.y -= ySpeed;
          break;
        case 's':
          position.y += ySpeed;
          break;
      }
    }
  }
  
  void render() {
    ellipse( position.x, position.y, 30, 30 );
  }

}
