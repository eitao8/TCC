#include <PID_v1.h>

#define pino_D0 2 // Leitor de pulsos
#define pino_PWM 11
#define pino_IN1 10
#define pino_IN2 5
#define pino_IN3 6

double setpoint = 60;  
double rpm = 0;     
double output = 0;    

double Kp = 2;
double Ki = 1;
double Kd = 0;

PID ControladorPID(&rpm, &output, &setpoint, Kp, Ki, Kd, DIRECT);

unsigned long TempoAntigo;
int Pulsos = 0;

void setup() {
  pinMode(pino_D0, INPUT);
  attachInterrupt(digitalPinToInterrupt(pino_D0), Contagem, RISING);

  pinMode(pino_PWM, OUTPUT);
  pinMode(pino_IN1, OUTPUT);
  pinMode(pino_IN2, OUTPUT);
  pinMode(pino_IN3, OUTPUT);

  Serial.begin(9600);

  digitalWrite(pino_IN1, LOW);
  analogWrite(pino_PWM, 0); 
  digitalWrite(pino_IN2, LOW);
  digitalWrite(pino_IN3, LOW);

  controladorPID.SetMode(AUTOMATIC); 
  controladorPID.SetOutputLimits(0, 255); 
  
  TempoAntigo = millis();
}

void loop() {
  if (millis() - TempoAntigo >= 1000) { 
    detachInterrupt(digitalPinToInterrupt(pino_D0)); 
    
    rpm = CalcularRPM();

    ControladorPID.Compute();
    analogWrite(pino_PWM, (int)output);

    Serial.println(rpm);

    TempoAntigo = millis();
    Pulsos = 0;
    
    attachInterrupt(digitalPinToInterrupt(pino_D0), Contagem, RISING);
  }
}

void Contagem() {
  Pulsos++;
}

float CalcularRPM() {
  unsigned long TempoDecorrido = millis() - TempoAntigo;
  float Revolucoes = Pulsos / 120.0;
  return (Revolucoes * 60000) / TempoDecorrido;
}
