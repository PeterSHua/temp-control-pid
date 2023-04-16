#include <math.h>

#define ERRORWINDOW 20

float p_value = 0; //User P for testing right now
float i_value = 0; //User I
float d_value = 0; //User D
float set_temp = 0; //User set temperature

float calc_temp = 0; //Calculated temperature

float v_o = 0; //Measured voltage
float v_i = 0; //Calculated diff amp input voltage
float v_j = 0; //Junction voltage
float v_ss = 5; //Whestone bridge reference voltage
float gain = 1.4; //Diff amplifier gain adjustable
float v_therm = 0;
float v_adj = 1.6; //

float R1 = 10000; //R1 in Ohm
float R2 = 345; //R adjustable
float R3 = 10000; //R1 in Ohm
float R4 = 0; //R Thermister
float R25 = 10000; //Thermister at 25 celcius, from datasheet

float pwmHeat = 6; //PWM Heat pin
float pwmCool = 5; //PWM Cool pin
float ch1_p = 1;
float ch1_n = 0;

float v_o_n = 0;
float v_o_p = 0;
//PID variables
float last_calc_temp = 0;
float error = 0;
float last_error = 0;

float p_error = 0;
float i_error = 0;
float d_error = 0;
float pid_sum = 0; //Sum of P, I, and D elements

float error_sum = 0;
float errors[ERRORWINDOW];

int t_d = 500; //Loop delay in miliseconds

int state = 0;
int fill_error = 0;

float start = 0;

void setup() {
  Serial.begin(9600); // opens serial port, sets data rate to 9600 bps
}

void loop() {
  ReadFromSerial();
  ReadFromAnalog();
  CalculateTemperature();

  if (start) {
    PID();
  } else {
    error = 0;
    error_sum = 0;
    pid_sum = 0;
    analogWrite(pwmHeat, 255);
    analogWrite(pwmCool, 255);
  }

  WriteToSerial();

  //Loop every t_d;
  delay(t_d);
}

int ReadFromSerial() {
  //Read user inputs
  while (!Serial.available()) {}
  start = Serial.read();

  while (!Serial.available()) {}
  //Read P
  p_value = Serial.read();

  while (!Serial.available()) {}
  //Read I
  i_value = Serial.read();

  while (!Serial.available()) {}
  //Read D
  d_value = Serial.read();

  while (!Serial.available()) {}
  //Read Set Temperature
  set_temp = Serial.read();

  return 0;
}

int ReadFromAnalog() {
  //Measure Voltage
  v_o_n = analogRead(ch1_n);
  v_o_p = analogRead(ch1_p);

  return 0;
}

int CalculateTemperature() {
  v_o = (v_o_p - v_o_n) * 5 / 1024; //Convert to Vo
  v_i = v_o / gain; //Convert Vo to Vi- diff amplifier

  //Calculate RTD resistance in kOhm
  //R4 = (R3*(v_i/v_ss)+(R2*R3)/(R1+R2))/((1-R2/(R1+R2)-v_i/v_ss));
  v_therm = v_adj - v_i;
  R4 = v_therm * R3 / (5 - v_therm);
  //Convert to temperature
  //This equation was found by plotting the resistance to temperature chart
  //Replace this with the Steinhart-Hart equation
  calc_temp = -21.42 * log(R4 / R25) + 31.069;
  return 0;
}

int PID() {
  //PID compute PWM
  last_error = error;
  error = set_temp - calc_temp;

  CalculateP();
  CalculateI();
  CalculateD();

  pid_sum = p_error + i_error + d_error;

  LimitOutput();

  return 0;
}

int CalculateP() {
  //Compute P term
  p_error = error * p_value;

  return 0;
}

int CalculateI() {
  //If error array isn't full, add the new error
  if (fill_error < ERRORWINDOW) {
    errors[fill_error] = error;
    error_sum = error_sum + errors[fill_error];
    fill_error = fill_error + 1;
  }
  //If the error array is full, shift all elements left by 1 and add the new error
  else {
    error_sum = 0;
    for (int j = 0; j < ERRORWINDOW - 1; j++) {
      errors[j] = errors[j + 1];
      error_sum = error_sum + errors[j];
    }
    errors[ERRORWINDOW - 1] = error;
    error_sum = error_sum + errors[ERRORWINDOW - 1];
  }
  //Compute I term
  i_error = error_sum * i_value * t_d / 1000;

  return 0;
}

int CalculateD() {
  //Compute D term
  d_error = (error - last_error) * d_value / t_d;

  return 0;
}

int WriteToSerial() {
  //Send calculated temperature to user                   
  //Serial.println(calc_temp, 4);
  Serial.println(calc_temp, DEC);
  //Send calculated PWM to user
  Serial.println(pid_sum, 4);
  return 0;
}

int LimitOutput() {
  if (pid_sum > 0) {
    //If PID is positive, send to pwmHeat
    if (pid_sum >= 255) {
      //Alias pid output if exceeds Arduino 100% PWM	
      pid_sum = 254;
    }
    analogWrite(pwmHeat, 255 - pid_sum);
    analogWrite(pwmCool, 255);
  } else {
    if (pid_sum < 0) {
      //If PID is negative, send to pwmCool
      if (pid_sum < -255) {
        //Alias pid output if exceeds Arduino 100% PWM
        pid_sum = -254;
      }
      analogWrite(pwmCool, 255 + pid_sum);
      analogWrite(pwmHeat, 255);
    }
  }
  return 0;
}
