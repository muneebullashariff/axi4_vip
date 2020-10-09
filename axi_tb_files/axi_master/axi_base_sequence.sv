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

`ifndef AXI_BASE_SEQ_INCLUDED_
`define AXI_BASE_SEQ_INCLUDED_

//------------------------------------------------------------------------------
// Class: axi_base_sequence
// Description of class. For ex:
// This class is a base sequence class for axi which generates a series of sequence item(s).
// It is parameterized with axi_seq_item, this defines the type of the item that sequence 
// will send/receive to/from the driver. 
// -----------------------------------------------------------------------------

class axi_base_sequence extends uvm_sequence#(axi_master_trans);
  
  `uvm_object_utils(axi_base_sequence)

  bit [31:0] exclsv_addr;
//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the axi_base_sequence class object
//
// Parameters:
//  name - instance name of the axi_base_sequence
//-----------------------------------------------------------------------------
    
  function new(string name = "axi_base_sequence");
    super.new(name);
  endfunction

/*
//------------------------------------------------------------------------------
// Method: body()  
// body method defines, what the sequence does.
//------------------------------------------------------------------------------
   
  virtual task body();
    
    req = axi_master_trans::type_id::create("req");
 
    wait_for_grant();
    req.randomize();
    send_request(req);
    wait_for_item_done();
  endtask
*/

endclass : axi_base_sequence

//********************************* WRITE SEQUENCE **************************************************//


//`ifndef AXI_WRITE_SEQ_INCLUDED_
//`define AXI_WRITE_SEQ_INCLUDED_

//------------------------------------------------------------------------------
// Class: axi_write_sequence
// Description of class. For ex:
// This class is a write sequence class for axi which generates a series of sequence 
// item(s) for write channel.
// It is extended from axi_base_sequence that will send/receive to/from the driver. 
// 
// -----------------------------------------------------------------------------

class axi_write_sequence extends axi_base_sequence;
  
  `uvm_object_utils(axi_write_sequence)
 
//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the axi_base_sequence class object
//
// Parameters:
//  name - instance name of the axi_base_sequence
//-----------------------------------------------------------------------------
 
  function new(string name = "axi_write_sequence");
    super.new(name);
  endfunction


//------------------------------------------------------------------------------
// Method: body()  
// body method defines, what the sequence does.
//------------------------------------------------------------------------------

  virtual task body();    
    req = axi_master_trans::type_id::create("req");
    
    `uvm_do_with(req,{req.AWVALID == 1; req.WVALID == 1; req.BREADY == 1;})

  endtask

endclass:axi_write_sequence

//********************************* READ SEQUENCE **************************************************//

//------------------------------------------------------------------------------
// Class: axi_read_sequence
// Description of class. For ex:
// This class is a read sequence class for axi which generates a series of sequence 
// item(s) for read channel.
// It is extended from axi_base_sequence that will send/receive to/from the driver. 
// -----------------------------------------------------------------------------

class axi_read_sequence extends axi_base_sequence;
  
  `uvm_object_utils(axi_read_sequence)
 
//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the axi_base_sequence class object
//
// Parameters:
//  name - instance name of the axi_base_sequence
//-----------------------------------------------------------------------------
 
  function new(string name = "axi_read_sequence");
    super.new(name);
  endfunction


//------------------------------------------------------------------------------
// Method: body()  
// body method defines, what the sequence does.
//------------------------------------------------------------------------------

  virtual task body();    
    req = axi_master_trans::type_id::create("req");
    
    `uvm_do_with(req,{req.ARVALID == 1; req.RREADY == 1;})

  endtask

endclass:axi_read_sequence


//******************** EXCLUSIVE WRITE ACCESS ***************************//

//-------------------------------------------------------
//Class: axi_master_wr_exclsv_seq
//-------------------------------------------------------
class axi_master_wr_exclsv_seq extends axi_base_sequence;
 
//Factory Registration  
  `uvm_object_utils (axi_master_wr_exclsv_seq)

//Constructor   
  function new(string name = "axi_master_wr_exclsv_seq");
    	super.new(name);
  endfunction

//Body method  
  virtual task body();
   	req = axi_master_trans::type_id::create("req");
   `uvm_do_with(req,{req.AWID == 1; req.AWLOCK == 1; req.AWADDR == exclsv_addr;})
  endtask
   
endclass:axi_master_wr_exclsv_seq


//******************** EXCLUSIVE READ ACCESS ***************************//

//-------------------------------------------------------
//Class: axi_master_rd_exclsv_seq
//-------------------------------------------------------

//Exclusive Read sequence 
class axi_master_rd_exclsv_seq extends axi_base_sequence;

//Factory Registration   
  `uvm_object_utils (axi_master_rd_exclsv_seq)

//Constructor  
  function new(string name = "axi_master_rd_exclsv_seq");
    	super.new(name);
  endfunction
   
//Body method  
  virtual task body();
   	req = axi_master_trans::type_id::create("req");
    `uvm_do_with(req,{req.ARID == 1; req.ARLOCK == 1; req.ARADDR == exclsv_addr;})
  endtask
   
endclass:axi_master_rd_exclsv_seq

/////////////////////////////////////////////////////////////////////////////////
`endif

