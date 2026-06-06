# TP4-ED1

Este proyecto contiene el código y los esquemas del trabajo práctico número 4 de Electrónica Digital 1 de la Facultad de Ciencias Exactas, Físicas y Naturales de la Univercidad Nacional de Córdoba hecho por el grupo 15.

## Consigna

Diseñar y construir en protoboard un Conversor de señal analogica a valores digitales (ADC) que realice la conversión de el valor de tensión proveniente de un divisor resistivo variable (potenciómetro) a 8 bits de salida. Los valores para convertir deben ser de 0 a 5 volt, y se supone que tendrán una frecuencia máxima de 2 KHz.

El trabajo consta de tres partes:

1) Adquisición: Realizar la conversión de la señal analógica y mostrar los valores digitales mediante la utilización de leds que muestren si los bits de salida son cero o uno. Para ello se debe seleccionar una de las siguientes 2 opciones:

    - Utilizar un ADC de aproximaciones sucesivas por ejemplo un ADC0808 o ADC0809.
    - Utilizar ADC de la Basys 3 (FPGA)

2) Almacenamiento: Guardar los valores adquiridos en una memoria RAM de 8 bits. Se deberá poder guardar al menos 5 segundos de muestras de la señal de entrada. Posteriormente, se deberá poder ver en los leds los valores almacenados en la memoria.
 
3) Conversión nuevamente a señal análoga (DAC): Convertir los valores digitales a analógico nuevamente, mediante la utilización de un DAC R-2R.
 
Importante:
Para evitar conflictos en el bus de 8 bits que conectará el ADC y la memoria (ambos intentarán controlar el bus), utilizar las salidas alta impedancia de ambos chips. Un switch decidirá si lo que se muestra en los LEDs o en el DAC viene del ADC o de la memoria.

Recomendación: Utilice en la entrada un generador de señales (pañol), seleccione que emita una señal sinusoidal, y vea la salida del R-2R, observando el efecto del muestreo en la forma de onda. Para observar dicho efecto y comparar ambas señales (input y output) puede utilizar un osciloscopio. TENGA EN CUENTA QUE ESTARÁ UTILIZANDO SEÑALES CON PARTE NEGATIVA, POR ENDE, DEBE UTILIZAR EL OFFSET CORRESPONDIENTE DEL GENERADOR DE SEÑALES.
Verificar previamente con el osciloscopio que la señal esté por arriba de 0V.

Componentes:

- RAM estática 32Kx8 bits (1 una)
- Contador de 16 bits con RESET (o 2 chips de 12/14 bits)
- Conversor Digital/Analógico R-2R de 8 bits (1 uno) – Alternativa= Resistencias R-2R y OpAmp