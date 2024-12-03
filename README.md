# <center> RISC-V Arch Test </center>

## *<center> Implementation of Task 2 </center>*

#### Question Statement:

###### *Write an assembly test for PMP*

1. Pre-requisites:
	1. Read RISCV privileged architecture spec for PMP.

2. Assembly Test:
	- Enhance your trap handler from task 1 to handler load/store/execute exceptions.
	-  Configure two 4KB PMP regions one using TOR method and other using NAPOT method.
	- Grant read permission to NAPOT and execute permission to TOR region.
	-  Jump to S mode.
	- You will get an Instruction access fault exception after entering into lower modes. Why is that? (Try to resolve it yourself).
	- Now (after resolving v), do read, write and execute from both the pmp region. You should get appropriate Access faults.
	- Jump to machine mode and now apply above (point iii) mentioned pmp restrictions for machine mode too. What do you  need to do for this?
	- Now again read, write and execute from both the pmp region. You should get appropriate Access faults.

#### Build & Run:

###### *Compile Assembly File to Elf:*

```shell
riscv64-unknown-elf-gcc -march=rv32g -mabi=ilp32 -nostdlib -T link.ld task2.S -o test.elf
```
###### *Create a Disassembly:*

```shell
riscv64-unknown-elf-objdump -D test.elf > test.disass
```

###### *Simulate on Spike & Generate Logfile:*

```shell
spike --isa=rv32gc -l --log-commits test.elf 1> spike.out 2> spike.log
```

###### *Simulate on Sail & Generate Logfile:*

```shell
riscv_sim_RV32 test.elf --trace=step 2> sail.out 1> sail.log
```

#### Documentation:

###### *Source Code Available at:*
-	<span style = 
			"color: rgb(255, 64, 92);
			background: rgb(228, 228, 228);
			padding: 4px 12px;
			border-radius: 10px"
		> /Code/task2.S
	</span>

###### *Log Files Available at:*
-	<span style = 
			"color: rgb(255, 64, 92);
			background: rgb(228, 228, 228);
			padding: 4px 12px;
			border-radius: 10px"
		> /Code/spike.log
	</span>
-	<span style = 
			"color: rgb(255, 64, 92);
			background: rgb(228, 228, 228);
			padding: 4px 12px;
			border-radius: 10px"
		> /Code/sail.log
	</span>

###### *Report Available at:*
-	<span style = 
			"color: rgb(255, 64, 92);
			background: rgb(228, 228, 228);
			padding: 4px 12px;
			border-radius: 10px"
		> /Report/RISC-V_Arch_Test_Task_2_Report.docx
	</span>

###### *Output Screenshots Available at:*
-	<span style = 
			"color: rgb(255, 64, 92);
			background: rgb(228, 228, 228);
			padding: 4px 12px;
			border-radius: 10px"
		> /Screenshots
	</span>