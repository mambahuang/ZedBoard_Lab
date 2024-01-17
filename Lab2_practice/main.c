/*
 * main.c
 *
 *  Created on: Jan 17, 2023
 *      Author: Chien Huang
 */

#include <stdio.h>
#include <xgpio.h>
#include "xparameters.h"
#include "sleep.h"

int main()
{
   XGpio gpio0, gpio1;
   int button_data = 0;
   int switch_data = 0;
   int time_green = 0;
   int time_yellow = 0;
   int time_red = 0;
   int reset = 0;

   XGpio_Initialize(&gpio0, XPAR_AXI_GPIO_0_DEVICE_ID);	//initialize input XGpio variable
   XGpio_Initialize(&gpio1, XPAR_AXI_GPIO_1_DEVICE_ID);	//initialize output XGpio variable

   XGpio_SetDataDirection(&gpio0, 1, 0x0);			//set first channel tristate buffer to output
   XGpio_SetDataDirection(&gpio0, 2, 0xF);			//set second channel tristate buffer to input

   XGpio_SetDataDirection(&gpio1, 1, 0xF);		//set first channel tristate buffer to input

   while(1){

	  reset = 0;
      switch_data = XGpio_DiscreteRead(&gpio0, 2);	//get switch data

      if(switch_data == 0b0000){
         time_green = 15;
         time_yellow = 1;
         time_red = 16;
      }else{
         time_green = 7;
         time_yellow = 1;
         time_red = 8;
      }

      for (int i = 0; i < time_green; i++)
      {
         if(reset) break;
         button_data = XGpio_DiscreteRead(&gpio1, 1);	//get button data
         if(button_data != 0){
            reset = 1;
            break;
         }
         xil_printf("Time left: %d\n\r", time_green - i);
         XGpio_DiscreteWrite(&gpio0, 1, time_green - i + 32);
         usleep(1000000);
      }

      for (int i = 0; i < time_yellow; i++)
      {
         if(reset) break;
         button_data = XGpio_DiscreteRead(&gpio1, 1);	//get button data
         if(button_data != 0){
            reset = 1;
            break;
         }
         xil_printf("Time left: %d\n\r", time_yellow - i);
         XGpio_DiscreteWrite(&gpio0, 1, time_yellow - i + 64);
         usleep(1000000);
      }

      for (int i=0; i<time_red; i++)
      {
         if(reset) break;
         button_data = XGpio_DiscreteRead(&gpio1, 1);	//get button data
         if(button_data != 0){
            reset = 1;
            break;
         }
         xil_printf("Time left: %d\n\r", time_red - i);
         XGpio_DiscreteWrite(&gpio0, 1, time_red - i + 128);
         usleep(1000000);
      }

   }
   return 0;
}
