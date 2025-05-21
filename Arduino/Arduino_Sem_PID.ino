#define pino_D0 2 // leitor de pulsos
#define pino_PWM 11
#define pino_IN1 10
#define pino_IN2 5
#define pino_IN3 6

unsigned long TempoAntigo;
int Pulsos = 0;

double rpm = 0;   

void setup() {
  pinMode(pino_D0, INPUT);
  attachInterrupt(digitalPinToInterrupt(pino_D0), Contagem, RISING);
  
  pinMode(pino_PWM, OUTPUT);
  pinMode(pino_IN1, OUTPUT);
  pinMode(pino_IN2, OUTPUT);
  pinMode(pino_IN3, OUTPUT);

  Serial.begin(9600);

  digitalWrite(pino_IN1, LOW);
  analogWrite(pino_PWM, 255);
  digitalWrite(pino_IN2, LOW);
  digitalWrite(pino_IN3, LOW);

  TempoAntigo = millis();
}

void loop() {
  if (millis() - TempoAntigo >= 1000) { 
    detachInterrupt(digitalPinToInterrupt(pino_D0)); 

    rpm = CalcularRPM(); 
    Serial.println(rpm);

    TempoAntigo = millis(); 
    Pulsos = 0;

    attachInterrupt(digitalPinToInterrupt(pino_D0), Contagem, RISING); 
  }
}

void Contagem() {
  Pulsos ++;
}

int CalcularRPM() {
  unsigned long TempoDecorrido = millis() - TempoAntigo; 
  float Revolucoes = Pulsos / 120.0;
  return (Revolucoes * 60000) / TempoDecorrido;
}
