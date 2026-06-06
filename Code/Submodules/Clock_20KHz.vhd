library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Clock_20KHz is Port (
    Ext: in  std_logic;
    Clk: out std_logic
); end Clock_20KHz;


architecture Behavioral of Clock_20KHz is

    signal Count: integer range 0 to 2499 := 0;
    signal Aux:   std_logic               := '0';

begin

    Clk <= Aux;

    Timer: process(Ext) begin
        if rising_edge(Ext) then
            if Count = 2499 then
                Count <= 0;
                Aux   <= not(Aux);
            else
                Count <= Count + 1;
            end if;
        end if;
    end process Timer;

end Behavioral;
