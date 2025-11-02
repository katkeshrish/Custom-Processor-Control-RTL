Custom-Processor-Control-RTL:
This project implements the core control unit (FSM) for a simplified 4-bit processor. Its primary function is to manage the program flow for nested function calls by utilizing a Last-In, First-Out (LIFO) stack to securely save and restore return addresses.

 Hardware Command Decoder (LIFO-Controlled Microprocessor Core)

This project implements the core control unit (FSM) for a simplified 4-bit processor. Its primary function is to manage the program flow for nested function calls by utilizing a Last-In, First-Out (LIFO) stack to securely save and restore return addresses.

Project Architecture

The design is fully synchronous and modular, composed of three primary hardware units instantiated within the top-level Command_Decoder module.

Module  Function  Core Logic

Command_Decoder (FSM)

Control Unit. Decodes the incoming 4-bit Opcode and generates control signals (pc_load, wr_en).

FSM (case statement)

LIFO_Stack_Final

State Storage. Saves the 4-bit return addresses (PC + 1) during a CALL instruction.

Single Stack Pointer (SP)

Program_Counter (PC)

Flow Manager. Stores the current instruction address and updates based on FSM commands (PC++, PC_LOAD).

Sequential Register



Instruction Set Architecture (ISA)

The decoder processes an 8-bit instruction packet split into a 4-bit Opcode (LSBs) and a 4-bit Operand (MSBs).

Opcode (Bits 3:0)

EXECUTE : 0000

PC increments by 1 (PC <= PC + 1).

JUMP :  0100

PC loads the Target Address. (No LIFO action).


CALL : 1000

PUSH Return Address onto LIFO. PC loads Target Address.

RETURN : 1100

POP Return Address from LIFO. PC loads LIFO output.

Handling Errors (Stack Safety)

The system includes crucial error-handling logic:

The LIFO is 4 levels deep.

The FSM checks the full flag before any CALL and the empty flag before any RETURN.

If an Overflow (CALL on a full stack) or Underflow (RETURN on an empty stack) occurs, the FSM asserts pc_inc = 0 and stalls the PC, preventing memory corruption.

How to Run the Simulation

This project is designed to be synthesized and simulated using open-source tools like Icarus Verilog (iverilog).

Save the Code: Ensure the provided complete Verilog code is saved as a single file (e.g., command_decoder_project.v).

Compile: Use the following command to compile the file and link the testbench:

iverilog -o command_decoder_sim command_decoder_project.v


Run Simulation: Execute the compiled file to generate the waveform file (.vcd):

vvp command_decoder_sim


Verification: Review the output using the $monitor logs or a waveform viewer (like GTKWave). Verify that:

During a CALL (0x8), the PC jumps to the target, and LIFO_WR is high.

During a RETURN (0xC), the PC jumps back to the saved address, and LIFO_RD is high.
