#include "C:\Documentos\servo controller\16f84a.h"



int8 const DUTYSTOP        = 5;
int8 const DUTYRIGHT       = 9;
int8 const DUTYLEFT        = 1;
int8 const DUTYEND         = 78;
int8 const CONTADOR_INIT   = 1;
int8 const MASTERMASK_INIT = 255;

int8 contador_ms = CONTADOR_INIT;
int8 mastermask  = MASTERMASK_INIT;
int8 leftmask    = MASTERMASK_INIT;
int8 rightmask   = MASTERMASK_INIT;
int8 stopmask    = 0;

#int_ext
rti_ext ()
{
   int8  mot = 0;
   int8  dir = 0;

   if (input(PIN_B5))
     bit_set (mot,0);
   if (input(PIN_B6))
     bit_set (mot,1);
   if (input(PIN_B7))
     bit_set (mot,2);

   if (input(PIN_B3))
      bit_set(dir,0);
   if (input(PIN_B4))
      bit_set(dir,1);

      motor (mot,dir);
}

#int_timer0
rti_timer0 ()
{
   output_a (mastermask);

   switch (contador_ms++)
   {
      case DUTYLEFT: mastermask &= leftmask;
         break;
      case DUTYRIGHT :
         mastermask &= rightmask;
         break;
      case DUTYSTOP :
         mastermask &= stopmask;
         break;
      case DUTYEND:
         mastermask  = MASTERMASK_INIT;
         contador_ms = CONTADOR_INIT;
         break;
   }

}

void motor(int8 num, int8 dir)
{
   int8 bit;
   int8 nbit;

   //intf ("Motor: %d, Direccion: %d\n\r", num, dir);

   bit  = 1<<num;
   nbit = 255 - bit; // xor

   //   printf ("MaskBit: \X\n\r", bit);
   switch (dir)
   {
      case 0:
         leftmask  &= nbit;
         rightmask |= bit;
         stopmask  |= bit;
    //     printf ("Leftmask = %X\n\r", leftmask);
         break;
      case 1:
         leftmask  |= bit;
         rightmask &= nbit;
         stopmask  |= bit;
     //    printf ("Rightmask = %X\n\r", rightmask);
         break;
      default:
         leftmask  |= bit;
         rightmask |= bit;
         stopmask  &= nbit;

         break;
   }
}


void main()
{
   setup_timer_0(RTCC_INTERNAL|RTCC_DIV_1);

   

   enable_interrupts (INT_TIMER0);
   enable_interrupts (INT_EXT);
   enable_interrupts (GLOBAL);


   set_tris_a (0x00);
   set_tris_b (0xFF);






while (TRUE)
   {
   continue;
   }

}

