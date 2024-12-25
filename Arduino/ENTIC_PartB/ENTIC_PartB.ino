// Includes the Servo library
#include <Servo.h> 

// Defines Trig and Echo pins of the Ultrasonic Sensor
const int trigPin = 10;
const int echoPin = 11;
const int servoPin = 12;

Servo myServo; // Creates a servo object for controlling the servo motor

void setup() {
  pinMode(trigPin, OUTPUT); // Sets the trigPin as an Output
  pinMode(echoPin, INPUT);  // Sets the echoPin as an Input
  myServo.attach(servoPin); // Defines on which pin is the servo motor attached
  Serial.begin(9600);
}

void loop() {
  // rotates the servo motor from 0 to 180 degrees
  for(int i=0;i<=180;i++){  // Ultrasonic sensor has 
    readAndPrint(i,myServo);
    delay(100);
  }
  // Repeate previous lines from 179 to 0 degrees
  for(int i=179;i>0;i--){ 
    readAndPrint(i,myServo);
    delay(100);
  }
}

// Function for calculating the distance measured by the Ultrasonic sensor
float calculateDistance(){ 
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2);
  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  int duration = pulseIn(echoPin, HIGH); // Reads the echoPin, returns the sound wave travel time in microseconds
  float distance= (duration)*0.0343/2; //in centimeters
  // Speed of sound = 343m/s = 0.0343cm/us
  // Dividimos entre 2 porque hemos medido el tiempo que tarda 
  // el pulso en ir y volver.
  return distance;
}

void readAndPrint(int pos, Servo servo) {
    servo.write(pos);
    
    int pressure = analogRead(A0);  
    Serial.print(pressure); // Sends the currect pressure value into the Serial Port
    Serial.print("\t");
    int temp = analogRead(A1);  // Sends the current temperature value into the Serial Port
    Serial.print(temp);
    Serial.print("\t");
    
    float distance = calculateDistance(); 
      // Calls a function for calculating the distance measured by the Ultrasonic sensor for each degree
    Serial.print(pos);  // Sends the current degree into the Serial Port
    Serial.print("\t");
    Serial.println(distance); // Sends the distance value into the Serial Port
    // Arrival order: Pressure\tTemperature\tDegrees\tDistance\n
}