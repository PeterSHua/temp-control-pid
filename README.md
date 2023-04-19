# temp-control-pid
This project is focused on designing and implementing a temperature control system for a gas sensor chamber. The objective is to maintain a known temperature in the chamber during experiments measuring material conductivities in the presence of different gases.

## System Overview
The overall system is a control loop that allows a user to control the gas chamber temperature. The major components of the system are a temperature control circuit, an Arduino microcontroller, and a MATLAB GUI. The GUI allows the user to enter a desired temperature and the PID parameters, which are sent to the Arduino. The Arduino then controls the temperature control circuit to maintain the desired temperature in the gas chamber. 

![system overview](https://github.com/PeterSHua/temp-control-pid/blob/main/img/overview.png?raw=true)

## GUI
The GUI allows the user to enter a desired temperature and the parameters for the PID controller. The MATLAB program graphs the measured temperature and pulse width modulation (PWM) signals received from the temperature control circuit. The GUI also displays recorded data, as well as a console panel that displays status messages and error messages.


![gui](https://github.com/PeterSHua/temp-control-pid/blob/main/img/gui.png?raw=true)

The Keithley SourceMeter is a type of instrument that can be used as a sensor in the temperature control system. It is not specifically designed for temperature control, but rather for measuring and sourcing voltage, current, and resistance. In this project, it was used as a sensor to measure the temperature of the gas chamber


![gui](https://github.com/PeterSHua/temp-control-pid/blob/main/img/gui2.png?raw=true)

## Schematic
The temperature control circuit is responsible for maintaining the desired temperature in the gas chamber by controlling the power supplied to a heating element. The Arduino receives input from the MATLAB program via serial communication and calculates an output using PID control. This output is then converted into a PWM signal that is sent to the H-Bridge. The H-Bridge controls the power supplied to the heating element.


![gui](https://github.com/PeterSHua/temp-control-pid/blob/main/img/schematic.png?raw=true)
