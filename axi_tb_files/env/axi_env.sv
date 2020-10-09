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
class axi_env extends uvm_env;

//Factory registration	
	`uvm_component_utils (axi_env)
	
axi_master_agent master_agent;
axi_slave_agent slave_agent;
axi_scoreboard scoreboard;
AXI_OOO_scoreboard ooo_scoreboard;
axi_tb_config tb_cfg;
axi_virtual_seqr v_seqr;
	
//Constructor	
	function new(string name = "axi_env", uvm_component parent);
    	super.new(name, parent);
	endfunction
	
	
//Building components
	function void build_phase (uvm_phase phase);
		
		master_agent = axi_master_agent::typeid::create("master_agent", this);
		slave_agent = axi_slave_agent::typeid::create("slave_agent", this);
		
		if(!uvm_config_db #(axi_tb_config)::get(this, "", "axi_tb_config", tb_cfg))
			`uvm_fatal("CONFIG DB", "Cannot access Testbench Config DB");
		
		if(env_cfg.has_ooo_scoreboard)
			ooo_scoreboard = AXI_OOO_scoreboard::typeid::create("ooo_scoreboard", this);
		if(env_cfg.has_scoreboard)
			scoreboard = axi_scoreboard::typeid::create("scoreboard", this);
		
		super.build_phase(phase);
	endfunction
	
//Connecting components	
	function void connect_phase (uvm_phase phase);
		
		v_seqr.mstr_vseqr_h = master_agent.m_sequencer;
		v_seqr.slv_vseqr_h = slave_agent.s_sequencer;
		
	endfunction
endclass
	
	