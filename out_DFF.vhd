library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;
	use ieee.std_logic_unsigned.all;

entity out_DFF is
  port ( presetN, clk, S, E, D, R : in std_logic;
  		 Q : out std_logic) ;
end out_DFF ; -- out_DFF

architecture arch of out_DFF is
begin
	process(presetN, clk)
	begin
		if presetN = '0' then
			Q <= '1';
		elsif rising_edge(clk) then
			if (R = '1') then
				Q <= '0';
			elsif (S = '1') then
				Q <= '1';
			elsif (E = '1') then
				Q <= D;
			end if;
		end if;			
	end process;
end architecture ; -- arch