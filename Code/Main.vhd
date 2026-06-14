library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Main is
    Port (
        clk_100MHz: in  std_logic;
        vauxp6:     in  std_logic;
        vauxn6:     in  std_logic;
        vp:         in  std_logic;
        vn:         in  std_logic;
        btn:        in  std_logic;
        swc:        in  std_logic_vector(2 downto 0);
        dac:        out std_logic_vector(7 downto 0);
        leds:       out std_logic_vector(7 downto 0);
        grab:       out std_logic;
        con_disp:   out std_logic
    );
end Main;

architecture Structural of Main is

    component ADC is port (
        daddr_in:    in  STD_LOGIC_VECTOR (6 downto 0);
        den_in:      in  STD_LOGIC;
        di_in:       in  STD_LOGIC_VECTOR (15 downto 0);
        dwe_in:      in  STD_LOGIC;
        do_out:      out STD_LOGIC_VECTOR (15 downto 0);
        drdy_out:    out STD_LOGIC;
        dclk_in:     in  STD_LOGIC;
        vauxp6:      in  STD_LOGIC;
        vauxn6:      in  STD_LOGIC;
        busy_out:    out STD_LOGIC;
        channel_out: out STD_LOGIC_VECTOR (4 downto 0);
        eoc_out:     out STD_LOGIC;
        eos_out:     out STD_LOGIC;
        alarm_out:   out STD_LOGIC;
        vp_in:       in  STD_LOGIC;
        vn_in:       in  STD_LOGIC
    ); end component;
    
    component Memoria is Port (
        clk_100MHz: in  std_logic;
        btn:        in  std_logic;
        sw:         in  std_logic_vector(1 downto 0);
        eoc:        in  std_logic;
        drdy:       in  std_logic;
        din:        in  std_logic_vector(7 downto 0);
        dout:       out std_logic_vector(7 downto 0);
        grab:       out std_logic
    ); end component;
    
    signal adc_out:  std_logic_vector (15 downto 0);    
    signal eoc:      std_logic;
    signal drdy:     std_logic;
    signal data:     std_logic_vector(7 downto 0);
    signal mem_out:  std_logic_vector(7 downto 0);
    signal vumetro:  std_logic_vector(7 downto 0);

begin
    ADC1: ADC port map(
        dclk_in  => clk_100MHz,
        vp_in    => vp,
        vn_in    => vn,
        vauxp6   => vauxp6,
        vauxn6   => vauxn6,
        eoc_out  => eoc,
        di_in    => "0000000000000000",
        dwe_in   => '0',
        daddr_in => "0010110",
        den_in   => eoc,
        do_out   => adc_out,
        drdy_out => drdy
    );
    
    Memoria1: Memoria port map (
        clk_100MHz => clk_100MHz,
        btn        => btn,
        sw         => swc(1 downto 0),
        eoc        => eoc,
        drdy       => drdy,
        din        => adc_out(15 downto 8),
        dout       => mem_out,
        grab       => grab
    );
    
    -- Salidas
    
    with swc(1) select data <=
        mem_out              when '0',
        adc_out(15 downto 8) when '1',
        "ZZZZZZZZ"           when others;
    
    with data(7 downto 5) select vumetro <=
        "00000001" when "000",
        "00000011" when "001",
        "00000111" when "010",
        "00001111" when "011",
        "00011111" when "100",
        "00111111" when "101",
        "01111111" when "110",
        "11111111" when "111";
    
    with swc(2) select leds <=
        data    when '0',
        vumetro when '1';
    
    dac      <= data;
    con_disp <= swc(1);
    
end Structural;
