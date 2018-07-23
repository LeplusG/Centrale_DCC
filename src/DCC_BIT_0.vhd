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

entity DCC_BIT_0 is
    Port ( GO_0 : in STD_LOGIC;
           CLK_100 : in STD_LOGIC;
           CLK_1 : in STD_LOGIC;
           RESET : in STD_LOGIC;
           FIN_0 : out STD_LOGIC;
           DCC_0 : out STD_LOGIC);
end DCC_BIT_0;

architecture Behavioral of DCC_BIT_0 is
    signal signal_FIN_0 : STD_LOGIC;
signal signal_DCC_0 : STD_LOGIC;

type Etat is(IDLE, SEND_ZERO,WAIT_MAE, SEND_ONE);
signal EP, EF : Etat;
signal cpt: integer:=0;

begin

process(CLK_100,RESET)
begin
     if RESET = '0' then
        EP <= IDLE; 
        FIN_0 <= '0';
        DCC_0 <= '0';             
     elsif(rising_edge(CLK_100)) then
        EP <= EF;
        FIN_0 <= signal_FIN_0;
        DCC_0 <= signal_DCC_0;  
     else null;
     end if;
end process;   

process(EP, GO_0,cpt) 
 begin       
        case EP is
             when IDLE => 
                          signal_FIN_0 <= '0';
                          signal_DCC_0 <= '0';
                          EF <= IDLE;
                          if GO_0 = '1'   then 
                             EF <= WAIT_MAE;
                          end if;
                          
             when WAIT_MAE =>
                            EF <= WAIT_MAE;  
                            signal_FIN_0 <= '0';
                            signal_DCC_0 <= '0';
                            EF <= WAIT_MAE;             
                            if GO_0 = '1'   then 
                               EF <= SEND_ZERO;
                            else
                                EF <= IDLE;
                            end if;
                          
             when SEND_ZERO =>
                         EF <= SEND_ZERO;    
                         signal_DCC_0 <= '0';
                         signal_FIN_0 <= '0';
                         if cpt = 100 then
                             EF <= SEND_ONE;
                          end if;
                          

             
             when SEND_ONE => 
                          EF <= SEND_ONE;
                          signal_DCC_0 <= '1'; 
                          if cpt = 200 then
                             EF <= IDLE;
                             signal_FIN_0 <= '1';
                          else 
                             signal_FIN_0 <='0';
                          end if;
                          
                          
             when OTHERS => NULL;
             end case;
    
end process;

    
process (CLK_1,EP)
begin
      
    if rising_edge(CLK_1) then
            cpt <= cpt + 1;
    end if;
    
    if EP=IDLE then
        cpt <= 0;        
    end if;
    
end process;
end Behavioral;
