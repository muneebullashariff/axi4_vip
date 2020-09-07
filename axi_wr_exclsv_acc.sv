class axi_master_wr_exclsv_seq extends uvm_sequence#(axi_xtn);
   
  `uvm_object_utils (axi_master_wr_exclsv_seq)
   
  function new(string name = "axi_master_wr_exclsv_seq");
    	super.new(name);
  endfunction
   
  virtual task body();
   	 `uvm_do_with(req,{req.AWID ==1;  req.AWLOCK==1; req.AWADDR== 32’ffff1001;})
  endtask
   
endclass
