#include <AltSoftSerial.h>

AltSoftSerial s;
int m = 0;
int i = 0;
int j = 0;
char c = 0;
String buffer = "";


void init_stamp() {
  // pause in case there's any ringing in the circuit
  delay(8);
  // toss out any extra stuff in the buffer
  while( s.available() ) s.read();
  // blink four times
  for( int j = 0; j < 5; j++ ) { 
    s.print( "l0\r" );
    delay(50);
    s.print( "l1\r" );
    delay(50);
  }
  // enter quiecent mode
  s.print( "e\r" );
  
  delay(100);
  
  // flush serial port
  //while( s.available() ) {}
}

void off_stamp() {
  // turn off LED
  s.print( "l0\r" );
}

void select( int i ) {
  off_stamp();
  switch( i ) {
    case 0:
      digitalWrite( 2, LOW  );
      analogWrite(  3, 0    );
      break;
    case 1:
      digitalWrite( 2, HIGH );
      analogWrite(  3, 0    );
      break;
    case 2:
      digitalWrite( 2, LOW  );
      analogWrite(  3, 255  );
      break;
    case 3:
      digitalWrite( 2, HIGH );
      analogWrite(  3, 255  );
      break;
  }
  init_stamp();
}


void setup() {
  pinMode(2, OUTPUT); // set MUX pin 1
  pinMode(3, OUTPUT); // set MUX pin 2
  
  Serial.begin(19200);
  s.begin(38400);
  
  Serial.println( "Atlas Shield test." );
  for( int m = 0; m < 4; m++ ) {
    Serial.print( "Port " + String(m) + " : " );
    select( m );
    s.print( "i\r" );
    delay( 500 );
    buffer = ""; c = 0;
    while(s.available()) {
      c = s.read();
      buffer += c;
      if( c == '\r' ) {
        Serial.println( buffer );
        break;
      }
    }
  }
  m = 0;
}

void loop() {
  select( m );
  Serial.print( String(m) + " : " );
  s.print( "r\r" );
  buffer = ""; c = 0;
  delay( 1000 );
  while(s.available()) {
    c = s.read();
    buffer += c;
    if( c == '\r' ) {
      Serial.println( buffer );
      break;
    }
  }
  m++;
  if ( m == 4 ) m = 0;  
}
