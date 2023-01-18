onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TB_RISCV_forloop/CLK
add wave -noupdate /TB_RISCV_forloop/RSTn
add wave -noupdate /TB_RISCV_forloop/I_MEM_CSN
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/I_MEM_DOUT
add wave -noupdate -radix decimal -radixshowbase 0 /TB_RISCV_forloop/I_MEM_ADDR
add wave -noupdate /TB_RISCV_forloop/D_MEM_CSN
add wave -noupdate /TB_RISCV_forloop/D_MEM_WEN
add wave -noupdate /TB_RISCV_forloop/D_MEM_BE
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/D_MEM_DOUT
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/D_MEM_DI
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/D_MEM_ADDR
add wave -noupdate /TB_RISCV_forloop/RF_WE
add wave -noupdate -radix unsigned -radixshowbase 0 /TB_RISCV_forloop/RF_RA1
add wave -noupdate -radix unsigned -radixshowbase 0 /TB_RISCV_forloop/RF_RA2
add wave -noupdate -radix unsigned -radixshowbase 0 /TB_RISCV_forloop/RF_WA
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/RF_RD1
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/RF_RD2
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/DE_RD1
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/DE_RD2
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/EM_RD2
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/RF_WD
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/OUTPUT_PORT
add wave -noupdate /TB_RISCV_forloop/HALT
add wave -noupdate -radix decimal -radixshowbase 0 /TB_RISCV_forloop/NUM_INST
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/FD_IR
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/DE_IR
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/EM_IR
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/MW_IR
add wave -noupdate /TB_RISCV_forloop/LoadDelaySlot
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/ALU_in1
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/ALU_in2
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/ALU_out
add wave -noupdate -radix unsigned -radixshowbase 0 /TB_RISCV_forloop/MW_WD
add wave -noupdate -radix unsigned -radixshowbase 0 /TB_RISCV_forloop/ForwardA
add wave -noupdate -radix unsigned -radixshowbase 0 /TB_RISCV_forloop/ForwardB
add wave -noupdate -radix unsigned -radixshowbase 0 /TB_RISCV_forloop/ForwardC
add wave -noupdate -radix unsigned -radixshowbase 0 /TB_RISCV_forloop/ForwardD
add wave -noupdate -radix unsigned -radixshowbase 0 /TB_RISCV_forloop/ForwardE
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/DE_imm
add wave -noupdate /TB_RISCV_forloop/DE_ALU_in1
add wave -noupdate /TB_RISCV_forloop/DE_ALU_in2
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/EM_ALU_out
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV_forloop/MW_ALU_out
add wave -noupdate -radix decimal -radixshowbase 0 /TB_RISCV_forloop/cycle
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {323634 ps} 0}
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
WaveRestoreZoom {208737 ps} {362699 ps}
