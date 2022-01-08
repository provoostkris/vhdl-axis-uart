------------------------------------------------------------------------------
--  Loopback setup with TX / RX ports exported
--  rev. 1.0 : 2022 Provoost Kris
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_axis_lb is
  generic(
      clkfreq    : integer := 50e6; -- 50 mhz clock
      baudrate   : integer := 115200;
      data_width : integer := 8;
      parity     : string  := "none"; -- none, even, odd
      stop_width : integer := 1
    );
  port (
    fpga_clk1_50      : in    std_ulogic; --! fpga clock 1 input 50 mhz
    fpga_clk2_50      : in    std_ulogic; --! fpga clock 2 input 50 mhz
    fpga_clk3_50      : in    std_ulogic; --! fpga clock 3 input 50 mhz
    -- buttons & leds
    key               : in    std_logic_vector(1 downto 0); --! push button - debounced
    sw                : in    std_logic_vector(3 downto 0); --! slide button
    led               : out   std_logic_vector(7 downto 0); --! indicators
    -- external interface signals
    rxd               : in  std_logic;
    txd               : out std_logic
  );
end uart_axis_lb;

architecture rtl of uart_axis_lb is

  signal clk           : std_logic;
  signal axis_tdata    : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal axis_tready   : std_logic;
  signal axis_tvalid   : std_logic;

begin

clk <= fpga_clk1_50;

  -- loop the AXIS port of the UART component
  i_uart : entity work.uart
      generic map (
        CLKFREQ=>CLKFREQ,
        BAUDRATE=>BAUDRATE,
        DATA_WIDTH=>DATA_WIDTH,
        PARITY=>PARITY,
        STOP_WIDTH=>STOP_WIDTH
      )
      port map(
        clk           =>  clk,
        rxd           =>  rxd,
        txd           =>  txd,
        m_axis_tvalid =>  axis_tvalid,
        m_axis_tdata  =>  axis_tdata,
        m_axis_tready =>  axis_tready,
        s_axis_tvalid =>  axis_tvalid,
        s_axis_tdata  =>  axis_tdata,
        s_axis_tready =>  axis_tready
        );

end rtl;