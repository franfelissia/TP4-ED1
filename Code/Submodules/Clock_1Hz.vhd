library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Clock_1Hz is Port (
    Ext: in  std_logic;
    En:  in  std_logic;
    Clk: out std_logic
); end Clock_1Hz;


architecture Behavioral of Clock_1Hz is
    
    signal Count: integer range 0 to 499 := 0;
    signal Aux:   std_logic              := '0';
    
begin
    
    Clk <= Aux;
    
    timer: process(Ext) begin
        if rising_edge(Ext) then
            if En = '0' then
                Count <= 0;
                Aux <= '0';
            elsif Count = 499 then
                Count <= 0;
                Aux  <= not(Aux);
            else
                Count <= Count + 1;
            end if;
        end if;
    end process timer;
    
end Behavioral;
