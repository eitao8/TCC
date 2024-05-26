%% Limpeza
clear all;
clc;

%% Criando objeto arduino
a = arduino('COM4', 'Nano3');  % Cria um objeto Arduino

%% Pinos
pino_D0 = 'D2'; % leitor de pulsos
pino_PWM = 'D11';
pino_IN1 = 'D10';
pino_IN2 = 'D5';
pino_IN3 = 'D6';

%% Variáveis
x = 0;
ultimo_tempo = tic;
dados_rpm = []; % Vetor para armazenar os valores de RPM
dados_tempo = []; % Vetor para armazenar os tempos correspondentes
tempo_maximo = 5; % Tempo máximo de coleta em segundos

%% Configuração inicial
configurePin(a, pino_D0, 'DigitalInput'); % Leitor de pulsos
configurePin(a, pino_PWM, 'PWM');
configurePin(a, pino_IN1, 'DigitalOutput');
configurePin(a, pino_IN2, 'DigitalOutput');
configurePin(a, pino_IN3, 'DigitalOutput');

writeDigitalPin(a, pino_IN1, 0);
writeDigitalPin(a, pino_IN2, 0);
writeDigitalPin(a, pino_IN3, 0);
writePWMDutyCycle(a, 'D11', 1);

%% Loop principal
while true
    tempo_decorrido = toc(ultimo_tempo); % Calcula o tempo decorrido desde o último reset
    if tempo_decorrido >= tempo_maximo % Verifica se atingiu o tempo máximo
        break; 
    end
    
    if (tempo_decorrido >= 100) % Atualiza o contador a cada 100ms
        
        rpm = (60 * 1000 / 51) / tempo_decorrido * x; % Calcula o RPM 
        fprintf('RPM = %d\n', rpm);

        ultimo_tempo = tic; % Reseta o contador de tempo
        x = 0; % Zerando para um novo cálculo
        
        % Armazena os valores de RPM e tempo nos vetores
        dados_rpm = [dados_rpm, rpm];
        dados_tempo = [dados_tempo, tempo_decorrido];
        
        % Plotagem do gráfico
        figure(1);
        plot(dados_tempo, dados_rpm, 'b', 'LineWidth', 1.5);
        xlabel('Tempo (s)');
        ylabel('Velocidade (pulsos/ms)');
        title('Velocidade do Motor CC ao Longo do Tempo');
        grid on;
        drawnow;
    end
    
    if readDigitalPin(a, pino_D0) % Verifica se houve um pulso no pino_D0
        x = x + 1; % Incrementa o contador de pulsos
    end
end

%% Desliga o objeto arduino
clear a;
