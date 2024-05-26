// Definir Pinos
#define pino_D0 2 // leitor de pulsos
#define pino_PWM 11
#define pino_IN1 10
#define pino_IN2 5
#define pino_IN3 6

// Variáveis Gllobais
int x = 0;
unsigned long ultimo_tempo;

void setup() {

  // Configuração dos Pinos
  pinMode(pino_D0, INPUT); // leitor de pulsos
  attachInterrupt(digitalPinToInterrupt(pino_D0), contagem, RISING);
  pinMode(pino_PWM, OUTPUT);
  pinMode(pino_IN1, OUTPUT);
  pinMode(pino_IN2, OUTPUT);
  pinMode(pino_IN3, OUTPUT);

  Serial.begin(9600);

  digitalWrite(pino_IN1, LOW);
  analogWrite(pino_PWM, 255);
  digitalWrite(pino_IN2, LOW);
  digitalWrite(pino_IN3, LOW);

  ultimo_tempo = millis();

}   // setup

void loop() {

if (millis() - ultimo_tempo >= 100) { // Atualiza o contador a cada 0,1s

    // Desabilita interrupção durante o cálculo
    detachInterrupt(digitalPinToInterrupt(pino_D0));

    int rpm = RPM();

    Serial.print("RPM = ");
    Serial.println(rpm);

    // Atualiza o tempo
    ultimo_tempo = millis();

    x = 0;

    // Habillita novamente
    attachInterrupt(digitalPinToInterrupt(pino_D0), contagem, RISING);
  }  // if

}   // loop

// Função para a contagem de pulsos
void contagem() {
  x += 1;

}   // contagem

// Função para o cálculo do RPM
int RPM() {

  // Calcula o tempo decorrido desde a última medição
  unsigned long tempo_decorrido = millis() - ultimo_tempo; 

  int rpm = (60 * 1000 / 51) / tempo_decorrido * x;

  return rpm;
}  // RPM
