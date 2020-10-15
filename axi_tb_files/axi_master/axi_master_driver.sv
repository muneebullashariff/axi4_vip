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

/////////////////////////////////////MASTER_DRIVER//////////////////////////////////////////////////////

`ifndef AXI_MASTER_DRIVER_INCLUDED
`define AXI_MASTER_DRIVER_INCLUDED

//------------------------------------------------------------------------------------------------
//Class: master_driver
//drives signal to dut
//------------------------------------------------------------------------------------------------

class axi_master_driver extends uvm_driver #(axi_master_trans);

//factory registration
  `uvm_component_utils(axi_master_driver)
	
//handle declaration
  virtual axi_if vif;

  //axi_master_trans req;

//---------------------------------------------
// Externally defined tasks and functions
//---------------------------------------------
   extern function new(string name="axi_master_driver",uvm_component parent); 
   extern function void build_phase(uvm_phase phase);
   extern function void connect_phase(uvm_phase phase);
	   
endclass:axi_master_driver
	   
function axi_master_driver::new(string name="axi_master_driver",uvm_component parent);
   super.new(name,parent);
 endfunction

 function void axi_master_driver::build_phase(uvm_phase phase);
       super.build_phase(phase);
	 if(!uvm_config_db #(virtual axi_if)::get(this,"","vif",vif))
       begin
          `uvm_fatal(get_type_name(),"interface in master driver not found")
       end
 endfunction

     function void axi_master_driver::connect_phase(uvm_phase phase);
       super.connect_phase(phase);
     endfunction
	   
///////////////////////////////////////// WRITE DRIVER ////////////////////////////////////
	   
class axi_wr_drvr extends axi_master_driver #(axi_master_trans);

//factory registration
	`uvm_component_utils(axi_wr_drvr)

		axi_master_trans wr_trans;
		virtual axi_if vif;

		function new(string name = "axi_wr_drvr",uvm_component parent = null);
				super.new(name,parent);
		endfunction

		virtual function void build_phase(uvm_phase phase);
		 begin
				 if((!uvm_config_db #(virtual axi_if)::get(this," ","vif",vif)))
						 `uvm_fatal("NOVIF","Virtual interface not found")

		 end
		endfunction

		virtual task run_phase(uvm_phase phase);
			begin
					forever
						begin
								seq_item_port.get_next_item(req);
								wr_drive(req);
								seq_item_port.finish_item(req);
						end
				end
		endtask

			 virtual task wr_drive(axi_master_trans wr_trans);
			begin
					fork
							addr_ch(wr_trans); //Task to drive address on address channel
							data_ch(wr_trans); //Task to drive data on write data channel
					join_none
			end
	endtask

			 virtual task addr_ch(axi_master_trans wr_trans); //Task to drive address on address channel
		begin
				@(posedge vif.clk);
					begin
							if(!vif.reset) //reset condition
							begin
									vif.AWADDR <= 0;
									vif.AWVALID <= 0;
									vif.AWSIZE <= 0;
									vif.AWLEN <= 0;
									vif.AWBURST <= 0;
									vif.AWCACHE <= 0;
									vif.AWID <= 0;
									vif.AWLOCK <= 0;
							end
							
							else
								begin
									for(int r=0;r<(wr_trans.AWLEN.size());r++)
										begin
										    vif.AWADDR <= wr_trans.AWADDR[r];
										    vif.AWVALID <= 1;
										    vif.AWSIZE <= wr_trans.AWSIZE;
										    vif.AWLEN <= wr_trans.AWLEN[r];
										    vif.AWBURST <= wr_trans.AWBURST;
										    vif.AWCACHE <= wr_trans.AWCACHE;
										    vif.AWID <= wr_trans.AWID[r];
										    vif.AWLOCK <= wr_trans.AWLOCK;
											wait(vif.AWREADY == 1);
										  @(posedge vif.clk);
									    end
								   end
						   end
				   end
		   endtask

			 virtual task data_ch(axi_master_trans wr_trans); //Task to drive write data on data channel
			begin
					@(posedge vif.clk);
			          begin
						if(!vif.reset) //reset condition
							begin
								vif.WDATA <= 0;
					            vif.WVALID <= 0;
								vif.WSTRB <= 0;
					            vif.WLAST <= 0;
					            vif.BREADY <= 0;
					         end

				         else
							begin
								for(int r=0;r<(wr_trans.AWLEN.size());r++)
									begin
										if(AWLEN[r] == 0) //For single write
											begin
												vif.WDATA <= wr_trans.WDATA[r];
												vif.WVALID <= 1;
												vif.WSTRB <= wr_trans.WSTRB[r];
												wait(vif.WREADY == 1);
								             end

										else //For burst write
										  begin
												  vif.WVALID <= 1;
											  for(int f=0;f<AWLEN[r];f++) //For burst write
												begin
													vif.WDATA <= wr_trans.WDATA[(index+f)];
						                            vif.WSTRB <= wr_trans.WSTRB[(index+f)];
													if(f == AWLEN[r])
															vif.WLAST <= 1;

													wait(vif.WREADY == 1);
													@(posedge vif.clk);
						                         end
					                        end
			                             //  vif.wlast <= 1;
										   @(posedge vif.clk);
										   vif.WLAST <= 0;
										   vif.BREADY <= 1;
										if(vif.BVALID == 1)
												   wr_trans.BRESP <= vif.BRESP;

										   @(posedge vif.clk);
										        vif.BREADY <= 0;

								   end
						   end
				   end
		   endtask
   endclass :AXI_WR_DRVR
				
///////////////////////////////////////////////// READ DRIVER ///////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////				
//class: axi_rd_driver
//driver class for read channels
///////////////////////////////////////////////////////////////////////////////////
				
class axi_rd_driver extends axi_master_driver#(axi_master_trans);

//factory registration	
 `uvm_component_utils(axi_rd_driver)

//handle declaration
virtual axi_if vif;

axi_master_trans m_trans;

int num_sent1;

//////constructor//////////

function new(string name="axi_rd_driver",uvm_component parent);
super.new(name,parent);
endfunction

/////////build phase///////////////////
function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 if(!uvm_config_db#(virtual axi_if)::get(this,"","vif",vif))
 `uvm_fatal("NO_VIF",{"virtual interface must be set for:",get_full_name(),".vif"});
	m_trans=axi_master_trans::type_id::create("m_trans",this);
endfunction
	
///////////////////START OF SIMULATION//////////////////
function void start_of_simulation_phase(uvm_phase phase );
 `uvm_info(get_type_name(),{"start of simulation for ",get_full_name()},UVM_LOW)
endfunction



//////////////////RUN PHASE/////////////////////////
task run_phase(uvm_phase phase);
 forever
   begin
	   repeat(5) @(vif.m_drv_cb);
	   if(!vif.m_drv_cb.rst)
           begin      
		   `uvm_info(get_type_name(),"RESET observed in Read Driver",UVM_LOW)
                 vif.m_drv_cb.ARVALID <= 0;   
                 vif.m_drv_cb.ARADDR <= 'bx;   
                 vif.m_drv_cb.ARPROT <= 0;   
                 vif.m_drv_cb.RREADY <= 0;
		 vif.m_drv_cb.ARID <= 0;   
                 vif.m_drv_cb.ARBURST <= 0;   
                 vif.m_drv_cb.ARSIZE <= 0;   
                 vif.m_drv_cb.ARLEN <= 0;
		 vif.m_drv_cb.ARLOCK <= 0;   
                 vif.m_drv_cb.ARCACHE <= 0;
	   end  
         else
          begin

		  seq_item_port.get_next_item(m_trans);  
                          vif.m_drv_cb.ARVALID <= m_trans.ARVALID;  
			
		  if(vif.m_drv_cb.ARREADY && vif.m_drv_cb.ARVALID) 
                         begin
			 vif.m_drv_cb.ARADDR <= m_trans.ARADDR;
    			 vif.m_drv_cb.ARPROT <= m_trans.ARPROT;
			 vif.m_drv_cb.ARID <= m_trans.ARID;
    			 vif.m_drv_cb.ARBURST <= m_trans.ARBURST;
		         vif.m_drv_cb.ARSIZE <= m_trans.ARSIZE;
    			 vif.m_drv_cb.ARLEN <= m_trans.ARLEN;
                         vif.m_drv_cb.ARLOCK <= m_trans.ARLOCK;
			 vif.m_drv_cb.ARCACHE <= m_trans.ARCACHE;
			 
				 
			vif.m_drv_cb.RREADY <= m_trans.RREADY;
	 	
		num_sent1++;
                         end
		seq_item_port.item_done();

          end
  end			
 endtask  
	
endclass : axi_rd_driver
				
//////////////////////////////////////////////////////////////////////////////////////////
`endif


		                                 								   
				  




