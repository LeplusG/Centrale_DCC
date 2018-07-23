----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2018 20:26:00
-- Design Name: 
-- Module Name: Registre_DCC - Behavioral
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
use IEEE.NUMERIC_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Registre_DCC is
       port 	(    CLK_100 	    : in  std_logic;
		             RESET		    : in  std_logic;
                     TRAME_DCC      : in  std_logic_vector (59 downto 0);
                     COMREG         : in std_logic_vector  ( 1 downto 0);
                     REG			: out  std_logic_vector (1 downto 0)
                );
end Registre_DCC;

architecture Behavioral of Registre_DCC is

    	signal	signal_TRAME_DCC   : std_logic_vector(59 downto 0);	
    	signal  flag               :std_logic;    
    	
begin
Re:	process(CLK_100, RESET, COMREG)
		begin
			if RESET = '0' then 
			     signal_TRAME_DCC <= "000000000000000000000000000000000000000000000000000000000000";
			     REG <= "00";
			     flag<='0';

			elsif rising_edge (CLK_100) then 
			     if signal_TRAME_DCC = "000000000000000000000000000000000000000000000000000000000000" and flag= '0'then
                      REG <= "01";
                      flag<='1';
                
                 elsif signal_TRAME_DCC /= "000000000000000000000000000000000000000000000000000000000000" and flag ='0' then
                    REG(0) <=signal_TRAME_DCC(59);
                    REG(1) <= '1';
                    
                  else flag<='0';
                 
                 end if;
                 
			     if COMREG = "01" then
			         signal_TRAME_DCC <= std_logic_vector(unsigned(signal_TRAME_DCC) sll 1);
			     elsif COMREG ="10" then 
			         signal_TRAME_DCC<=TRAME_DCC; 
			     end if ;


			end if;		
		end process;

end Behavioral;
