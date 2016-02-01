import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import java.util.*;

Twitter twitter;

//String is not needed anymore, can leave it here for now as a note
//Incase we want to put it back in, pass it through the Query object.
String search = "Dublin";


int currentTweet;
boolean nextPage = false;
QueryResult result;
//Arraylist to store the status (the tweet);
List<Status> tweets;

//Going to put in a switch to turn on and off the get tweets function
int tweetsOnOffSwitch = 1;

// To store the XML file location.
XML xmlFile;

Interface myInterface;
/*
The “Consumer Key”: LuxDk9NaQOvqqQkn9LOXmwBY1
The “Consumer Secret”: 0IANaFy2X3qNx6rKc3drLit6kG7ETPOGBZD1GYL5YSopZiw5j2
The “Access Token”: 537618780-TnQbYM3IS88usjTURUFyX2QJTL2kwBZemAqOCQKu
The “Access Token Secret”: CWwSNlbOajW0cxG211yfCOaLS5SYurJGWeoVEUNxiBUYL
 */

void setup() {
  size(800, 600);
  
  xmlFile = loadXML("storeTweets.xml");
  
  myInterface = new Interface(800,50,0,550); //Initiate the interface
  
  ConfigurationBuilder cb = new ConfigurationBuilder();

  cb.setOAuthConsumerKey("LuxDk9NaQOvqqQkn9LOXmwBY1");
  cb.setOAuthConsumerSecret("0IANaFy2X3qNx6rKc3drLit6kG7ETPOGBZD1GYL5YSopZiw5j2");
  cb.setOAuthAccessToken("537618780-TnQbYM3IS88usjTURUFyX2QJTL2kwBZemAqOCQKu");
  cb.setOAuthAccessTokenSecret("CWwSNlbOajW0cxG211yfCOaLS5SYurJGWeoVEUNxiBUYL");

  TwitterFactory tf = new TwitterFactory(cb.build());

  twitter = tf.getInstance();

  getNewTweets();

  currentTweet = 0;
}

void draw() {
  fill(0, 40);
  rect(0, 0, width, height);

  currentTweet = currentTweet +1;
  background(0);

  myInterface.paint();
  
  //Im wondering about this piece here, the tweets.size is 100 (can be max 100)
  //We add 1 to currentTweet and when it is == 100, we reset it to 0.
  //Maybe here when the current tweet is == 100, we fire off a function that calls the next 100 tweets?
  //Will do some research and try test it out.
  
  //Tested it and it works!!
  //When currentTweet is 100, it must be time to go onto the next page
  //Set nextPage to true and then call the getNewTweets() function.
  if (currentTweet >= tweets.size()) {
    currentTweet = 0;
    nextPage = true;
    getNewTweets();
  }
  println(tweets.size());
  
  /*http://twitter4j.org/javadoc/twitter4j/Status.html*/
  Status status = tweets.get(currentTweet);
  //I found this part a little confusing
  //First we get the current tweet
  //We store it in a status object,
  //Then we can make a User object, then put the status.user property(its in JSON) into that object
  //then we can get different attributes associated with it.
  User user = status.getUser();
  
  //Running this piece of code returns when the tweets were created. 
  //Will store this in XML as well. 
  String storeDate = "" + status.getCreatedAt();
  
  //Ok, so tweets come up, but seems like some are repeated.
  //In order to eliminate these from being saved to the XML file and being false data
  //One possible solution is we must get each ones id, then compare it to the rest of the IDs.
  //And only add it to the XML file if the ID is unique. For loop, load XML, check then add or delete.
  
  //The id is in the data type LONG
  //In order to convert to string I had to use concatenation. 
  long idLong = status.getId();
  String longString = "" + idLong;
  fill(200);
  
  //Space switches the number
  //Control to turn it on and off
  if(tweetsOnOffSwitch == 1) {
     text(status.getText(), 100, 100, 300, 200);
     text(user.getName(), 200, 300, 300, 200);
     text(longString,300,300,300,200);
     println(status.getCreatedAt());
     delay(100);
  }
  
  //Declaring a new XML object to add to the file  
  //Set its content to == the tweet text
  
  XML newChild = xmlFile.addChild("tweet");  
  newChild.setContent(status.getText());
  //give the tweet an ID attribute
  newChild.setString("tweet-id", longString);
  //give the tweet a userName attribute
  newChild.setString("tweet-name", user.getName());
  //give the tweet a date attribute
  newChild.setString("tweet-date", storeDate);
  //Have cleaned this up and removed the old method i was using.
  //Not sure if theres other pieces we should add.
  
}

void mouseClicked() {
  deleteTweets(); // Call the delete function from the Handler
  saveTweets();// Call the saveTweets function from the Handler
  pauseTweets();// Call the pauseTweets function from the Handler
}