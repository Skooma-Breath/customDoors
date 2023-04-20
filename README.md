# customDoors
Download and place the server folder into your tes3mp directory.
 
Add   require("custom.CustomDoors")   to server/scripts/customScripts.lua

--how to do stuff

-- use `/placeat selection_tool` to spawn the tool.

-- hit a door to select it after typing `/copy` then go to where you want the destination to be and type `/setdoor`.

-- `/paste` will place a copy of whatever object you have selected in front of you. (best to have a decorate script to use this)

-- `/removedoor` will remove a door that you have re routed but players that have used that door since they logged in will have to relog
   to clear the destination for them.(figure out if this can be fixed)
   
-- `/realmofdoors` will teleport you to the realm of doors   
