#include <SPI.h>

const byte slaveSelectPin = 10;  // SS pini
int dataArray[] = {1,2,3,4,5,6,7,8,9,10};
const int arraySize = sizeof(dataArray) / sizeof(dataArray[0]);

void setup() {
  Serial.begin(9600);

  pinMode(slaveSelectPin, OUTPUT);
  digitalWrite(slaveSelectPin, HIGH); // Slave'i pasif yap
  
  SPI.begin(); // SPI başlat
  SPI.setClockDivider(SPI_CLOCK_DIV16); // SPI hızı ayarla
}

void loop() {
  for (int i = 0; i < arraySize; i++) {
    sendToSlave(dataArray[i]);
    delay(1000); // 1 saniye bekle
  }

  delay(1000); // Tüm veriler gönderildikten sonra 1 saniye dur
}

void sendToSlave(byte data) {
  digitalWrite(slaveSelectPin, LOW);   // Slave'i seç
  SPI.transfer(data);                  // Veriyi gönder
  digitalWrite(slaveSelectPin, HIGH);  // Slave'i bırak

  Serial.print("Gönderilen veri: ");
  Serial.println(data);
}
