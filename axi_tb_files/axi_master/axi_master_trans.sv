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

class axi_master_trans extends uvm_sequence_item;

typedef enum bit [1:0] {FIXED, INCR, WRAP, RESERVED} burst_t;
typedef enum logic [1:0] {OKAY, EXOKAY, SLVERR, DECERR} resp_t;

//Write address signal
rand bit        AWVALID;
     logic      AWREADY;
rand bit [31:0] AWADDR;
rand bit [2:0]  AWPROT;
rand bit [3:0]  AWID;
rand bit [3:0]  AWLEN;
rand bit [2:0]  AWSIZE;
rand burst_t    AWBURST;
rand bit [1:0]  AWLOCK;
rand bit [3:0]  AWCACHE;

//Write data signal
rand bit        WVALID;
     logic      WREADY;
rand bit [31:0] WDATA;
rand bit [3:0]  WSTRB;
rand bit [3:0]  WID;
rand bit        WLAST;

//Write response signal
     logic 	     BVLAID;
rand bit  	     BREADY;
     resp_t      BRESP;
     logic [3:0] BID;

//Read address signal
rand bit 	      ARVALID;
     logic 	    ARREADY;
rand bit [31:0] ARADDR;
rand bit [2:0]  ARPROT;
rand bit [3:0]  ARID;
rand bit [3:0]  ARLEN;
rand bit [2:0]  ARSIZE;
rand burst_t    ARBURST;
rand bit [1:0]  ARLOCK;
rand bit [3:0]  ARCACHE;

//Read data signal
     logic        RVALID;
rand bit        	RREADY;
     logic [31:0] RDATA;
     resp_t       RRESP;
     logic        RLAST;
     logic [3:0]  RID;


constraint WALIGNADDR {AWADDR % 4==0;} //aligned address
constraint RALIGNADDR {ARADDR % 4==0;}
constraint STROBE {WSTRB == 4'b1111;} //write strobe for valid data
constraint WDATA_SIZE {WDATA.size() == AWLEN+1;} //burst length
constraint RDATA_SIZE {RDATA.size() == ARLEN+1;}

constraint write_address_id_c {
    soft AWID == WID;
  }
  
  constraint write_address_c {    
    soft AWBURST inside {[0:2]};
    soft AWADDR inside {[0:4095]};
    soft WDATA.size() == AWLEN+1;
    if (AWBURST == 2) {
      soft AWLEN inside {2, 4, 8, 16};
      if (AWSIZE == 1) {
        soft AWADDR[0] == 1'b0;
      } else if (AWSIZE == 2) {
        soft AWADDR[1:0] == 2'b0;
      } else if (AWSIZE == 3) {
        soft AWADDR[2:0] == 3'b0;
      } else if (AWSIZE == 4) {
        soft AWADDR[3:0] == 4'b0;
      } else if (AWSIZE == 5) {
        soft AWADDR[4:0] == 5'b0;
      } else if (AWSIZE == 6) {
        soft AWADDR[5:0] == 6'b0;
      } else if (AWSIZE == 7) {
        soft AWADDR[6:0] == 7'b0;
      }
    }

    solve AWBUSRT before AWLEN;
    solve AWBUSRT before AWADDR;
    solve AWLEN before WDATA;
    solve AWLEN before WSTRB;
  }
        
  constraint read_address_c {    
    ARBURST inside {[0:2]};
    ARADDR inside {[0:4095]};
    if (ARBURST == 2) {
      ARLEN inside {2, 4, 8, 16};
      if (ARSIZE == 1) {
        ARADDR[0] == 1'b0;
      } else if (ARSIZE == 2) {
        ARADDR[1:0] == 2'b0;
      } else if (ARSIZE == 3) {
        ARADDR[2:0] == 3'b0;
      } else if (ARSIZE == 4) {
        ARADDR[3:0] == 4'b0;
      } else if (ARSIZE == 5) {
        ARADDR[4:0] == 5'b0;
      } else if (ARSIZE == 6) {
        ARADDR[5:0] == 6'b0;
      } else if (ARSIZE == 7) {
        ARADDR[6:0] == 7'b0;
      }
    }
  }
        
  constraint write_address_cache_c {
    soft (AWCACHE != 4 && AWCACHE != 5 && AWCACHE != 8 && AWCACHE != 9 && AWCACHE != 12 && AWCACHE != 13);  //As per Table A4-5 Memory type encoding
  }
  
  constraint read_address_cache_c {
    soft (ARCACHE!= 4 && ARCACHE != 5 && ARCACHE != 8 && ARCACHE != 9 && ARCACHE != 12 && ARCACHE != 13);   //As per Table A4-5 Memory type encoding
  }
          
  function post_randomize();
      int i, j;
      WDATA = new[AWLEN+1];
      WSTRB = new[AWLEN+1];
      foreach (WDATA[i]) begin
        WDATA[i] = $urandom_range(((2**(8*(AWSIZE+1)))-1), 0);
      end

      foreach (WSTRB[j]) begin
        WSTRB[j] = $urandom_range(((2**(AWSIZE+1))-1), 0);
      end      
  endfunction



function new(string name="axi_master_trans");
super.new(name);
endfunction


`uvm_object_utils_begin(axi_master_trans)
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
