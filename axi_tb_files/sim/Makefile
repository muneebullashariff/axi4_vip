
TOP = ../top/axi4_top.sv

run_test:

vcs -V -R $(TOP) -full64 -ntb_opts uvm-1.2 -sverilog +v2k -debug_access+all -debug_pp +ntb_random_seed_automatic -override_timescale=1ps/1ps
