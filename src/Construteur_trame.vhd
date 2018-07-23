----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2018 21:39:20
-- Design Name: 
-- Module Name: Construteur_trame - Behavioral
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

entity Construteur_trame is
     Port ( CLK_100 : in STD_LOGIC;
            RESET : in STD_LOGIC;
            RG_CONTROL : in   std_logic_vector (31 downto 0);
            RG_PARAM_1 : in   std_logic_vector (31 downto 0);
            TRAME_DCC : out   std_logic_vector (59 downto 0)
      );
end Construteur_trame;

architecture Behavioral of Construteur_trame is
signal	signal_TRAME_DCC   : std_logic_vector(59 downto 0);
attribute keep : string;
attribute keep of signal_TRAME_DCC : signal is "true";
begin
Re:	process(CLK_100, RESET)
		begin
		      
			if RESET = '0' then 
                TRAME_DCC <= (others => '0');
			
			elsif rising_edge (CLK_100) then 
			     if RG_CONTROL(0) = '1' then
			         signal_TRAME_DCC (59 downto 44)   <= (others => '1');
                     signal_TRAME_DCC (45)   <= '0';
                     signal_TRAME_DCC (44 downto 37) <= RG_PARAM_1(7 downto 0);
                     signal_TRAME_DCC (36)   <= '0';
                 end if;
                 
			     if RG_CONTROL(1) = '1' then
			         signal_TRAME_DCC (35 downto 28) <= RG_PARAM_1(15 downto 8);
			         signal_TRAME_DCC (27)   <= '0';
			         signal_TRAME_DCC (26 downto 19)   <= RG_PARAM_1(7 downto 0) xor RG_PARAM_1(15 downto 8);
                     signal_TRAME_DCC (18)   <= '1';
                     signal_TRAME_DCC (17 downto 0)   <= (others => '0');
                 end if;
			     
			     if RG_CONTROL(2) = '1' then	     
			         signal_TRAME_DCC (35 downto 28) <= RG_PARAM_1(15 downto 8);
			         signal_TRAME_DCC (27)   <= '0';			         
			         signal_TRAME_DCC (26 downto 19) <= RG_PARAM_1(23 downto 16);
			         signal_TRAME_DCC (18)   <= '0';
			         signal_TRAME_DCC (17 downto 10)   <= RG_PARAM_1(7 downto 0) xor RG_PARAM_1(15 downto 8) xor RG_PARAM_1(23 downto 16);
                     signal_TRAME_DCC (9)   <= '1';
                     signal_TRAME_DCC (8 downto 0)   <= (others => '0');
			     end if;
			     
			     if RG_CONTROL(3) = '1' then		     
			         signal_TRAME_DCC (35 downto 28) <= RG_PARAM_1(15 downto 8);
			         signal_TRAME_DCC (27)   <= '0';			         
                     signal_TRAME_DCC (26 downto 19) <= RG_PARAM_1(23 downto 16);
                     signal_TRAME_DCC (18)   <= '0';
			         signal_TRAME_DCC (17 downto 10) <= RG_PARAM_1(31 downto 24);
			         signal_TRAME_DCC (9)   <= '0';
			         signal_TRAME_DCC (8 downto 1)   <= RG_PARAM_1(7 downto 0) xor RG_PARAM_1(15 downto 8) xor RG_PARAM_1(23 downto 16) xor RG_PARAM_1(31 downto 24);
			         signal_TRAME_DCC (0)   <= '1';
			     end if;

                                  
			     if RG_CONTROL(4) = '1' then
			         TRAME_DCC<=signal_TRAME_DCC;
			     end if ;
			     
			     if RG_CONTROL(31 downto 0) = "11111111111111111111111111111111" then
                     TRAME_DCC<=signal_TRAME_DCC;
                 end if ;
                 
               else null;
			end if;
		end process;

end Behavioral;
