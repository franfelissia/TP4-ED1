library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Debounce is Port(
    Clk:  in  std_logic;
    Btn:  in  std_logic;
    Data: out std_logic
); end Debounce;

architecture Behavioral of Debounce is
    
    signal Count: integer range 0 to 31 := 0;
    
begin
    
    process (Clk, Btn, Count) begin
        if Btn = '0' then
            Count <= 0;
        elsif rising_edge(Clk) and Count < 31 then
            Count <= Count + 1;
        end if;
    end process;
    
    Data <= '1' when Count = 31 else '0';
    
end Behavioral;
