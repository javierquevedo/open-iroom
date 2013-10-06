#include <16F84A.h>

#FUSES NOWDT                 	//No Watch Dog Timer
#FUSES
#use delay(clock=4000000)
void motor(int8 num, int8 dir);
