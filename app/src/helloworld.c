#include "xparameters.h"
#include "xil_io.h"
#include "xgpio.h"
#include "xil_printf.h"
#include "sleep.h"
#include "xuartlite.h"
#include <stdio.h>

#define AES_BASE_ADDR      XPAR_AES256_WRAPPER_0_BASEADDR
#define REG(offset)        (AES_BASE_ADDR + (offset))



//Intrare de 128 biti in 4 registre
void write_input(const u32 input[4]) {
    for (int i = 0; i < 4; i++) {
        Xil_Out32(REG(0x00 + i * 4), input[i]);
    }
}

//Cheie de 256 biti in 8 registre
void write_key(const u32 key[8]) {
    for (int i = 0; i < 8; i++) {
        Xil_Out32(REG(0x10 + i * 4), key[i]);
    }
}

//Valoarea 1 in registrul de start
void start_encryption() {
    Xil_Out32(REG(0x40), 1);
}

//Citeste bitul done
int is_done() {
    return Xil_In32(REG(0x44)) & 0x1;
}

//Citeste iesirea rezultata
void read_output(u32 output[4]) {
    for (int i = 0; i < 4; i++) {
        output[i] = Xil_In32(REG(0x30 + i * 4));
    }
}

int main()
{
    u32 buttons_read;
    u32 leds_out;

    XUartLite UartLite;
    XUartLite_Initialize(&UartLite, XPAR_AXI_UARTLITE_0_DEVICE_ID);


    u32 input[4] = {
        0x00112233, 0x44556677, 0x8899aabb, 0xccddeeff
    };

    u32 key[8] = {
        0x00010203, 0x04050607, 0x08090a0b, 0x0c0d0e0f,
        0x10111213, 0x14151617, 0x18191a1b, 0x1c1d1e1f
    };

    u32 output[4] = {0};

    write_input(input);
    write_key(key);

    while (1) {

        buttons_read = Xil_In32(XPAR_AXI_GPIO_1_BASEADDR + 0);
        leds_out     = buttons_read;

        if (buttons_read) {
            start_encryption();
            Xil_Out32(XPAR_AXI_GPIO_0_BASEADDR, leds_out);
        }


        while (! is_done())
        {
        	;
        }

		break;

    }

    read_output(output);




int count_j = 0;
   //ILUMINARE SECVENTIALA
    for (int i = 0; i < 4; i++) {  // 4 elemente de 32 biti in output[i]
        for (int j = 0; j < 2; j++) {  // prelucram cate 16 biti pe rand din fiecare element
            u16 segment = (output[i] >> (j * 16)) & 0xFFFF;


            if (segment != 0) {
                Xil_Out32(XPAR_AXI_GPIO_2_BASEADDR, segment);
                count_j++; //contorizare secvente corecte
            } else {
                Xil_Out32(XPAR_AXI_GPIO_2_BASEADDR, 0);
            }

            usleep(100);  // pauza de o secunda
        }
    }

    if(count_j == 8) //verificare secvente corecte
    {
    	for(int k = 0; k < 8 ;k++){
    	Xil_Out32(XPAR_AXI_GPIO_2_BASEADDR, 15);
    	usleep(50);

    	Xil_Out32(XPAR_AXI_GPIO_2_BASEADDR, 0);
    	usleep(50);
    	}
    }

    Xil_Out32(XPAR_AXI_GPIO_2_BASEADDR, 15); //aprindere permanenta LEDURI





    return 0;
}



//	for (int i = 0; i < 4; i++){

//		for(int j = 0; j < 4; j++){        ILUMINARE TOTALA

	//		u8 byte_shift = (output[i] >> (j*8));

//		 Xil_Out32(XPAR_AXI_GPIO_2_BASEADDR, byte_shift);  //aprindem ledurile de done
	//	 usleep(1000);
//	 }
//	}




//    int led_index = 0;

//    for (int i = 0; i < 4; i++) {     //4 registre output
//        for (int j = 0; j < 2; j++) {  // prelucram cate 2 secvente de 16 biti din fiecare registru

//            u16 segment = (output[i] >> (j * 16)) & 0xFFFF;  // segmente de 16 biti

//           u8 led_mask = 1 << led_index; //trece la urmatorul led

//            if (segment != 0) {

//                Xil_Out32(XPAR_AXI_GPIO_2_BASEADDR, segment); //aprinde ledul
//            } else {
//                Xil_Out32(XPAR_AXI_GPIO_2_BASEADDR, 0); // nu aprinde nimic
//            }

//            usleep(100);  // delay 1 sec.
//            led_index++;
//        }
