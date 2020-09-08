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

`ifndef AXI_SCOREBOARD_INCLUDED_
`define AXI_SCOREBOARD_INCLUDED_

//-----------------------------------------------------------------------------
// Class: axi_scoreboard 
// Description of the class. For ex:
// This class verifies the functionality of axi design which recieves transaction
// level objects captured from interfaces of a DUT via TLM analysis Ports
// (or fifos)
//-----------------------------------------------------------------------------

class axi_scoreboard extends uvm_scoreboard;
   `uvm_component_utils(axi_scoreboard)

    uvm_tlm_analysis_fifo #(write_xtn_master) fifo_master;  // TLM analysis fifo for master
    uvm_tlm_analysis_fifo #(write_xtn_slave) fifo_slave;    // TLM analysis fifo for slave

    write_xtn_master  master_data;                          //Master write Transaction
    write_xtn_slave   slave_data;                           //Slave write Transaction
   
      static int no_of_write_packet;                        //total number of transactions received from write monitor
      static int no_of_read_packet;                         //total number of transactions received from read monitor
      static int no_of_data_verification;                   //total number of data for verification (read + write)
      static int no_of_data_with_success;                   //total number of data verified with success i.e. matching 
      static int no_of_data_with_failure;                   //total number of data verified with failure i.e. not matching 

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the axi_scoreboard class object
//
// Parameters:
//  name - instance name of the axi_scoreboard
//  parent - parent under which this component is created
//-----------------------------------------------------------------------------
	  	
      function new(string name,uvm_component parent);
        super.new(name, parent);

         fifo_master=new("fifo_master",this);
         fifo_slave=new("fifo_slave",this);
      endfunction

//-----------------------------------------------------------------------------
// Task: run_phase
// This is the main task that can consume simulation time in UVM and initiates the main data checking function i.e. check_phase() 
//
// Parameters:
//  phase - stores the current phase 
//-----------------------------------------------------------------------------
        
      task run_phase(uvm_phase phase);
      forever
	 begin
	    fork
	    begin
              fifo_master.get(master_data);
              $display("write_data_receive in sb at time %0t",$time);
              no_of_write_packet++;
	    end

            begin
              fifo_slave.get(slave_data);
              $display("read_data_receive in sb at time %0t",$time);
              no_of_read_packet++;
            end  
	   join
        
           $display("checking*****SB got the wr and rd data at time %0t******......",$time);
           check_phase();
        end
     endtask

//---------------------------------------------------------------------------------
// Function: check_phase()
// This function compares prints master data as well slave data. It further
// checks whether data(s) are matching or not and gives result accordingly.
//
// --------------------------------------------------------------------------------
           
     function void check_phase();

       `uvm_info("scoreboard",$sformatf("wr_moniter at time %0t",$time),UVM_LOW)
	master_data.print;

	`uvm_info("scoreboard",$sformatf("rd_moniter at time %0t",$time),UVM_LOW)
	slave_data.print;
        
        foreach(master_data.MDATA[i])
	begin
	   if(master_data.MDATA[i] != slave_data.WDATA[i])
	   begin
             `uvm_info("axi_scoreboard",$sformatf("DATA mismatch[%0d]",i),UVM_LOW)
              no_of_data_with_failure++;
              no_of_data_verification++;
           end
	   else
           begin
             `uvm_info("axi_scoreboard",$sformatf("DATA match[%0d]",i),UVM_LOW)
              no_of_data_with_success++;
              no_of_data_verification++;
           end
	end


        $display(" ***************************** SCOREBOARD RESULT FOR PACKET *************************************\n");
        $display(" NO OF TRANS RECEIVED FROM WR_MONITOR: %0d ",no_of_write_packet);
        $display(" NO OF TRANS RECEIVED FROM RD_MONITOR: %0d ",no_of_read_packet);
        $display(" TOTAL NO OF DATA VERIFIED : %0d ", no_of_data_verification);
        $display(" TOTAL NO OF DATA VERIFIED WITH SUCCESS: %0d ", no_of_data_with_success);
        $display(" TOTAL NO OF DATA VERIFIED WITH FAILURE: %0d ", no_of_data_with_failure);

     endfunction
endclass

`endif

