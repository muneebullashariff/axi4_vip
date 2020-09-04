 class axi_seq_item extends uvm_sequence_item;
  
  `uvm_object_utils(axi_seq_item)

  function new(string name = "axi_seq_item");
    super.new(name);
  endfunction
  
  rand bit [3:0]                  AWID ;
  rand bit [31:0]                 AWADDR;
  rand bit [3:0]                  AWLEN;
  rand bit [2:0]                  AWSIZE;
  rand bit [1:0]                  AWBURST;
  rand bit [1:0]                  AWLOCK;
  rand bit [3:0]                  AWCHACHE;
  rand bit [2:0]                  AWPROT;
  
  rand bit [3:0]                  WID;
  rand bit [31:0]                 WDATA[];
  rand bit [3:0]                  WSTRB[];
   
  rand bit [3:0]                  ARID;
  rand bit [31:0]                 ARADDR;
  rand bit [3:0]                  ARLEN;
  rand bit [2:0]                  ARSIZE;
  rand bit [1:0]                  ARBURST;
  rand bit [1:0]                  ARLOCK;
  rand bit [3:0]                  ARCACHE;
  rand bit [2:0]                  ARPROT;
  
  bit [3:0]                       BID;
  bit [1:0]                       BRESP;
  bit [3:0]                       RID;
  bit [1:0]                       RRESP;
  
  constraint write_address_id_c {
    soft AWID == WID;
  }
  
  constraint write_address_c {    
    soft AWBURST inside {[0:2]};
    soft AWADDR inside {[0:4095]};
    soft WDATA.size() == AWLEN+1;
    if (AWBURST == 2) {
      soft AWLEN inside {2, 4, 8, 16};
      if (AWSIZE == 1) {
        soft AWADDR[0] == 1'b0;
      } else if (AWSIZE == 2) {
        soft AWADDR[1:0] == 2'b0;
      } else if (AWSIZE == 3) {
        soft AWADDR[2:0] == 3'b0;
      } else if (AWSIZE == 4) {
        soft AWADDR[3:0] == 4'b0;
      } else if (AWSIZE == 5) {
        soft AWADDR[4:0] == 5'b0;
      } else if (AWSIZE == 6) {
        soft AWADDR[5:0] == 6'b0;
      } else if (AWSIZE == 7) {
        soft AWADDR[6:0] == 7'b0;
      }
    }

    solve AWBUSRT before AWLEN;
    solve AWBUSRT before AWADDR;
    solve AWLEN before WDATA;
    solve AWLEN before WSTRB;
  }
        
  constraint read_address_c {    
    ARBURST inside {[0:2]};
    ARADDR inside {[0:4095]};
    if (ARBURST == 2) {
      ARLEN inside {2, 4, 8, 16};
      if (ARSIZE == 1) {
        ARADDR[0] == 1'b0;
      } else if (ARSIZE == 2) {
        ARADDR[1:0] == 2'b0;
      } else if (ARSIZE == 3) {
        ARADDR[2:0] == 3'b0;
      } else if (ARSIZE == 4) {
        ARADDR[3:0] == 4'b0;
      } else if (ARSIZE == 5) {
        ARADDR[4:0] == 5'b0;
      } else if (ARSIZE == 6) {
        ARADDR[5:0] == 6'b0;
      } else if (ARSIZE == 7) {
        ARADDR[6:0] == 7'b0;
      }
    }
  }
        
  constraint write_address_cache_c {
    soft (AWCACHE != 4 && AWCACHE != 5 && AWCACHE != 8 && AWCACHE != 9 && AWCACHE != 12 && AWCACHE != 13);  //As per Table A4-5 Memory type encoding
  }
  
  constraint read_address_cache_c {
    soft (ARCACHE!= 4 && ARCACHE != 5 && ARCACHE != 8 && ARCACHE != 9 && ARCACHE != 12 && ARCACHE != 13);   //As per Table A4-5 Memory type encoding
  }
          
  function post_randomize();
      int i, j;
      WDATA = new[AWLEN+1];
      WSTRB = new[AWLEN+1];
      foreach (WDATA[i]) begin
        WDATA[i] = $urandom_range(((2**(8*(AWSIZE+1)))-1), 0);
      end

      foreach (WSTRB[j]) begin
        WSTRB[j] = $urandom_range(((2**(AWSIZE+1))-1), 0);
      end      
  endfunction
      
endclass

//***********************************************************************************//

class axi_base_sequence extends uvm_sequence#(axi_seq_item);
  
  `uvm_object_utils(axi_sequence)
    
  function new(string name = "axi_sequence");
    super.new(name);
  endfunction
   
  virtual task body();
    
    req = axi_seq_item::type_id::create("req");
 
    wait_for_grant();
    req.randomize();
    send_request(req);
    wait_for_item_done();
  endtask
  
endclass

class axi_write_sequence extends axi_base_sequence;
  
  `uvm_object_utils(axi_write_sequence)
  
  function new(string name = "axi_write_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    int cmd;
    
    req = axi_seq_item::type_id::create("req");
    if ($value$plusargs("CMD=%0d",cmd)) begin
    end else begin
      cmd = 10;
    end
    for (int i = 0; i < cmd; i ++) begin
      wait_for_grant();
      req.randomize();
      send_request(req);
      wait_for_item_done();
    end
  endtask
  
endclass
