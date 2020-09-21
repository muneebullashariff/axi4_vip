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

`ifndef AXI_MASTER_AGENT_CONFIG_INCLUDED
`define AXI_MASTER_AGENT_CONFIG_INCLUDED

//-----------------------------------------------------------------------------
// Class: master_agent_config
// Description of the class
// configures the agent as active or passive
//------------------------------------------------------------------------------

class axi_master_agent_config extends uvm_object;

//factory registration
 `uvm_object_utils(axi_master_agent_config)

//declaring agent is active or passive
 uvm_active_passive_enum is_active=UVM_ACTIVE;

//declare handles for virtual interface
   virtual axi_if vif;

//---------------------------------------------
// Externally defined tasks and functions
//---------------------------------------------
extern function new(string name = "axi_master_agent_config"); 

endclass: axi_master_agent_config

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the master_agent_config class component
//
// Parameters:
//  name - instance name of the config
//-----------------------------------------------------------------------------

 function axi_master_agent_config::new(string name="axi_master_agent_config");
       super.new(name);
 endfunction:new

//-----------------------------------------------------------------------------
`endif

