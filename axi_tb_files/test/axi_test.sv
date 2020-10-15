//  ###########################################################################
//
//  Licensed to the Apache Software Foundation (ASF) under one
//  or more contributor license agreements.  See the NOTICE file
//  distributed with this work for additional information
//  regarding copyright ownership.  The ASF licenses this file
//  to you under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in compliance
//  with the License.  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.
//  
//  ###########################################################################

//Base test
class axi_test extends uvm_test;

axi_env env;
 
//Factory registration	
	`uvm_component_utils (axi_test)
	
//Constructor	
	function new(string name = "axi_test", uvm_component parent);
    	super.new(name, parent);
	endfunction
	
	
//Building test component
	function void build_phase (uvm_phase phase);
		env = axi_env::typeid::create ("env", this); 
		
		//**** "Getting Interface****//
		if (!uvm_config_db #(virtual axi_if)::get(this, "", vif, i_f))
			`uvm_error ("AXI_INTERFACE", "Cannot get interface")
			
		//**** Setting Environment Config*****//
		uvm_config_db #(axi_tb_config)::set(this, "*", "axi_tb_config", tb_cfg);
		
		super.build_phase(phase);
	endfunction
	
//Printing the topology/heirarchy of the TB components	
	function void end_of_elaboration_phase (uvm_phase phase);
		uvm_top.print_topology();
	endfunction
	
endclass


//Test 1: Write and Read sequence Test
class axi_write_read_test extends axi_test;

axi_write_sequence wr_sequence;
axi_read_sequence rd_sequence;
 
//Factory registration	
	`uvm_component_utils (axi_write_test)
	
//Constructor	
	function new(string name = "axi_write_read_test", uvm_component parent);
    	super.new(name, parent);
	endfunction
	
	function void build_phase (uvm_phase phase);	
		super.build_phase(phase);
	endfunction
	
	function run_phase (uvm_phase phase);	
		
		wr_sequence = axi_write_sequence::typeid::create("wr_sequence");
		rd_sequence = axi_read_sequence::typeid::create("rd_sequence");
		
		phase.raise_objection(this);
			wr_sequence.start(env.v_seqr);
			rd_sequence.start(env.v_seqr);
		#100;	
		phase.drop_objection(this);
	
	endfunction
endclass
	
	
//Test 2 : Exclusive Sequence (Exclsv Read followed by Exclsv Write to same address)

class axi_exclsv_rd_wr_test extends axi_test;

exclsv_rd_wr_vseq exclsv_rd_wr;;
 
//Factory registration	
	`uvm_component_utils (axi_exclsv_rd_wr_test)
	
//Constructor	
	function new(string name = "axi_exclsv_rd_wr_test;", uvm_component parent);
    	super.new(name, parent);
	endfunction
	
	function void build_phase (uvm_phase phase);	
		super.build_phase(phase);
	endfunction
	
	function run_phase (uvm_phase phase);	
		
		exclsv_rd_wr = exclsv_rd_wr_vseq::typeid::create("exclsv_rd_wr");
		phase.raise_objection(this);
			exclsv_rd_wr.start(env.v_seqr);
		#100;	
		phase.drop_objection(this);
	
	endfunction
endclass
	
//Test 3 : Exclusive Sequence (Exclsv Read followed by Normal Write to same address)

class axi_exclsv_rd_normal_wr_test extends axi_test;

exclsv_rd_nor_wr_vseq exclsv_rd_nor_wr;;
 
//Factory registration	
	`uvm_component_utils (axi_exclsv_rd_normal_wr_test)
	
//Constructor	
	function new(string name = "axi_exclsv_rd_normal_wr_test;", uvm_component parent);
    	super.new(name, parent);
	endfunction
	
	function void build_phase (uvm_phase phase);	
		super.build_phase(phase);
	endfunction
	
	function run_phase (uvm_phase phase);	
		
		exclsv_rd_nor_wr = exclsv_rd_nor_wr_vseq::typeid::create("exclsv_rd_nor_wr");
		phase.raise_objection(this);
			exclsv_rd_nor_wr.start(env.v_seqr);
		#100;	
		phase.drop_objection(this);
	
	endfunction
endclass
