class axi_scoreboard extends uvm_scoreboard;
   `uvm_component_utils(axi_scoreboard)

    uvm_tlm_analysis_fifo #(write_xtn_master) fifo_master;
    uvm_tlm_analysis_fifo #(write_xtn_slave) fifo_slave;

    write_xtn_master  master_data;
    write_xtn_slave   slave_data; 
   
      static int no_of_write_packet;
      static int no_of_read_packet;
      static int no_of_data_verification; 
      static int no_of_data_with_success;
      static int no_of_data_with_failure;

	  	
      function new(string name,uvm_component parent);
        super.new(name, parent);

         fifo_master=new("fifo_master",this);
         fifo_slave=new("fifo_slave",this);
      endfunction

        
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
        $display(" NO OF TRANS RECEIVED FORM WR_MONITOR: %0d ",no_of_write_packet);
        $display(" NO OF TRANS RECEIVED FROM RD_MONITOR: %0d ",no_of_read_packet);
        $display(" TOTAL NO OF DATA VERIFIED : %0d ", no_of_data_verification);
        $display(" TOTAL NO OF DATA VERIFIED WITH SUCCESS: %0d ", no_of_data_with_success);
        $display(" TOTAL NO OF DATA VERIFIED WITH FAILURE: %0d ", no_of_data_with_failure);

     endfunction
endclass

