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
// Class : AXI Slave base sequence
// Description of the class : sequence for slave basic read
// FILE NAME: axi_slave_base_seq.sv
//-----------------------------------------------------------------------------

`ifndef AXI_SLAVE_BASE_SEQ_SV
`define AXI_SLAVE_BASE_SEQ_SV

class axi_slave_base_seq extends uvm_sequence#(AXI_transfer);
  
  // Required macro for sequences automation
  `uvm_object_utils(axi_slave_base_seq)

  // Constructor
  function new(string name="axi_slave_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    starting_phase.raise_objection(this, get_type_name());
    `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
  endtask : pre_body

  task post_body();
    starting_phase.drop_objection(this, get_type_name());
    `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
  endtask : post_body

endclass : axi_slave_base_seq


class axi_basic_rd_seq extends axi_slave_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(axi_basic_rd_seq)

  // Constructor
  function new(string name="axi_basic_rd_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing axi_basic_rd_seq", UVM_LOW)
     repeat(20)
        `uvm_do_with(req,{req.addr == 500;req.itype == 0; req.rw == 0;})
  endtask
  
endclass : axi_basic_rd_seq
`endif


