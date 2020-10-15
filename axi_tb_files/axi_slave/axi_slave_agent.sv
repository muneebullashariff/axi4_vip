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

//-----------------------------------------------------------------------------
// Class : AXI Slave Agent
// Description of the class : Active/Passive AXI Slave Agent
// FILE NAME: axi_slave_agent.sv	
//-----------------------------------------------------------------------------
`ifndef AXI_SLAVE_AGENT_SV
`define AXI_SLAVE_AGENT_SV

class AXI_slave_agent extends uvm_agent;

  //  This field determines whether an agent is active or passive.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;

  AXI_slave_driver	s_driver;
  AXI_slave_sequencer	s_sequencer;
  AXI_slave_monitor	s_monitor;

   // reserve fields
  `uvm_component_utils_begin(AXI_slave_agent)
     `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON) 
  `uvm_component_utils_end


  // constructor
  function new(string name, uvm_component parent);
  	super.new(name, parent);
  endfunction : new


  // build phase
  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     
     s_monitor = AXI_slave_monitor::type_id::create("s_monitor", this);
     
     if (is_active == UVM_ACTIVE) begin
     	s_driver = AXI_slave_driver::type_id::create("s_driver", this);
     	s_sequencer = AXI_slave_sequencer::type_id::create("s_sequencer", this);
     end
     
  endfunction : build_phase


	// connect phase
	virtual function void connect_phase(uvm_phase phase);
           if (is_active == UVM_ACTIVE) begin
	       s_driver.seq_item_port.connect(s_sequencer.seq_item_export);
           end
	endfunction : connect_phase

endclass : AXI_slave_agent


`endif // AXI_slave_agent

