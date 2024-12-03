#define RVTEST_DATA_BEGIN                                               	\
        .pushsection .tohost,"aw",@progbits;                            	\
        .align 6; .global tohost; tohost: .dword 0; .size tohost, 8;    	\
        .align 6; .global fromhost; fromhost: .dword 0; .size fromhost, 8;	\
        .popsection;                                                    	\
        .align 4; .global begin_signature; begin_signature:
#define RVTEST_CODE_BEGIN                                               	\
        .section .text.init;                                            	\
        .align  6;                                                      	\
        .global _start;                         				\
_start:                                 					\
    j main;                            						\
	j writeToHost
RVTEST_CODE_BEGIN

main:

	# PROLOGUE
		# addi sp, sp, -16
		# sw ra, 0(sp)
		# sw gp, 4(sp)
		# sw tp, 8(sp)
		# sw fp, 12(sp)
	# END PROLOGUE
	
	# CODE

		la t0, trapVector
		csrw mtvec, t0

		li t0, 0
		li t0, 0b00011101
		slli t0, t0, 8
		ori t0, t0, 0b00001100
		csrw pmpcfg0, t0
		
		li t0, 0x80001000
		srli t0, t0, 2
		csrw pmpaddr0, t0
		
		li t0, 0x80004000
		srli t0, t0, 2
		addi t0, t0, 0x1FF
		csrw pmpaddr1, t0
		
		csrr a0, mstatus		

		li a0, 0			
		call switchMode	
		
		li t0, 0x80000000
		jalr t0
		
		li t0, 0x80000000
		lw t0, 0(t0)
		
		li t0, 0x80000000
		li t1, 0xDEADBEEF
		sw t0, 0(t1)
		
		li t0, 0x80004000
		jalr t0
		
		li t0, 0x80004000
		lw t0, 0(t0)
		
		li t0, 0x80004000
		li t1, 0xDEADBEEF
		sw t0, 0(t1)

		csrr a0, sstatus		

		ecall				
		
		csrr a0, mstatus		

		li a0, 1			
		call switchMode
		
		ecall				
		ecall
		
		csrr a0, mstatus

		li t0, 0
		li t0, 0b10011101
		slli t0, t0, 8
		ori t0, t0, 0b10001100
		csrw pmpcfg0, t0
		
		li t0, 0x80000000
		jalr t0
		
		li t0, 0x80000000
		lw t0, 0(t0)
		
		li t0, 0x80000000
		li t1, 0xDEADBEEF
		sw t0, 0(t1)
		
		li t0, 0x80004000
		jalr t0
		
		li t0, 0x80004000
		lw t0, 0(t0)
		
		li t0, 0x80004000
		li t1, 0xDEADBEEF
		sw t0, 0(t1)

	# END CODE
    
	# EPILOGUE
		# lw fp, 12(sp)
		# lw tp, 8(sp)
		# lw gp, 4(sp)
		# lw ra, 0(sp)
		# addi sp, sp, 16
	# END EPILOGUE
    
end_main: call writeToHost

writeToHost:

	# PROLOGUE
		# addi sp, sp, -16
		# sw ra, 0(sp)
		# sw gp, 4(sp)
		# sw tp, 8(sp)
		# sw fp, 12(sp)
	# END PROLOGUE
	
	# CODE

		li gp, 1
		sw gp, tohost, t5
	
	# END CODE

	# EPILOGUE
		# lw fp, 12(sp)
		# lw tp, 8(sp)
		# lw gp, 4(sp)
		# lw ra, 0(sp)
		# addi sp, sp, 16
	# END EPILOGUE

end_writeToHost: call writeToHost
    
switchMode:

	# PROLOGUE
		# addi sp, sp, -16
		# sw ra, 0(sp)
		# sw gp, 4(sp)
		# sw tp, 8(sp)
		# sw fp, 12(sp)
	# END PROLOGUE
	
	# CODE
	
		mv t0, a0
		csrr t1, mstatus
		li t6, 0x1800
		not t6, t6
		and t1, t1, t6
		
		if1: bnez t0, else1
			li t6, 0x0800
			j end_if1
		else1:
			li t6, 0x0000
			j end_if1
		end_if1:
		
		or t1, t1, t6
		csrw mstatus, t1
	
	# END CODE
	
	# EPILOGUE
		# lw fp, 12(sp)
		# lw tp, 8(sp)
		# lw gp, 4(sp)
		# lw ra, 0(sp)
		# addi sp, sp, 16
		csrw mepc, ra
	# END EPILOGUE

end_switchMode: mret

trapVector:

	# PROLOGUE
		# addi sp, sp, -64
		# sw gp, 4(sp)
		# sw tp, 8(sp)
		# sw fp, 12(sp)
		# sw s0, 16(sp)
		# sw s1, 20(sp)
		# sw s2, 24(sp)
		# sw s3, 28(sp)
		# sw s4, 32(sp)
		# sw s5, 36(sp)
	# END PROLOGUE
	
	# CODE

		csrr s0, mcause
		li s1, 9
		li s2, 8
		li s3, 5
		li s4, 7
		li s5, 1
		
		if2: bne s0, s1, else2if3
			li s1, 0x1800
			j end_if23456
		else2if3: bne s0, s2, else3if4
			li s1, 0x0800
			j end_if23456
		else3if4: bne s0, s3, else4if5
			li s1, 0
			j end_if23456
		else4if5: bne s0, s4, else5if6
			li s1, 0
			j end_if23456
		else5if6: bne s0, s5, end_if23456
			li s1, 0
			j end_if23456
		end_if23456:

		csrr s0, mstatus
		or s0, s0, s1
		csrw mstatus, s0
	
	# END CODE
	
	# EPILOGUE
		# lw s5, 36(sp)
		# lw s4, 32(sp)
		# lw s3, 28(sp)
		# lw s2, 24(sp)
		# lw s1, 20(sp)
		# lw s0, 16(sp)
		# lw fp, 12(sp)
		# lw tp, 8(sp)
		# lw gp, 4(sp)
		# lw ra, 0(sp)
		# addi sp, sp, 64
		addi ra, ra, 4
		csrw mepc, ra
	# END EPILOGUE

end_trapVector: mret
    
.data
base:
.word 0xcafebeef
RVTEST_DATA_BEGIN