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
/////////////////////////////////////MASTER_MONITOR//////////////////////////////////////////////////////


`ifndef AXI_MASTER_MONITOR_INCLUDED
`define AXI_MASTER_MONITOR_INCLUDED

//------------------------------------------------------------------------------------------------
//Class: master_monitor
//A monitor is a passive entity that samples the DUT signals through the virtual interface and 
//converts the signal level activity to the transaction level. 
//------------------------------------------------------------------------------------------------

class axi_master_monitor extends uvm_monitor;
 
 //factory registration
  `uvm_component_utils(axi_master_monitor)
 
 //declare VI handle
   virtual axi_if vif;
     
   axi_master_trans m_trans;
    
 //tlm port
   uvm_analysis_port #(axi_xtn) mon2sb;
 
//---------------------------------------------
// Externally defined tasks and functions
//---------------------------------------------

  extern function new(string name="axi_master_monitor",uvm_component parent); 
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task write_add_xtn();
  extern task write_data_xtn();
  extern task write_resp_xtn();
  extern task read_add_xtn();
  extern task read_data_xtn();
      
endclass : axi_master_monitor
    
//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the master_monitor class component
//
// Parameters:
//  name - instance name of the config_template
//  parent - parent under which this component is created
//-----------------------------------------------------------------------------
  function axi_master_monitor:: new(string name="axi_master_monitor",uvm_component parent);
    super.new(name,parent);
    mon2sb = new("mon2sb",this);
  endfunction: new
      
//-----------------------------------------------------------------------------
// Function: build_phase
// Creates the required components
//
// Parameters:
// phase - stores the current phase 
//-----------------------------------------------------------------------------
  function void axi_master_monitor:: build_phase(uvm_phase phase);
    super.build_phase(phase);
       
   m_trans=axi_master_trans::type_id::create("m_trans");
         
    if(!uvm_config_db # (virtual axi_if)::get(this,"","vif",vif))
      `uvm_fatal(get_type_name(),$sformatf("not able to get interface in master monitor"))
         
  endfunction:build_phase
           
//-----------------------------------------------------------------------------------------------
// Function: connect_phase
// The connect phase is used to make TLM connections between components
//------------------------------------------------------------------------------------------------     
  function void axi_master_monitor::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
  endfunction:connect_phase

//-----------------------------------------------------------------------------------------------
//task:run_phase
//The run phase is implemented as a task, and all uvm_component run tasks are executed in parallel.
//------------------------------------------------------------------------------------------------
  task axi_master_monitor::run_phase(uvm_phase phase);
    super.run_phase(phase);
     fork
       write_add_xtn();
       write_data_xtn();
       write_resp_xtn();
       read_add_xtn();
       read_data_xtn();
      join
  endtask: run_phase

//////////////////////////////////////////////////////////////
//collect write add @posedge
/////////////////////////////////////////////////////////////
 task axi_master_monitor::write_add_xtn();
   axi_master_trans m_trans;

    forever
      begin
        @(posedge vif.ACLK)
         if(vif.m_mon_cb.AWVALID == 1'b1 && vif.m_mon_cb.AWREADY == 1'b1);
          begin
           m_trans.AWADDR   = vif.m_mon_cb.AWADDR;
           m_trans.AWID     = vif.m_mon_cb.AWID;
           m_trans.AWLEN    = vif.m_mon_cb.AWLEN;
           m_trans.AWSIZE   = vif.m_mon_cb.AWSIZE;
           m_trans.AWBURST  = vif.m_mon_cb.AWBURST;
           m_trans.AWLOCK   = vif.m_mon_cb.AWLOCK;
           m_trans.AWCACHE  = vif.m_mon_cb.AWCACHE;
           m_trans.AWPROT   = vif.m_mon_cb.AWPROT;
         end 

       `uvm_info(get_type_name(), $sprintf("collected write addr addr : %h, len : %h", m_trans.AWADDR, m_trans.AWLEN), UVM_LOW)
      end
 endtask : write_add_xtn

/////////////////////////////////////////////////////////
//collect write data
/////////////////////////////////////////////////////////
 task axi_master_monitor::write_data_xtn();
   axi_master_trans m_trans;

    forever begin
      @(posedge vif.ACLK)
       if(vif.m_mon_cb.WVALID == 1'b1 && vif.m_mon_cb.WREADY == 1'b1);
        begin
          m_trans.WDATA = vif.m_mon_cb.WDATA;
          m_trans.WSTRB = vif.m_mon_cb.WSTRB;
        end
    
     `uvm_info(get_type_name(), $sprintf("collected write data data : %h", m_trans.WDATA), UVM_LOW)
      end
  endtask : write_data_xtn


////////////////////////////////////////////////
//collect write resp
////////////////////////////////////////////////
 task axi_master_monitor::write_resp_xtn();
   axi_master_trans m_trans;

    forever begin
      @(posedge vif.ACLK)
       if(vif.m_mon_cb.BVALID ==1'b1 && vif.m_mon_cb.BREADY ==1'b1);
        begin
          m_trans.BRESP = vif.m_mon_cb.BRESP;
        end
 
  // send transfer to scb
     mon2sb.write(m_trans);
         
      end
 endtask : write_resp_xtn

 //////////////////////////////////////////////////////////////
//collect read add @posedge
/////////////////////////////////////////////////////////////
 task axi_master_monitor::read_add_xtn();
   axi_master_trans m_trans;

    forever
      begin
        @(posedge vif.ACLK)
         if(vif.m_mon_cb.ARVALID == 1'b1 && vif.m_mon_cb.ARREADY == 1'b1);
          begin
           m_trans.ARADDR   = vif.m_mon_cb.ARADDR;
           m_trans.ARID     = vif.m_mon_cb.ARID;
           m_trans.ARLEN    = vif.m_mon_cb.ARLEN;
           m_trans.ARSIZE   = vif.m_mon_cb.ARSIZE;
           m_trans.ARBURST  = vif.m_mon_cb.ARBURST;
           m_trans.ARLOCK   = vif.m_mon_cb.ARLOCK;
           m_trans.ARCACHE  = vif.m_mon_cb.ARCACHE;
           m_trans.ARPROT   = vif.m_mon_cb.ARPROT;
         end 

       `uvm_info(get_type_name(), $sprintf("collected read addr addr : %h, len : %h", m_trans.ARADDR, m_trans.ARLEN), UVM_LOW)
      end
 endtask : read_add_xtn

/////////////////////////////////////////////////////////
//collect read data & resp
/////////////////////////////////////////////////////////
 task axi_master_monitor::read_data_xtn();
   axi_master_trans m_trans;

    forever begin
      @(posedge vif.ACLK)
       if(vif.m_mon_cb.RVALID == 1'b1 && vif.m_mon_cb.RREADY == 1'b1);
        begin
          m_trans.RDATA = vif.m_mon_cb.RDATA;
          m_trans.RRESP = vif.m_mon_cb.RRESP;
        end
    
     `uvm_info(get_type_name(), $sprintf("collected read data data : %h", m_trans.RDATA), UVM_LOW)
     
    // send transfer to scb
     mon2sb.write(m_trans);
         
     end

 endtask : read_data_xtn

///////////////////////////////////////////////////////////////////////   
`endif

