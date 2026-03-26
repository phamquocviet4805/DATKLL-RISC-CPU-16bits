# DATKLL-RISC-CPU-16bits

A 16-bit RISC CPU project written in **Verilog HDL** and implemented as a **Vivado** FPGA design for the **Digilent Arty Z7-20** board.

This project is a course design assignment that builds a simplified **MIPS-inspired** processor with a custom 16-bit ISA, special registers, memory access instructions, and an extended **FP16 unit** for basic half-precision floating-point operations.

## Overview

The processor is organized around the classic execution flow:

- **IF** — Instruction Fetch
- **ID** — Instruction Decode / Register Read
- **EX** — Execute
- **MEM** — Memory Access
- **WB** — Write Back

The design targets educational use: it helps demonstrate how a CPU datapath, control unit, register file, ALU, memory subsystem, and floating-point extension can be combined into a working soft-core processor on FPGA.

## Main Features

- **16-bit RISC CPU** with simplified MIPS-style organization
- **16-bit address space**
- **8 general-purpose registers**: `r0` to `r7`
- **Special registers**: `ZERO`, `PC`, `RA`, `AT`, `HI`, `LO`
- **Three instruction formats**:
  - **R-type** for register-register operations
  - **I-type** for immediate, branch, and memory operations
  - **J-type** for jump instructions
- **ALU instruction groups** for arithmetic, logic, shift, rotate, comparison, and multiply/divide
- **Memory support** with `LH` / `SH`
- **Control-flow support** with branch and jump instructions
- **Special-register access** through `MFSR` / `MTSR`
- **FP16 extension** for basic half-precision floating-point operations and type conversion

## Supported Instruction Groups

### 1. Integer / Logic ALU
Examples of supported integer operations include:

- `ADDU`, `SUBU`, `MULTU`, `DIVU`
- `ADD`, `SUB`, `MULT`, `DIV`
- `AND`, `OR`, `NOR`, `XOR`
- `SLT`, `SLTU`, `SEQ`, `JR`

### 2. Shift / Rotate
- `SHR`, `SHL`, `ROR`, `ROL`
- `SHRA`, `BITREV`, `CLZ`, `CTZ`

### 3. Immediate / Control / Memory
- `ADDI`, `SLTI`, `LUI`, `ORI`
- `BNEQ`, `BGTZ`
- `JUMP`, `HLT`
- `LH`, `SH`

### 4. Special Register Instructions
- `MFSR` to read from special registers
- `MTSR` to write to special registers

### 5. FP16 Instructions
- `FADDH`
- `FSUBH`
- `FMULH`
- `FCMPH`
- `ITOFH`
- `FTOHI`

> Note: The FP16 unit is a simplified educational implementation and does **not** fully support all IEEE-754 edge cases such as NaN/Inf, denormal numbers, complete rounding behavior, or overflow/underflow handling.

## Architecture

The project is built from a hierarchical set of Verilog modules. The main blocks are:

- `TOP` — top-level integration module
- `program_counter` — program counter management
- `Ins_Mem` — instruction memory and instruction field extraction
- `C_U` — central control unit
- `ALU_control` — ALU operation decoder
- `ALU` — arithmetic and logic unit
- `reg_file` — general-purpose register file
- `special_register` — `RA`, `AT`, `HI`, `LO`, and special readback logic
- `fp16_unit` — floating-point processing unit
- `data_mem` — data memory
- `Imm_gen`, `Jump`, adders, and MUX blocks — datapath support modules

## Repository Structure

```text
DATKLL-RISC-CPU-16bits/
└── CPU_RISC_16Bits/
    ├── DATKLL.xpr
    ├── DATKLL.srcs/
    │   ├── constrs_1/
    │   │   └── imports/
    │   │       └── digilent-xdc-master/
    │   │           └── Arty-Z7-20-Master.xdc
    │   ├── sim_1/
    │   │   └── new/
    │   │       ├── tb_cpu.v
    │   │       └── fp16_unit_tb.v
    │   └── sources_1/
    │       ├── imports/
    │       │   └── new/
    │       │       ├── ALU.v
    │       │       ├── ALU_control.v
    │       │       ├── C_U.v
    │       │       ├── Clock_div.v
    │       │       ├── Imm_gen.v
    │       │       ├── Ins_Mem.v
    │       │       ├── MUX_2_1.v
    │       │       ├── MUX_2_1_PC.v
    │       │       ├── MUX_3_1_RET.v
    │       │       ├── MUX_alu_2_1.v
    │       │       ├── MUX_clk.v
    │       │       ├── TOP.v
    │       │       ├── add_pc.v
    │       │       ├── branch.v
    │       │       ├── data_mem.v
    │       │       ├── pc_add_2.v
    │       │       ├── program_counter.v
    │       │       └── reg_file.v
    │       └── new/
    │           ├── Jump.v
    │           ├── MUX_jump.v
    │           ├── fp16_unit.v
    │           ├── mux_mtsr_wb.v
    │           └── special_register.v
    ├── DATKLL.cache/
    ├── DATKLL.hw/
    ├── DATKLL.ip_user_files/
    └── DATKLL.sim/
```

## How to Open the Project

### Vivado
1. Clone or download this repository.
2. Open **Xilinx Vivado**.
3. Open the project file:
   - `CPU_RISC_16Bits/DATKLL.xpr`
4. Make sure the target board / device matches **Arty Z7-20**.
5. Check the constraints file:
   - `CPU_RISC_16Bits/DATKLL.srcs/constrs_1/imports/digilent-xdc-master/Arty-Z7-20-Master.xdc`

## Simulation

Two simulation testbenches are included:

- `tb_cpu.v` — top-level CPU simulation
- `fp16_unit_tb.v` — dedicated FP16 functional testbench

### CPU simulation
`tb_cpu.v` instantiates the `TOP` module, drives a **10 ns clock**, keeps `interrupt_pending = 0`, selects the fastest internal clock mode with `mux_clk = 2'b00`, and runs the CPU for a fixed simulation interval.

### FP16 simulation
`fp16_unit_tb.v` exercises representative floating-point cases such as:

- addition and subtraction
- comparison
- integer-to-float conversion
- float-to-integer conversion
- multiplication

## Synthesis / Implementation Results

According to the project report, the design was implemented successfully on **Arty Z7-20** with the following reported results:

### Resource utilization
- **LUTs**: 4,589 / 53,200 (**8.63%**)
- **Flip-Flops**: 2,256 / 106,400 (**2.12%**)
- **DSPs**: 1 / 220 (**0.45%**)
- **IO**: 6 / 125 (**4.80%**)

### Timing
- Target clock: **20 MHz**
- Clock period: **50.00 ns**
- **WNS**: **+0.149 ns**
- **WHS**: **+0.211 ns**

### Power
- Total on-chip power: **0.139 W**
- Static power: **0.105 W**
- Dynamic power: **0.035 W**
- Junction temperature: **26.6 °C**

These results show that the design fits comfortably on the target FPGA and is suitable for low-power educational embedded experiments.

## Demo

- **GitHub repository**: <https://github.com/phamquocviet4805/DATKLL-RISC-CPU-16bits>
- **Demo video / materials**: available in the project report link section

## Limitations

Current limitations noted in the report include:

- The instruction set and control mechanism are still basic
- The FP16 unit handles only simplified cases
- No full hazard-handling pipeline is implemented yet
- Verification is based mainly on representative directed testbenches

## Future Work

Possible extensions for this project include:

- a full pipelined version with forwarding / stall logic
- broader instruction-set support
- interrupt / exception handling
- more complete IEEE-754 FP16 behavior
- stronger random / regression testing
- peripheral integration such as UART and timer modules

## Authors

- **Phạm Quốc Việt**
- **Nguyễn Minh Quang**

Supervisor:
- **Tôn Huỳnh Long**

## Acknowledgment

This project was developed as a logic design / computer architecture course assignment at **Ho Chi Minh City University of Technology (HCMUT)**.
