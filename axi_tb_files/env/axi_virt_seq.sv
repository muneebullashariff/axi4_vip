
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

//Virtual Sequence base class
class axi_virtual_seq_base extends uvm_sequence #(axi_seq_item);
	
//Factory Registration
	`uvm_object_utils(axi_virtual_seq_base)
	
	bit addr [31:0];
	axi_master_wr_exclsv_seq wr_exclsv_seq;
	axi_master_rd_exclsv_seq rd_exclsv_seq;
	axi_virtual_sequencer v_seqr;
	axi_master_sequencer mstr_sqr;
	axi_slave_sequencer slv_sqr;

//Constructor
	
	function new(string name = "axi_virtual_seq_base");
    	super.new(name);
	endfunction

//Body Method
	
	task body();

		if(!$cast(v_seqr, m_sequencer))
			begin
				`uvm_error (get_full_name(), "CASTING FAILED");
				end
		mstr_sqr = v_seqr.mstr_vseqr_h;
		slv_sqr = v_seqr.slv_vseqr_h;
	
	endtask
endclass


//Sequence 1 : Exclusive read followed by Exclusive write 
class exclsv_rd_wr_vseq extends axi_virtual_seq_base;

//Factory Registration
	`uvm_object_utils (exclsv_rd_wr_vseq)
		
//Constructor	
	function new(string name = "exclsv_rd_wr_vseq");
    	super.new(name);
	endfunction
	
//Body method	
	virtual task body();
		`uvm_info (get_type_name(), "********Exclusive Read followed by Exclusive Write started********", UVM_LOW)
		
		`uvm_do_on (rd_exclsv_seq, master_seqr)
		 addr = rd_exclsv_seq.exclsv_addr;
		`uvm_do_on_with (wr_exclsv_seq, master_seqr,{exclsv_addr == addr;})
		
		`uvm_info (get_type_name(), "*******Exclusive Read followed by Exclusive Write ended********", UVM_LOW)

	endtask
endclass


//Scenario 2 : Exclusive read followed by Normal write	
class exclsv_rd_normal_wr_vseq extends axi_virtual_seq_base;

//Factory Registration
	`uvm_object_utils (exclsv_rd_normal_wr_vseq)
		
//Constructor	
	function new(string name = "exclsv_rd_normal_wr_vseq");
    	super.new(name);
	endfunction
	
//Body method	
	virtual task body();
		`uvm_info (get_type_name(), "********Exclusive Read followed by Normal Write started********", UVM_LOW)
		
		`uvm_do_on (rd_exclsv_seq, master_seqr)
		 addr = rd_exclsv_seq.exclsv_addr;
		`uvm_do_on_with (wr_seq, master_seqr,{exclsv_addr == addr;}) //To be fixed by normal write sequence
		
		`uvm_info (get_type_name(), "*******Exclusive Read followed by Normal Write ended********", UVM_LOW)

	endtask	
endclass
