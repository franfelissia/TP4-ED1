library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Memoria is Port (
    clk_100MHz: in  std_logic;
    btn:        in  std_logic;
    sw:         in  std_logic_vector(1 downto 0);
    eoc:        in  std_logic;
    drdy:       in  std_logic;
    din:        in  std_logic_vector(7 downto 0);
    dout:       out std_logic_vector(7 downto 0);
    grab:       out std_logic
); end Memoria;


architecture Behavioral of Memoria is
    
    component Clock_1KHz is Port (
        Ext:  in  std_logic;
        Clk:  out std_logic
    ); end component;
    
    component Debounce is Port(
        Clk:  in  std_logic;
        Btn:  in  std_logic;
        Data: out std_logic
    ); end component;
    
    component Clock_1Hz is Port (
        Ext:  in  std_logic;
        En:   in  std_logic;
        Clk:  out std_logic
    ); end component;
    
    type ram_type is array (0 to 155647)
        of std_logic_vector(7 downto 0);
    
    signal eom:      std_logic;
    signal btnAux:   std_logic;
    signal clk_1Khz: std_logic;
    signal we:       std_logic;
    signal weAux:    std_logic;
    signal weD:      std_logic;
    signal clk_c:    std_logic;
    signal rst:      std_logic;
    signal addr:     integer range 0 to 149000;
    signal clk_d:    std_logic;
    signal RAM:      ram_type;

begin
    
    C1KHz: Clock_1KHz port map(
        Ext   => clk_100MHz,
        Clk   => clk_1KHz
    );
    
    Boton: Debounce port map (
        Clk  => Clk_1KHz,
        Btn  => Btn,
        Data => BtnAux
    );
    
    JK : process (clk_100MHz) begin
        if rising_edge(clk_100MHz) then
            if weAux = '0' then
                if BtnAux = '1' then
                    weAux <= '1';
                end if;
            elsif weAux = '1' then
                if eom = '1' then
                    weAux <= '0';
                end if;
            end if;
        end if;
    end process JK;
    
    with sw(0) select we <=
        weAux and sw(1) when '0',
        sw(1)           when '1',
        'Z'             when others;
    
    C1Hz: Clock_1Hz port map(
        Ext => clk_1KHz,
        En  => we,
        Clk => grab
    );
    
    FFD: process(clk_c) begin
        if rising_edge(clk_c) and clk_c = '1' then
            weD <= we;
        end if;
    end process FFD;
    
    rst <= we and not(weD);
    
    FFT_c: process(eoc) begin
        if rising_edge(eoc) and eoc = '1' then
            clk_c <= not clk_c;
        end if;
    end process FFT_c;
    
    Contador: process(clk_c) begin
        if rising_edge(clk_c) and clk_c = '1' then
            if rst = '1' then addr <= 0;
            elsif addr = 149000 then
                eom  <= '1';
                addr <= 0;
            else
                eom  <= '0';
                addr <= addr + 1;
            end if;
        end if;
    end process Contador;
    
    FFT_d: process(drdy) begin
        if rising_edge(drdy) then
            clk_d <= not clk_d;
        end if;
    end process FFT_d;
    
    RAM_150Kbx8: process(clk_d) begin
        if rising_edge(clk_d) and clk_d = '1' then
            if we = '1' then
                RAM(addr) <= din;
            end if;
            dout <= RAM(addr);
        end if;
    end process RAM_150Kbx8;
    
end Behavioral;
