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
// Class : AXI Slave Driver
// Description of the class : Axi slave driver class to drive to master
// FILE NAME: axi_slave_driver.sv	
//-----------------------------------------------------------------------------

`ifndef AXI_SLAVE_DRIVER_SV
`define AXI_SLAVE_DRIVER_SV

class AXI_slave_driver extends uvm_driver #(AXI_transfer);

  virtual interface AXI_vif   ms_vif;


 // component macro
  `uvm_component_utils(AXI_slave_driver)

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    if (!axi_vif_config::get(this,"","ms_vif", ms_vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".ms_vif"})
  endfunction: build_phase

 // start_of_simulation 
  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH) 
  endfunction : start_of_simulation_phase

  // UVM run_phase
  task run_phase(uvm_phase phase);
      get_and_drive();
  endtask : run_phase



 // Gets packets from the sequencer and passes them to the driver. 
  task get_and_drive();
     ms_vif.AXI_AWREADY <= 1'b1;
     ms_vif.AXI_WREADY  <= 1'b1;
     ms_vif.AXI_BRESP   <= OKAY;
     ms_vif.AXI_BVALID  <= 1;
     ms_vif.AXI_BID  <= 1;
   endtask : get_and_drive

endclass
`endif
