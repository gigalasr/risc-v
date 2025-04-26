#!/bin/bash

vxx="ghdl"
#vxx="vhdl –-std=08"

$vxx -a packages/constant_package.vhdl &&
$vxx -a components/alu/alu.vhdl &&
$vxx -a testbenches/alu/alu_tb.vhdl &&
$vxx -e alu_tb
