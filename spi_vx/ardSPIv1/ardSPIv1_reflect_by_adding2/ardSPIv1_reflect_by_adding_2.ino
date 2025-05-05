#include <SPI.h>

volatile byte receivedData = 0;
volatile byte replyData = 0;  // Bu veriyi SPDR’ye yazacağız
volatile bool dataReady = false;

void setup() {
  pinMode(MISO, OUTPUT); // Slave sadece MISO’ya çıkış yapar

  SPCR |= _BV(SPE);           // SPI Enable
  SPI.attachInterrupt();      // SPI veri geldiğinde interrupt çağrılır

  Serial.begin(9600);
}

// SPI veri geldiğinde otomatik çağrılır
ISR(SPI_STC_vect) {
  receivedData = SPDR;        // Master'dan gelen veri
  SPDR = replyData;           // Önceki veri + 2, şimdi Master’a gönderiliyor

  replyData = receivedData + 2;  // Sonraki tur için hazırla
  dataReady = true;
}

void loop() {
  if (dataReady) {
    Serial.print("Received from Master: ");
    Serial.print(receivedData, HEX);
    Serial.print(" | Will reply: ");
    Serial.println(replyData, HEX);
    dataReady = false;
  }
}
