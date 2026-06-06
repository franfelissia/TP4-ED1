library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Main is
    Port (
        btns:       in  std_logic_vector(2 downto 0);
        clk_100MHz: in  std_logic;
        vauxp6:     in  std_logic;
        vauxn6:     in  std_logic;
        vp:         in  std_logic;
        vn:         in  std_logic;
        dac:        out std_logic_vector(7 downto 0);
        led:        out std_logic_vector(7 downto 0);
        led_c:      out std_logic_vector(2 downto 0)
    );
end Main;

architecture Structural of Main is

    component ADC is port (
        daddr_in:    in  STD_LOGIC_VECTOR (6 downto 0);  -- Address bus for the dynamic reconfiguration port
        den_in:      in  STD_LOGIC;                      -- Enable Signal for the dynamic reconfiguration port
        di_in:       in  STD_LOGIC_VECTOR (15 downto 0); -- Input data bus for the dynamic reconfiguration port
        dwe_in:      in  STD_LOGIC;                      -- Write Enable for the dynamic reconfiguration port
        do_out:      out STD_LOGIC_VECTOR (15 downto 0); -- Output data bus for dynamic reconfiguration port
        drdy_out:    out STD_LOGIC;                      -- Data ready signal for the dynamic reconfiguration port
        dclk_in:     in  STD_LOGIC;                      -- Clock input for the dynamic reconfiguration port
        convst_in:   in  STD_LOGIC;                      -- Convert Start Input
        vauxp6:      in  STD_LOGIC;                      -- Auxiliary Channel 6
        vauxn6:      in  STD_LOGIC;
        busy_out:    out STD_LOGIC;                      -- ADC Busy signal
        channel_out: out STD_LOGIC_VECTOR (4 downto 0);  -- Channel Selection Outputs
        eoc_out:     out STD_LOGIC;                      -- End of Conversion Signal
        eos_out:     out STD_LOGIC;                      -- End of Sequence Signal
        alarm_out:   out STD_LOGIC;                      -- OR'ed output of all the Alarms
        vp_in:       in  STD_LOGIC;                      -- Dedicated Analog Input Pair
        vn_in:       in  STD_LOGIC
    ); end component;
    
    component Clock_1KHz is Port (
        Ext:         in  std_logic;
        Clk:         out std_logic
    ); end component;
    
    component Clock_20KHz is Port (
        Ext:         in  std_logic;
        Clk:         out std_logic
    ); end component;
    
    component Estado is Port (
        btns:        in  std_logic_vector(2 downto 0);
        clk:         in  std_logic;
        eom:         in  std_logic;
        st:          out std_logic_vector(1 downto 0);
        rst:         out std_logic
    ); end component;
    
    component Memoria is Port (
        st:          in  std_logic_vector(1 downto 0);
        clk:         in  std_logic;
        drdy:        in  std_logic;
        eoc:         in  std_logic;
        rst:         in  std_logic;
        din:         in  std_logic_vector(7 downto 0);
        dout:        out std_logic_vector(7 downto 0);
        eom:         out std_logic
    ); end component;
    
    signal eoc:       std_logic;
    signal eom:       std_logic;
    signal st:        std_logic_vector(1  downto 0);
    signal ADC_out:   std_logic_vector(15 downto 0);
    signal mem_out:   std_logic_vector(7  downto 0);
    signal drdy:      std_logic;
    signal clk_20KHz: std_logic;
    signal clk_1KHz:  std_logic;
    signal rst:       std_logic;

begin
    ADC1: ADC port map(
        daddr_in  => "0010110",
        den_in    => eoc,
        di_in     => "0000000000000000",
        dwe_in    => '0',
        do_out    => ADC_out,
        drdy_out  => drdy,
        dclk_in   => clk_100MHz,
        convst_in => clk_20KHz,
        vauxp6    => vauxp6,
        vauxn6    => vauxn6,
        eoc_out   => eoc,
        vp_in     => vp,
        vn_in     => vn
    );
    
    Clock_1KHz1: Clock_1KHz port map(
        Ext       => clk_100MHz,
        Clk       => clk_1KHz
    );
    
    Clock_20KHz1: Clock_20KHz port map(
        Ext       => clk_100MHz,
        Clk       => clk_20KHz
    );
    
    Estado1: Estado port map(
        btns      => btns,
        clk       => clk_1KHz,
        eom       => eom,
        st        => st,
        rst       => rst
    );
    
    Memoria1: Memoria port map (
        st        => st,
        clk       => clk_20KHz,
        drdy      => drdy,
        eoc       => eoc,
        rst       => rst,
        din       => ADC_out(15 downto 8),
        dout      => mem_out,
        eom       => eom
    );
    
    with st select led <=
        ADC_out(15 downto 8) when "11",
        mem_out              when "10",
        "ZZZZZZZZ"           when others;
    
    with st select dac <=
        ADC_out(15 downto 8) when "11",
        mem_out              when "10",
        "ZZZZZZZZ"           when others;
    
    with st select led_c <=
        "001" when "11",
        "010" when "10",
        "100" when "01",
        "000" when others;
    
end Structural;
