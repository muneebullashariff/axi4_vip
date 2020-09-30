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
// Class : AXI Slave sequencer
// Description of the class : Axi slave sequencer
// FILE NAME: axi_slave_sequencer.sv	
//-----------------------------------------------------------------------------

`ifndef AXI_SLAVE_SEQUENCER_SV
`define AXI_SLAVE_SEQUENCER_SV

class AXI_slave_sequencer extends uvm_sequencer #(AXI_transfer);

  `uvm_component_utils_begin(AXI_slave_sequencer)
  `uvm_component_utils_end

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : AXI_slave_sequencer

`endif // AXI_slave_sequencer
