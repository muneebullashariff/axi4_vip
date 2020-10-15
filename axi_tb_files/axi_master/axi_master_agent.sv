//  ################################################################################################
//
//  Licensed to the Apache Software Foundation (ASF) under one or more contributor license 
//  agreements. See the NOTICE file distributed with this work for additional information
//  regarding copyright ownership. The ASF licenses this file to you under the Apache License,
//  Version 2.0 (the"License"); you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software distributed under the 
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
//  either express or implied. See the License for the specific language governing permissions and 
//  limitations under the License.
//
//  ################################################################################################

`ifndef AXI_MASTER_AGENT_INCLUDED
`define AXI_MASTER_AGENT_INCLUDED

//------------------------------------------------------------------------------------------------//
//  Class: axi_master_agent
//  axi_master_agent is extended from uvm_agent, uvm_agent is inherited by uvm_component.
//  An agent typically contains: a driver,sequencer, and monitor. Agents can be configured either
//  active or passive.
//------------------------------------------------------------------------------------------------//

class axi_master_agent extends uvm_agent;

//Factory registration 
 `uvm_component_utils(axi_master_agent)

//declare handle of master_agent_config which is extended from the configuration class
 	axi_master_agent_config m_agt_cfg;

//Handles for the driver, monitor, sequencer
	axi_master_driver m_drvh;
	axi_master_monitor m_monh;
	axi_master_sequencer m_sequencer;
 

//---------------------------------------------
// Externally defined tasks and functions
//---------------------------------------------
  extern function new(string name="axi_master_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);

endclass

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the master_agent class component
//
// Parameters:
//  name - instance name of the config_template
//  parent - parent under which this component is created
//-----------------------------------------------------------------------------

function axi_master_agent::new(string name="axi_master_agent", uvm_component parent);
	super.new(name, parent);
endfunction:new


//-----------------------------------------------------------------------------
// Function: build_phase
// Creates the required components
//
// Parameters:
// phase - stores the current phase 
//-----------------------------------------------------------------------------

function void axi_master_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
  
 	if(!uvm_config_db #(axi_master_agent_config)::get(this,"","axi_master_agent_config",m_agt_cfg))
	`uvm_fatal("CONFIG", "cannot get() m_agt_cfg from uvm_config_db. Have you set it?")

//For Active UVM Agent monitor class is created along with the Sequencer and Driver but for the
//Passive UVM Agent only Monitor is created

	m_monh=axi_master_monitor::type_id::create("m_monh", this);

  if(m_agt_cfg.is_active==UVM_ACTIVE);
	 begin
	  m_drvh=axi_master_driver::type_id::create("m_drvh", this);
	  m_sequencer=axi_master_sequencer::type_id::create("m_sequencer", this);
  end

endfunction:build_phase


//-----------------------------------------------------------------------------------------------//
// Function: connect_phase
//  The connect phase is used to make TLM connections between components
//------------------------------------------------------------------------------------------------//

function void axi_master_agent::connect_phase(uvm_phase phase);
	if(m_agt_cfg.is_active==UVM_ACTIVE)
	m_drvh.seq_item_port.connect(m_sequencer.seq_item_export);
endfunction:connect_phase

/////////////////////////////////////////////////////////////////////////////////////////
`endif

