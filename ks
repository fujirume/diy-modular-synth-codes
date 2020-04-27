#include "LedControl.h"
#include <Wire.h>
#include <JC_Button.h>  
#include <MD_REncoder.h>
MD_REncoder R = MD_REncoder(8, 9);
MD_REncoder R2 = MD_REncoder(6, 7);

LedControl lc=LedControl(12,11,10,1);
#include <TM1637Display.h>
#define CLK 3
#define DIO 4
int i=0;
float calib=73.9; 
uint8_t x ;
uint8_t x2 ;
uint8_t x3 ;
//int movled=0;
#include <Adafruit_MCP4725.h>
Adafruit_MCP4725 dac;
int scala=1;
int valled[64];
int mas=32;
int y=0;
unsigned long ledOnTime;
bool ledOn;
int menu=0;
int kstep=0;


int p[8][64]= {  {0,1,2,3,4,3,2,1,0,0,0,1,0,0,0,1,8,9,10,11,12,11,10,9,8,8,8,8,9,8,8,8,16,17,18,19,20,19,18,17,16,16,16,17,16,16,16,17,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63},
                 {0,8,16,24,63,62,61,59,58,57,56,55,54,53,4,5,6,7,5,6,7,8,7,8,9,10,12,15,46,31,45,64,15,14,12,13,14,21,24,29,21,34,35,36,37,38,45,46,1,2,4,5,1,2,59,58,54,51,52,50},
                 {16,17,18,19,20,21,22,23,24,25,26,25,33,41,49,57,2,10,18,26,34,42,50,58,3,11,19,27,35,43,51,59,4,12,20,28,26,44,52,60,5,13,21,29,37,45,53,61,6,14,22,30,38,46,54,62,7,15,23,31,39,47,55,63},
                 {0,8,16,24,63,55,47,26,61,53,45,37,3,11,19,27,60,52,44,36,4,12,20,28,59,51,43,35,5,13,21,29,58,50,42,34,6,14,22,30,57,49,41,33,7,15,23,31,56,48,40,32},
                 {0,1,2,3,4,5,6,7,15,23,31,39,47,55,63,62,61,60,59,58,57,56,48,40,32,24,16,8,9,10,11,12,13,14,22,30,38,46,54,53,52,51,50,49,41,33,25,17,18,19,20,21,29,37,45,44,43,42,34,26,27,28,36,35},
                 {0,1,2,3,4,5,6,7,15,14,13,12,11,10,9,8,16,17,18,19,20,21,22,23,31,30,29,28,27,26,25,24,32,33,34,35,36,37,38,39,47,46,45,44,43,42,41,40,48,49,50,51,52,53,54,55,63,62,61,60,59,58,57,56},
                 {0,5,9,1,2,4,9,6,32,2,45,6,7,8,9,6,15,16,14,17,18,19,12,12,1,2,3,45,5,6,9,8,0,5,9,1,2,4,9,6,32,2,45,6,7,8,9,6,15,16,14,17,18,19,12,12, 1,2,3,45,5,6,9,8},
                 {63,62,61,60,59,58,57,56,55,54,53,52,51,50,49,48,47,46,45,44,43,42,41,40,39,38,37,36,35,34,33,32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0}  };






 
int pattern=1;
const byte
    BUTTON_PIN(A1);

Button myBtn(BUTTON_PIN); 
TM1637Display display(CLK, DIO);


const uint8_t SEG_PATT[] = {
  SEG_E | SEG_F | SEG_A | SEG_B | SEG_G,           
  SEG_E | SEG_F | SEG_A | SEG_B | SEG_C | SEG_G,  
  SEG_F | SEG_G | SEG_E | SEG_D ,                           
  SEG_F | SEG_G | SEG_E | SEG_D              
  };

const uint8_t SEG_STEP[] = {
  SEG_A | SEG_F | SEG_G | SEG_C | SEG_D,           
  SEG_F | SEG_G | SEG_E | SEG_D ,   
  SEG_A | SEG_G | SEG_D | SEG_E | SEG_F,                              
  SEG_E | SEG_F | SEG_A | SEG_B | SEG_G          
  };

const uint8_t SEG_SEQ[] = {
  SEG_A | SEG_F | SEG_G | SEG_C | SEG_D,          
  SEG_A | SEG_G | SEG_D | SEG_E | SEG_F,  
  SEG_A | SEG_F | SEG_G | SEG_B | SEG_C ,                           
  SEG_D              
  };

const uint8_t SEG_CALI[] = {
  SEG_A | SEG_F | SEG_E | SEG_D,          
  SEG_E | SEG_F | SEG_A | SEG_B | SEG_C | SEG_G,   
  SEG_F | SEG_E | SEG_D ,                           
  SEG_F | SEG_E             
  };
const uint8_t SEG_SCAL[] = {
  SEG_A | SEG_F | SEG_G | SEG_C | SEG_D,          
  SEG_A | SEG_F | SEG_E | SEG_D,   
  SEG_E | SEG_F | SEG_A | SEG_B | SEG_C | SEG_G,                         
  SEG_F | SEG_E | SEG_D ,            
  };

//const uint8_t SEG_MAJ[] = {
//  SEG_E | SEG_F | SEG_A | SEG_B | SEG_C,          
//  SEG_E | SEG_F | SEG_A | SEG_B | SEG_C | SEG_G,   
//  SEG_A | SEG_F | SEG_E | SEG_D | SEG_C | SEG_G,                         
//  SEG_D ,            
//  };
//
//const uint8_t SEG_MIN[] = {
//  SEG_E | SEG_F | SEG_A | SEG_B | SEG_C,          
//  SEG_E | SEG_F ,   
//  SEG_E | SEG_G | SEG_C,                         
//  SEG_D ,            
//  };
//
//const uint8_t SEG_LID[] = {
//  SEG_E | SEG_F | SEG_D,          
//  SEG_E | SEG_F ,   
//  SEG_B | SEG_C | SEG_G | SEG_E | SEG_D,                         
//  SEG_D ,            
//  };



void setup() {
display.setBrightness(0);
display.clear();
pinMode (8, OUTPUT);
R.begin();
R2.begin();

dac.begin(0x60);
Serial.begin(9600);
myBtn.begin();
lc.shutdown(0,false);
lc.setIntensity(0,8);
lc.clearDisplay(0);
distr();
}



void loop() {
  
x = R.read(); 

if(x==16){
 menu = menu-1;
 if(menu==-1){menu=4;}

 switch(menu){
  case 0:display.setSegments(SEG_PATT); break;
  case 1:display.setSegments(SEG_STEP); break;
  case 2:display.setSegments(SEG_SEQ); break;
  case 3:display.setSegments(SEG_CALI); break;
  case 4:display.setSegments(SEG_SCAL); break;
  
 }
  }

if(x==32){
  menu = menu+1;
  if(menu==5){menu=0;}
   switch(menu){
  case 0: display.setSegments(SEG_PATT); break;
  case 1:display.setSegments(SEG_STEP); break;
  case 2:display.setSegments(SEG_SEQ); break;
  case 3:display.setSegments(SEG_CALI); break;
  case 4:display.setSegments(SEG_SCAL); break;
 }
  }


x2 = R2.read(); 

    switch (x2){
    case 32 : 
    
          switch (menu){
             case 0: patternm();display.showNumberDec(pattern,false);break;
             case 1: kstep=kstep-1;kstepk();break;
             case 2: seqm();display.showNumberDec(y,false);break;
             case 3: calibm(); display.showNumberDec(calib*100,false);break;
             case 4: scala=scala-1; compscala();break;
            } break;
    
    
    
    
    case 16 :     
            switch (menu){
             case 0: patternp();display.showNumberDec(pattern,false);break;
             case 1: kstep=kstep+1;kstepk();break;
             case 2: seqp();display.showNumberDec(y,false);break;
             case 3: calibp();display.showNumberDec(calib*100,false);break;
             case 4: scala=scala+1;compscala();break;
            } break;
    }



  
myBtn.read();    
if (myBtn.wasReleased()){

  
//switch (movled){
//
//case 0:
switch (i){
  case 0: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][mas-1]]==0) {down(p[y][mas-1]);}  if (valled[p[y][mas-1]]==1) {up(p[y][mas-1]);}                                    break;
  
  case 1: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                               break;
  
  case 2: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 3: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 4: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 5: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 6: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                 break;
  
  case 7: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}        break;
  

  case 8: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}    break;
 
  case 9:  if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}    break;
  
  case 10: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}     break;
   
  case 11: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}    break;
    
  case 12: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}     break;
     
  case 13: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}      break;
      
  case 14: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}     break;
       
  case 15: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}      break;
  
   
  case 16: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}     break;
  
  case 17: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                               break;
  
  case 18: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 19: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 20: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 21: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 22: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                 break;
  
  case 23: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}        break;


  case 24: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}     break;
  
  case 25: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                               break;
  
  case 26: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 27: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 28: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 29: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 30: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                 break;
  
  case 31: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}        break;


  case 32: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}     break;
  
  case 33: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                               break;
  
  case 34: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 35: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 36: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 37: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 38: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                 break;
  
  case 39: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}        break;

  
  case 40: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}     break;
  
  case 41: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                               break;
  
  case 42: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 43: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 44: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 45: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 46: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                 break;
  
  case 47: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}        break;


  case 48: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}     break;
  
  case 49: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                               break;
  
  case 50: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 51: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 52: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 53: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 54: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                 break;
  
  case 55: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}        break;

 
  case 56: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}     break;
  
  case 57: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                               break;
  
  case 58: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 59: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 60: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 61: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                break;
  
  case 62: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}                                 break;
  
  case 63: if (valled[p[y][i]]==0) {up(p[y][i]);}     if (valled[p[y][i]]==1) {down(p[y][i]);suona(p[y][i]);}  if (valled[p[y][i-1]]==0) {down(p[y][i-1]);}    if (valled[p[y][i-1]]==1) {up(p[y][i-1]);}        break;
  }
//break;







//}








i = i+1;if (i==mas){i=0;}
}

if(ledOn) 
    if(millis() - ledOnTime > 60) {
      digitalWrite(8, LOW);
      ledOn = false;
    } 





}
//loop




void compscala(){
  
  switch (scala){
    
    case 0:display.showNumberDec(scala,false);break;
    case 1:display.showNumberDec(scala,false);break;
    case 2:display.showNumberDec(scala,false);break;}
  
  
  }
 
  
void kstepk(){
  i = 0;
  if(kstep==16){kstep=0;}
  if(kstep==-1){kstep=15;}
  switch(kstep){
     case 0: mas=1;display.showNumberDec(mas,false);break;
     case 1: mas=2;display.showNumberDec(mas,false);break;
     case 2: mas=3;display.showNumberDec(mas,false);break;
     case 3: mas=4;display.showNumberDec(mas,false);break;
     case 4: mas=5;display.showNumberDec(mas,false);break;
     case 5: mas=6;display.showNumberDec(mas,false);break;
     case 6: mas=7;display.showNumberDec(mas,false);break;
     case 7: mas=8;display.showNumberDec(mas,false);break;
     case 8: mas=9;display.showNumberDec(mas,false);break;
     case 9: mas=12;display.showNumberDec(mas,false);break;
     case 10: mas=15;display.showNumberDec(mas,false);break;
     case 11: mas=16;display.showNumberDec(mas,false);break;
     case 12: mas=24;display.showNumberDec(mas,false);break;
     case 13: mas=32;display.showNumberDec(mas,false);break;
     case 14: mas=48;display.showNumberDec(mas,false);break;
     case 15: mas=64;display.showNumberDec(mas,false);break;
      }
  
  
  }  
  
  
 void distr(){


  
switch (pattern){

case 0:     
          lc.setLed(0,0,0,true); valled[0]= 1;
          lc.setLed(0,0,1,true); valled[1]= 1;
          lc.setLed(0,0,2,true); valled[2]= 1;
          lc.setLed(0,0,3,true); valled[3]= 1;
          lc.setLed(0,0,4,true); valled[4]= 1;
          lc.setLed(0,0,5,true); valled[5]= 1;
          lc.setLed(0,0,6,true); valled[6]= 1;
          lc.setLed(0,0,7,true); valled[7]= 1;
  
          lc.setLed(0,1,0,true); valled[8]= 1;
          lc.setLed(0,1,1,true); valled[9]= 1;
          lc.setLed(0,1,2,true); valled[10]=1;
          lc.setLed(0,1,3,true); valled[11]= 1;
          lc.setLed(0,1,4,true); valled[12]= 1;
          lc.setLed(0,1,5,true); valled[13]= 1;
          lc.setLed(0,1,6,true); valled[14]= 1;
          lc.setLed(0,1,7,true); valled[15]= 1;
          
          lc.setLed(0,2,0,true); valled[16]= 1;
          lc.setLed(0,2,1,true); valled[17]= 1;
          lc.setLed(0,2,2,true); valled[18]= 1;
          lc.setLed(0,2,3,true); valled[19]= 1;
          lc.setLed(0,2,4,true); valled[20]= 1;
          lc.setLed(0,2,5,true); valled[21]= 1;
          lc.setLed(0,2,6,true); valled[22]= 1;
          lc.setLed(0,2,7,true); valled[23]= 1;
          
          lc.setLed(0,3,0,true); valled[24]= 1;
          lc.setLed(0,3,1,true); valled[25]= 1;
          lc.setLed(0,3,2,true); valled[26]= 1;
          lc.setLed(0,3,3,true); valled[27]= 1;
          lc.setLed(0,3,4,true); valled[28]= 1;
          lc.setLed(0,3,5,true); valled[29]= 1;
          lc.setLed(0,3,6,true); valled[30]= 1;
          lc.setLed(0,3,7,true); valled[31]= 1;          
          
          lc.setLed(0,4,0,true); valled[32]= 1;
          lc.setLed(0,4,1,true); valled[33]= 1;
          lc.setLed(0,4,2,true); valled[34]= 1;
          lc.setLed(0,4,3,true); valled[35]= 1;
          lc.setLed(0,4,4,true); valled[36]= 1;
          lc.setLed(0,4,5,true); valled[37]= 1;
          lc.setLed(0,4,6,true); valled[38]= 1;
          lc.setLed(0,4,7,true); valled[39]= 1; 

          lc.setLed(0,5,0,true); valled[40]= 1;
          lc.setLed(0,5,1,true); valled[41]= 1;
          lc.setLed(0,5,2,true); valled[42]= 1;
          lc.setLed(0,5,3,true); valled[43]= 1;
          lc.setLed(0,5,4,true); valled[44]= 1;
          lc.setLed(0,5,5,true); valled[45]= 1;
          lc.setLed(0,5,6,true); valled[46]= 1;
          lc.setLed(0,5,7,true); valled[47]= 1;   
          
          lc.setLed(0,6,0,true); valled[48]= 1;
          lc.setLed(0,6,1,true); valled[49]= 1;
          lc.setLed(0,6,2,true); valled[50]= 1;
          lc.setLed(0,6,3,true); valled[51]= 1;
          lc.setLed(0,6,4,true); valled[52]= 1;
          lc.setLed(0,6,5,true); valled[53]= 1;
          lc.setLed(0,6,6,true); valled[54]= 1;
          lc.setLed(0,6,7,true); valled[55]= 1;    

          lc.setLed(0,7,0,true); valled[56]= 1;
          lc.setLed(0,7,1,true); valled[57]= 1;
          lc.setLed(0,7,2,true); valled[58]= 1;
          lc.setLed(0,7,3,true); valled[59]= 1;
          lc.setLed(0,7,4,true); valled[60]= 1;
          lc.setLed(0,7,5,true); valled[61]= 1;
          lc.setLed(0,7,6,true); valled[62]= 1;
          lc.setLed(0,7,7,true); valled[63]= 1;         
          
          break;



  case 1:
          lc.setLed(0,0,0,true); valled[0]= 1;
          lc.setLed(0,0,1,false); valled[1]=0;
          lc.setLed(0,0,2,false); valled[2]= 0;
          lc.setLed(0,0,3,false); valled[3]= 0;
          lc.setLed(0,0,4,true); valled[4]= 1;
          lc.setLed(0,0,5,false); valled[5]= 0;
          lc.setLed(0,0,6,false); valled[6]= 0;
          lc.setLed(0,0,7,false); valled[7]= 0;
  
          lc.setLed(0,1,0,true); valled[8]= 1;
          lc.setLed(0,1,1,true); valled[9]= 1;
          lc.setLed(0,1,2,false); valled[10]= 0;
          lc.setLed(0,1,3,false); valled[11]= 0;
          lc.setLed(0,1,4,true); valled[12]= 1;
          lc.setLed(0,1,5,true); valled[13]= 1;
          lc.setLed(0,1,6,false); valled[14]= 0;
          lc.setLed(0,1,7,false); valled[15]= 0;
          
          lc.setLed(0,2,0,false); valled[16]= 0;
          lc.setLed(0,2,1,true); valled[17]= 1;
          lc.setLed(0,2,2,true); valled[18]= 1;
          lc.setLed(0,2,3,false); valled[19]= 0;
          lc.setLed(0,2,4,false); valled[20]= 0;
          lc.setLed(0,2,5,true); valled[21]= 1;
          lc.setLed(0,2,6,true); valled[22]= 1;
          lc.setLed(0,2,7,false); valled[23]= 0;
          
          lc.setLed(0,3,0,false); valled[24]= 0;
          lc.setLed(0,3,1,false); valled[25]= 0;
          lc.setLed(0,3,2,true); valled[26]= 1;
          lc.setLed(0,3,3,true); valled[27]= 1;
          lc.setLed(0,3,4,false); valled[28]= 0;
          lc.setLed(0,3,5,false); valled[29]= 0;
          lc.setLed(0,3,6,true); valled[30]= 1;
          lc.setLed(0,3,7,true); valled[31]= 1;   

          lc.setLed(0,4,0,false); valled[32]= 0;
          lc.setLed(0,4,1,false); valled[33]= 0;
          lc.setLed(0,4,2,true); valled[34]= 1;
          lc.setLed(0,4,3,true); valled[35]= 1;
          lc.setLed(0,4,4,false); valled[36]= 0;
          lc.setLed(0,4,5,false); valled[37]= 0;
          lc.setLed(0,4,6,true); valled[38]= 1;
          lc.setLed(0,4,7,true); valled[39]= 1;  

          lc.setLed(0,5,0,false); valled[40]= 0;
          lc.setLed(0,5,1,true); valled[41]= 1;
          lc.setLed(0,5,2,true); valled[42]= 1;
          lc.setLed(0,5,3,false); valled[43]= 0;
          lc.setLed(0,5,4,false); valled[44]= 0;
          lc.setLed(0,5,5,true); valled[45]= 1;
          lc.setLed(0,5,6,true); valled[46]= 1;
          lc.setLed(0,5,7,false); valled[47]= 0;   
          
          lc.setLed(0,6,0,true); valled[48]= 1;
          lc.setLed(0,6,1,true); valled[49]= 1;
          lc.setLed(0,6,2,false); valled[50]= 0;
          lc.setLed(0,6,3,false); valled[51]= 0;
          lc.setLed(0,6,4,true); valled[52]= 1;
          lc.setLed(0,6,5,true); valled[53]= 1;
          lc.setLed(0,6,6,false); valled[54]= 0;
          lc.setLed(0,6,7,false); valled[55]= 0;    

          lc.setLed(0,7,0,true); valled[56]= 1;
          lc.setLed(0,7,1,false); valled[57]= 0;
          lc.setLed(0,7,2,false); valled[58]= 0;
          lc.setLed(0,7,3,false); valled[59]= 0;
          lc.setLed(0,7,4,true); valled[60]= 1;
          lc.setLed(0,7,5,false); valled[61]= 0;
          lc.setLed(0,7,6,false); valled[62]= 0;
          lc.setLed(0,7,7,false); valled[63]= 0;                   
          
          
          
          break;

case 2:     
          lc.setLed(0,0,0,false); valled[0]= 0; //killpatrick
          lc.setLed(0,0,1,false); valled[1]= 0;
          lc.setLed(0,0,2,false); valled[2]= 0;
          lc.setLed(0,0,3,true); valled[3]= 1;
          lc.setLed(0,0,4,false); valled[4]= 0;
          lc.setLed(0,0,5,true); valled[5]= 1;
          lc.setLed(0,0,6,false); valled[6]= 0;
          lc.setLed(0,0,7,false); valled[7]= 0;
  
          lc.setLed(0,1,0,false); valled[8]= 0;
          lc.setLed(0,1,1,false); valled[9]= 0;
          lc.setLed(0,1,2,true); valled[10]= 1;
          lc.setLed(0,1,3,false); valled[11]= 0;
          lc.setLed(0,1,4,false); valled[12]= 0;
          lc.setLed(0,1,5,true); valled[13]= 1;
          lc.setLed(0,1,6,false); valled[14]= 0;
          lc.setLed(0,1,7,false); valled[15]= 0;
          
          lc.setLed(0,2,0,false); valled[16]= 0;
          lc.setLed(0,2,1,false); valled[17]= 0;
          lc.setLed(0,2,2,true); valled[18]= 1;
          lc.setLed(0,2,3,false); valled[19]= 0;
          lc.setLed(0,2,4,true); valled[20]= 1;
          lc.setLed(0,2,5,false); valled[21]= 0;
          lc.setLed(0,2,6,false); valled[22]= 0;
          lc.setLed(0,2,7,false); valled[23]= 0;
          
          lc.setLed(0,3,0,false); valled[24]= 0;
          lc.setLed(0,3,1,true); valled[25]= 1;
          lc.setLed(0,3,2,true); valled[26]= 1;
          lc.setLed(0,3,3,true); valled[27]= 1;
          lc.setLed(0,3,4,false); valled[28]= 0;
          lc.setLed(0,3,5,false); valled[29]= 0;
          lc.setLed(0,3,6,false); valled[30]= 0;
          lc.setLed(0,3,7,false); valled[31]= 0;          
          
          lc.setLed(0,4,0,false); valled[32]= 0;
          lc.setLed(0,4,1,true); valled[33]= 1;
          lc.setLed(0,4,2,true); valled[34]= 1;
          lc.setLed(0,4,3,true); valled[35]= 1;
          lc.setLed(0,4,4,false); valled[36]= 0;
          lc.setLed(0,4,5,false); valled[37]= 0;
          lc.setLed(0,4,6,false); valled[38]= 0;
          lc.setLed(0,4,7,false); valled[39]= 0; 

          lc.setLed(0,5,0,false); valled[40]= 0;
          lc.setLed(0,5,1,false); valled[41]= 0;
          lc.setLed(0,5,2,true); valled[42]= 1;
          lc.setLed(0,5,3,false); valled[43]= 0;
          lc.setLed(0,5,4,true); valled[44]= 1;
          lc.setLed(0,5,5,false); valled[45]= 0;
          lc.setLed(0,5,6,true); valled[46]= 1;
          lc.setLed(0,5,7,false); valled[47]= 0;   
          
          lc.setLed(0,6,0,false); valled[48]= 0;
          lc.setLed(0,6,1,false); valled[49]= 0;
          lc.setLed(0,6,2,true); valled[50]= 1;
          lc.setLed(0,6,3,false); valled[51]= 0;
          lc.setLed(0,6,4,false); valled[52]= 0;
          lc.setLed(0,6,5,true); valled[53]= 1;
          lc.setLed(0,6,6,false); valled[54]= 0;
          lc.setLed(0,6,7,false); valled[55]= 0;    

          lc.setLed(0,7,0,false); valled[56]= 0;
          lc.setLed(0,7,1,false); valled[57]= 0;
          lc.setLed(0,7,2,false); valled[58]= 0;
          lc.setLed(0,7,3,true); valled[59]= 1;
          lc.setLed(0,7,4,false); valled[60]= 0;
          lc.setLed(0,7,5,false); valled[61]= 0;
          lc.setLed(0,7,6,false); valled[62]= 0;
          lc.setLed(0,7,7,false); valled[63]= 0;        
          
          break;

case 3:     
          lc.setLed(0,0,0,true); valled[0]= 1;  //inventata
          lc.setLed(0,0,1,true); valled[1]= 1;
          lc.setLed(0,0,2,true); valled[2]= 1;
          lc.setLed(0,0,3,true); valled[3]= 1;
          lc.setLed(0,0,4,true); valled[4]= 1;
          lc.setLed(0,0,5,false); valled[5]= 0;
          lc.setLed(0,0,6,false); valled[6]= 0;
          lc.setLed(0,0,7,false); valled[7]= 0;
  
          lc.setLed(0,1,0,true); valled[8]= 1;
          lc.setLed(0,1,1,true); valled[9]= 1;
          lc.setLed(0,1,2,true); valled[10]= 1;
          lc.setLed(0,1,3,true); valled[11]= 1;
          lc.setLed(0,1,4,true); valled[12]= 1;
          lc.setLed(0,1,5,false); valled[13]= 0;
          lc.setLed(0,1,6,false); valled[14]= 0;
          lc.setLed(0,1,7,false); valled[15]= 0;
          
          lc.setLed(0,2,0,true); valled[16]= 1;
          lc.setLed(0,2,1,true); valled[17]= 1;
          lc.setLed(0,2,2,true); valled[18]= 1;
          lc.setLed(0,2,3,true); valled[19]= 1;
          lc.setLed(0,2,4,true); valled[20]= 1;
          lc.setLed(0,2,5,false); valled[21]= 0;
          lc.setLed(0,2,6,false); valled[22]= 0;
          lc.setLed(0,2,7,false); valled[23]= 0;
          
          lc.setLed(0,3,0,true); valled[24]= 1;
          lc.setLed(0,3,1,true); valled[25]= 1;
          lc.setLed(0,3,2,true); valled[26]= 1;
          lc.setLed(0,3,3,true); valled[27]= 1;
          lc.setLed(0,3,4,true); valled[28]= 1;
          lc.setLed(0,3,5,false); valled[29]= 0;
          lc.setLed(0,3,6,false); valled[30]= 0;
          lc.setLed(0,3,7,false); valled[31]= 0;          
          
          lc.setLed(0,4,0,false); valled[32]= 0;
          lc.setLed(0,4,1,false); valled[33]= 0;
          lc.setLed(0,4,2,false); valled[34]= 0;
          lc.setLed(0,4,3,true); valled[35]= 1;
          lc.setLed(0,4,4,true); valled[36]= 1;
          lc.setLed(0,4,5,true); valled[37]= 1;
          lc.setLed(0,4,6,true); valled[38]= 1;
          lc.setLed(0,4,7,true); valled[39]= 1; 

          lc.setLed(0,5,0,false); valled[40]= 0;
          lc.setLed(0,5,1,false); valled[41]= 0;
          lc.setLed(0,5,2,false); valled[42]= 0;
          lc.setLed(0,5,3,true); valled[43]= 1;
          lc.setLed(0,5,4,true); valled[44]= 1;
          lc.setLed(0,5,5,true); valled[45]= 1;
          lc.setLed(0,5,6,true); valled[46]= 1;
          lc.setLed(0,5,7,true); valled[47]= 1;   
          
          lc.setLed(0,6,0,false); valled[48]= 0;
          lc.setLed(0,6,1,false); valled[49]= 0;
          lc.setLed(0,6,2,false); valled[50]= 0;
          lc.setLed(0,6,3,true); valled[51]= 1;
          lc.setLed(0,6,4,true); valled[52]= 1;
          lc.setLed(0,6,5,true); valled[53]= 1;
          lc.setLed(0,6,6,true); valled[54]= 1;
          lc.setLed(0,6,7,true); valled[55]= 1;    

          lc.setLed(0,7,0,false); valled[56]= 0;
          lc.setLed(0,7,1,false); valled[57]= 0;
          lc.setLed(0,7,2,false); valled[58]= 0;
          lc.setLed(0,7,3,true); valled[59]= 1;
          lc.setLed(0,7,4,true); valled[60]= 1;
          lc.setLed(0,7,5,true); valled[61]= 1;
          lc.setLed(0,7,6,true); valled[62]= 1;
          lc.setLed(0,7,7,true); valled[63]= 1;         
          
          break;
      
      
      
case 4:     
          lc.setLed(0,0,0,false); valled[0]= 0;   //center sqares
          lc.setLed(0,0,1,false); valled[1]= 0;
          lc.setLed(0,0,2,true); valled[2]= 1;
          lc.setLed(0,0,3,true); valled[3]= 1;
          lc.setLed(0,0,4,true); valled[4]= 1;
          lc.setLed(0,0,5,true); valled[5]= 1;
          lc.setLed(0,0,6,false); valled[6]= 0;
          lc.setLed(0,0,7,false); valled[7]= 0;
  
          lc.setLed(0,1,0,false); valled[8]= 0;
          lc.setLed(0,1,1,false); valled[9]= 0;
          lc.setLed(0,1,2,true); valled[10]= 1;
          lc.setLed(0,1,3,true); valled[11]= 1;
          lc.setLed(0,1,4,true); valled[12]= 1;
          lc.setLed(0,1,5,true); valled[13]= 1;
          lc.setLed(0,1,6,false); valled[14]= 0;
          lc.setLed(0,1,7,false); valled[15]= 0;
          
          lc.setLed(0,2,0,true); valled[16]= 1;
          lc.setLed(0,2,1,true); valled[17]= 1;
          lc.setLed(0,2,2,false); valled[18]= 0;
          lc.setLed(0,2,3,false); valled[19]= 0;
          lc.setLed(0,2,4,false); valled[20]= 0;
          lc.setLed(0,2,5,false); valled[21]= 0;
          lc.setLed(0,2,6,true); valled[22]= 1;
          lc.setLed(0,2,7,true); valled[23]= 1;
          
          lc.setLed(0,3,0,true); valled[24]= 1;
          lc.setLed(0,3,1,true); valled[25]= 1;
          lc.setLed(0,3,2,false); valled[26]= 0;
          lc.setLed(0,3,3,true); valled[27]= 1;
          lc.setLed(0,3,4,true); valled[28]= 1;
          lc.setLed(0,3,5,false); valled[29]= 0;
          lc.setLed(0,3,6,true); valled[30]= 1;
          lc.setLed(0,3,7,true); valled[31]= 1;          
          
          lc.setLed(0,4,0,true); valled[32]= 1;
          lc.setLed(0,4,1,true); valled[33]= 1;
          lc.setLed(0,4,2,false); valled[34]= 0;
          lc.setLed(0,4,3,true); valled[35]= 1;
          lc.setLed(0,4,4,true); valled[36]= 1;
          lc.setLed(0,4,5,false); valled[37]= 0;
          lc.setLed(0,4,6,true); valled[38]= 1;
          lc.setLed(0,4,7,true); valled[39]= 1; 

          lc.setLed(0,5,0,true); valled[40]= 1;
          lc.setLed(0,5,1,true); valled[41]= 1;
          lc.setLed(0,5,2,false); valled[42]= 0;
          lc.setLed(0,5,3,false); valled[43]= 0;
          lc.setLed(0,5,4,false); valled[44]= 0;
          lc.setLed(0,5,5,false); valled[45]= 0;
          lc.setLed(0,5,6,true); valled[46]= 1;
          lc.setLed(0,5,7,true); valled[47]= 1;   
          
          lc.setLed(0,6,0,false); valled[48]= 0;
          lc.setLed(0,6,1,false); valled[49]= 0;
          lc.setLed(0,6,2,true); valled[50]= 1;
          lc.setLed(0,6,3,true); valled[51]= 1;
          lc.setLed(0,6,4,true); valled[52]= 1;
          lc.setLed(0,6,5,true); valled[53]= 1;
          lc.setLed(0,6,6,false); valled[54]= 0;
          lc.setLed(0,6,7,false); valled[55]= 0;    

          lc.setLed(0,7,0,false); valled[56]= 0;
          lc.setLed(0,7,1,false); valled[57]= 0;
          lc.setLed(0,7,2,true); valled[58]= 1;
          lc.setLed(0,7,3,true); valled[59]= 1;
          lc.setLed(0,7,4,true); valled[60]= 1;
          lc.setLed(0,7,5,true); valled[61]= 1;
          lc.setLed(0,7,6,false); valled[62]= 0;
          lc.setLed(0,7,7,false); valled[63]= 0;        
          
          break;

case 5:     
          lc.setLed(0,0,0,false); valled[0]= 0;   //fan
          lc.setLed(0,0,1,false); valled[1]= 0;
          lc.setLed(0,0,2,false); valled[2]= 0;
          lc.setLed(0,0,3,true); valled[3]= 1;
          lc.setLed(0,0,4,true); valled[4]= 1;
          lc.setLed(0,0,5,false); valled[5]= 0;
          lc.setLed(0,0,6,false); valled[6]= 0;
          lc.setLed(0,0,7,false); valled[7]= 0;
  
          lc.setLed(0,1,0,false); valled[8]= 0;
          lc.setLed(0,1,1,false); valled[9]= 0;
          lc.setLed(0,1,2,false); valled[10]= 0;
          lc.setLed(0,1,3,true); valled[11]= 1;
          lc.setLed(0,1,4,true); valled[12]= 1;
          lc.setLed(0,1,5,false); valled[13]= 0;
          lc.setLed(0,1,6,false); valled[14]= 0;
          lc.setLed(0,1,7,false); valled[15]= 0;
          
          lc.setLed(0,2,0,false); valled[16]= 0;
          lc.setLed(0,2,1,false); valled[17]= 0;
          lc.setLed(0,2,2,false); valled[18]= 0;
          lc.setLed(0,2,3,true); valled[19]= 1;
          lc.setLed(0,2,4,true); valled[20]= 1;
          lc.setLed(0,2,5,false); valled[21]= 0;
          lc.setLed(0,2,6,false); valled[22]= 0;
          lc.setLed(0,2,7,false); valled[23]= 0;
          
          lc.setLed(0,3,0,true); valled[24]= 1;
          lc.setLed(0,3,1,true); valled[25]= 1;
          lc.setLed(0,3,2,true); valled[26]= 1;
          lc.setLed(0,3,3,false); valled[27]= 0;
          lc.setLed(0,3,4,false); valled[28]= 0;
          lc.setLed(0,3,5,true); valled[29]= 1;
          lc.setLed(0,3,6,true); valled[30]= 1;
          lc.setLed(0,3,7,true); valled[31]= 1;          
          
          lc.setLed(0,4,0,true); valled[32]= 1;
          lc.setLed(0,4,1,true); valled[33]= 1;
          lc.setLed(0,4,2,true); valled[34]= 1;
          lc.setLed(0,4,3,false); valled[35]= 0;
          lc.setLed(0,4,4,false); valled[36]= 0;
          lc.setLed(0,4,5,true); valled[37]= 1;
          lc.setLed(0,4,6,true); valled[38]= 1;
          lc.setLed(0,4,7,true); valled[39]= 1; 

          lc.setLed(0,5,0,false); valled[40]= 0;
          lc.setLed(0,5,1,false); valled[41]= 0;
          lc.setLed(0,5,2,false); valled[42]= 0;
          lc.setLed(0,5,3,true); valled[43]= 1;
          lc.setLed(0,5,4,true); valled[44]= 1;
          lc.setLed(0,5,5,false); valled[45]= 0;
          lc.setLed(0,5,6,false); valled[46]= 0;
          lc.setLed(0,5,7,false); valled[47]= 0;   
          
          lc.setLed(0,6,0,false); valled[48]= 0;
          lc.setLed(0,6,1,false); valled[49]= 0;
          lc.setLed(0,6,2,false); valled[50]= 0;
          lc.setLed(0,6,3,true); valled[51]= 1;
          lc.setLed(0,6,4,true); valled[52]= 1;
          lc.setLed(0,6,5,false); valled[53]= 0;
          lc.setLed(0,6,6,false); valled[54]= 0;
          lc.setLed(0,6,7,false); valled[55]= 0;    

          lc.setLed(0,7,0,false); valled[56]= 0;
          lc.setLed(0,7,1,false); valled[57]= 0;
          lc.setLed(0,7,2,false); valled[58]= 0;
          lc.setLed(0,7,3,true); valled[59]= 1;
          lc.setLed(0,7,4,true); valled[60]= 1;
          lc.setLed(0,7,5,false); valled[61]= 0;
          lc.setLed(0,7,6,false); valled[62]= 0;
          lc.setLed(0,7,7,false); valled[63]= 0;        break;

case 6:     
          lc.setLed(0,0,0,false); valled[0]= 0;   //NUOVA
          lc.setLed(0,0,1,false); valled[1]= 0;
          lc.setLed(0,0,2,false); valled[2]= 0;
          lc.setLed(0,0,3,true); valled[3]= 1;
          lc.setLed(0,0,4,true); valled[4]= 1;
          lc.setLed(0,0,5,false); valled[5]= 0;
          lc.setLed(0,0,6,false); valled[6]= 0;
          lc.setLed(0,0,7,false); valled[7]= 0;
  
          lc.setLed(0,1,0,false); valled[8]= 0;
          lc.setLed(0,1,1,false); valled[9]= 0;
          lc.setLed(0,1,2,true); valled[10]= 1;
          lc.setLed(0,1,3,true); valled[11]= 1;
          lc.setLed(0,1,4,true); valled[12]= 1;
          lc.setLed(0,1,5,true); valled[13]= 1;
          lc.setLed(0,1,6,false); valled[14]= 0;
          lc.setLed(0,1,7,false); valled[15]= 0;
          
          lc.setLed(0,2,0,false); valled[16]=0;
          lc.setLed(0,2,1,true); valled[17]= 1;
          lc.setLed(0,2,2,true); valled[18]= 1;
          lc.setLed(0,2,3,true); valled[19]= 1;
          lc.setLed(0,2,4,true); valled[20]= 1;
          lc.setLed(0,2,5,true); valled[21]= 1;
          lc.setLed(0,2,6,true); valled[22]= 1;
          lc.setLed(0,2,7,false); valled[23]= 0;
          
          lc.setLed(0,3,0,true); valled[24]= 1;
          lc.setLed(0,3,1,true); valled[25]= 1;
          lc.setLed(0,3,2,false); valled[26]=0;
          lc.setLed(0,3,3,true); valled[27]= 1;
          lc.setLed(0,3,4,true); valled[28]= 1;
          lc.setLed(0,3,5,false); valled[29]= 0;
          lc.setLed(0,3,6,true); valled[30]= 1;
          lc.setLed(0,3,7,true); valled[31]= 1;          
          
          lc.setLed(0,4,0,true); valled[32]= 1;
          lc.setLed(0,4,1,true); valled[33]= 1;
          lc.setLed(0,4,2,true); valled[34]= 1;
          lc.setLed(0,4,3,true); valled[35]= 1;
          lc.setLed(0,4,4,true); valled[36]= 1;
          lc.setLed(0,4,5,true); valled[37]= 1;
          lc.setLed(0,4,6,true); valled[38]= 1;
          lc.setLed(0,4,7,true); valled[39]= 1; 

          lc.setLed(0,5,0,false); valled[40]= 0;
          lc.setLed(0,5,1,false); valled[41]= 0;
          lc.setLed(0,5,2,true); valled[42]= 1;
          lc.setLed(0,5,3,false); valled[43]= 0;
          lc.setLed(0,5,4,false); valled[44]= 0;
          lc.setLed(0,5,5,true); valled[45]= 1;
          lc.setLed(0,5,6,false); valled[46]= 0;
          lc.setLed(0,5,7,false); valled[47]= 0;   
          
          lc.setLed(0,6,0,false); valled[48]= 0;
          lc.setLed(0,6,1,true); valled[49]= 1;
          lc.setLed(0,6,2,false); valled[50]= 0;
          lc.setLed(0,6,3,true); valled[51]= 1;
          lc.setLed(0,6,4,true); valled[52]= 1;
          lc.setLed(0,6,5,false); valled[53]= 0;
          lc.setLed(0,6,6,true); valled[54]= 1;
          lc.setLed(0,6,7,false); valled[55]= 0;    

          lc.setLed(0,7,0,true); valled[56]= 1;
          lc.setLed(0,7,1,false); valled[57]= 0;
          lc.setLed(0,7,2,true); valled[58]= 1;
          lc.setLed(0,7,3,false); valled[59]= 0;
          lc.setLed(0,7,4,false); valled[60]= 0;
          lc.setLed(0,7,5,true); valled[61]= 1;
          lc.setLed(0,7,6,false); valled[62]= 0;
          lc.setLed(0,7,7,true); valled[63]= 1;        break;






}



  
  
  }
  
void calibm(){calib=calib-0.1;}

void calibp(){calib=calib+0.1;}



void patternp(){
  pattern = pattern +1;if (pattern==7){pattern = 0;}

distr();
  
 
  }

void patternm(){
  pattern=pattern-1;if (pattern==-1){pattern = 6;}


distr();
  
  
  }



void seqp(){
  y = y+1; if(y==9){y=0;}
  i = 0;
  lc.clearDisplay(0);
  distr();
  
 
  
  }
void seqm(){
  y = y-1;if(y==-1){y=8;}
  i = 0;
  lc.clearDisplay(0);
  distr();
  
  }


void suona (int a){
ledOn = true;
ledOnTime = millis();
digitalWrite(8, HIGH);
  
switch (scala){

case 0:
      switch (a){
      case 0:playC1();break;
      case 1:playC1D();break;
      case 2:playE1();break;
      case 3:playF1();break;
      case 4:playG1();break;
      case 5:playG1D();break;
      case 6:playB1();break;
      case 7:playC2();break;

      case 8:playC2();break;
      case 9:playC2D();break;
      case 10:playE2();break;
      case 11:playF2();break;
      case 12:playG2();break;
      case 13:playG2D();break;
      case 14:playB2();break;
      case 15:playC3();break;

      case 16:playC3();break;
      case 17:playC3D();break;
      case 18:playE3();break;
      case 19:playF3();break;
      case 20:playG3();break;
      case 21:playG3D();break;
      case 22:playB3();break;
      case 23:playC4();break;

      case 24:playC4();break;
      case 25:playC4D();break;
      case 26:playE4();break;
      case 27:playF4();break;
      case 28:playG4();break;
      case 29:playG4D();break;
      case 30:playB4();break;
      case 31:playC5();break;

      case 32:playC1();break;
      case 33:playC1D();break;
      case 34:playE1();break;
      case 35:playF1();break;
      case 36:playG1();break;
      case 37:playG1D();break;
      case 38:playB1();break;
      case 39:playC2();break;

      case 40:playC2();break;
      case 41:playC2D();break;
      case 42:playE2();break;
      case 43:playF2();break;
      case 44:playG2();break;
      case 45:playG2D();break;
      case 46:playB2();break;
      case 47:playC3();break;

      case 48:playC3();break;
      case 49:playC3D();break;
      case 50:playE3();break;
      case 51:playF3();break;
      case 52:playG3();break;
      case 53:playG3D();break;
      case 54:playB3();break;
      case 55:playC4();break;

      case 56:playC4();break;
      case 57:playC4D();break;
      case 58:playE4();break;
      case 59:playF4();break;
      case 60:playG4();break;
      case 61:playG4D();break;
      case 62:playB4();break;
      case 63:playC5();break;}break;


case 1:

switch (a){
case 0:playC1();break;
case 1:playD1();break;
case 2:playE1();break;
case 3:playF1();break;
case 4:playG1();break;
case 5:playA1();break;
case 6:playB1();break;
case 7:playC2();break;

case 8:playC2();break;
case 9:playD2();break;
case 10:playE2();break;
case 11:playF2();break;
case 12:playG2();break;
case 13:playA2();break;
case 14:playB2();break;
case 15:playC3();break;

case 16:playC3();break;
case 17:playD3();break;
case 18:playE3();break;
case 19:playF3();break;
case 20:playG3();break;
case 21:playA3();break;
case 22:playB3();break;
case 23:playC4();break;

case 24:playC4();break;
case 25:playD4();break;
case 26:playE4();break;
case 27:playF4();break;
case 28:playG4();break;
case 29:playA4();break;
case 30:playB4();break;
case 31:playC5();break;

case 32:playC1();break;
case 33:playD1();break;
case 34:playE1();break;
case 35:playF1();break;
case 36:playG1();break;
case 37:playA1();break;
case 38:playB1();break;
case 39:playC2();break;

case 40:playC2();break;
case 41:playD2();break;
case 42:playE2();break;
case 43:playF2();break;
case 44:playG2();break;
case 45:playA2();break;
case 46:playB2();break;
case 47:playC3();break;

case 48:playC3();break;
case 49:playD3();break;
case 50:playE3();break;
case 51:playF3();break;
case 52:playG3();break;
case 53:playA3();break;
case 54:playB3();break;
case 55:playC4();break;

case 56:playC4();break;
case 57:playD4();break;
case 58:playE4();break;
case 59:playF4();break;
case 60:playG4();break;
case 61:playA4();break;
case 62:playB4();break;
case 63:playC5();break;}break;

case 2:

switch (a){
case 0:playC1();break;
case 1:playD1();break;
case 2:playE1();break;
case 3:playF1D();break;
case 4:playG1();break;
case 5:playA1();break;
case 6:playB1();break;
case 7:playC2();break;

case 8:playC2();break;
case 9:playD2();break;
case 10:playE2();break;
case 11:playF2D();break;
case 12:playG2();break;
case 13:playA2();break;
case 14:playB2();break;
case 15:playC3();break;

case 16:playC3();break;
case 17:playD3();break;
case 18:playE3();break;
case 19:playF3D();break;
case 20:playG3();break;
case 21:playA3();break;
case 22:playB3();break;
case 23:playC4();break;

case 24:playC4();break;
case 25:playD4();break;
case 26:playE4();break;
case 27:playF4D();break;
case 28:playG4();break;
case 29:playA4();break;
case 30:playB4();break;
case 31:playC5();break;

case 32:playC1();break;
case 33:playD1();break;
case 34:playE1();break;
case 35:playF1D();break;
case 36:playG1();break;
case 37:playA1();break;
case 38:playB1();break;
case 39:playC2();break;

case 40:playC2();break;
case 41:playD2();break;
case 42:playE2();break;
case 43:playF2D();break;
case 44:playG2();break;
case 45:playA2();break;
case 46:playB2();break;
case 47:playC3();break;

case 48:playC3();break;
case 49:playD3();break;
case 50:playE3();break;
case 51:playF3D();break;
case 52:playG3();break;
case 53:playA3();break;
case 54:playB3();break;
case 55:playC4();break;

case 56:playC4();break;
case 57:playD4();break;
case 58:playE4();break;
case 59:playF4D();break;
case 60:playG4();break;
case 61:playA4();break;
case 62:playB4();break;
case 63:playC5();break;}break;

}
  
  
  
  
  
  
  }
  
void playC1(){dac.setVoltage(calib*1,false);}
void playD1(){dac.setVoltage(calib*3,false);}
void playE1(){dac.setVoltage(calib*5,false);}
void playF1(){dac.setVoltage(calib*6,false);}
void playG1(){dac.setVoltage(calib*8,false);}
void playA1(){dac.setVoltage(calib*10,false);}
void playB1(){dac.setVoltage(calib*12,false);}  

void playC2(){dac.setVoltage(calib*13,false);}
void playD2(){dac.setVoltage(calib*15,false);}
void playE2(){dac.setVoltage(calib*17,false);}
void playF2(){dac.setVoltage(calib*18,false);}
void playG2(){dac.setVoltage(calib*20,false);}
void playA2(){dac.setVoltage(calib*22,false);}
void playB2(){dac.setVoltage(calib*24,false);}

void playC3(){dac.setVoltage(calib*25,false);}
void playD3(){dac.setVoltage(calib*27,false);}
void playE3(){dac.setVoltage(calib*29,false);}
void playF3(){dac.setVoltage(calib*30,false);}
void playG3(){dac.setVoltage(calib*32,false);}
void playA3(){dac.setVoltage(calib*34,false);}
void playB3(){dac.setVoltage(calib*36,false);}

void playC4(){dac.setVoltage(calib*37,false);}
void playD4(){dac.setVoltage(calib*39,false);}
void playE4(){dac.setVoltage(calib*41,false);}
void playF4(){dac.setVoltage(calib*42,false);}
void playG4(){dac.setVoltage(calib*44,false);}
void playA4(){dac.setVoltage(calib*46,false);}
void playB4(){dac.setVoltage(calib*48,false);}


void playC5(){dac.setVoltage(calib*49,false);}




void playD1D(){dac.setVoltage(calib*4,false);}
void playA1D(){dac.setVoltage(calib*11,false);}
void playF1D(){dac.setVoltage(calib*7,false);}
void playC1D(){dac.setVoltage(calib*2,false);}
void playG1D(){dac.setVoltage(calib*9,false);}

void playD2D(){dac.setVoltage(calib*16,false);}
void playA2D(){dac.setVoltage(calib*23,false);}
void playF2D(){dac.setVoltage(calib*19,false);}
void playC2D(){dac.setVoltage(calib*14,false);}
void playG2D(){dac.setVoltage(calib*21,false);}

void playD3D(){dac.setVoltage(calib*28,false);}
void playA3D(){dac.setVoltage(calib*35,false);}
void playF3D(){dac.setVoltage(calib*31,false);}
void playC3D(){dac.setVoltage(calib*26,false);}
void playG3D(){dac.setVoltage(calib*33,false);}

void playD4D(){dac.setVoltage(calib*40,false);}
void playA4D(){dac.setVoltage(calib*47,false);}
void playF4D(){dac.setVoltage(calib*43,false);}
void playC4D(){dac.setVoltage(calib*38,false);}
void playG4D(){dac.setVoltage(calib*45,false);}





void up (int a){
  
    switch (a){
    
    case 0 : lc.setLed(0,0,0,true);break;
    case 1 : lc.setLed(0,0,1,true);break;
    case 2 : lc.setLed(0,0,2,true);break;
    case 3 : lc.setLed(0,0,3,true);break;
    case 4 : lc.setLed(0,0,4,true);break;
    case 5 : lc.setLed(0,0,5,true);break;
    case 6 : lc.setLed(0,0,6,true);break;
    case 7 : lc.setLed(0,0,7,true);break;
    
    case 8 :  lc.setLed(0,1,0,true);break;
    case 9 :  lc.setLed(0,1,1,true);break;
    case 10 : lc.setLed(0,1,2,true);break;
    case 11 : lc.setLed(0,1,3,true);break;
    case 12 : lc.setLed(0,1,4,true);break;
    case 13 : lc.setLed(0,1,5,true);break;
    case 14 : lc.setLed(0,1,6,true);break;
    case 15 : lc.setLed(0,1,7,true);break;
    
    case 16 : lc.setLed(0,2,0,true);break;
    case 17 : lc.setLed(0,2,1,true);break;
    case 18 : lc.setLed(0,2,2,true);break;
    case 19 : lc.setLed(0,2,3,true);break;
    case 20 : lc.setLed(0,2,4,true);break;
    case 21 : lc.setLed(0,2,5,true);break;
    case 22 : lc.setLed(0,2,6,true);break;
    case 23 : lc.setLed(0,2,7,true);break;    

    case 24 : lc.setLed(0,3,0,true);break;
    case 25 : lc.setLed(0,3,1,true);break;
    case 26 : lc.setLed(0,3,2,true);break;
    case 27 : lc.setLed(0,3,3,true);break;
    case 28 : lc.setLed(0,3,4,true);break;
    case 29 : lc.setLed(0,3,5,true);break;
    case 30 : lc.setLed(0,3,6,true);break;
    case 31 : lc.setLed(0,3,7,true);break; 

    case 32 : lc.setLed(0,4,0,true);break;
    case 33 : lc.setLed(0,4,1,true);break;
    case 34 : lc.setLed(0,4,2,true);break;
    case 35 : lc.setLed(0,4,3,true);break;
    case 36 : lc.setLed(0,4,4,true);break;
    case 37 : lc.setLed(0,4,5,true);break;
    case 38 : lc.setLed(0,4,6,true);break;
    case 39 : lc.setLed(0,4,7,true);break;
    
    case 40 : lc.setLed(0,5,0,true);break;
    case 41 : lc.setLed(0,5,1,true);break;
    case 42 : lc.setLed(0,5,2,true);break;
    case 43 : lc.setLed(0,5,3,true);break;
    case 44 : lc.setLed(0,5,4,true);break;
    case 45 : lc.setLed(0,5,5,true);break;
    case 46 : lc.setLed(0,5,6,true);break;
    case 47 : lc.setLed(0,5,7,true);break;  
  
    case 48 : lc.setLed(0,6,0,true);break;
    case 49 : lc.setLed(0,6,1,true);break;
    case 50 : lc.setLed(0,6,2,true);break;
    case 51 : lc.setLed(0,6,3,true);break;
    case 52 : lc.setLed(0,6,4,true);break;
    case 53 : lc.setLed(0,6,5,true);break;
    case 54 : lc.setLed(0,6,6,true);break;
    case 55 : lc.setLed(0,6,7,true);break;    
  
    case 56 : lc.setLed(0,7,0,true);break;
    case 57 : lc.setLed(0,7,1,true);break;
    case 58 : lc.setLed(0,7,2,true);break;
    case 59 : lc.setLed(0,7,3,true);break;
    case 60 : lc.setLed(0,7,4,true);break;
    case 61 : lc.setLed(0,7,5,true);break;
    case 62 : lc.setLed(0,7,6,true);break;
    case 63 : lc.setLed(0,7,7,true);break;  
  
  
    }
  
  
  }


void down (int a){
  
    switch (a){
    
    case 0 : lc.setLed(0,0,0,false);break;
    case 1 : lc.setLed(0,0,1,false);break;
    case 2 : lc.setLed(0,0,2,false);break;
    case 3 : lc.setLed(0,0,3,false);break;
    case 4 : lc.setLed(0,0,4,false);break;
    case 5 : lc.setLed(0,0,5,false);break;
    case 6 : lc.setLed(0,0,6,false);break;
    case 7 : lc.setLed(0,0,7,false);break;
    
    case 8 : lc.setLed(0,1,0,false);break;
    case 9 : lc.setLed(0,1,1,false);break;
    case 10 : lc.setLed(0,1,2,false);break;
    case 11 : lc.setLed(0,1,3,false);break;
    case 12 : lc.setLed(0,1,4,false);break;
    case 13 : lc.setLed(0,1,5,false);break;
    case 14 : lc.setLed(0,1,6,false);break;
    case 15 : lc.setLed(0,1,7,false);break;  

    case 16 : lc.setLed(0,2,0,false);break;
    case 17 : lc.setLed(0,2,1,false);break;
    case 18 : lc.setLed(0,2,2,false);break;
    case 19 : lc.setLed(0,2,3,false);break;
    case 20 : lc.setLed(0,2,4,false);break;
    case 21 : lc.setLed(0,2,5,false);break;
    case 22 : lc.setLed(0,2,6,false);break;
    case 23 : lc.setLed(0,2,7,false);break;  

    case 24 : lc.setLed(0,3,0,false);break;
    case 25 : lc.setLed(0,3,1,false);break;
    case 26 : lc.setLed(0,3,2,false);break;
    case 27 : lc.setLed(0,3,3,false);break;
    case 28 : lc.setLed(0,3,4,false);break;
    case 29 : lc.setLed(0,3,5,false);break;
    case 30 : lc.setLed(0,3,6,false);break;
    case 31 : lc.setLed(0,3,7,false);break; 

    case 32 : lc.setLed(0,4,0,false);break;
    case 33 : lc.setLed(0,4,1,false);break;
    case 34 : lc.setLed(0,4,2,false);break;
    case 35 : lc.setLed(0,4,3,false);break;
    case 36 : lc.setLed(0,4,4,false);break;
    case 37 : lc.setLed(0,4,5,false);break;
    case 38 : lc.setLed(0,4,6,false);break;
    case 39 : lc.setLed(0,4,7,false);break; 

    case 40 : lc.setLed(0,5,0,false);break;
    case 41 : lc.setLed(0,5,1,false);break;
    case 42 : lc.setLed(0,5,2,false);break;
    case 43 : lc.setLed(0,5,3,false);break;
    case 44 : lc.setLed(0,5,4,false);break;
    case 45 : lc.setLed(0,5,5,false);break;
    case 46 : lc.setLed(0,5,6,false);break;
    case 47 : lc.setLed(0,5,7,false);break;  
  
    case 48 : lc.setLed(0,6,0,false);break;
    case 49 : lc.setLed(0,6,1,false);break;
    case 50 : lc.setLed(0,6,2,false);break;
    case 51 : lc.setLed(0,6,3,false);break;
    case 52 : lc.setLed(0,6,4,false);break;
    case 53 : lc.setLed(0,6,5,false);break;
    case 54 : lc.setLed(0,6,6,false);break;
    case 55 : lc.setLed(0,6,7,false);break;    
  
    case 56 : lc.setLed(0,7,0,false);break;
    case 57 : lc.setLed(0,7,1,false);break;
    case 58 : lc.setLed(0,7,2,false);break;
    case 59 : lc.setLed(0,7,3,false);break;
    case 60 : lc.setLed(0,7,4,false);break;
    case 61 : lc.setLed(0,7,5,false);break;
    case 62 : lc.setLed(0,7,6,false);break;
    case 63 : lc.setLed(0,7,7,false);break; 
    
    }
  
  
  }
  

