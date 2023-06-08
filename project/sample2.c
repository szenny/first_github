#include "base.h"
#include <stdint.h>
#include <stdlib.h>

#define SRC_ADDRESS  0x40000000
#define DEST_ADDRESS 0x41000000
#define DEST1_ADDRESS 0x42000000
#define DEST2_ADDRESS 0x43000000
#define DEST3_ADDRESS 0x44000000
#define DEST4_ADDRESS 0x45000000
#define FILTER_ADDRESS  0x40900000
#define DATA_SIZE    3
#define ROWS 1080
#define COLS 1920
#define FILTER_SIZE 3
#define ZROW 1082
#define ZCOL 1922

void Grayscale(volatile uint8_t* src_address, volatile uint8_t* dest_address, volatile uint8_t (*gray)[COLS]);
void ZeroPadding(volatile uint8_t (*gray)[COLS], volatile uint8_t (*zero)[ZCOL]);
void Convolution(volatile uint8_t (*zero)[ZCOL], volatile int8_t (*conv)[COLS]); 
void Relu(volatile int8_t (*conv)[COLS], volatile int8_t (*relu)[COLS]);

extern void CONVOLUTION();

int main(void) {

	//addressing to uint8
    volatile uint8_t* src_address	 		=	(volatile uint8_t*)	SRC_ADDRESS;  //src_address of hex
    volatile uint8_t* dest_address 		= (volatile uint8_t*)	DEST_ADDRESS; 
    volatile uint8_t* gray_address 		= (volatile uint8_t*)	DEST1_ADDRESS;
    volatile uint8_t* zero_address 		= (volatile uint8_t*)	DEST2_ADDRESS;
    volatile int8_t* 	conv_address 		= (volatile int8_t*)	DEST3_ADDRESS;
    volatile int8_t* 	relu_address 		= (volatile int8_t*)	DEST4_ADDRESS;
		volatile double*  filter_address 	= (volatile double*)	FILTER_ADDRESS;
	//addressing arrays    
		volatile uint8_t 	(*gray)[COLS] 	= (volatile uint8_t(*)[COLS])	gray_address;
   	volatile uint8_t 	(*zero)[ZCOL] 	= (volatile uint8_t(*)[ZCOL])	zero_address;
    volatile int8_t 	(*con)[COLS]	 	= (volatile int8_t(*)[COLS])	conv_address;
    volatile int8_t 	(*rel)[COLS]	 	= (volatile int8_t(*)[COLS])	relu_address;
	  volatile double 	(*filter)[3]	 	= (volatile double(*)[3])			filter_address;

	//function of each step
		Grayscale(src_address,dest_address,gray); //src of the image file ,dest of gray
    ZeroPadding(gray, zero);
    Convolution(zero, con);
    Relu(con, rel);

	// Infinite loop	
    while (1) {
        
    }
}


void Grayscale(volatile uint8_t* src_address, volatile uint8_t* dest_address, volatile uint8_t (*gray)[COLS]){
    
    for (int j = 0; j < 1920 * 1080; j++) {
			  
        uint8_t max = 0;
        uint8_t min = 255;

        for (int i = 0; i < DATA_SIZE; i++) { 									//3byte R G B -> repeat 3 times for each pixel 
            uint8_t value = *(src_address + i + DATA_SIZE * j); //pointer of ( 0x40000000 + (3time) + pixel location of the pixel)  
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
        uint8_t average = (max + min) / 2; 
				*(dest_address + j) = average;				
    }		

		//filling the gray array with the value
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
            uint8_t value = *(dest_address + (i * COLS + j));
							gray[i][j] = value;
        }
    }


    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
            uint8_t value = *(dest_address + (i * COLS + j));
							gray[i][j] = value;
        }
    }
}

void ZeroPadding(volatile uint8_t (*gray)[COLS], volatile uint8_t (*zero)[ZCOL]) {
    for (int i = 0; i < ZROW; i++) {
        for (int j = 0; j < ZCOL; j++) {
             zero[i][j] = 0;
        }
    }
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
            zero[i + 1][j + 1] = gray[i][j];
        }
    }
}

void Convolution(volatile uint8_t (*zero)[ZCOL], volatile int8_t (*con)[COLS]) {
     
	
			double filter[3][3] = {
        {0.125, -0.14, 0.05},
        {-0.14, 0, -0.075},
        {0.05, -0.075, 0.125}
    };

    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
            con[i][j] = 0;
            }
         }
      for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
            for (int x = 0; x < 3; x++) {
                for (int y = 0; y < 3; y++) {
                    con[i][j] += zero[i + x][j + y] * filter[x][y];
                    }
            }
               }
            }
        
}

void Relu(volatile int8_t (*con)[COLS], volatile int8_t (*rel)[COLS]) {
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
            if (con[i][j] > 0) {
                rel[i][j] = con[i][j];
            }
            else {
                rel[i][j] = 0;
            }
        }
    }
}

