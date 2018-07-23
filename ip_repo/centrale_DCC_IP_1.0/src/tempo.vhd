----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2018 10:16:40
-- Design Name: 
-- Module Name: tempo - Behavioral
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

entity tempo is
    Port ( CLK_1 : in STD_LOGIC;
           RESET : in STD_LOGIC;
           COMTEMPO : in STD_LOGIC;
           FIN : out STD_LOGIC);
end tempo;

architecture Behavioral of tempo is


    signal count: integer;
 
    begin
    
    process(RESET, CLK_1)
    begin
        if(RESET='0') then
                count<=0;
                FIN <= '0';
        elsif (rising_edge(CLK_1)) then
            
            
            if (count = 6000) and COMTEMPO='1' then
                  FIN <= '1';
                  count <= 0;
            elsif count /= 6000 and COMTEMPO='1' then
                count <=count+1;
            else 
                FIN <= '0'; 
            end if;
        end if; 
    end process;
    

end Behavioral;
