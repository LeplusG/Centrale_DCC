----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.03.2018 15:09:27
-- Design Name: 
-- Module Name: MAE - Behavioral
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

entity MAE is
port 	( 	CLK_100 	    : in  std_logic;
			RESET		    : in  std_logic;
			REG			    : in  std_logic_vector(1 downto 0);
			FIN_1			: in  std_logic;
			FIN_0			: in  std_logic;
			FIN		    	: in  std_logic;
			COMREG		    : out std_logic_vector(1 downto 0) ;	
			GO_1	     	: out std_logic;
			GO_0	     	: out std_logic;
			COMTEMPO	    : out std_logic
		);
end MAE;

architecture Behavioral of MAE is 

	signal	signal_GO_1		: std_logic := '0';
	signal	signal_GO_0		: std_logic := '0';
	signal	signal_COMREG   : std_logic_vector(1 downto 0) := "00";	
	signal	signal_COMTEMPO	: std_logic := '0';
	
	type etat is ( DEBUT,SEND_0,SEND_1,TEMPO);
	signal EP, ES 	: etat;
	
begin

Res:	process(CLK_100, RESET)
		begin
			if RESET = '0' then
				COMREG <= "00";	
                GO_1 <= '0';
                GO_0 <= '0';
                COMTEMPO <= '0';
                EP <= DEBUT;
			elsif rising_edge (CLK_100) then 
			    EP <= ES;           
	            GO_1 <= signal_GO_1;
                GO_0 <= signal_GO_0;    
                COMREG <= signal_COMREG;
                COMTEMPO <= signal_COMTEMPO;			
			end if;
		end process Res;
		

EtatPresent:	process(EP, FIN_1, FIN_0, REG, FIN)
		begin
		case (EP) is
			when DEBUT => 
                 signal_GO_1     <= '0'; 
                 signal_GO_0     <= '0';
                 signal_COMREG   <= "00";
                 signal_COMTEMPO <= '0';    

			     if REG="01" then
                    ES <= TEMPO;
			     elsif    REG = "11" then
			        ES <= SEND_1;
			     elsif REG = "10" then
			        ES <= SEND_0;
                 else 
                    ES <= DEBUT;
			     end if;
			
			when SEND_1 =>
			     ES <= SEND_1;
			     signal_GO_1     <= '1'; 
                 signal_GO_0     <= '0';
                 signal_COMREG   <= "00";
                 signal_COMTEMPO <= '0';	
                 
                 if    FIN_1 = '1' then 
                     signal_COMREG   <= "01";
                     signal_GO_1     <= '0';
                     if REG="01" then
                        ES <= TEMPO;
                     elsif    REG = "11" then
                        ES <= SEND_1;
                     elsif REG = "10" then
                        ES <= SEND_0;
                     end if;

                 end if;
			
			when SEND_0 => 
			     ES <= SEND_0;
			     signal_GO_1      <= '0'; 
                 signal_GO_0     <= '1';
                 signal_COMREG   <= "00";
                 signal_COMTEMPO <= '0';
			     
                 if    FIN_0 = '1' then 
                       signal_COMREG   <= "01";
                       signal_GO_0     <= '0';
                       if REG="01" then
                          ES <= TEMPO;
                       elsif  REG = "11" then
                          ES <= SEND_1;
                       elsif REG = "10" then
                          ES <= SEND_0;
                       end if;
                 end if;
			
			when TEMPO => 
		         ES <= TEMPO;
			     signal_GO_1      <= '0'; 
                 signal_GO_0     <= '0';
                 signal_COMREG   <= "00";
                 signal_COMTEMPO <= '1';

                 if    FIN = '1' then 
                     signal_COMREG   <= "10";
                     signal_COMTEMPO <= '0';
                     if REG="01" then
                        ES <= TEMPO;
                     elsif    REG = "11" then
                        ES <= SEND_1;
                     elsif REG = "10" then
                        ES <= SEND_0;
                     end if;
                 end if;
                   
			
			when others => null;
		end case;

	end process;

		

end architecture;
