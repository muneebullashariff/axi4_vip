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

`ifndef AXI_PACKAGE_SV
`define AXI_PACKAGE_SV


package axi_pkg;

import uvm_pkg::*;

`include "uvm_macros.svh"

//----------Including MASTER files----------
`include "axi_base_sequence.sv"
`include "axi_master_agent.sv"
`include "axi_master_agent_config.sv"
`include "axi_master_driver.sv"
`include "axi_master_monitor.sv"
`include "axi_master_sequencer.sv"
`include "axi_master_trans.sv"

//----------Including SLAVE files----------
`include "axi_slave_agent.sv"
`include "axi_slave_base_seq.sv"
`include "axi_slave_driver.sv"
`include "axi_slave_monitor.sv"
`include "axi_slave_sequencer.sv"
`include "axi_slave_trans.sv"

//----------Including ENV files----------
`include "axi_env.sv"
`include "axi_env_config.sv"
`include "axi_virt_seq.sv"
`include "axi_virtual_seqr.sv"

//----------Including INTERFACE files----------
`include "axi_interface.sv"

//----------Including TEST files----------
`include "axi_test.sv"
`include "AXI4_OOO_Scoreboard.sv"
`include "AXI4_Scoreboard.sv"

//----------Including ASSERTION files----------
`include "axi_assertion.sv"

endpackage

`endif

//-------E.O.F-------
