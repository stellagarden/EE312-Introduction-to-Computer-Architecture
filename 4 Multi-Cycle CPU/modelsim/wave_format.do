onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TB_RISCV/CLK
add wave -noupdate /TB_RISCV/RSTn
add wave -noupdate /TB_RISCV/I_MEM_CSN
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV/I_MEM_DOUT
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV/IR
add wave -noupdate -radix decimal -radixshowbase 0 /TB_RISCV/I_MEM_ADDR
add wave -noupdate -radix decimal -radixshowbase 0 /TB_RISCV/PC
add wave -noupdate /TB_RISCV/D_MEM_CSN
add wave -noupdate /TB_RISCV/D_MEM_WEN
add wave -noupdate /TB_RISCV/D_MEM_BE
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV/D_MEM_DOUT
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV/D_MEM_DI
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV/D_MEM_ADDR
add wave -noupdate /TB_RISCV/RF_WE
add wave -noupdate /TB_RISCV/RF_RA1
add wave -noupdate /TB_RISCV/RF_RA2
add wave -noupdate /TB_RISCV/RF_WA
add wave -noupdate -radix decimal -radixshowbase 0 /TB_RISCV/RF_RD1
add wave -noupdate -radix decimal -radixshowbase 0 /TB_RISCV/RF_RD2
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV/RF_WD
add wave -noupdate -radix decimal -radixshowbase 0 /TB_RISCV/NUM_INST
add wave -noupdate -radix hexadecimal -radixshowbase 0 /TB_RISCV/OUTPUT_PORT
add wave -noupdate -radix decimal -radixshowbase 0 /TB_RISCV/state
add wave -noupdate -radix decimal -radixshowbase 0 /TB_RISCV/cycle
add wave -noupdate /TB_RISCV/HALT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20355000 ps} 0}
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
WaveRestoreZoom {20197085 ps} {20520532 ps}
