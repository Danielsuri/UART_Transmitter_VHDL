package uart_constants is

   constant clockfreq  : integer := 25000000 ;
   constant baud       : integer := 115200   ;
   constant t1_count   : integer := clockfreq / baud ; -- 217
   constant t2_count   : integer := t1_count / 2     ; -- 108

end uart_constants ;

-------------------------------------------------------------------------------------

-------------------------------------------------------
-- UART transmitter (C) VHDL workshop Amos Zaslavsky --
-------------------------------------------------------
use work.uart_constants.all ;
library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
entity transmitter is
   port ( resetN    : in     std_logic                    ;
          clk       : in     std_logic                    ;
          write_din : in     std_logic                    ;
          din       : in     std_logic_vector(7 downto 0) ;
          tx        : out std_logic                       ;
          tx_busy   : out std_logic                       ) ;
end transmitter ;

architecture arc_transmitter of transmitter is

	component timer 
   		port ( te, clk, resetN : in  std_logic ;
         	 tout           : out std_logic ) ;
	end component ;
   -- timer            floor(log2(t1_count)) downto 0
   signal tcount : std_logic_vector(8 downto 0) ;
   signal te     : std_logic ; -- Timer_Enable/!reset
   signal t1     : std_logic ; -- end of one time slot

   component counter 
   		port (en, clr, clk, resetN : in  std_logic ;
       		  cout                 : out std_logic ) ;
	end component ;
   -- data counter
   signal dcount     : std_logic_vector(2 downto 0) ; -- data counter
   signal ena_dcount : std_logic                    ; -- enable this counter
   signal clr_dcount : std_logic                    ; -- clear this counter
   signal eoc        : std_logic                    ; -- end of count (7)

   	component shift_register 
  		generic(depth : positive := 8);
 	 	port (resetN, clk, clrN, PL, SE : in std_logic;
  			din						  : in std_logic_vector (depth-1 downto 0);
  			LSB						  : out std_logic) ;
	end component ; -- shift_register
   -- shift register
   signal dint      : std_logic_vector(7 downto 0) ;
   signal ena_shift : std_logic                    ; -- enable shift register
   signal ena_load  : std_logic                    ; -- enable parallel load

	component out_DFF 
  		port ( presetN, clk, S, E, D, R : in std_logic;
  		 	Q : out std_logic) ;
	end component ; -- out_DFF
   -- output flip-flop --
   signal clr_tx : std_logic ; -- clear  tx during start bit
   signal set_tx : std_logic ; -- set    tx during stop  bit
   signal ena_tx : std_logic ; -- enable tx from shift register during data transfer

  -- state machine
   type state is
   ( idle        ,
     write_din_start  ,
     clear_timer ,
     write_din_data   ,
     test_eoc    ,
     shift_count ,
     write_din_stop   ) ;

    signal present_state , next_state : state ;

begin

   -------------------
   -- state machine --
   -------------------
   process(resetN, clk)
   begin
   	if resetN = '0' then
   		present_state <= idle;
	elsif rising_edge(clk) then
	
		

   end process;
   -----------
   -- timer --
   -----------

   ------------------
   -- data counter --
   ------------------

   --------------------
   -- shift register --
   --------------------

   ----------------------
   -- output flip-flop --
   ----------------------

end arc_transmitter ;

-------------------------------------------------------------------------------------
