library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Estado is Port (
    btns: in  std_logic_vector(2 downto 0);
    clk:  in  std_logic;
    eom:  in  std_logic;
    st:   out std_logic_vector(1 downto 0);
    rst:  out std_logic                    := '0'
); end Estado;
    
    
architecture Behavioral of Estado is
    
    component Debounce is Port(
        Clk:  in  std_logic;
        Btn:  in  std_logic;
        Data: out std_logic
    ); end component;
    
    signal ctls:   std_logic_vector(2 downto 0);
    signal ctls_r: std_logic_vector(2 downto 0) := "000"; -- valor anterior
    signal stAux:  std_logic_vector(1 downto 0) := "00";
    signal rstAux: std_logic;

begin
    
    st <= stAux;
    rst <= rstAux;
    
    Grabar: Debounce port map (
        Clk  => Clk,
        Btn  => Btns(0),
        Data => Ctls(0)
    );
    
    Reproducir: Debounce port map (
        Clk  => Clk,
        Btn  => Btns(1),
        Data => Ctls(1)
    );
    
    Live: Debounce port map (
        Clk  => Clk,
        Btn  => Btns(2),
        Data => Ctls(2)
    );
    
        -- Proceso síncrono: un solo rising_edge(clk)
    SM : process (clk) begin
        if rising_edge(clk) then

            -- Detectar flancos: rising = antes '0', ahora '1'
            -- (ctls_r guarda el ciclo anterior)

            if stAux = "00" then
                if ctls_r(0) = '0' and ctls(0) = '1' then   -- flanco en Ctls(0)
                    rstAux <= '0';
                    stAux  <= "01";
                elsif ctls_r(1) = '0' and ctls(1) = '1' then -- flanco en Ctls(1)
                    rstAux <= '0';
                    stAux  <= "10";
                elsif ctls_r(2) = '0' and ctls(2) = '1' then -- flanco en Ctls(2)
                    rstAux <= not rstAux;
                    stAux  <= "11";
                end if;

            elsif stAux = "11" then
                if ctls_r(2) = '0' and ctls(2) = '1' then
                    rstAux <= not rstAux;
                    stAux  <= "00";
                end if;

            elsif stAux = "01" or stAux = "10" then
                if eom = '1' then
                    rstAux <= '1';
                    stAux  <= "00";
                end if;
            end if;

            -- Actualizar registro del ciclo anterior
            ctls_r <= ctls;

        end if;
    end process SM;
    
--    SM : process (Ctls) begin
--        if    stAux = "00" and rising_edge(Ctls(0)) and Ctls(0) = '1' then
--            rstAux <= '0';
--            stAux  <= "01";
--        elsif stAux = "00" and rising_edge(Ctls(1)) and Ctls(1) = '1' then
--            rstAux <= '0';
--            stAux  <= "10";
--        elsif (stAux = "00" or stAux = "11") and rising_edge(Ctls(2)) and Ctls(2) = '1' then
--            rstAux <= not(rstAux);
--            stAux  <= not(stAux);
--        elsif (stAux = "01" or stAux = "10") and eom = '1' then
--            rstAux <= '1';
--            stAux  <= "00";
--        end if;
--    end process SM;

end Behavioral;
