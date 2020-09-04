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

class axi_xtn extends uvm_sequence_item;
//`uvm_object_utils(axi_xtn)

typedef enum logic [1:0] {FIXED, INCR, WRAP, RESERVED} burst_t;
typedef enum logic [1:0] {OKAY, EXOKAY, SLVERR, DECERR} resp_t;

//global signals
     logic ARESETn;

//Write address signal
rand logic        AWVALID;
     logic        AWREADY;
rand logic [31:0] AWADDR;
rand logic [2:0]  AWPROT;
rand logic [3:0]  AWID;
rand logic [3:0]  AWLEN;
rand logic [2:0]  AWSIZE;
     burst_t      AWBURST;
rand logic [1:0]  AWLOCK;
rand logic [3:0]  AWCACHE;

//Write data signal
rand logic        WVALID;
     logic        WREADY;
rand logic [31:0] WDATA;
rand logic [3:0]  WSTRB;
rand logic [3:0]  WID;
rand logic        WLAST;

//Write response signal
     logic 	     BVLAID;
rand logic 	     BREADY;
     resp_t      BRESP;
     logic [3:0] BID;

//Read address signal
rand logic 	      ARVALID;
     logic 	      ARREADY;
rand logic [31:0] ARADDR;
rand logic [2:0]  ARPROT;
rand logic [3:0]  ARID;
rand logic [3:0]  ARLEN;
rand logic [2:0]  ARSIZE;
     burst_t      ARBURST;
rand logic [1:0]  ARLOCK;
rand logic [3:0]  ARCACHE;

//Read data signal
rand logic      	RREADY;
     logic [31:0] RDATA;
     resp_t       RRESP;
     logic        RLAST;


constraint WALIGNADDR {AWADDR % 4==0;} //aligned address
constraint RALIGNADDR {ARADDR % 4==0;}
constraint STROBE {WSTRB == 4'b1111;} //write strobe for valid data
constraint WDATA_SIZE {WDATA.size() == AWLEN+1;} //burst length
constraint RDATA_SIZE {RDATA.size() == ARLEN+1;}


function new(string name="axi_xtn");
super.new(name);
endfunction


`uvm_object_utils_begin(axi_xtn)
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
