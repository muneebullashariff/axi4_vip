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

`ifndef AXI_INTF_INCLUDED_
`define AXI_INTF_INCLUDED_

//Inferface file for AXI4 protocol containing all the interface signals

interface axi_if (input bit clk);

logic [3:0]  AWID;
logic [31:0] AWADDR;
logic [3:0]  AWLEN;
logic [2:0]  AWSIZE;
logic [1:0]  AWBURST;
logic        AWLOCK;
logic 	     AWCACHE;
logic        AWPROT;
logic 	     AWQOS;
logic 	     AWREGION;
logic 	     AWUSER;
logic 	     AWVALID;
logic 	     AWREADY;

logic [3:0]  WID;
logic [31:0] WDATA;
logic [3:0]  WSTRB;
logic 	     WLAST;
logic 	     WUSER;
logic  	     WVALID;
logic 	     WREADY;

logic [3:0]  BID;
logic [1:0]  BRESP;
logic 	     BUSER;
logic 	     BVALID;
logic 	     BREADY;

logic [3:0]  ARID;
logic [31:0] ARADDR;
logic [3:0]  ARLEN;
logic [2:0]  ARSIZE;
logic [1:0]  ARBURST;
logic 	     ARLOCK;
logic 	     ARCACHE;
logic 	     ARPROT;
logic 	     ARQOS;
logic        ARREGION;
logic        ARUSER;
logic 	     ARVALID;
logic 	     ARREADY;

logic [3:0]  RID;
logic [31:0] RDATA;
logic [3:0]  RRESP;
logic 	     RLAST;
logic 	     RUSER;
logic 	     RVALID;
logic 	     RREADY;

// Master_driver clocking block
clocking m_drv_cb @(posedge clk);
default input #1 output #1;
output   AWID;
output   AWADDR;
output   AWLEN;
output   AWSIZE;
output   AWBURST;
output   AWLOCK;
output   AWCACHE;
output   AWPROT;
output   AWQOS;
output   AWREGION;
output   AWUSER;
output   AWVALID;
input 	 AWREADY;

output   WID;
output   WDATA;
output   WSTRB;
output   WLAST;
output   WUSER;
output   WVALID;
input    WREADY;

input    BID;
input    BRESP;
input    BUSER;
input    BVALID;
output   BREADY;

output   ARID;
output   ARADDR;
output   ARLEN;
output   ARSIZE;
output   ARBURST;
output   ARLOCK;
output   ARCACHE;
output   ARPROT;
output   ARQOS;
output   ARREGION;
output   ARUSER;
output   ARVALID;
input    ARREADY;

input    RID;
input    RDATA;
input    RRESP;
input 	 RLAST;
input 	 RUSER;
input 	 RVALID;
output 	 RREADY;

endclocking

//master_monitor clocking block
clocking m_mon_cb @(posedge clk);
default input #1 output #1;

input   AWID;
input   AWADDR;
input   AWLEN;
input   AWSIZE;
input   AWBURST;
input   AWLOCK;
input   AWCACHE;
input   AWPROT;
input   AWQOS;
input   AWREGION;
input   AWUSER;
input   AWVALID;
input 	AWREADY;

input   WID;
input   WDATA;
input   WSTRB;
input   WLAST;
input   WUSER;
input   WVALID;
input   WREADY;

input   BID;
input   BRESP;
input   BUSER;
input   BVALID;
input   BREADY;

input   ARID;
input   ARADDR;
input   ARLEN;
input   ARSIZE;
input   ARBURST;
input   ARLOCK;
input   ARCACHE;
input   ARPROT;
input   ARQOS;
input   ARREGION;
input   ARUSER;
input   ARVALID;
input   ARREADY;

input   RID;
input   RDATA;
input   RRESP;
input   RLAST;
input	RUSER;
input   RVALID;
input 	RREADY;

endclocking

//slave_driver clocking block
clocking s_drv_cb @(posedge clk);
default input #1 output #1;

input   AWID;
input   AWADDR;
input   AWLEN;
input   AWSIZE;
input   AWBURST;
input   AWLOCK;
input   AWCACHE;
input   AWPROT;
input   AWQOS;
input   AWREGION;
input   AWUSER;
input   AWVALID;
output 	AWREADY;

input   WID;
input   WDATA;
input   WSTRB;
input   WLAST;
input   WUSER;
input   WVALID;
output  WREADY;

output  BID;
output  BRESP;
output  BUSER;
output  BVALID;
input   BREADY;

input   ARID;
input   ARADDR;
input   ARLEN;
input   ARSIZE;
input   ARBURST;
input   ARLOCK;
input   ARCACHE;
input   ARPROT;
input   ARQOS;
input   ARREGION;
input   ARUSER;
input   ARVALID;
output  ARREADY;

output  RID;
output  RDATA;
output  RRESP;
output  RLAST;
output	RUSER;
output  RVALID;
input 	RREADY;

endclocking

//slave_monitor clocking block
clocking s_mon_cb @(posedge clk);
default input #1 output #1;

input   AWID;
input   AWADDR;
input   AWLEN;
input   AWSIZE;
input   AWBURST;
input   AWLOCK;
input   AWCACHE;
input   AWPROT;
input   AWQOS;
input   AWREGION;
input   AWUSER;
input   AWVALID;
input 	AWREADY;

input   WID;
input   WDATA;
input   WSTRB;
input   WLAST;
input   WUSER;
input   WVALID;
input   WREADY;

input   BID;
input   BRESP;
input   BUSER;
input   BVALID;
input   BREADY;

input   ARID;
input   ARADDR;
input   ARLEN;
input   ARSIZE;
input   ARBURST;
input   ARLOCK;
input   ARCACHE;
input   ARPROT;
input   ARQOS;
input   ARREGION;
input   ARUSER;
input   ARVALID;
input   ARREADY;

input   RID;
input   RDATA;
input   RRESP;
input 	RLAST;
input 	RUSER;
input 	RVALID;
input 	RREADY;

endclocking


//modports

modport M_DRV_MP(clocking m_drv_cb);
modport M_MON_MP(clocking m_mon_cb);
modport S_DRV_MP(clocking s_drv_cb);
modport S_MON_MP(clocking s_mon_cb);

endinterface

`endif
