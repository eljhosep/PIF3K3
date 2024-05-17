#include <LiquidCrystal.h>
#include <DHT.h>

#define DHTPIN 2     // Cambiar el pin al que está conectado el sensor DHT
#define DHTTYPE DHT11   // Tipo de sensor DHT (DHT11 o DHT22)

DHT dht(DHTPIN, DHTTYPE);
LiquidCrystal lcd(8, 9, 4, 5, 6, 7);

float temperatura = 0, a = 0, promtmp;
int num_mediciones = 0;

void setup() {
  lcd.begin(16, 2);
  Serial.begin(9600);
  dht.begin();
}

void loop() {
  delay(2000); // Espera 2 segundos entre mediciones

  // Lee la temperatura en grados Celsius
  temperatura = dht.readTemperature();

  // Verifica si la lectura fue exitosa
  if (isnan(temperatura)) {
    Serial.println("Error al leer el sensor DHT!");
    return;
  }

  lcd.setCursor(0, 0);
  lcd.print("Tomando Datos");

  lcd.setCursor(0, 1);
  lcd.print("De Temperatura...");

  delay(100);
  a = a + temperatura;
  num_mediciones++;

  // Si se han realizado 5 mediciones
  if (num_mediciones == 5) {
    promtmp = (a / 5) - 2; // Calcula el promedio de las mediciones y resta 2 grados
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Temperatura");

    lcd.setCursor(0, 1);
    lcd.print(promtmp);

    // Muestra el promedio de temperatura en el monitor serial
    Serial.println("Promedio de temperatura: " + String(promtmp) + " grados Celsius");

    // Reinicia las variables para la siguiente serie de mediciones
    a = 0;
    num_mediciones = 0;

    // Espera 5 minutos (300000 milisegundos) antes de iniciar una nueva serie de mediciones
    delay(300000);
  } else {
    // Espera 2 minutos (120000 milisegundos) antes de tomar la próxima medición
    delay(120000);
  }
}