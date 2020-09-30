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
// Class : AXI Slave Monitor
// Description of the class : axi slave monitor
// FILE NAME: axi_slave_monitor.sv	
//-----------------------------------------------------------------------------

`ifndef AXI_SLAVE_MONITOR_SV
`define AXI_SLAVE_MONITOR_SV

class AXI_slave_monitor extends uvm_monitor;
 
virtual interface AXI_vif   ms_vif;

AXI_transfer t_trx;

  // component macro
  `uvm_component_utils(AXI_slave_monitor)

  // component constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
    //t_trx = new();
  endfunction : new
  
 function void build_phase(uvm_phase phase);
    if (!axi_vif_config::get(this,"","ms_vif", ms_vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".ms_vif"})
  endfunction: build_phase

  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH);
  endfunction : start_of_simulation_phase
 
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task collect_write_transfer();
  extern virtual protected task collect_addr_write_trx();
  extern virtual protected task collect_data_write_trx();

endclass : AXI_slave_monitor

  // UVM run_phase()
  task AXI_slave_monitor::run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Inside the run_phase", UVM_MEDIUM);
    forever begin
       t_trx = AXI_transfer::type_id::create();
       collect_write_transfer();
    end
  endtask : run_phase

  task AXI_slave_monitor::collect_write_transfer();
  fork
    collect_addr_write_trx();
    collect_data_write_trx();
  join
  endtask : collect_write_transfer

// collect addr write @ pos edge
  task AXI_slave_monitor::collect_addr_write_trx();

    // check write pool, if the W(id) is not found,then create a new one
    // and recored it's timing


    //forever begin
        while(ms_vif.AXI_AWVALID == 1'b1 && ms_vif.AXI_AWREADY == 1'b1) begin
        @(posedge ms_vif.AXI_ACLK);
         t_trx.rw      = 1;
         t_trx.addr    = ms_vif.AXI_AWADDR;
         t_trx.id      = ms_vif.AXI_AWID;
         t_trx.len     = ms_vif.AXI_AWLEN;
         t_trx.size    = ms_vif.AXI_AWSIZE;
         t_trx.burst   = ms_vif.AXI_AWBURST;
         t_trx.addr_done = `TRUE;
      end
  endtask : collect_addr_write_trx


// collect data write @ pos edge
  task AXI_slave_monitor::collect_data_write_trx();
        int j;
        bit [31:0] temp_data;
        bit [3:0] temp_strb;
        
	while(ms_vif.AXI_WVALID == 1'b1 && ms_vif.AXI_WREADY == 1'b1)begin
        @(posedge ms_vif.AXI_ACLK);
        t_trx.data.push_back(ms_vif.AXI_WDATA);
        t_trx.strb.push_back(ms_vif.AXI_WSTRB);
        t_trx.wid      = ms_vif.AXI_WID;

        if (ms_vif.AXI_WLAST == 1'b1) begin
         t_trx.wlast       = ms_vif.AXI_WLAST;
          t_trx.data_done = `TRUE;
          $display("From Slave Monitor @ %g",$time);
          t_trx.print();
          j = t_trx.data.size();
          foreach(t_trx.data[j]) begin
             temp_data = t_trx.data.pop_front(); 
             temp_strb = t_trx.strb.pop_front(); 
          end
        end
       end

endtask : collect_data_write_trx

`endif
