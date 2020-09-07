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


module axi4_assertion();

//declare all signals
input ACLK, ARESETn;
input ARVALID,AWVALID,WVALID,RVALID,BVALID;
input ARREADY,AWREADY,WREADY,RREADY,BREADY;
input AWID,AWADDR,AWLEN,AWSIZE ,AWBURST,AWLOCK,AWCACHE,AWPROT;
input WDATA,WSTRB,WLAST;
input BID,BRESP;
input ARID,ARADDR,ARLEN,ARSIZE,ARBURST,ARLOCK,ARCACHE,ARPROT;
input RID,RDATA,RRESP,RLAST;

//During RESET CONDITION:
//The AXI protocol uses a single active LOW reset signal, ARESETn

property reset_awvalid;
@(posedge ACLK) disable iff(!ARESETn)
$fell (AWVALID);
endproperty
AWVALID_AT_RESET: assert property (reset_awvalid);


property reset_arvalid;
@(posedge ACLK) disable iff(!ARESETn)
$fell (ARVALID);
endproperty
ARVALID_AT_RESET: assert property (reset_arvalid);


property reset_wvalid;
  @(posedge ACLK) disable iff(!ARESETn)
 $fell (WVALID);
endproperty
WVALID_AT_RESET: assert property (reset_wvalid);


property reset_rvalid;
  @(posedge ACLK) disable iff(!ARESETn)
$fell (RVALID);
endproperty
RVALID_AT_RESET: assert property (reset_rvalid);


property reset_bvalid;
  @(posedge ACLK) disable iff(!ARESETn)
$fell (BVALID);
endproperty
BVALID_AT_RESET: assert property (reset_bvalid);


//After RESET CONDITION:


property resetn_awvalid;
@(posedge ACLK) disable iff(ARESETn)
$rose (AWVALID);
endproperty
AWVALID_AFTER_RESET: assert property (resetn_awvalid);


property resetn_arvalid;
  @(posedge ACLK) disable iff(ARESETn)
$rose (ARVALID);
endproperty
ARVALID_AFTER_RESET: assert property (resetn_arvalid);


property resetn_wvalid;
@(posedge ACLK) disable iff(ARESETn)
$rose (WVALID);
endproperty
WVALID_AFTER_RESET: assert property (resetn_wvalid);

//Write_address (Handshake Signal)
// When asserted, VALID must remain asserted until the rising clock edge after the slave asserts READY
property write_address;
   @(posedge ACLK) disable iff (ARESETn)
   (AWVALID && (!AWREADY)) |-> ##1 AWVALID;
endproperty
Write_Address_Valid_Ready: assert property (write_address);

//Write_data (Handshake Signal)
property write_data;
   @(posedge ACLK) disable iff (ARESETn)
   (WVALID && (!WREADY)) |-> ##1 WVALID;
endproperty
Write_Data_Valid_Ready: assert property (write_data);

//Write_response (Handshake Signal)
property write_response;
   @(posedge ACLK) disable iff (ARESETn)
   (BVALID && (!BREADY)) |-> ##1 BVALID;
endproperty
Write_Response_Valid_Ready: assert property (write_response);

//Read_address (Handshake Signal)
property read_address;
   @(posedge ACLK) disable iff (ARESETn)
   (ARVALID && (!ARREADY)) |-> ##1 ARVALID;
endproperty
Read_Address_Valid_Ready: assert property (read_address);

//Read_data (Handshake Signal)
property read_data;
   @(posedge ACLK) disable iff (ARESETn)
   (RVALID && (!RREADY)) |-> ##1 RVALID;
endproperty
Read_Data_Valid_Ready: assert property (read_data);



///////////////////////////////////////////////////////////////////////////////////
WRITE ADDRESS CHANNEL 
//////////////////////////////////////////////////////////////////////////////////

// Following signal should not x or z when AWVALID is high

AWID_X: assert property (@(posedge ACLK) AWVALID |-> (!$isunknown(AWID)));

AWADDR_X: assert property (@(posedge ACLK) AWVALID |-> (!$isunknown(AWADDR)));

AWLEN_X: assert property (@(posedge ACLK) AWVALID |-> (!$isunknown(AWLEN)));

AWSIZE_X: assert property (@(posedge ACLK) AWVALID |-> (!$isunknown(AWSIZE)));

AWBURST_X: assert property (@(posedge ACLK) AWVALID |-> (!$isunknown(AWBURST)));

AWLOCK_X: assert property (@(posedge ACLK) AWVALID |-> (!$isunknown(AWLOCK)));

AWCACHE_X: assert property (@(posedge ACLK) AWVALID |-> (!$isunknown(AWCACHE)));

AWPROT_X: assert property (@(posedge ACLK) AWVALID |-> (!$isunknown(AWPROT)));

//Following signals remain stable when AWVALID is asserted and AWREADY is LOW

property writeaddr_stable;
   @(posedge ACLK) disable iff (ARESETn)
   (AWVALID && !AWREADY) |->
   ##1 (AWADDR == $past(AWADDR));
endproperty
AWADDR_STABLE: assert property (writeaddr_stable);

property writeburstlength_stable;
   @(posedge ACLK) disable iff (ARESETn)
   (AWVALID && !AWREADY) |->
   ##1 (AWLEN == $past(AWLEN));
endproperty
AWLEN_STABLE: assert property (burstlength_stable);

property writelock_stable;
   @(posedge ACLK) disable iff (ARESETn)
   (AWVALID && !AWREADY) |->
   ##1 (AWLOCK == $past(AWLOCK));
endproperty
AWLOCK_STABLE: assert property (writelock_stable);

property writememory_stable;
   @(posedge ACLK) disable iff (ARESETn)
   (AWVALID && !AWREADY) |->
   ##1 (AWCACHE == $past(AWCACHE));
endproperty
AWCACHE_STABLE: assert property (writememory_stable);

property writeprot_stable;
   @(posedge ACLK) disable iff (ARESETn)
   (AWVALID && !AWREADY) |->
   ##1 (AWPROT == $past(AWPROT));
endproperty
AWPROT_STABLE: assert property (writeprot_stable);

property writeaddID_stable;
   @(posedge ACLK) disable iff (ARESETn)
   (AWVALID && !AWREADY) |->
   ##1 (AWID == $past(AWID));
endproperty
AWID_STABLE: assert property (writeaddID_stable);

property writeburstsize_stable;
   @(posedge ACLK) disable iff (ARESETn)
   (AWVALID && !AWREADY) |->
   ##1 (AWSIZE == $past(AWSIZE));
endproperty
AWSIZE_STABLE: assert property (writeburstsize_stable);

property writebursttype_stable;
   @(posedge ACLK) disable iff (ARESETn)
   (AWVALID && !AWREADY) |->
   ##1 (AWBURST == $past(AWBURST));
endproperty
AWBURST_STABLE: assert property (writebursttype_stable);

// Write Burst Type can’t be 2’b11 as it is reserved
property writeburst_reserved;
 @(posedge ACLK) disable iff(ARESETn)
AWVALID |-> (AWBURST !=2’b11);
endproperty
AWBURST_RESVD: assert property (writeburst_reserved);


////////////////////////////////////////////////////////////////////////////////////////
WRITE DATA CHANNEL
/////////////////////////////////////////////////////////////////////////////////////

//Following signal remain stable when WVALID is asserted and WREADY is LOW

property writedata_stable;
 @(posedge ACLK) disable iff(ARESETn)
 (WVALID && !WREADY) |-> $stable(WDATA);
endproperty
WDATA_STABLE:assert property(writedata_stable)


property writestrobe_stable;
 @(posedge ACLK) disable iff(ARESETn)
 (WVALID && !WREADY) |-> $stable(WSTRB);
endproperty
WSTRB_STABLE:assert property(writestrobe_stable)


property writelast_stable;
 @(posedge ACLK) disable iff(ARESETn)
 (WVALID && !WREADY) |-> $stable(WLAST);
endproperty
WLAST_STABLE:assert property(writelast_stable)

// When WVALID is HIGH, value of X on following signal is not permitted

WDATA_X: assert property (@(posedge ACLK) WVALID |-> (!$isunknown(WDATA)));

WSTRB_X: assert property (@(posedge ACLK) WVALID |-> (!$isunknown(WSTRB)));

WLAST_X: assert property (@(posedge ACLK) WVALID |-> (!$isunknown(WLAST)));


////////////////////////////////////////////////////////////////////////
WRITE RESPONSE CHANNEL
///////////////////////////////////////////////////////////////////////

// Following signal remain stable when BVALID is asserted and BREADY is LOW

property writeresponse_stable;
 @(posedge ACLK) disable iff(ARESETn)
 (BVALID && !BREADY) |-> $stable(BRESP);
endproperty
BRESP_STABLE:assert property(writeresponse_stable)


property writeresponseID_stable;
 @(posedge ACLK) disable iff(ARESETn)
 (BVALID && !BREADY) |-> $stable(BID);
endproperty
BID_STABLE:assert property(writeresponseID_stable)

// When BVALID is HIGH, value of X on following signal is not permitted

BID_X: assert property (@(posedge ACLK) BVALID |-> (!$isunknown(BID)));

BRESP_X: assert property (@(posedge ACLK) BVALID |-> (!$isunknown(BRESP)));


/////////////////////////////////////////////////////////////////////////////////
READ ADDRESS CHANNEL
///////////////////////////////////////////////////////////////////////////////

// Following signal remain stable when BVALID is asserted and BREADY is LOW

property readaddID_stable;
 @(posedge ACLK) disable iff(ARESETn)
 (ARVALID && !ARREADY) |-> $stable(ARID);
endproperty
ARID_STABLE:assert property(readaddID_stable)

property readadd_stable;
 @(posedge ACLK) disable iff(ARESETn)
 (ARVALID && !ARREADY) |-> $stable(ARADDR);
endproperty
ARADDR_STABLE:assert property(readadd_stable)

property readburstlength_stable;
 @(posedge ACLK) disable iff(ARESETn)
 (ARVALID && !ARREADY) |-> $stable(ARLEN);
endproperty
ARLEN_STABLE:assert property(readburstlength_stable)

property readburstsize_stable;
 @(posedge ACLK) disable iff(ARESETn)
 (ARVALID && !ARREADY) |-> $stable(ARSIZE);
endproperty
ARSIZE_STABLE:assert property(readburstsize_stable)

property readbursttype_stable;
 @(posedge ACLK) disable iff(ARESETn)
 (ARVALID && !ARREADY) |-> $stable(ARBURST);
endproperty
ARBURST_STABLE:assert property(readbursttype_stable)


property readlock_stable;
 @(posedge ACLK) disable iff(ARESETn)
 (ARVALID && !ARREADY) |-> $stable(ARLOCK);
endproperty
ARLOCK_STABLE:assert property(readlock_stable)

property readmem_stable;
 @(posedge ACLK) disable iff(ARESETn)
 (ARVALID && !ARREADY) |-> $stable(ARCACHE);
endproperty
ARCACHE_STABLE:assert property(readmem_stable)


property readprot_stable;
 @(posedge ACLK) disable iff(ARESETn)
 (ARVALID && !ARREADY) |-> $stable(ARPROT);
endproperty
ARPROT_STABLE:assert property(readprot_stable)


// When ARVALID is HIGH, value of X on following signal is not permitted

ARID_X: assert property (@(posedge ACLK) ARVALID |-> (!$isunknown(ARID)));

ARDDR_X: assert property (@(posedge ACLK) ARVALID |-> (!$isunknown(ARDDR)));

ARLEN_X: assert property (@(posedge ACLK) ARVALID |-> (!$isunknown(ARLEN)));

ARSIZE_X: assert property (@(posedge ACLK) ARVALID |-> (!$isunknown(ARSIZE)));

ARBURST_X: assert property (@(posedge ACLK) ARVALID |-> (!$isunknown(ARBURST)));

ARLOCK_X: assert property (@(posedge ACLK) ARVALID |-> (!$isunknown(ARLOCK)));

ARCACHE_X: assert property (@(posedge ACLK) ARVALID |-> (!$isunknown(ARCACHE)));

ARPROT_X: assert property (@(posedge ACLK) ARVALID |-> (!$isunknown(ARPROT)));

// Read burst type can’t be reserved

property readburst_reserved;
 @(posedge ACLK) disable iff(ARESETn)
ARVALID |-> (ARBURST !=2’b11);
endproperty
ARBURST_RESVD: assert property (readburst_reserved);


/////////////////////////////////////////////////////////////////////////////////////
READ DATA CHANNEL
//////////////////////////////////////////////////////////////////////////////////

// Following signal remain stable when RVALID is asserted and RREADY is LOW

property readID_stable;
 @(posedge ACLK) disable iff(ARESETn)
 (RVALID && !RREADY) |-> $stable(RID);
endproperty
RID_STABLE:assert property(readID_stable)


property readdata_stable;
 @(posedge ACLK) disable iff(ARESETn)
 (RVALID && !RREADY) |-> $stable(RDATA);
endproperty
RDATA_STABLE:assert property(readdata_stable)


property readresp_stable;
 @(posedge ACLK) disable iff(ARESETn)
 (RVALID && !RREADY) |-> $stable(RRESP);
endproperty
RRESP_STABLE:assert property(readresp_stable)

property readlast_stable;
 @(posedge ACLK) disable iff(ARESETn)
 (RVALID && !RREADY) |-> $stable(RLAST);
endproperty
RLAST_STABLE:assert property(readlast_stable)


// When RVALID is HIGH, value of X on following signal is not permitted

RID_X: assert property (@(posedge ACLK) RVALID |-> (!$isunknown(RID)));


RDATA_X: assert property (@(posedge ACLK) RVALID |-> (!$isunknown(RDATA)));


RRESP_X: assert property (@(posedge ACLK) RVALID |-> (!$isunknown(RRESP)));


RLAST_X: assert property (@(posedge ACLK) RVALID |-> (!$isunknown(RLAST)));

endmodule






















