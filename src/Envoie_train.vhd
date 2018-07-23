----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.04.2018 10:51:24
-- Design Name: 
-- Module Name: Envoie_train - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Envoie_train is
Port ( 
           CLK_100          : in STD_LOGIC;
           RESET            : in STD_LOGIC;
           
           RG_CONTROL       : in   std_logic_vector (31 downto 0);
           RG_PARAM_1       : in   std_logic_vector (31 downto 0);

           SORTIE_DCC       : out STD_LOGIC);
end Envoie_train;

architecture Behavioral of Envoie_train is


           signal GO          : std_logic;
           signal  NAME       : std_logic_vector (7 downto 0) ;
           signal  CMD_1      : std_logic_vector (7 downto 0) ;
           signal  CMD_2      : std_logic_vector (7 downto 0);
           signal  CMD_3      : std_logic_vector (7 downto 0) ;

            signal CLK_1        :  std_logic;
			signal REG			:  std_logic_vector (1 downto 0);
			signal FIN_1		:  std_logic;
			signal FIN_0		:  std_logic;
			signal FIN		    :  std_logic;
			signal COMREG		:  std_logic_vector(1 downto 0);	
			signal GO_1	     	:  std_logic ;
			signal GO_0	     	:  std_logic ;
			signal COMTEMPO	    :  std_logic ;
			signal DCC_1        :  std_logic;
			signal DCC_0        :  std_logic;
            signal TRAME_DCC : std_logic_vector (59 downto 0);
begin
clock_1MHz: entity work.clock
    port map(CLK_100,RESET,CLK_1);

tempo: entity work.tempo
    port map(CLK_1,RESET,COMTEMPO,FIN);
    
DCC_BIT1: entity work.DCC_BIT_1
    port map(GO_1,CLK_100,CLK_1,RESET,FIN_1,DCC_1);
        
DCC_BIT0: entity work.DCC_BIT_0
    port map(GO_0,CLK_100,CLK_1,RESET,FIN_0,DCC_0);

Registre_DCC: entity work.Registre_DCC
    port map(CLK_100,RESET,TRAME_DCC,COMREG,REG);
       
MAE: entity work.MAE
    port map(CLK_100,RESET,REG,FIN_1,FIN_0,FIN,COMREG,GO_1,GO_0,COMTEMPO);
            
Construteur_trames: entity work.Construteur_trame
    port map(CLK_100,RESET,RG_CONTROL,RG_PARAM_1,TRAME_DCC);

SORTIE_DCC<= DCC_1 or DCC_0;



end Behavioral;
