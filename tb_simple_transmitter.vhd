library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
entity tb_simple_transmitter is
  -- Test bench of UART transmitter
end tb_simple_transmitter ;
architecture arc_tb_simple_transmitter of tb_simple_transmitter is
   component transmitter
      port ( resetN     : in  std_logic                    ; -- a-sync reset
             clk        : in  std_logic                    ; -- clock
             write_din  : in  std_logic                    ; -- send enable
             din        : in  std_logic_vector(7 downto 0) ; -- parallel in
             tx         : out std_logic                    ; -- serial out
             tx_ready   : out std_logic                    ) ;
   end component ;
   signal resetN     : std_logic ; -- actual resetN (active low)
   signal clk        : std_logic ; -- actual clock
   signal write_din  : std_logic ; -- actual send enable
   signal din        : std_logic_vector(7 downto 0) ; -- actual parallel in
   signal txrx       : std_logic ; -- from hardware transmitter to receiver
   constant bit_time : time := 8680 ns ;             -- 115200 BPS (baud)
--   signal dout       : std_logic_vector(7 downto 0) ; -- int Parallel output
begin 
   -- Transmitter instantiation (named association)
   eut: transmitter
      port map ( resetN    => resetN      ,
                 clk       => clk         ,
                 write_din => write_din   ,
                 din       => din         ,
                 tx        => txrx        ,
                 tx_ready  => open        ) ;
   -- Clock process (50 MHz)
   process
   begin
      clk <= '0' ;  wait for 20 ns ;
      clk <= '1' ;  wait for 20 ns ;
   end process ;   
   -- Active low reset pulse
   resetN <= '0' , '1' after 40 ns ;

   -- Transmission activation & test vectors process
   process
      variable data_send : std_logic_vector(7 downto 0) ;
   begin
      -- wait for end async of reset
      din <= "XXXXXXXX" ; write_din <= '0' ;  
      wait for 40 ns ;
      -------------------------------------------------      
      din <= "01001000" ; write_din <= '1' ;  -- send H character 
--      wait for 40 ns ;
--      din <= "XXXXXXXX" ; write_din <= '0' ;  
      wait for 11 * bit_time ;
      -------------------------------------------------      
      din <= "01101001" ; write_din <= '1' ;  -- send i character
--      wait for 40 ns ;
--      din <= "XXXXXXXX" ; write_din <= '0' ;  
      wait for 11 * bit_time ;
      -------------------------------------------------      
      din <= "00001101" ; write_din <= '1' ;  -- send CR character  
--      wait for 40 ns ;
--      din <= "XXXXXXXX" ; write_din <= '0' ;  
      wait for 11 * bit_time ;
      -------------------------------------------------      
      din <= "00001001" ; write_din <= '1' ;  -- send LF character
--      wait for 40 ns ;
--      din <= "XXXXXXXX" ; write_din <= '0' ;  
      wait for 11 * bit_time ;
      -------------------------------------------------      
      report "end of test vectors" ;
      wait ;
   end process ;

end arc_tb_simple_transmitter ;
        