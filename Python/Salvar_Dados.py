import serial
import time

porta_serial = 'COM4'  
baud_rate = 9600

ser = serial.Serial(porta_serial, baud_rate)

with open("dadados_motor_PID_PerfeitoMotor.txt", "w") as arquivo:
    arquivo.write("Tempo(s) RPM\n") 
    
    tempo_inicial = time.time()
    
    while True:
        try:
            dados = ser.readline().decode('utf-8').strip()
            #print(f"Recebido: {dados}")  
            
            if dados:
                rpm = dados.split()[0] 
                
                tempo_decorrido = round(time.time() - tempo_inicial, 2)
                
                arquivo.write(f"{tempo_decorrido} {rpm}\n")  
                
            time.sleep(1)
        except KeyboardInterrupt:
            print("Leitura interrompida.")
            break

ser.close()

