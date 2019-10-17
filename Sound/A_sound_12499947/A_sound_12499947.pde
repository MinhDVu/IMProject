
/****COPY******/
/*****FROM*****/
import beads.*;
import org.jaudiolibs.beads.*;
import java.math.RoundingMode;

AudioContext ac;
Gain g;
Envelope rate;
SamplePlayer hit;
Glide freqSlider;


StopWatchTimer sw = new StopWatchTimer();
int flag = 0;
boolean hold = false;


String timeInterval = "";
float pace = 1.2;
float MIN_INTERVAL = 10;
float MAX_INTERVAL = 300;
float MIN_PACE = 0.1;
float MAX_PACE = 2.4;
/****TO******/

color background;



void setup(){
size(400, 400);
background = color(98, 133, 156);
ellipseMode(RADIUS);
sw.start();
}

void draw(){
  background(background);
  if(flag > 1){
    displayTime(""+timeInterval,width/2,(height/2)-75,25);
  }
  displayTime(getTimeString(),width/2,(height/2),30);
  displayFreq(pace,width/2,(height/2)+30,25);
  
}

void displayFreq(float p,int x,int y,int size){
  textAlign(CENTER);
  textSize(size);
  text("Pace: "+Math.round(pace * 100.0) / 100.0,x,y);
  fill(255);

}

void displayTime(String t,int x,int y,int size){
  fill(255);
  textAlign(CENTER);
  textSize(size);
  text(t,x,y);
}

String getTimeString(){
  String time = sw.second()+"."+sw.milisecond();
  return time;
}

float getTime(){
  float interval = sw.milisecond();
  return interval;
}

void keyPressed(){
  if(key == ' '){
    if(flag ==0){
      sw.start(); /*run this line when program starts*/
      flag++;
    }
    else{
      flag++;
      /*****FROM here*****/
      /*Run these lines when object hit the edges*/
      timeInterval = getTimeString();
      float t = getTime();
      if(t > 300){
      t = 300;
      }
      pace = (MAX_PACE+0.1) - map(t,MIN_INTERVAL,MAX_INTERVAL,MIN_PACE,MAX_PACE); 
      sw.stop();
      sw.start();
    } //ignore }
    playHit();
    /*****TO here*****/
  }
  
  if(key =='a'){
    playCorner(); /*Run this line when object hit the corner*/
    background(0);
  }
}

/*****FROM here*****/
/**Copy 2 function**/

void playHit(){
  ac = new AudioContext();
  freqSlider =new Glide(ac, 0, 1000);
  hit = new SamplePlayer(ac, SampleManager.sample(dataPath("hit.mp3")));
  float pan = map(mouseX,0,width,-1,1); /*Replace mouseX with object x-coord*/
  Panner p = new Panner(ac, pan); 
  g = new Gain(ac, 1, 0.5);
  rate = new Envelope(ac, pace); 
  hit.setRate(rate);
  p.addInput(hit);
  g.addInput(p);
  ac.out.addInput(g);
  ac.start();
}

void playCorner(){
  ac = new AudioContext();
  freqSlider =new Glide(ac, 0, 1000);
  hit = new SamplePlayer(ac, SampleManager.sample(dataPath("fireworks.wav")));
  float pan = map(mouseX,0,width,-1,1); /*Replace mouseX with object x-coord*/
  Panner p = new Panner(ac, pan);
  g = new Gain(ac, 1, 0.5);
  p.addInput(hit);
  g.addInput(p);
  ac.out.addInput(g);
  ac.start();
}

/*****TO here*****/