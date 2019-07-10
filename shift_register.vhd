library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity shift_register is
  generic(depth : positive := 8);
  port (resetN, clk, clrN, PL, SE : in std_logic;
  		din						  : in std_logic_vector (depth-1 downto 0);
  		LSB						  : out std_logic) ;
end shift_register ; -- shift_register

architecture arch of shift_register is

component dffx
  port ( resetN, clk, d : in std_logic ;
  		q		 		: out std_logic) ;
end component ; -- dffx

signal d, p : std_logic_vector (depth-1 downto 0);

begin

	pi: for i in 0 to depth-2 generate
		pii: p(i) <= din(i) when PL ='1' else
					d(i+1) when SE ='1' else '0';
	end generate pi;
	p(depth-1) <= din(depth-1) when PL = '1' else '0';

	ui: for i in 0 to depth-1 generate
		SR: dffx port map (resetN, clk, p(i), d(i));
	end generate ui;
	LSB <= d(0);

end architecture ; -- arch