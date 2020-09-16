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

`ifndef AXI_OOO_SCOREBOARD_INCLUDED_
`define AXI_OOO_SCOREBOARD_INCLUDED_

// declare the implementation ports for incoming transactions 
`uvm_analysis_imp_decl(_dut)                           // for more details about usage one can refer : http://www.testbench.in/UL_11_PHASE_8_SCOREBOARD.html
`uvm_analysis_imp_decl(_ref)

class AXI4_OOO_scoreboard extends uvm_component;       //AXI4 out of order scoreboard
  `uvm_component_utils(AXI4_OOO_scoreboard)

  // implementation ports instances
  uvm_analysis_imp_dut#(my_trans, AXI4_OOO_scoreboard)      dut_in_imp;          //analysis port from DUT
  uvm_analysis_imp_ref#(my_trans, AXI4_OOO_scoreboard)      ref_in_imp;          //analysis port from REFERENCE Model

  // queues holding the transactions from different sources
  my_trans dut_q[$];    // one queue from Dut
  my_trans ref_q[$];    // another queue from REF

 
//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the axi_scoreboard class object
//
// Parameters:
//  name - instance name of the axi_scoreboard
//  parent - parent under which this component is created
//-----------------------------------------------------------------------------
	  	 
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
    dut_in_imp    = new("dut_in_imp", this);
    ref_in_imp    = new("ref_in_imp", this);
  endfunction

//---------------------------------------------------------------------------------
// Function :: write_dut
// This function receives transactions from DUT through analysis port and calls another function search_and_compare()
//---------------------------------------------------------------------------------
  function void write_dut(my_trans dut_trans);
    search_and_compare(dut_trans, ref_q, dut_q);
  endfunction  


//---------------------------------------------------------------------------------
// Function :: write_ref
// This function receives transactions from reference model through analysis port and calls another function search_and_compare()
//---------------------------------------------------------------------------------
  function void write_ref(my_trans ref_trans);
    search_and_compare(ref_trans, dut_q, ref_q);
  endfunction

//----------------------------------------------------------------------------------
// Function :: search_and_compare 
// This function is the main logical function which compares master data which are out of order and compares that with slave data. 
// It further checks whether data(s) are matching or not and gives result accordingly.
//-----------------------------------------------------------------------------------

  function void search_and_compare(my_trans a_trans, ref my_trans search_q[$], ref my_trans save_q[$]);
    int indexes[$];
    
    indexes = search_q.find_first_index(it) with (a_trans.match(it));   // logic to find the index of the data to be compared

    if (indexes.size() == 0) begin
      save_q.push_back(a_trans);
      return;
    end

    // sample a_trans coverage
    search_q.delete(indexes[0]);
  endfunction

  // at the end of the test we need to check that the two queues are empty

  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    REF_Q_ERR : assert(ref_q.size() == 0) else
      `uvm_error("REF_Q_ERR", $sformatf("ref_q is not empty!!! It still contains %d transactions!", ref_q.size()))

    DUT_Q_ERR : assert(dut_q.size() == 0) else
      `uvm_error("DUT_Q_ERR", $sformatf("dut_q is not empty!!! It still contains %d transactions!", dut_q.size()))
  endfunction
  
endclass


`endif


