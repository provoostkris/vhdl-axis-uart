

echo "Create workspace"

  proc delete_lib { lib } { if { [file exists $lib]} { file delete -force $lib } }
  proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }

  delete_lib          work
  ensure_lib          work

echo "Compiling design"

  vcom   -work work ../rtl/uart_rx.vhd
  vcom   -work work ../rtl/uart_tx.vhd
  vcom   -work work ../rtl/uart.vhd


echo "Compiling test bench"

  vcom  -quiet -work work ../sim/tb_uart_rx.vhd
  vcom  -quiet -work work ../sim/tb_uart_tx.vhd
  vcom  -quiet -work work ../sim/tb_uart_rt_lb.vhd
  vcom  -quiet -work work ../sim/tb_uart_axis_lb.vhd

echo "start simulation"

  vsim -gui -t ps -novopt work.tb_uart_axis_lb

echo "adding waves"

  delete wave /*

  add wave                 -group "UART"               /tb_uart_axis_lb/uut/*
  add wave                 -group "RX"                 /tb_uart_axis_lb/uut/urx/*
  add wave                 -group "TX"                 /tb_uart_axis_lb/uut/utx/*


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