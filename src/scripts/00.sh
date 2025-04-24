#!/bin/bash

vxx="ghdl"
#vxx="vhdl –-std=08"

$vxx -a packages/constant_package.vhdl &&
$vxx -a components/alu/gen_xor.vhdl &&
$vxx -a components/alu/gen_or.vhdl &&
$vxx -a components/alu/gen_and.vhdl &&
$vxx -a components/alu/half_adder.vhdl &&
$vxx -a components/alu/full_adder.vhdl &&
$vxx -a components/alu/gen_n_bit_full_adder.vhdl &&

$vxx -a testbenches/alu/gates_tb.vhdl &&
$vxx -a testbenches/alu/half_adder_tb.vhdl &&
$vxx -a testbenches/alu/full_adder_tb.vhdl &&
$vxx -a testbenches/alu/gen_n_bit_adder_tb_1.vhdl &&
$vxx -a testbenches/alu/gen_n_bit_adder_tb_2.vhdl &&


$vxx -e gates_tb &&
$vxx -r gates_tb &&

$vxx -e my_half_adder_tb &&
$vxx -r my_half_adder_tb &&

$vxx -e my_full_adder_tb &&
$vxx -r my_full_adder_tb

$vxx -e my_gen_n_bit_full_adder_tb &&
$vxx -r my_gen_n_bit_full_adder_tb

$vxx -e my_gen_n_bit_full_adder_tb2 &&
$vxx -r my_gen_n_bit_full_adder_tb2

