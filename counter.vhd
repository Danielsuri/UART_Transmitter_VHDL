package uart_constants is

   constant clockfreq  : integer := 25000000 ;
   constant baud       : integer := 115200   ;
   constant t1_count   : integer := clockfreq / baud ; -- 217
   constant t2_count   : integer := t1_count / 2     ; -- 108

end uart_constants ;

use work.uart_constants.all ;
library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
use ieee.numeric_std.all;
entity counter is
   port (en, clr, clk, resetN : in  std_logic ;
         cout                 : out std_logic ) ;
end counter ;
architecture arc_counter of counter is
   signal count : std_logic_vector (2 downto 0);
   
begin
   process (clk , resetN)
   begin
      if resetN = '0' then
         count <= (others => '0');
      elsif clk'event and clk = '1' then
         if clr = '1' then
            count <= (others => '0');
         elsif count /= "111" and en = '1' then
            count <= count + 1;
         end if;
      end if ;
   end process ;
   cout <= '1' when (count >= t1_count) else '0';
end arc_counter ;