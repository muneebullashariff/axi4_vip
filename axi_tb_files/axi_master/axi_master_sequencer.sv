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

`ifndef AXI_MASTER_SEQUENCER_SV
`define AXI_MASTER_SEQUENCER_SV

//-----------------------------------------------------------------------------
// Class : AXI Master sequencer
// Description of the class : routes the seq_item to driver
//-----------------------------------------------------------------------------

class axi_master_sequencer extends uvm_sequencer#(axi_master_trans);

 //Factory registration
  `uvm_component_utils(axi_master_sequencer)
 
//---------------------------------------------
// Externally defined tasks and functions
//---------------------------------------------
  extern function new(string name="axi_master_sequencer", uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass : axi_master_sequencer
 
//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the master_sequencer class component
//
// Parameters:
//  name - instance name of the config_template
//  parent - parent under which this component is created
//-----------------------------------------------------------------------------
 
  function axi_master_sequencer::new (string name="axi_master_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction : new

//-----------------------------------------------------------------------------
// Function: build_phase
// Creates the required components
//
// Parameters:
// phase - stores the current phase 
//-----------------------------------------------------------------------------

 function void axi_master_sequencer::build_phase(uvm_phase phase);
    super.build_phase(phase);
 endfunction : build_phase

////////////////////////////////////////////////////////////////
`endif 

