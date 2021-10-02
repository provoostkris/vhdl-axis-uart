echo "Compiling design"

  vlib work
  vcom  -quiet -work work ../rtl/uart_rx.vhd
  vcom  -quiet -work work ../rtl/uart_tx.vhd
  vcom  -quiet -work work ../rtl/uart.vhd


echo "Compiling test bench"

  vcom  -quiet -work work ../sim/tb_uart_rx.vhd
  vcom  -quiet -work work ../sim/tb_uart_tx.vhd
  vcom  -quiet -work work ../sim/tb_uart_rt_lb.vhd
  vcom  -quiet -work work ../sim/tb_uart_axis_lb.vhd

echo "start simulation"

  vsim -gui -t ps -novopt work.tb_uart_axis_lb

echo "adding waves"

  delete wave /*

  add wave                 -group "uut i/o"   -ports            /tb_uart_axis_lb/uut/*


echo "view wave forms"
  view wave
  run 2100 us

  configure wave -namecolwidth  280
  configure wave -valuecolwidth 120
  configure wave -justifyvalue right
  configure wave -signalnamewidth 1
  configure wave -snapdistance 10
  configure wave -datasetprefix 0
  configure wave -rowmargin 4
  configure wave -childrowmargin 2
  configure wave -gridoffset 0
  configure wave -gridperiod 1
  configure wave -griddelta 40
  configure wave -timeline 1
  configure wave -timelineunits us
  update

  wave zoom full