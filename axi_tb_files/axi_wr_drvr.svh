class axi_wr_drvr extends uvm_driver #(axi_wr_trans);
		`uvm_component_utils(axi_wr_drvr)

		//axi_wr_trans wr_trans;
		virtual axi_intf vif;

		function new(string name = "axi_wr_drvr",uvm_component parent = null);
				super.new(name,parent);
		endfunction

		virtual function void build_phase(uvm_phase phase);
		 begin
				 if((!uvm_config_db #(virtual axi_intf)::get(this," ","vif",vif)))
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

		virtual task wr_drive(axi_wr_trans wr_trans);
			begin
					fork
							addr_ch(wr_trans); //Task to drive address on address channel
							data_ch(wr_trans); //Task to drive data on write data channel
					join_none
			end
	endtask

	virtual task addr_ch(axi_wr_trans wr_trans); //Task to drive address on address channel
		begin
				@(posedge vif.clk);
					begin
							if(!vif.reset) //reset condition
							begin
									vif.awaddr <= 0;
									vif.awvalid <= 0;
									vif.awsize <= 0;
									vif.awlen <= 0;
									vif.awburst <= 0;
									vif.awcache <= 0;
									vif.awid <= 0;
									vif.awlock <= 0;
							end
							
							else
								begin
									for(int r=0;r<(wr_trans.awlen.size());r++)
										begin
											vif.awaddr <= wr_trans.awaddr[r];
										    vif.awvalid <= 1;
										    vif.awsize <= wr_trans.awsize;
										    vif.awlen <= wr_trans.awlen[r];
										    vif.awburst <= wr_trans.awburst;
										    vif.awcache <= wr_trans.awcache;
										    vif.awid <= wr_trans.awid[r];
										    vif.awlock <= wr_trans.awlock;
										  wait(vif.awready == 1);
										  @(posedge vif.clk);
									    end
								   end
						   end
				   end
		   endtask

        virtual task data_ch(axi_wr_trans wr_trans); //Task to drive write data on data channel
			begin
					@(posedge vif.clk);
			          begin
						if(!vif.reset) //reset condition
							begin
								vif.wdata <= 0;
					            vif.wvalid <= 0;
								vif.wstrb <= 0;
					            vif.wlast <= 0;
					            vif.bready <= 0;
					         end

				         else
							begin
								for(int r=0;r<(wr_trans.awlen.size());r++)
									begin
										if(awlen[r] == 0) //For single write
											begin
												vif.wdata <= wr_trans.wdata[r];
												vif.wvalid <= 1;
												vif.wstrb <= wr_trans.wstrb[r];
												wait(vif.wready == 1);
								             end

										else //For burst write
										  begin
												  vif.wvalid <= 1;
											for(int f=0;f<awlen[r];f++) //For burst write
												begin
													vif.wdata <= wr_trans.wdata[(index+f)];
						                            vif.wstrb <= wr_trans.wstrb[(index+f)];
													if(f == awlen[r])
															vif.wlast <= 1;

													wait(vif.wready == 1);
													@(posedge vif.clk);
						                         end
					                        end
			                             //  vif.wlast <= 1;
										   @(posedge vif.clk);
										   vif.wlast <= 0;
										   vif.bready <= 1;
										   if(vif.bvalid == 1)
												   wr_trans.bresp <= vif.bresp;

										   @(posedge vif.clk);
										        vif.bready <= 0;

								   end
						   end
				   end
		   endtask
   endclass
		                                 								   
				  




