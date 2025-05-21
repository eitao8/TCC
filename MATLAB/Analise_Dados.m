%% Limpeza
clear all;
clc;

%% Lê os dados do Arduino
dados_sem_pid = readtable('dados_motor1.txt');
dados_com_pid1 = readtable('dados_motor2.txt');
dados_com_pid2 = readtable('dados_motor3.txt');

tempo_sem_pid = dados_sem_pid{:, 1};
rpm_sem_pid = dados_sem_pid{:, 2};

tempo_com_pid1 = dados_com_pid1{:, 1};
rpm_com_pid1 = dados_com_pid1{:, 2};

tempo_com_pid2 = dados_com_pid2{:, 1};
rpm_com_pid2 = dados_com_pid2{:, 2};

%% Índices de início
inicio_indice_sem = find(rpm_sem_pid > 0, 1, 'first');
inicio_indice_com1 = find(rpm_com_pid1 > 0, 1, 'first');
inicio_indice_com2 = find(rpm_com_pid2 > 0, 1, 'first');

if inicio_indice_sem > 1, inicio_indice_sem = inicio_indice_sem - 1; end
if inicio_indice_com1 > 1, inicio_indice_com1 = inicio_indice_com1 - 1; end
if inicio_indice_com2 > 1, inicio_indice_com2 = inicio_indice_com2 - 1; end

tempo_inicio_sem = tempo_sem_pid(inicio_indice_sem);
tempo_inicio_com1 = tempo_com_pid1(inicio_indice_com1);
tempo_inicio_com2 = tempo_com_pid2(inicio_indice_com2);

tempo_filtrado_sem = tempo_sem_pid(inicio_indice_sem:end) - tempo_inicio_sem;
rpm_filtrado_sem = rpm_sem_pid(inicio_indice_sem:end);

tempo_filtrado_com1 = tempo_com_pid1(inicio_indice_com1:end) - tempo_inicio_com1;
rpm_filtrado_com1 = rpm_com_pid1(inicio_indice_com1:end);

tempo_filtrado_com2 = tempo_com_pid2(inicio_indice_com2:end) - tempo_inicio_com2;
rpm_filtrado_com2 = rpm_com_pid2(inicio_indice_com2:end);

%% Reamostragem e função de transferência
dt = 0.01; 
tempo_uniforme = tempo_filtrado_sem(1):dt:tempo_filtrado_sem(end);
rpm_interpolada = interp1(tempo_filtrado_sem, rpm_filtrado_sem, tempo_uniforme);

funcao_erro = @(p) sum((lsim(tf([p(1)], [p(2), p(3)]), ones(size(tempo_uniforme)), tempo_uniforme) - rpm_interpolada').^2);
parametros = [100, 3, 2];
parametros_otimizados = fminsearch(funcao_erro, parametros);

k = parametros_otimizados(1);
j = parametros_otimizados(2);
b = parametros_otimizados(3);

fprintf('FT:\n k = %.4f\n j = %.4f\n b = %.4f\n', k, j, b);

sys = tf([k], [j b]);
[step_response, step_time] = step(sys, tempo_uniforme);

%% Simulações no Simulink
disp('Rodando Simulação 1');
simOut1 = sim('Controlador_TCC'); 
dados_sim1 = simOut1.logsout;
save('simulink1.mat', 'dados_sim1');

disp('ENTER');
pause;

disp('Rodando Simulação 2');
simOut2 = sim('Controlador_TCC');
dados_sim2 = simOut2.logsout;
save('simulink2.mat', 'dados_sim2');

%% Carrega dados do Simulink
load('simulink1.mat');
load('simulink2.mat');

rpm_sim1 = dados_sim1.get('rpm_simulink');
rpm_sim2 = dados_sim2.get('rpm_simulink');

tempo_sim1 = rpm_sim1.Values.Time;
valores_sim1 = rpm_sim1.Values.Data;

tempo_sim2 = rpm_sim2.Values.Time;
valores_sim2 = rpm_sim2.Values.Data;

%% GRÁFICO 1 - Dados motor vs FT
figure;
hold on;
plot(tempo_filtrado_sem, rpm_filtrado_sem, 'b', 'LineWidth', 1.5);
plot(step_time, step_response, 'g--', 'LineWidth', 2);
xlabel('Tempo (s)');
ylabel('RPM');
title('Dados Motor vs Modelo FT');
legend('Dados Motor', 'Modelo FT');
grid on;

%% GRÁFICO 2 - PID Arduino vs Simulink (1ª versão)
figure;
hold on;
plot(tempo_filtrado_com1, rpm_filtrado_com1, 'r', 'LineWidth', 1.5);
plot(tempo_sim1, valores_sim1, 'k--', 'LineWidth', 2);
xlabel('Tempo (s)');
ylabel('RPM');
title('PID Arduino vs Simulink (1ª versão)');
legend('Arduino PID', 'Simulink PID');
grid on;

%% GRÁFICO 3 - PID Arduino vs Simulink (2ª versão)
figure;
hold on;
plot(tempo_filtrado_com2, rpm_filtrado_com2, 'm', 'LineWidth', 1.5);
plot(tempo_sim2, valores_sim2, 'k--', 'LineWidth', 2);
xlabel('Tempo (s)');
ylabel('RPM');
title('PID Arduino vs Simulink (2ª versão)');
legend('Arduino PID 2', 'Simulink PID 2');
grid on;



