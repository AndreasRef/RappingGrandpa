import rita.*;
import java.util.*;

import guru.ttslib.*;

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
BeatDetect bd;
BeatListener bl;
TTS tts;

boolean displayText = false;
long time;

float[] fNums = new float[13];

int minScale = 0;
int maxScale = 900;
int xStart  = 10;
int xOffset = 90;


int numAssets = 100;
int[] pickedFreq = new int[numAssets];
PVector[] pickedLoc = new PVector[numAssets];
color[] clr = {#000000,#111111,#202020,#242424,#333333,#4d4d4d,#666666,#999999,#CCCCCC,#FFFFFF,#FF3300,#0095A8,#00616F};




PImage grandpa;

String myText = "killer";

String masterSent = "";

int r1;
int r2;
int r3;
int r4;
int r5;
int r6;
String nouns[] = {
  "gold digger", "ass clown", "ass hat", "baller", "one reply bitch", "ex with benefits", "punk", "hater", "spicey edit", "outcast", "nerd freak", "ladies man", "Angel", "Lone Wolf", "Fan girl"
}; 
String verbs[] = {
  "cock blocked by Steve Jobs", "bitching out", "half assing it", "dropping a dime", "doggy styling", "piggin out", "wining and dining", "golfing", "booty calling your mother", "bearbording", "hustling", "hulking out", "hooking up", "dropping", "swaggering", "hating", "playing", "rolling on the floor laughing", "grinding", "pimping", "scamming",
};
String adjectives [] = {
  "sloppy", "baller", "fly", "hip", "gangsta", "dope", "dank", "deadly", "doggy style", "sweet", "hipster", "fugly", "weak", "punk ass", "hella", "janky", "fly", "snarky", "straight edge", "gnarly", "adorable", "precious", "lovely", "twee", "legit"
};
String lifeLessons [] = {
  "Chicks before dicks", "Boom shaka laka", "Thats what he said", "Fo shizzle my nizzle", "Come meet my cat", "Yada", "It has been real", "Leave Britney Alone", "Oh yeah", "And then I found five dollars", "This is actually happening", "What you see is what you get", "For life, homie", "Thug life chose me", "Nerd for life"
};

String like [] = {
  "like a", "style like", "a true", "friends called me", "as a", "high as a", "just call me", "know as", "hung like a"
};

String just [] = {
  "just", "only", "like", "you know", "everyday, just", "playerhate no", "all good, no", "this rhymes with", "this rhymes with", "never ever"
};



RiText rt, rts[];
RiWordNet wordnet;

RiLexicon lexicon;

void setup() 
{
  size(displayWidth, displayHeight);    
  
  grandpa = loadImage("niels.png");
  
  smooth();

  rectMode(CENTER);
  
  minim = new Minim(this);
  player = minim.loadFile("rappers_delight.mp3", 2048);
  player.setGain(-10);
  player.play();

  bd = new BeatDetect(player.bufferSize(), player.sampleRate());
  bd.setSensitivity(0);  
  bl = new BeatListener(bd, player);

  for (int i = 0; i < numAssets; ++i) {
    pickedFreq[i] = (int)random(fNums.length);

    PVector pt = new PVector();
    pt.x = (int)random(width);
    pt.y = (int)random(height+maxScale)-(maxScale/2);
    pickedLoc[i] = pt;
  }
  

  tts = new TTS();
  minim = new Minim(this);
  player = minim.loadFile("rappers_delight.mp3");
  //player.play();

  RiText.defaultFill(255);
  RiText.defaultFont("arial", 14);

  rt = new RiText(this, "random", 280, 40);
  rt.align(RIGHT).fontSize(36);



  lexicon = new RiLexicon();

  wordnet = new RiWordNet("/Users/andreasrefsgaard/Downloads/WordNet-3.1/WordNet-3.1/", false, false);
  RiTa.timer(this, 2.0);
}

void draw() 
{  
  background(0);
  noStroke();

  for (int i = 0; i < fNums.length; ++i) {
    if ( bd.isOnset( (i+1)*2 ) ) fNums[i]  = maxScale; // frequency bands / 2,4,6,8,10,12,14,16,18,20,22,24,26
    fNums[i] = constrain(fNums[i]  * 0.3, minScale, maxScale);
  }
  
  
  
  for (int i = 0; i < numAssets; ++i) {
    fill( clr[ pickedFreq[i] ], 255 );
    pushMatrix();
      translate(pickedLoc[i].x, pickedLoc[i].y);
      rotate((sin(frameCount/100.0)));
      rotate(radians(45));
      rect ( 0, 0, fNums[pickedFreq[i]], 10000 );
      rotate(radians(-90));
      rect ( 0, 0, fNums[pickedFreq[i]], 10000 );
    popMatrix();
  }
  
  
  fill(0,50);
  rect(width/2,height/2,width,height);
  
  fill(255);
  textAlign(CENTER);
  textSize(18);
  text("Give grandpa a word to freestyle with", width/2, 50);
  //text(myText, width/2, 100);
  textSize(72);
  text(myText, width/2, 150);

  r1 = int(random(nouns.length));
  r2 = int(random(verbs.length));
  r3 = int(random(lifeLessons.length));
  r4 = int(random(adjectives.length));
  r5 = int(random(like.length));
  r6 = int(random(just.length));

  
  
  
  
  
  imageMode(CENTER);
  pushMatrix();
  translate(width/2,height/1.9);
  rotate((sin(frameCount/10.0)*0.1));
  //image(grandpa,width/2,height/5.8, grandpa.width*1.5, grandpa.height*1.5 + y);
  image(grandpa,0,0, grandpa.width*0.65, grandpa.height*0.65);
  popMatrix();
  
  textSize(50);
  if (displayText) {
    fill(0,30);
    rect(width/2,height/2,width,height);
    fill(255);
    text(masterSent, width/2, height/2);
  }
  
}

void onRiTaEvent(RiTaEvent re) { // called every 2 seconds by timer   

  String[] tmp = {
  };    
  while (tmp.length < 1) {

    //String word = wordnet.getRandomWord("n");
    String word = myText;
    rt.text(word);
    //tmp = wordnet.getSoundsLike(word, "n",2);
    tmp = lexicon.rhymes(word);
  }    
  //Arrays.sort(tmp); // alphabetize the list
  if (tmp.length > 1) {


    masterSent = "Did you know, \n I used to be a " + adjectives[r4] + " " + nouns[r1] + ", " + like[r5] + " " + myText + ". \n I was " + verbs[r2] +", " + just[r6] + " " + tmp[1] + ". \n " + lifeLessons[r3] +"!";


  } else {
    masterSent = "Did you know, \n I used to be a " + adjectives[r4] + " " + nouns[r1] + ", " + like[r5] + " " + myText + ". \n I was " + verbs[r2] +", " + just[r6] + " " + tmp[0] + ". \n " + lifeLessons[r3] +"!";
    String test[] = {
      "Did you know I hate motherfucking " + tmp[0], "I have never seen such a whack " + tmp[0]
    };
    
  }
}

void keyPressed() {
  
  
  
  if (keyCode == BACKSPACE) {
    if (myText.length() > 0) {
      myText = myText.substring(0, myText.length()-1);
    }
  } else if (keyCode == DELETE) {
    myText = "";
  } else if (keyCode == ALT) {
  displayText =! displayText;
  }
    else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
    myText = myText + key;
  }
}

void mousePressed() {
  displayText = true;
}

void mouseClicked() {
  tts.speak(masterSent);
  displayText = false;
  
  
}

//void stop() {
//  player.close();
//  minim.stop();
//  super.stop();
//}

class BeatListener implements AudioListener {
  private BeatDetect bd;
  private AudioPlayer source;

  BeatListener(BeatDetect bd, AudioPlayer source) {
    this.source = source;
    this.source.addListener(this);
    this.bd = bd;
  }

  void samples(float[] samps) {
    bd.detect(source.mix);
  }

  void samples(float[] sampsL, float[] sampsR) {
    bd.detect(source.mix);
  }
}


