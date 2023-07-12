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

    type State is (N1, N2, N3, Tiros,Verifica);
    signal current_state, next_state : State;
    signal navio1_foi_colocado, navio2_foi_colocado, navio3_foi_colocado : STD_LOGIC;
    signal tabuleiro : STD_LOGIC_VECTOR (15 downto 0);
    signal tiro_pos_reg, tiro_pos_next : STD_LOGIC_VECTOR (3 downto 0);
    signal tiro_acerto_reg : STD_LOGIC := '0';
    signal tiro_pos_encoded : STD_LOGIC_VECTOR (3 downto 0);
    signal auxn1 : STD_LOGIC_VECTOR (3 downto 0);
    signal auxn2 : STD_LOGIC_VECTOR (3 downto 0);
    signal auxn3 : STD_LOGIC_VECTOR (3 downto 0);

    -- Processo para codificar o valor de tiro_pos
    function codificacao (pos : std_logic_vector(3 downto 0)) return std_logic_vector is
        variable auxfun: std_logic_vector(3 downto 0);
        begin
            if pos = "0000"  then
                auxfun := "0001";
            elsif pos = "0001"  then
                auxfun := "0000";
            elsif pos =  "0010"  then
                auxfun := "1111";
            elsif pos = "0011" then
                auxfun := "1110";
            elsif pos = "0100" then
                auxfun := "1010";
            elsif pos = "0101"  then
                auxfun := "0111";
            elsif pos = "0110"  then
                auxfun := "0100";
            elsif pos = "0111"  then
                auxfun := "1000";
            elsif pos = "1000"  then
                auxfun := "0110";
            elsif pos = "1001"  then
                auxfun := "0111";
            elsif pos = "1010"  then
                auxfun := "0010";
            elsif pos = "1011"  then
                auxfun := "1011";
            elsif pos = "1100"  then
                auxfun := "0001";
            elsif pos = "1101"  then
                auxfun := "1101";
            elsif pos = "1110"  then
                auxfun := "1001";
            elsif pos ="1111"  then
                auxfun := "0011";
            end if;
            return auxfun;
                --tiro_pos_encoded <= "0000";
        end function;

begin


    process (clk, reset)
    begin
        if reset = '1' then
            current_state <= N1;
            next_state <= N1;
            tiro_acerto <= '0';
        elsif rising_edge(clk) then
        current_state <= next_state;
        navio1_foi_colocado <= '0';
        navio2_foi_colocado <= '0';
        navio3_foi_colocado <= '0';
        
        tiro_acerto_reg <= '0';

        case current_state is
            when N1 =>
                if navio1_pos /= "0000" then
                    
                    navio1_foi_colocado <= '1';
                    auxn1 <= navio1_pos;
                    next_state <= N2;
                end if;

            when N2 =>
                if navio2_pos /= "0000" then
                    
                    navio2_foi_colocado <= '1';
                    auxn2 <= navio2_pos;
                    next_state <= N3;
                end if;

            when N3 =>
                if navio3_pos(3 downto 0) /= "0000" and navio3_pos(7 downto 4) /= "0000" then
                    
                    navio3_foi_colocado <= '1';
                    next_state <= Tiros;
                    --auxn3 <= navio3_pos;
                end if;

            when Tiros =>

                tiro_pos_encoded <= codificacao(tiro_pos);
                next_state <= Verifica;
            when Verifica =>
                if tiro_pos_encoded /= "0000" then
                    if tiro_pos_encoded = auxn1 then
                        tiro_acerto <= '1';
                    elsif tiro_pos_encoded = auxn2 then
                        tiro_acerto <= '1';
                    elsif tiro_pos_encoded = auxn3 then
                        tiro_acerto <= '1';
                    end if;
                end if;

        end case;
        end if;
    end process;

    --tiro_acerto <= tiro_acerto_reg;

end Behavioral;
                
