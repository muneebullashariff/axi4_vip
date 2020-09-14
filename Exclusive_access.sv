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

//Base sequence consisting variables to store values 
class axi_exclsv_base_seq uvm_sequence#(axi_xtn);

 bit [31:0] exclsv_addr;

//Factory registration	
	`uvm_object_utils (axi_exclsv_base_seq)
	
//Constructor	
	function new(string name = "axi_exclsv_base_seq");
    	super.new(name);
	endfunction
	
endclass


//Exclusive Write sequence 
class axi_master_wr_exclsv_seq extends axi_exclsv_base_seq;
 
//Factory Registration  
  `uvm_object_utils (axi_master_wr_exclsv_seq)

//Constructor   
  function new(string name = "axi_master_wr_exclsv_seq");
    	super.new(name);
  endfunction

//Body method  
  virtual task body();
   	 `uvm_do_with(req,{req.AWID == 1; req.AWLOCK == 1; req.AWADDR == exclsv_addr;})
  endtask
   
endclass

//Exclusive Read sequence 
class axi_master_rd_exclsv_seq extends axi_exclsv_base_seq;

//Factory Registration   
  `uvm_object_utils (axi_master_rd_exclsv_seq)

//Constructor  
  function new(string name = "axi_master_rd_exclsv_seq");
    	super.new(name);
  endfunction
   
//Body method  
  virtual task body();
   	 `uvm_do_with(req,{req.ARID == 1; req.ARLOCK == 1; req.ARADDR == exclsv_addr;})
  endtask
   
endclass

