library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BatalhaNaval is
    Port ( clk : in  STD_LOGIC;
            
            reset : in  STD_LOGIC;
           navio1_pos : in  STD_LOGIC_VECTOR (3 downto 0);
           navio2_pos : in  STD_LOGIC_VECTOR (3 downto 0);
           navio3_pos : in  STD_LOGIC_VECTOR (7 downto 0);
           tiro_pos : in  STD_LOGIC_VECTOR (3 downto 0);
           tiro_acerto : out STD_LOGIC);
end BatalhaNaval;

architecture Behavioral of BatalhaNaval is

    type State is (N1, N2, N3, Tiros);
    signal current_state, next_state : State;
    signal navio1_foi_colocado, navio2_foi_colocado, navio3_foi_colocado : STD_LOGIC;
    signal tabuleiro : STD_LOGIC_VECTOR (15 downto 0);
    signal tiro_pos_reg, tiro_pos_next : STD_LOGIC_VECTOR (3 downto 0);
    signal tiro_acerto_reg : STD_LOGIC := '0';
    signal tiro_pos_encoded : STD_LOGIC_VECTOR (3 downto 0);
    signal auxn1 : STD_LOGIC_VECTOR (3 downto 0);
    signal auxn2 : STD_LOGIC_VECTOR (3 downto 0);
    signal auxn3 : STD_LOGIC_VECTOR (3 downto 0);


begin


    process (clk, reset)
    begin
        if reset = '1' then
            current_state <= N1;
            tiro_acerto_reg <= '0';
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;


    process (current_state, navio1_foi_colocado, navio2_foi_colocado, navio3_foi_colocado, tiro_pos_reg)
    begin
        next_state <= current_state;
        navio1_foi_colocado <= '0';
        navio2_foi_colocado <= '0';
        navio3_foi_colocado <= '0';
        
        tiro_acerto_reg <= '0';

        case current_state is
            when N1 =>
                if navio1_pos /= "0000" then
                    next_state <= N2;
                    navio1_foi_colocado <= '1';
                end if;

            when N2 =>
                if navio2_pos /= "0000" then
                    next_state <= N3;
                    navio2_foi_colocado <= '1';
                end if;

            when N3 =>
                if navio3_pos(3 downto 0) /= "0000" and navio3_pos(7 downto 4) /= "0000" then
                    next_state <= Tiros;
                    navio3_foi_colocado <= '1';
                end if;

            when Tiros =>
                if tiro_pos_encoded /= "0000" then
                    if tiro_pos_encoded = auxn1 then
                        tiro_acerto_reg <= '1';
                    elsif tiro_pos_encoded = auxn2 then
                        tiro_acerto_reg <= '1';
                    elsif tiro_pos_encoded = auxn3 then
                        tiro_acerto_reg <= '1';
                    end if;
                end if;

        end case;
    end process;

    -- Processo para codificar o valor de tiro_pos
    function codificacao (pos : std_logic_vector(3 downto 0)) return std_logic_vector is
        begin
            if "0000" =>
                tiro_pos_encoded <= "0001";
            if "0001" =>
                tiro_pos_encoded <= "0000";
            if "0010" =>
                tiro_pos_encoded <= "1111";
            if "0011" =>
                tiro_pos_encoded <= "1110";
            if "0100" =>
                tiro_pos_encoded <= "1010";
            if "0101" =>
                tiro_pos_encoded <= "0111";
            if "0110" =>
                tiro_pos_encoded <= "0100";
            if "0111" =>
                tiro_pos_encoded <= "1000";
            if "1000" =>
                tiro_pos_encoded <= "0110";
            if "1001" =>
                tiro_pos_encoded <= "0111";
            if "1010" =>
                tiro_pos_encoded <= "0010";
            if "1011" =>
                tiro_pos_encoded <= "1011";
            if "1100" =>
                tiro_pos_encoded <= "0001";
            if "1101" =>
                tiro_pos_encoded <= "1101";
            if "1110" =>
                tiro_pos_encoded <= "1001";
            if "1111" =>
                tiro_pos_encoded <= "0011";
            --if others =>
                --tiro_pos_encoded <= "0000";
        end function;

    -- Processo para atualizar o tabuleiro
    process (clk, reset, current_state, navio1_foi_colocado, navio2_foi_colocado, navio3_foi_colocado, tiro_pos_reg)
    begin
        if reset = '1' then
            tabuleiro <= (others => '0');
            tiro_pos_next <= (others => '0');
        elsif rising_edge(clk) then
            tabuleiro <= tabuleiro;
            tiro_pos_reg <= tiro_pos_next;
            case current_state is
                when N1 =>
                    if navio1_foi_colocado = '1' then
                        auxn1 <= navio1_pos;
                    end if;

                when N2 =>
                    if navio2_foi_colocado = '1' then
                        auxn2 <= navio2_pos;
                    end if;

                when N3 =>
                    if navio3_foi_colocado = '1' then
                        
                        --auxn3 <= navio3_pos;
                        --tabuleiro(to_integer(unsigned(navio3_pos(7 downto 4)))) <= '1';
                    end if;

                when Tiros =>
                    
                    tiro_pos_encoded <= codificacao(tiro_pos);

            end case;
        end if;
    end process;


    tiro_acerto <= tiro_acerto_reg;

end Behavioral;
                
