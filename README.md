# risc-v CPU in VHDL
![Static Badge](https://img.shields.io/badge/VHDL-blue?style=for-the-badge) ![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white) ![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white) ![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)

[![Testbenches](https://github.com/gigalasr/risc-v/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/gigalasr/risc-v/actions/workflows/main.yml)

## How To Run
### Labor 3
- Labor 2 Aufgabe 2: `tools/vhdlmake/build/vhdlmake run sign_extension_tb`
- Labor 2 Aufgabe 1: `tools/vhdlmake/build/vhdlmake run decoder_tb`

### Labor 2
- Labor 2 Aufgabe 2: `tools/vhdlmake/build/vhdlmake run register_file_tb`
- Labor 2 Aufgabe 1: `tools/vhdlmake/build/vhdlmake run single_port_ram_tb`

### Labor 1
- Labor 1 Aufgabe 3: `tools/vhdlmake/build/vhdlmake run gen_mux_tb`
- Labor 1 Aufgabe 2: `tools/vhdlmake/build/vhdlmake run pipeline_register_tb`
- Labor 1 Aufgabe 1: `tools/vhdlmake/build/vhdlmake run alu_tb`

## Clone
Clone this repo using: ``git clone --recursive https://github.com/gigalasr/risc-v.git``

## Setup
Before you can run [vhdlmake](https://github.com/gigalasr/vhdlmake) you need to run ``source setup.sh``.