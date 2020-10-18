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

`ifndef AXI_MASTER_COVERAGE_SV
`define AXI_MASTER_COVERAGE_SV

//////////////////////////////////////////
//Class: axi_master_coverage
//for master axi vip
/////////////////////////////////////////
class axi_master_coverage extends uvm_subscriber #(axi_master_trans);

  //factory registration
  `uvm_component_utils(axi_master_coverage)

  //handle declaration
  axi_master_trans item;

  //externally defined task & function
  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void write(axi_master_trans t);  //write method

  

////// Coverage for write address channel /////////////////

 covergroup wr_addr_cg(axi_master_trans item);
   option.per_instance = 1;

  //write add coverpoint
  WRITEADDR: coverpoint item.AWADDR {
              bins awaddr_bin = default;
             }

  //WADDR ID coverpoint
  WADDR_ID: coverpoint item.AWID {
             bins awid_bin[] = {[0:$]}; //all possible values to be covered
            }

  //burst length coverpoint
  //for fixed burst
  AWLEN_FIXED: coverpoint item.AWLEN iff(item.burst_t == FIXED) {
                bins awlen_fixed_bin[] = {[0:15]};
               }
        
  //for incr burst
  AWLEN_INCR: coverpoint item.AWLEN iff(item.burst_t == INCR) {
               bins awlen_incr_bin[] = {[0:$]};
              }
        
  //for wrap burst
  AWLEN_WRAP: coverpoint item.AWLEN iff(item.burst_t == WRAP) {
               bins awlen_wrap_bin[] = {1, 3, 8, 15};
              }
  
  //burst size coverpoint
  BURSTSIZE : coverpoint item.AWSIZE {
                 bins 1BYTE    = {3'b000}; //transfer 1byte per beat
                 bins 2BYTES   = {3'b001};
                 bins 4BYTES   = {3'b010};
                 bins 8BYTES   = {3'b011};
                 bins 16BYTES  = {3'b100};
                 bins 32BYTES  = {3'b101};
                 bins 64BYTES  = {3'b110};
                 bins 128BYTES = {3'b111};
               }

  //burst type coverpoint 
  BURSTTYPE : coverpoint item.burst_t.AWBURST {
                 bins FIXED_bin   = {FIXED};
                 bins INCR_bin    = {INCR};
                 bins WRAP_bin    = {WRAP};
                 illegal_bins resvd_bin = {RESERVED};
                }

  //lock type coverpoint
  LOCK:	coverpoint item.AWLOCK {
		     bins NORMAL_ACCESS_bin 		= {'b0};
			   bins EXCLUSIVE_ACCESS_bin	= {'b1};
		    }
     
 endgroup: wr_addr_cg


//////////////////// Coverage for Write data channel ///////////////////

  covergroup wr_data_cg(axi_master_trans item);
   option.per_instance = 1;

   //write data coverpoint
   WRITEDATA: coverpoint item.WDATA {
               bins wdata_bin = default;
              }
   
   //WDATA ID coverpoint
   WDATA_ID: coverpoint item.WID {
              bins wid_bin[] = {[0:$]}; //all possible values to be covered
             }

   //write strobe coverpoint
   WRITESTROBE: coverpoint item.WSTRB {
                 bins wstrb_bin[] = {[0:$]}; //all possible values to be covered
                }

   //write last coverpoint
   WRITELAST: coverpoint item.WLAST {
               bins wlast_trans_bin = (0 => 1);
              }
   
  endgroup: wr_data_cg


/////////////// Coverage for Write response channel ////////////////////

covergroup wr_resp_cg(axi_master_trans item);

        option.per_instance = 1;
       
        //write response id coverpoint
        WRSP_ID: coverpoint item.BID {
                  bins bid_bin[] = {[0: $]};
                 }

        //write response coverpoint
        WRITERESP: coverpoint item.resp_t.BRESP {
                    bins okay_bin   = {OKAY};
                    bins EXOKAY_bin = {EXOKAY};
                    bins SLVERR_bin = {SLVERR};
                    bins DECERR_bin = {DECERR};
                  }

endgroup: wr_resp_cg

////////////// Coverage for read address channel ///////////////

covergroup rd_addr_cg(axi_master_trans item);

        option.per_instance = 1;
       
       //read address coverpoint
       READADDR: coverpoint item.ARADDR {
               bins araddr_bin = default;
              }
 

       //read address id coverpoint
       RADDR_ID: coverpoint item.ARID {
                   bins arid_bin[] = {[0: $]};
                 }

        //burst length coverpoint
        //for fixed burst
        ARLEN_FIXED: coverpoint item.ARLEN iff(item.burst_t == FIXED) {
                      bins arlen_fixed_bin[] = {[0: 15]};
                    }
        
        //for incr burst
        ARLEN_INCR: coverpoint item.ARLEN iff(item.burst_t == INCR) {
                     bins arlen_incr_bin[] = {[0: $]};
                   }
        //for wrap burst
        ARLEN_WRAP: coverpoint item.ARLEN iff(item.burst_t == WRAP {
                     bins arlen_wrap_bin[] = {1, 3, 8, 15};
                    }

        //read burst type
        READBURST: coverpoint item.burst_t.ARBURST {
                    bins fixed_bin = {FIXED};
                    bins incr_bin  = {INCR};
                    bins wrap_bin  = {WRAP};
                    illegal_bins reserved_bin = {RESERVED};
                   }

        //read burst size
        BURSTSIZE :	coverpoint item.ARSIZE {
		      	         bins 1BYTE   = {3'b000};
			               bins 2BYTES  = {3'b001};
			               bins 4BYTES  = {3'b010};
			               bins 8BYTES  = {3'b011};
			               bins 16BYTES =	{3'b100};
			               bins 32BYTES =	{3'b101};
			               bins 64BYTES =	{3'b110};
			               bins 128BYTES ={3'b111};
		               }
       
        //read lock type
        READLOCK: coverpoint item.ARLOCK {
                   bins NORMAL_ACCESS_bin 		= {'b0};
                   bins EXCLUSIVE_ACCESS_bin	= {'b1};
                 }

    endgroup: rd_addr_cg

    //read data channel coverage specification
    covergroup rd_data_cg(axi_master_trans item);

        option.per_instance = 1;
        
    //read data coverpoint
    R_DATA : coverpoint item.RDATA{
              bins rdata_bin = default;
            }

        
    //read last coverpoint
    RD_LAST: coverpoint item.RLAST {
              bins rlast_trans_bin = (0 => 1);
             }

    //read id coverpoint
    RD_ID: coverpoint item.RID {
            bins rid_bin[] = {[0: $]};
           }

    //read response coverpoint
    RD_RESP: coverpoint item.resp_t.RRESP {
              bins okay_bin   = {OKAY};
              bins EXOKAY_bin = {EXOKAY};
              bins SLVERR_bin = {SLVERR};
              bins DECERR_bin = {DECERR};
        }
   
  endgroup: rd_data_cg


 endclass : axi_master_coverage


 function axi_master_coverage::new(string name, uvm_component parent);
   super.new(name, parent);

      wr_addr_cg = new();
      wr_data_cg = new();
      wr_resp_cg = new();
      rd_add_cg  = new();
      rd_data_cg = new();

endfunction : new

function void axi_master_coverage::build_phase(uvm_phase phase);
    super.build_phase(phase); 
endfunction:build_phase


////////// sampling the coverage ///////////////////

function void axi_master_coverage::write(axi_master_trans t);
  `uvm_info(this.get_type_name(), $sformatf("%s", t.convert2string()), UVM_HIGH)

   if(item.AWVALID && item.AWREADY) begin
     wr_addr_cg.sample();
   end
   
   if(item.WVALID && item.WREADY) begin
      wr_data_cg.sample();
   end
  
   if(item.BVALID && item.BREADY) begin
      wr_resp_cg.sample();
   end
   
   if(item.ARVALID && item.ARREADY) begin
      rd_addr_cg.sample();
   end
   
   if(item.RVALID && item.RREADY) begin
     rd_data_cg.sample();
   end
 
endfunction : write

