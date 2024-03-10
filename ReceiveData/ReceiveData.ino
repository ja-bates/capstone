void setup() {

  // initialize digital pin LED_BUILTIN as an output.
   Serial.begin(115200);

   pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:

  // Check if data is available to read
  if (Serial.available() > 0) {
    // Read the incoming byte:
    String incomingData = Serial.readString();
    //Serial.readStringUntil('\n'); // Read the incoming data until newline character
    //delay(2000); 
    // Print the incoming data to the Serial Monitor
    Serial.println("Received: ");
    Serial.println(incomingData);

    if (incomingData == "Testing Testing") {
      digitalWrite(LED_BUILTIN, HIGH);   // turn the LED on (HIGH is the voltage level)

    }
  }              
}
