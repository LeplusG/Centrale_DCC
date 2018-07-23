----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2018 12:02:16
-- Design Name: 
-- Module Name: DCC_BIT_0 - Behavioral
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

entity DCC_BIT_1 is
    Port ( GO_1 : in STD_LOGIC;
           CLK_100 : in STD_LOGIC;
           CLK_1 : in STD_LOGIC;
           RESET : in STD_LOGIC;
           FIN_1 : out STD_LOGIC;
           DCC_1 : out STD_LOGIC);
end DCC_BIT_1;

architecture Behavioral of DCC_BIT_1 is
 signal signal_FIN_1 : STD_LOGIC;
signal signal_DCC_1 : STD_LOGIC;

type Etat is(IDLE, SEND_ZERO,WAIT_MAE, SEND_ONE);
signal EP, EF : Etat;
signal cpt: integer:=0;

begin

lol: process(CLK_100,RESET)
begin
 if RESET = '0' then
    FIN_1 <= '0';
    DCC_1 <= '0';
    EP <= IDLE;           
 elsif(rising_edge(CLK_100)) then
    FIN_1 <= signal_FIN_1;
    DCC_1 <= signal_DCC_1;
    EP <= EF; 
 else null;
 end if;
end process;   

cat: process(EP, GO_1,cpt) 
begin       
    case EP is
         when IDLE => 
                      EF <= IDLE;
                      signal_FIN_1 <= '0';
                      signal_DCC_1 <= '0';
                      if GO_1 = '1'   then 
                         EF <= WAIT_MAE;
                      end if;


         when WAIT_MAE =>
                        EF <= WAIT_MAE;
                        signal_FIN_1 <= '0';
                        signal_DCC_1 <= '0';
                        if GO_1 = '1'   then 
                           EF <= SEND_ZERO;
                        else
                            EF <= IDLE;
                        end if;
                      
         when SEND_ZERO =>    
                      EF <= SEND_ZERO;   
                      signal_FIN_1 <= '0';
                      signal_DCC_1 <= '0';                      
                      if cpt = 58 then
                         EF <= SEND_ONE;
                      end if;
         
         when SEND_ONE => 
                      EF <= SEND_ONE;
                      signal_DCC_1 <= '1';
                      if cpt = 116 then
                         EF <= IDLE;
                         signal_FIN_1 <= '1';
                      else 
                         signal_FIN_1 <= '0';
                      end if;

                      
                      
         when OTHERS => null;

         end case;
 

end process;



compteur: process (CLK_1,EP)
begin
  
    if rising_edge(CLK_1) then
        cpt <= cpt + 1;
    end if;

    if EP=IDLE then
        cpt <= 0;        
    end if;

end process;


end Behavioral;
