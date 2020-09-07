class axi_master_rd_exlsv_seq extends uvm_sequence#(axi_xtn);
   
  `uvm_object_utils (axi_master_rd_exclsv_seq)

//Constructor
  function new(string name = "axi_master_rd_exclsv_seq");
  	  super.new(name);
  endfunction
   
  virtual task body();
   	 `uvm_do_with(req,{req.ARID ==1;  req.ARLOCK==1; req.ARADDR== 32’ffff1001;})
  endtask   
endclass
