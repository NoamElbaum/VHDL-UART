library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY TX IS
PORT( CLK :IN STD_LOGIC;
		START:IN STD_LOGIC;
		BUSY:OUT STD_LOGIC;
		DATA: IN STD_LOGIC_VECTOR(7 downto 0);
		TX_LINE:OUT STD_LOGIC);
END TX;

architecture arch_TX of TX is

signal PRSCL: integer range 0 to 5802:=0;
signal INDEX: integer range 0 to 9:=0;
signal DATAFLL: STD_LOGIC_VECTOR(9 downto 0);
signal TX_FLG: STD_LOGIC:='0';
BEGIN
	process(CLK)
		begin
			if rising_edge(CLK) then
				if(TX_FLG = '0' and START = '1') then
					TX_FLG <= '1';
					BUSY <= '1';
					DATAFLL(0)<='0';
					DATAFLL(9)<='1';
					DATAFLL(8 downto 1)<=DATA;
				end if;
			
				if(TX_FLG = '1')then
					if(PRSCL<5207)then	
						PRSCL <= PRSCL+1;
					else
						PRSCL <= 0;
					end if;
			
					if(PRSCL = 2607)then
						TX_LINE<=DATAFLL(INDEX);
						if(INDEX<9)then
							INDEX<=INDEX+1;
						else
							TX_FLG <='0';
								BUSY <='0';
							INDEX <= 0;
						end if;
					end if;	
				end if;
			end if;
	end process;
end architecture;
