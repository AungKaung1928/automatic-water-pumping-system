// Automatic Water Pumping System
// ME-41032 - Group 8 Project
// Ultrasonic sensor controls water pump based on tank levels

// Pin definitions
const int trigPin = 2;     // Ultrasonic sensor trigger pin
const int echoPin = 3;     // Ultrasonic sensor echo pin
const int relayPin = 8;    // Relay control pin for pump
const int ledPin = 13;     // Built-in LED for status

// System parameters
const float tankHeight = 20.0;  // Small demo tank height in cm
const float lowerThreshold = 6.0;  // Turn pump ON when water level below this
const float upperThreshold = 15.0; // Turn pump OFF when water level above this
const float maxDistance = 400.0;   // Maximum sensor range in cm

// Variables
float distance;
float waterLevel;
bool pumpStatus = false;
unsigned long lastReading = 0;
const unsigned long readingInterval = 500; // Read sensor every 0.5 seconds

void setup() {
  // Initialize serial communication
  Serial.begin(9600);
  
  // Configure pins
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(relayPin, OUTPUT);
  pinMode(ledPin, OUTPUT);
  
  // Initial state - pump OFF
  digitalWrite(relayPin, LOW);
  digitalWrite(ledPin, LOW);
  
  Serial.println("Automatic Water Pumping System Started");
  Serial.println("Tank Height: " + String(tankHeight) + " cm");
  Serial.println("Lower Threshold: " + String(lowerThreshold) + " cm");
  Serial.println("Upper Threshold: " + String(upperThreshold) + " cm");
  Serial.println("-----------------------------------");
}

void loop() {
  // Check if it's time for a new reading
  if (millis() - lastReading >= readingInterval) {
    // Measure distance using ultrasonic sensor
    distance = measureDistance();
    
    // Calculate actual water level
    // Formula: Actual water level = Tank height - Distance
    if (distance > 0 && distance <= maxDistance) {
      waterLevel = tankHeight - distance;
      
      // Ensure water level is within valid range
      if (waterLevel < 0) waterLevel = 0;
      if (waterLevel > tankHeight) waterLevel = tankHeight;
      
      // Control logic with hysteresis
      controlPump();
      
      // Display readings
      displayStatus();
      
    } else {
      Serial.println("Sensor Error: Invalid distance reading");
    }
    
    lastReading = millis();
  }
}

float measureDistance() {
  // Clear the trigger pin
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  
  // Send ultrasonic pulse
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  // Read the echo pin and calculate distance
  long duration = pulseIn(echoPin, HIGH);
  
  // Convert time to distance (cm)
  // Using formula from slide: Distance = 340000/T (modified for Arduino)
  // Speed of sound = 340 m/s, round trip consideration
  float dist = (duration * 0.034) / 2;
  
  return dist;
}

void controlPump() {
  // Hysteresis control to prevent rapid on/off switching
  if (!pumpStatus && waterLevel <= lowerThreshold) {
    // Turn pump ON when water level is low
    pumpStatus = true;
    digitalWrite(relayPin, HIGH);
    digitalWrite(ledPin, HIGH);
    Serial.println(">>> PUMP TURNED ON <<<");
    
  } else if (pumpStatus && waterLevel >= upperThreshold) {
    // Turn pump OFF when water level is high
    pumpStatus = false;
    digitalWrite(relayPin, LOW);
    digitalWrite(ledPin, LOW);
    Serial.println(">>> PUMP TURNED OFF <<<");
  }
}

void displayStatus() {
  Serial.print("Distance: ");
  Serial.print(distance, 1);
  Serial.print(" cm | Water Level: ");
  Serial.print(waterLevel, 1);
  Serial.print(" cm | Pump: ");
  Serial.print(pumpStatus ? "ON" : "OFF");
  
  // Show status relative to thresholds
  if (waterLevel <= lowerThreshold) {
    Serial.println(" [LOW - NEED WATER]");
  } else if (waterLevel >= upperThreshold) {
    Serial.println(" [HIGH - SUFFICIENT]");
  } else {
    Serial.println(" [NORMAL - FILLING]");
  }
}
