library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Memoria is Port (
    st:   in  std_logic_vector(1 downto 0);
    clk:  in  std_logic;
    drdy: in  std_logic;
    eoc:  in  std_logic;
    rst:  in  std_logic;
    din:  in  std_logic_vector(7  downto 0);
    dout: out std_logic_vector(7  downto 0);
    eom:  out std_logic
); end Memoria;


architecture Behavioral of Memoria is

    type ram_type is array (0 to 131071)
        of std_logic_vector(7 downto 0);
    
    
    signal RAM:   ram_type;
    signal addr:  integer range 0 to 99999;
    signal we:    std_logic;
    signal clk_r: std_logic;
    signal clk_c: std_logic;  

begin
    
    we    <= '1'  when st = "01" else -- Grabando
             '0';                     -- Cualquier otro caso
    
    clk_r <= clk  when st = "10" else -- Reproduciendo
             drdy when st = "01" else -- Grabando
             '0';                     -- Cualquier otro caso
             
    clk_c <= clk  when st = "10" else -- Reproduciendo
             eoc  when st = "01" else -- Grabando
             '0';                     -- Cualquier otro caso
    
    RAM_128Kbx8: process(clk_r) begin
        if rising_edge(clk_r) then
            if we = '1' then
                RAM(addr) <= din;
            end if;
            dout <= RAM(addr);
        end if;
    end process RAM_128Kbx8;
    
    Contador: process(clk_c, rst) begin
        if rst = '1' then addr <= 0;
        elsif rising_edge(clk_c) then
            if addr = 99999 then
                eom  <= '1';
                addr <= 0;
            else
                eom  <= '0';
                addr <= addr + 1;
            end if;
        end if;
    end process Contador;
    
end Behavioral;
