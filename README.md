# Projeto de Controle PID de Motor DC com Arduino e Simulink

Este repositório contém o projeto completo de modelagem, controle e análise de um motor de corrente contínua (CC) utilizando o controlador PID, com implementação no Arduino e simulações no Simulink/MATLAB.

## 📌 Objetivo

Desenvolver um sistema de controle PID para um motor DC utilizando o Arduino e comparar os resultados reais com simulações feitas no Simulink. O projeto visa avaliar a eficácia do modelo matemático da planta (função de transferência) e os efeitos práticos da implementação do controle em hardware.

---

## ⚙️ Tecnologias e Ferramentas Utilizadas

- **Arduino Nano**
- **Sensor Encoder com 120 furos**
- **Sensor LDR para leitura de pulsos**
- **Fonte 6V 0.6A**
- **MATLAB / Simulink (R2023b)**
- **Python 3.10**
- **Bibliotecas**: `PID_v1` (Arduino), `serial` (Python), `Control System Toolbox` (MATLAB)

---

## ▶️ Como Executar

### 1. Configurar e Rodar no Arduino
- Conecte o Arduino Nano com o sensor no motor DC.
- Faça upload de `Arduino_Sem_PID.ino` ou `Arduino_Com_PID.ino` (dependendo se deseja apenas medir ou controlar com PID).
- A comunicação usa baud rate de 9600.

### 2. Salvar Dados com Python
- Execute o script `salvar_dados.py` após iniciar o Arduino.
- Os dados serão salvos em um arquivo `.txt` no formato `Tempo(s) RPM`.

### 3. Análise no MATLAB
- Use o script `Analise_Dados.m` para ler os dados coletados e comparar com:
  - Modelo da função de transferência
  - Resultados das simulações no Simulink
- Os arquivos `simulink1.mat` e `simulink2.mat` gerados contêm os logs das simulações.

### 4. Simulação no Simulink
- Abra o arquivo `Controlador_TCC.slx`
- Rode duas vezes, salvando os dados em `simulink1.mat` e `simulink2.mat`

---

## 📊 Resultados

- Comparação entre dados reais e modelo FT.
- Comparação do PID implementado no Arduino com simulação no Simulink (v1 e v2).
- Avaliação crítica das diferenças e limitações práticas do sistema.

---

## 📝 Autor

**Eiti Parruca Adama**  
Engenharia da Computação  
Universidade Tecnológica Federal do Paraná (UTFPR)  
Email: *eitiadama@gmail.com*

---

## 📚 Referências

- Franklin, G.F., Powell, J.D., Emami-Naeini, A. (2015). *Feedback Control of Dynamic Systems*. Pearson.
- Ogata, K. (2010). *Modern Control Engineering*. Prentice Hall.
- Arduino PID Library: [https://playground.arduino.cc/Code/PIDLibrary/](https://playground.arduino.cc/Code/PIDLibrary/)
