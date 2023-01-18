onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TB_RISCV_sort/CLK
add wave -noupdate /TB_RISCV_sort/RSTn
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/I_MEM_DOUT
add wave -noupdate -radix unsigned /TB_RISCV_sort/I_MEM_ADDR
add wave -noupdate -radix unsigned -radixshowbase 0 /TB_RISCV_sort/next_PC
add wave -noupdate /TB_RISCV_sort/D_MEM_WEN
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/D_MEM_DOUT
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/D_MEM_DI
add wave -noupdate -radix hexadecimal /TB_RISCV_sort/D_MEM_ADDR
add wave -noupdate /TB_RISCV_sort/RF_WE
add wave -noupdate -radix unsigned /TB_RISCV_sort/RF_RA1
add wave -noupdate -radix unsigned /TB_RISCV_sort/RF_RA2
add wave -noupdate /TB_RISCV_sort/RF_WA
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/RF_RD1
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/RF_RD2
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/RF_WD
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/OUTPUT_PORT
add wave -noupdate /TB_RISCV_sort/flag_HALT
add wave -noupdate /TB_RISCV_sort/HALT
add wave -noupdate -radix unsigned /TB_RISCV_sort/cycle
add wave -noupdate -radix unsigned /TB_RISCV_sort/NUM_INST
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/FD_IR
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/DE_IR
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/EM_IR
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/MW_IR
add wave -noupdate /TB_RISCV_sort/LoadDelaySlot
add wave -noupdate /TB_RISCV_sort/jumped
add wave -noupdate /TB_RISCV_sort/predict
add wave -noupdate /TB_RISCV_sort/FD_predict
add wave -noupdate /TB_RISCV_sort/DE_predict
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/ALU_in1
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/ALU_in2
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/ALU_out
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/DE_imm
add wave -noupdate /TB_RISCV_sort/DE_ALU_in1
add wave -noupdate /TB_RISCV_sort/DE_ALU_in2
add wave -noupdate /TB_RISCV_sort/MW_WD
add wave -noupdate -radix unsigned /TB_RISCV_sort/ForwardA
add wave -noupdate -radix unsigned /TB_RISCV_sort/ForwardB
add wave -noupdate -radix unsigned /TB_RISCV_sort/ForwardC
add wave -noupdate -radix unsigned /TB_RISCV_sort/ForwardD
add wave -noupdate -radix unsigned /TB_RISCV_sort/ForwardE
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/EM_ALU_out
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/MW_ALU_out
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/DE_RD1
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/DE_RD2
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_sort/EM_RD2
add wave -noupdate -radix unsigned -radixshowbase 0 /TB_RISCV_sort/DE_target
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6977738 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {6924385 ps} {7082928 ps}
