----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2018 09:36:08
-- Design Name: 
-- Module Name: clock - Behavioral
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

entity clock is
    Port ( CLK_100 : in STD_LOGIC;
           RESET : in STD_LOGIC;
           CLK_1 : out STD_LOGIC);
end clock;

architecture Behavioral of clock is

    signal count: integer;
    signal tmp : std_logic;
 
    begin
 
    process(CLK_100,reset,tmp)
    begin
        if(reset='0') then
            count<=0;
            tmp<='0';
            CLK_1 <='0';
        elsif(CLK_100'event and CLK_100='1') then
            count <=count+1; -- ce signal compte de 0 Ã  49
            if (count = 49) then
              tmp <= NOT tmp; -- quand count vaut 49, on inverse la sortie.
              count <= 0;
            end if;
        end if;
        
        CLK_1 <= tmp; 
    end process;

end Behavioral;

