# Verilog RTL Cache Controller & VGA Interface via SRAM

A complete Digital IC / RTL design project implemented in Verilog HDL. This project integrates a parameterized Cache Controller with a single-port SRAM memory architecture and a VGA Display Interface for real-time memory-mapped rendering.

## Key Features
- **Cache Controller:** FSM-based read/write hit/miss logic, tag matching, and memory update control.
- **SRAM Model:** Single-port memory interface with strict setup/hold timing control.
- **VGA Controller:** Standard 640x480 @ 60Hz timing generator (H-SYNC, V-SYNC, RGB output).
- **Toolchain & Verification:** Simulated using QuestaSim / GTKWave, and targeted for Intel Quartus FPGA synthesis.

## Directory Structure
- `rtl/`: Core Verilog modules (`cache_controller.v`, `vga_controller.v`, `sram_interface.v`, `top_module.v`)
- `tb/`: Simulation testbenches (`tb_cache_controller.v`, `tb_vga.v`)
- `fpga/`: Intel Quartus synthesis pin constraints (`pin_assignment.qsf`)

## Tools Used
- Verilog HDL
- QuestaSim / GTKWave
- Intel Quartus Prime
- Ubuntu Linux
