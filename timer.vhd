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
entity timer is
   port ( te, clk, resetN : in  std_logic ;
          tout           : out std_logic ) ;
end timer ;
architecture arc_timer of timer is
   signal tcount : std_logic_vector (8 downto 0);
   
begin
   process (clk , resetN)
   begin
      if resetN = '0' then
         tcount <= (others => '0');
      elsif clk'event and clk = '1' then
         if te = '0' then
            tcount <= (others => '0');
         elsif tcount < t1_count then
            tcount <= tcount + 1;
         end if;
      end if ;
   end process ;
   tout <= '1' when (tcount >= t1_count) else '0';
end arc_timer ;