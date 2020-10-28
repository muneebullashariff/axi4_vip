# Makefile for uvm test bench of AXI VIP

INC = +incdir+../axi_master +incdir+../axi_slave +incdir+../env +incdir+../test +incdir+../top
TOP =  ../top/axi4_top.sv
PKG = ../env/axi_package.sv
TEST= ../test/axi_test.sv
#COVOP= -dbg -coverage sba

work = work
VSIMOPT= +access +r -sva
VSIMBATCH = -acdb_file mem_cov.acdb
VSIMBATCH1 = -c -acdb_file mem_cov2.acdb -do "log -rec *;run -all;exit"
lib:
	vlib $(work)
	vmap work $(work)

sv_cmp:clean  lib comp0
		       

gui:
	vsim&

comp0:
	vcs -uvm $(INC) $(PKG) $(TOP)

run_test:
	vcs -V -R $(INC) $(PKG) $(TOP) -full64 -ntb_opts uvm-1.2 -sverilog +v2k -debug_access+all -debug_pp +ntb_random_seed_automatic -override_timescale=1ps/1ps

#----------E.O.F----------
