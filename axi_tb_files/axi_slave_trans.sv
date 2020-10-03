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

class axi_slave_trans extends uvm_sequence_item;

typedef enum logic [1:0] {FIXED, INCR, WRAP, RESERVED} burst_t;
typedef enum bit [1:0] {OKAY, EXOKAY, SLVERR, DECERR} resp_t;

//Write address signal
     logic        AWVALID;
rand bit          AWREADY;
     logic [31:0] AWADDR;
     logic [2:0]  AWPROT;
     logic [3:0]  AWID;
     logic [3:0]  AWLEN;
     logic [2:0]  AWSIZE;
     burst_t      AWBURST;
     logic [1:0]  AWLOCK;
     logic [3:0]  AWCACHE;

//Write data signal
     logic        WVALID;
rand bit          WREADY;
     logic [31:0] WDATA;
     logic [3:0]  WSTRB;
     logic [3:0]  WID;
     logic        WLAST;

//Write response signal
rand bit 	     BVLAID;
     logic  	 BREADY;
rand resp_t    BRESP;
rand bit [3:0] BID;

//Read address signal
     logic 	      ARVALID;
rand bit 	        ARREADY;
     logic [31:0] ARADDR;
     logic [2:0]  ARPROT;
     logic [3:0]  ARID;
     logic [3:0]  ARLEN;
     logic [2:0]  ARSIZE;
     burst_t      ARBURST;
     logic [1:0]  ARLOCK;
     logic [3:0]  ARCACHE;

//Read data signal
rand bit        RVALID;
     logic      RREADY;
rand bit [31:0] RDATA;
rand resp_t     RRESP;
rand bit        RLAST;
rand bit [3:0]  RID;

///////////////////////////////////
//Constraints to be added
////////////////////////////////////

function new(string name="axi_slave_trans");
super.new(name);
endfunction


`uvm_object_utils_begin(axi_slave_trans)
`uvm_field_int(AWADDR,UVM_ALL_ON)
`uvm_field_int(AWVALID,UVM_ALL_ON)
`uvm_field_int(AWREADY,UVM_ALL_ON)
`uvm_field_int(AWPROT,UVM_ALL_ON)
`uvm_field_int(AWID,UVM_ALL_ON)
`uvm_field_int(AWLEN,UVM_ALL_ON)
`uvm_field_int(AWSIZE,UVM_ALL_ON)
`uvm_field_int(AWBURST,UVM_ALL_ON)
`uvm_field_int(AWLOCK,UVM_ALL_ON)
`uvm_field_int(AWCACHE,UVM_ALL_ON)
`uvm_field_int(WREADY,UVM_ALL_ON)
`uvm_field_int(WDATA,UVM_ALL_ON)
`uvm_field_int(WVALID,UVM_ALL_ON)
`uvm_field_int(WLAST,UVM_ALL_ON)
`uvm_field_int(WSTRB,UVM_ALL_ON)
`uvm_field_int(BVALID,UVM_ALL_ON)
`uvm_field_int(BREADY,UVM_ALL_ON)
`uvm_field_int(BRESP,UVM_ALL_ON)
`uvm_field_int(BID,UVM_ALL_ON)
`uvm_field_int(ARADDR,UVM_ALL_ON)
`uvm_field_int(ARVALID,UVM_ALL_ON)
`uvm_field_int(ARREADY,UVM_ALL_ON)
`uvm_field_int(ARPROT,UVM_ALL_ON)
`uvm_field_int(ARID,UVM_ALL_ON)
`uvm_field_int(ARLEN,UVM_ALL_ON)
`uvm_field_int(ARBURST,UVM_ALL_ON)
`uvm_field_int(ARSIZE,UVM_ALL_ON)
`uvm_field_int(ARLOCK,UVM_ALL_ON)
`uvm_field_int(ARCACHE,UVM_ALL_ON)
`uvm_field_int(RVALID,UVM_ALL_ON)
`uvm_field_int(RREADY,UVM_ALL_ON)
`uvm_field_int(RDATA,UVM_ALL_ON)
`uvm_field_int(RRESP,UVM_ALL_ON)
`uvm_field_int(RID,UVM_ALL_ON)
`uvm_field_int(RLAST,UVM_ALL_ON)

`uvm_object_utils_end

endclass
