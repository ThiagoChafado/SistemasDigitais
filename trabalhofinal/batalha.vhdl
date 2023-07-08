LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY teste IS
    PORT (
        key: IN STD_LOGIC_VECTOR(3 downto 0);--clock,reset
        sw: IN STD_LOGIC_VECTOR(9 DOWNTO 0);--local navio
        ledr : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);--errou
        ledg : out STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
END teste;

ARCHITECTURE elevator_behav OF teste IS

    TYPE state_type IS (N1, N2, N3, TIROS, ACERTOS);
    TYPE behav_type IS (U, D);
		
	 
    SIGNAL state : state_type;
    SIGNAL prev_state : state_type;
    SIGNAL behav_state : behav_type;
    SIGNAL stop_behav : STD_LOGIC;
	SIGNAL aux : STD_LOGIC_VECTOR(9 downto 0);
BEGIN
	 
    PROCESS (state)
	 
    BEGIN
	 
	 CASE state IS
            WHEN N1 =>
					 aux <= "0000000001";
                ledr <= aux;
            WHEN N2 =>
					 aux <= "0000000010";
                ledr <= aux;
            WHEN N3 =>
					 aux <= "0000000100";
                ledr <= aux;
            WHEN TIROS =>
					 aux <= "0000001000";
                ledr <= aux;
            WHEN ACERTOS =>

        END CASE;
    END PROCESS;


    PROCESS (key)
    BEGIN
        IF key(0) = '0' THEN
            state <= N1;
				
        ELSIF (key(1)'EVENT AND key(1) = '0') THEN
            CASE state IS
                WHEN ACERTOS =>
                    CASE prev_state IS
                        WHEN N1 =>
                            state <= N2;
									 
                        WHEN N2 =>
                            IF behav_state = D THEN
                                state <= N1;
										  
                            ELSIF behav_state = U THEN
                                state <= N3;
										  
                            END IF;
                        WHEN N3 =>
                            IF behav_state = D THEN
                                state <= N2;
										  
                            ELSIF behav_state = U THEN
                                state <= TIROS;
										  
                            END IF;
                        WHEN TIROS =>
                            state <= N3;
									 
                        WHEN ACERTOS =>
                    END CASE;
                WHEN N1 =>
                    IF sw > aux THEN
                        prev_state <= state;
                        state <= ACERTOS;
                    END IF;
                WHEN N2 =>
                    IF sw > aux THEN
                        prev_state <= N2;
                        behav_state <= U;
                        state <= ACERTOS;
                    ELSIF sw < aux THEN
                        prev_state <= N2;
                        behav_state <= D;
                        state <= ACERTOS;
                    END IF;
                WHEN N3 =>
                    IF sw > aux THEN
                        prev_state <= N3;
                        behav_state <= U;
                        state <= ACERTOS;
                    ELSIF sw < aux THEN
                        prev_state <= N3;
                        behav_state <= D;
                        state <= ACERTOS;
                    END IF;
                WHEN TIROS =>
                    IF sw > aux THEN
                        prev_state <= TIROS;
                        behav_state <= U;
                        state <= ACERTOS;
                    ELSIF sw < aux THEN
                        prev_state <= TIROS;
                        behav_state <= D;
                        state <= ACERTOS;
                    END IF;
            END CASE;
        END IF;
    END PROCESS;

END elevator_behav;
