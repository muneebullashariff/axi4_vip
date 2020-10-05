//  #######################################################################
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
//  ########################################################################
//

class axi_wr_mon extends uvm_monitor #(axi_trans);
	`uvm_component_utils(axi_wr_mon)

	virtual axi_intf vif;
	uvm_analysis_port #(axi_trans) mon_port;
	axi_trans trans;

	function new(string name = "axi_wr_mon",uvm_component parent = null);
			super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if((!uvm_config_db #(virtual axi_intf)::get(this," ","vif",vif)))
						 `uvm_fatal("NOVIF","Virtual interface not found")

	endfunction

	virtual task run_phase(uvm_phase phase);
		begin
				trans = axi_trans::type_id::create("trans",this);
				forever
					begin
							@(posedge clk);
								begin
										if(!vif.reset) //Logic when is reset is asserted
										begin
												trans.awaddr.delete();
												trans.wdata.delete();
												trans.awsize = 0;
												trans.awlen.delete();
												trans.awburst = 0;
												trans.awid.delete();
												trans.awlock = 0;
												trans.awcache = 0;
												trans.wstrb.delete():
											    trans.bresp = 0;
								         end

										 else //Monitor Logic
										 begin
												trans.awaddr[index] = vif.awaddr;
												trans.awlen[index] = vif.awlen;
												trans.awburst = vif.awburst;
												trans.awcache = vif.awcache;
												trans.awlock = vif.awlock;
												trans.awid[index] = vif.awid;
												if(vif.awlen > 0) //This logic when AWLEN is greater than zero
												begin
														for(int r=0;r<(vif.awlen+1);r++)
														begin
																trans.wdata[index2+r] = vif.wdata;
																trans.wstrb[index2+r] = vif.wstrb;
																@(posedge clk);
														end
														index2 = vif.awlen+1;
												end

												else //This logic when AWLEN == 0
												begin
														trans.wdata[index2] = vif.wdata;
														trans.wstrb[index2] = vif.wstrb;
														index2++;
														@(posedge clk);
												end
										end
								end
						end
						mon_port.write(axi_trans);
				end
		endtask
endclass


