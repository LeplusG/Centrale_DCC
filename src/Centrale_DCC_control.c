/*
 * Centrale_DCC_control.c
 *
 *  Created on: 9 mai 2018
 *      Author: Kiasa
 */


#include <xgpio.h>
#include <xparameters.h>
#include <sleep.h>
#include <centrale_DCC_IP.h>

#define NAME  0
#define OCTET1  1
#define OCTET2 2
#define OCTET3 3
#define ENVOIE_TRAME  4


int main()
{
    XGpio led_switch, boutons; int toto;

    u16 led_buffer = 0;
    u16 sw_buffer = 0;
    u16 boutons_buffer = 0;
    u8 cpt = 6;
    u8 btc = 0;
    u8 btr = 0;
    u8 btl = 0;
	u8 btu = 0;
	u8 name = 0;
	u32 octets = 0;
    u32 reg_controle = 0;
    u32 reg_param = 0;



    XGpio_Initialize(&led_switch,XPAR_LED_SWITCH_DEVICE_ID);
    XGpio_Initialize(&boutons,XPAR_BOUTONS_DEVICE_ID);
    XGpio_SetDataDirection(&led_switch,1,1);
    XGpio_SetDataDirection(&led_switch,2,0);
    XGpio_SetDataDirection(&boutons,1,1);

    while (1){
        boutons_buffer = XGpio_DiscreteRead(&boutons,1);
        sw_buffer     = XGpio_DiscreteRead(&led_switch,1);

        btr = boutons_buffer & 0b01000;
        btc = boutons_buffer & 0b00001;
        btl = boutons_buffer & 0b00100;
		btu = boutons_buffer & 0b00010;

        if (btr)
        {
            usleep(100000);
            cpt = (cpt - 1) % 4;
        }
        if (btl)
        {
            usleep(100000);
            cpt = (cpt + 1) % 4;
        }
		if (btu)
		{
			usleep(100000);
            cpt = 7;
		}

        if (btc)
        {
            usleep(100000);
            reg_controle |= (1 << ENVOIE_TRAME);
            XGpio_DiscreteWrite(&led_switch,2,0b1111111111111111);
            usleep(100000);
            XGpio_DiscreteWrite(&led_switch,2,led_buffer);
        }
        else {
        	reg_controle &= ~(1 << ENVOIE_TRAME);
        }

        if (cpt == 7)
        {
            reg_controle |= (1 << NAME);
            led_buffer = 0b1;
            XGpio_DiscreteWrite(&led_switch,2,led_buffer);
			name = sw_buffer & 0b11111111;
        }

		else if(cpt == 0)
        {
            reg_controle |= (1 << OCTET1);
            reg_controle &= ~(1 << OCTET2);
            led_buffer = 0b10;
            XGpio_DiscreteWrite(&led_switch,2,led_buffer);
            octets = 0b01000000 | (sw_buffer & 0b111111);
        }

        else if(cpt == 1)
        {
            reg_controle |= (1 << OCTET1);
            reg_controle &= ~(1 << OCTET2);
            led_buffer = 0b100;
            XGpio_DiscreteWrite(&led_switch,2,led_buffer);
            octets = 0b10000000 | (sw_buffer & 0b11111);
        }

        else if(cpt == 2)
        {
            reg_controle |= (1 << OCTET1);
            reg_controle &= ~(1 << OCTET2);
            led_buffer = 0b1000;
            XGpio_DiscreteWrite(&led_switch,2,led_buffer);
			octets = 0b10100000 | (sw_buffer & 0b11111);
        }

        else if(cpt == 3)
        {
            reg_controle |= (1 << OCTET2);
            reg_controle &= ~(1 << OCTET1);
            led_buffer = 0b10000;
			octets = 0b0000000011011110 | (sw_buffer & 0b1111111100000000);
        }
        else cpt = 0;
		reg_param = (octets << 8) | name;
		XGpio_DiscreteWrite(&led_switch,2,led_buffer);
		CENTRALE_DCC_IP_mWriteReg(XPAR_CENTRALE_DCC_IP_0_S00_AXI_BASEADDR,CENTRALE_DCC_IP_S00_AXI_SLV_REG0_OFFSET,reg_controle);
		CENTRALE_DCC_IP_mWriteReg(XPAR_CENTRALE_DCC_IP_0_S00_AXI_BASEADDR,CENTRALE_DCC_IP_S00_AXI_SLV_REG1_OFFSET,reg_param);
    }
}
