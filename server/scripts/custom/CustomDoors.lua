---[[ INSTALLATION:
--1) Save this file as "CustomDoors.lua" in server/scripts/custom
--2) Add   require("custom.CustomDoors")   to customScripts.lua

--how to do stuff

-- use /placeat selection_tool to spawn the tool. 
-- hit a door to select it after typing /copy then go to where you want the destination to be and type /setdoor.
-- /paste will place a copy of whatever object you have selected in front of you. (best to have a decorate script to use this)
-- /removedoor will remove a door that you have re routed but players that have used that door since they logged in will have to relog
-- to clear the destination for them.(figure out if this can be fixed)

local CustomDoors = {}

--table containing all the re routed door uniqueIndexes and destinations
local CreatedDoors = {}

--table containg temporary door info when you select a door with the selection tool
local door_info = {}


--Config--
local cfg = {}

--TODO create a book or /help menu with help info on how to use the script.
--TODO create a method that adds the selection_tool to players inventory on login IF they are an admin AND its not in there already.
--TODO figure out why a player can still use a door that has been removed from the CreatedDoors table with /removedoor command if 
--they used the door before the command was run. relog or cell reset seem to fix it

--just a table of all the doors that are in the realm of doors, no reason for them to be in here really
local VanillaDoors = {

  -- "door_redoran_tower_01", TODO make door with this model to showcase
  -- "ex_colony_bardoor", TODO possibly disabled for ravenrock purposes?
  -- "Ex_colony_door01_1B.NIF",
  -- "Ex_colony_door02_1",
  -- "Ex_colony_door02_2",
  -- "Ex_colony_door02b_2",
  -- "Ex_colony_door03",
  -- "Ex_colony_door03_1_uryn",
  -- "Ex_colony_door03_1",
  -- "Ex_colony_door03_2",
  -- "Ex_colony_door03_4a",
  -- "Ex_colony_door03_4",
  -- "Ex_colony_door04_1",
  -- "Ex_colony_door04_2",
  -- "Ex_colony_door04_2b",
  -- "Ex_colony_door04_3",
  -- "Ex_colony_door04b_3",
  -- "Ex_colony_door04c_3",
  -- "Ex_colony_door05_int_a",
  -- "Ex_colony_door05_int_b",
  -- "Ex_colony_door05_int_c",
  -- "Ex_colony_door05_2",
  -- "Ex_colony_door05a_4",
  -- "Ex_colony_door05b_4",
  -- "Ex_colony_door05c_4",
  -- "Ex_colony_door05_3",
  -- "ex_colony_minedoor",
  "bm_ic_door_01",
  "bm_ic_door_pelt",
  "bm_ic_door_pelt_dark",
  "bm_ka_door",
  "bm_ka_door_dark",
  "BM_mazegate_01",
  "door_cavern_doors00",
  "door_cavern_doors10",
  "door_cavern_doors20",
  "door_dwe_00_exp",
  "door_dwrv_double00",
  "door_dwrv_double01",
  "door_dwrv_inner00",
  "door_dwrv_load00",
  "door_dwrv_loaddown00",
  "door_dwrv_loadup00",
  "door_dwrv_main00",
  "door_sotha_double00",
  "door_sotha_load",
  "door_sotha_pre_load",
  "In_thirsk_door_main_2_b",
  "In_thirsk_door_main_1_b",
  "ex_bm_tomb_door_01",
  "ex_bm_tomb_door_02",
  "ex_bm_tomb_door_03",
  "ex_cave_door_01",
  "Ex_colony_door01.NIF",
  "Ex_colony_door02",
  "Ex_colony_door03 int",
  "Ex_colony_door03_int",
  "Ex_colony_door04",
  "Ex_colony_door05",
  "Ex_colony_door05_int",
  "Ex_colony_door06",
  "Ex_colony_door07",
  "Rent_colony_door",
  "Ex_colony_door08",
  "ex_common_door_01",
  "ex_common_door_balcony",
  "ex_dae_door_load_oval",
  "Ex_DE_ship_cabindoor",
  "ex_de_ship_trapdoor",
  "ex_emp_tower_01_a",
  "ex_emp_tower_01_b",
  "ex_h_trapdoor_01",
  "ex_imp_loaddoor_01",
  "ex_imp_loaddoor_02",
  "ex_imp_loaddoor_03",
  -- "ex_mh_doorjamb_01", TODO make customrecord door to display these
  -- "ex_mh_doorjamb_02",
  "EX_MH_door_02",
  "Ex_MH_Palace_gate",
  "ex_mh_sewer_trapdoor_01",
  "ex_mh_temple_door_01",
  -- "ex_mh_wall_gate_01", TODO investigate mournhold doors
  -- "ex_mh_wall_gate_door",
  -- "ex_mg_pav_gate_door", TODO doesn't spawn for some reason?
  "ex_nord_door_01",
  "ex_nord_door_02",
  "ex_redoran_barracks_door",
  "ex_redoran_hut_01_a",
  "ex_r_trapdoor_01",
  "ex_s_door",
  "ex_s_door_double",
  "ex_s_door_rounded",
  "ex_s_fence_gate",
  "ex_t_door_01",
  "ex_t_door_02",
  "ex_t_door_slavepod_01",
  "ex_t_door_sphere_01",
  "ex_t_door_stone_large",
  "ex_velothicave_door_01",
  "ex_velothicave_door_03",
  "ex_velothi_loaddoor_01",
  "ex_velothi_loaddoor_02",
  "ex_vivec_grate_01",
  "ex_v_cantondoor_01",
  "ex_v_palace_grate_01",
  "ex_v_palace_grate_02",
  "hlaal_loaddoor_01",
  "in_hlaalu_loaddoor_01",
  "hlaalu_loaddoor_ 02",
  "in_hlaalu_loaddoor_02",
  "in_ar_door_01",
  "in_ci_door_01",
  -- "in_colony_door01", TODO couldn't find / won't spawn, the mesh exists its a ravenrock door
  "in_c_door_arched",
  "in_c_door_wood_square",
  "in_dae_door_01",
  "In_DB_door01",
  "in_db_door_oval",
  "in_db_door_oval_02",
  "in_de_ship_cabindoor",
  "in_de_llshipdoor_large",
  "in_de_shipdoor_toplevel",
  "in_hlaalu_door",
  "in_h_trapdoor_01",
  "in_impsmall_door_01",
  "in_impsmall_door_jail_01",
  -- "in_impsmall_door_jail_02",  TODO make customrecord to display door
  "in_impsmall_d_cave_01",
  "in_impsmall_d_hidden_01",
  "in_impsmall_loaddoor_01",
  "in_mh_door_01",
  "in_mh_door_02",
  "in_mh_jaildoor_01",
  "in_mh_trapdoor_01",
  "in_m_sewer_door_01",
  "in_m_sewer_door_broken",
  "in_m_sewer_trapdoor_01",
  "in_om_door_round",
  "in_redoran_barrack_door",
  "in_redoran_hut_door_01",
  "in_r_s_door_01",
  "in_r_trapdoor_01",
  "in_strong_vaultdoor00",
  "in_s_door",
  "in_thirsk_door",
  "in_t_door_small",
  "in_t_door_small_load",
  "in_t_housepod_djamb_exit",
  "in_t_housepod_door_exit",
  "in_t_l_door_01",
  "in_t_s_plain_door",
  "in_velothismall_ndoor_01",
  "in_vivec_grate_01",
  "in_v_s_jaildoor_01",
  "in_v_s_trapdoor_01",
  "in_v_s_trapdoor_02",
  -- "scene root"
}

--Functions--

--TODO make copy/paste commands for creating new doors from the door realm.

local function OnPlayerAuthentifiedHandler(eventStatus, pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		
    	local pname = tes3mp.GetName(pid)

        door_info[pname] = {}
        Players[pid].data.customVariables.isDoorSelectionOn = false
		
	-- check if selection_tool is in players inventory and add it if they are admin and it its not in there
        --local recordStore = RecordStores["weapon"]
        -- for refId, record in pairs(recordStore.data.permanentRecords) do
        --     if  tableHelper.containsValue(Players[pid].data.inventory, "selection_tool", true) then
        --         tes3mp.MessageBox(pid, -1, "")
    end
end

local function SpawnVanillaDoors(pid, cmd)

    local pname = tes3mp.GetName(pid)
    local cell = tes3mp.GetCell(pid)

    local playerAngleZ = tes3mp.GetRotZ(pid)
    local playerAngleX = tes3mp.GetRotX(pid)
    --TODO tweak this for best results when placing objects with /paste command
    local PosX = (100 * math.sin(playerAngleZ) + (tes3mp.GetPosX(pid) - 100))
    local PosY = (100 * math.cos(playerAngleZ) + (tes3mp.GetPosY(pid) + 100))
    local PosZ = (100 * math.sin(-playerAngleX) + (tes3mp.GetPosZ(pid) + 100))

    local location = {
        posX = PosX, posY = PosY, posZ = PosZ,
        rotX = 0, rotY = 0, rotZ = tes3mp.GetRotZ(pid)
    }

    local objectData = dataTableBuilder.BuildObjectData(door_info[pname].refId)

    logicHandler.CreateObjectAtLocation(cell, location, objectData, "place")

    --change decorateScript to whatever you named your global in customScripts when requiring your Decorate Script
    --and uncomment to have object selected in /dh after you place it with /paste

    -- decorateScript.SetSelectedObject(pid, furnRefIndex)

end

local function warpToDoorRealm(pid, cmd)
    tes3mp.SetCell(pid, "realm of doors")
    tes3mp.SendCell(pid)

    tes3mp.SetRot(pid, 0, 0)
    tes3mp.SetPos(pid, 0, 0, 1517)
    tes3mp.SendPos(pid)
end

local function setDoorSelectionState(pid, cmd)
    Players[pid].data.customVariables.isDoorSelectionOn = true
    tes3mp.SendMessage(pid, color.Silver .. "Door Selection Mode is now on.\n")
end

local function saveCustomDoors()
    jsonInterface.save("custom/CustomDoors.json", CreatedDoors)
end

local function loadCustomDoors()
    CreatedDoors = jsonInterface.load("custom/CustomDoors.json")
end

function removeDoor(pid, cmd)
    local pname = tes3mp.GetName(pid)

    local uniqueIndex = tostring( door_info[pname].refNum .. "-" ..  door_info[pname].mpNum)
    CreatedDoors[tostring(uniqueIndex)] = nil
    saveCustomDoors()
end

local function CreateCustomDoorsJson()
    if jsonInterface.load("custom/CustomDoors.json") ~= nil then
        loadCustomDoors()
        tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "CreatedDoors.json was loaded into server memory.")
    else
	saveCustomDoors()
        tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "CreatedDoors.json was created.")
    end
end

CreateCustomDoorsJson()

--Methods--

CustomDoors.OnServerPostInitHandler = function()

    local cellRecordstore = RecordStores["cell"]

    if cellRecordstore.data.permanentRecords["realm of doors"] == nil then
        cellRecordstore.data.permanentRecords["realm of doors"] = {

            name = "Realm of Doors",
            baseId = "Seyda Neen, Foryn Gilnith's Shack"

        }
        cellRecordstore:Save()
        tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "Realm of Doors was created.")
    else
        tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "Realm of doors already existed.")
    end

    local weaponRecordStore = RecordStores["weapon"]

    if weaponRecordStore.data.permanentRecords["selection_tool"] == nil then
        weaponRecordStore.data.permanentRecords["selection_tool"] = {

            name = "Door Selection Tool",
            subtype = 0,
            value = 666,
            weight = 0,
            icon  = "m\\tx_skeleton_key.tga",
            model = "m\\Skeleton_key.NIF",
            health = -1,
            speed = 2,
            reach = 999,
            damageThrust = {
              min = 666,
              max = 666
            }
        }
        weaponRecordStore:Save()
        tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "Selection Tool was created.")
    else
        tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "Selection Tool already existed.")
    end
end

CustomDoors.get_door_info = function(eventStatus, pid, cellDescription, objects, targetPlayers)

    local pname = tes3mp.GetName(pid)

    if tes3mp.HasItemEquipped(pid, "selection_tool") then

        if Players[pid].data.customVariables.isDoorSelectionOn then
            -- if the hittingPid is not your own then return
            if not tableHelper.containsKeyValue(objects, "hittingPid", pid, true) then
                return customEventHooks.makeEventStatus(false, false)
            end

            local RefId = tes3mp.GetObjectRefId(0)
            local MpNum = tes3mp.GetObjectMpNum(0)
            local RefNum = tes3mp.GetObjectRefNum(0)

            door_info[pname].refId = RefId
            door_info[pname].mpNum = MpNum
            door_info[pname].refNum = RefNum

            tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. " door_info[pname].refId: " .. tostring( door_info[pname].refId))
            tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. " door_info[pname].refNum: " .. tostring( door_info[pname].refNum))
            tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. " door_info[pname].mpNum: " .. tostring( door_info[pname].mpNum))

            tes3mp.SendMessage(pid, color.Silver .. "You have selected " .. color.LimeGreen .. tostring(RefId) .. "\n")
            logicHandler.RunConsoleCommandOnObject(pid, "ExplodeSpell, Shield", cellDescription, tostring(RefNum .. "-" .. MpNum), false)
            logicHandler.RunConsoleCommandOnPlayer(pid, 'PlaySound, "book page2"', false)
            tes3mp.SendMessage(pid, color.Silver .. "Use the " .. color.LimeGreen .. "/paste " .. color.Silver .. "command to create a new door at your current location.\n")
            tes3mp.SendMessage(pid, color.Silver .. "Use the " .. color.LimeGreen .. "/setdoor " .. color.Silver .. "command to set the destination of " ..
            color.LimeGreen .. tostring(RefNum) .. "-" .. tostring(MpNum) .. color.Silver .. "to your current location.\n")

            Players[pid].data.customVariables.isDoorSelectionOn = false
            return customEventHooks.makeEventStatus(false, false)

        else

            tes3mp.SendMessage(pid, color.Silver .. "Initiate door selection with the " .. color.LimeGreen .. "/copy " .. color.Silver .. "command\n")
            return customEventHooks.makeEventStatus(false, false)

        end
    end
end

CustomDoors.set_door_destination = function(pid, cmd)

    local cellDescription = tes3mp.GetCell(pid)
    local pname = tes3mp.GetName(pid)

    door_info[pname].DestinationCell = cellDescription

    local px = tes3mp.GetPosX(pid)
    local py = tes3mp.GetPosY(pid)
    local pz = tes3mp.GetPosZ(pid)
    local rx = tes3mp.GetRotX(pid)
    local rz = tes3mp.GetRotZ(pid)

    door_info[pname].position = {px, py, pz}
    door_info[pname].rotation = {z = rz, x = rx}

    tes3mp.SetObjectRefId( door_info[pname].refId)
    tes3mp.SetObjectRefNum( door_info[pname].refNum)
    tes3mp.SetObjectMpNum( door_info[pname].mpNum)
    local uniqueIndex = tostring( door_info[pname].refNum .. "-" ..  door_info[pname].mpNum)

    CreatedDoors[uniqueIndex] = {
        refId =  door_info[pname].refId,
        position =  door_info[pname].position,
        rotation =  door_info[pname].rotation,
        DestinationCell =  door_info[pname].DestinationCell
    }

    tes3mp.SendMessage(pid, "Door destination was set for " ..  door_info[pname].refId .. ": " ..  door_info[pname].refNum .. "-" ..  door_info[pname].mpNum)
    -- tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "CreatedDoors[uniqueIndex].refId" .. tostring(CreatedDoors[uniqueIndex].refId))

    saveCustomDoors()
end

CustomDoors.load_doordestination_packets = function(eventStatus, pid, cellDescription, objects, targetPlayers)

    local cellDescription = tes3mp.GetCell(pid)
    --tableHelper.print(CreatedDoors)
    for uniqueIndex, door in pairs(CreatedDoors) do

        for objectUniqueIndex, object in pairs(objects) do
            -- if uniqueIndex from the CreatedDoors table == the current object being activated's uniqueIndex then do the sutuff. else do nothing.
            if objectUniqueIndex == uniqueIndex then
                --tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "CreatedDoors uniqueIndex: " .. tostring(uniqueIndex))
                --tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "objectUniqueIndex: " .. tostring(objectUniqueIndex))

                local splitIndex = uniqueIndex:split("-")

                tes3mp.ClearObjectList()
                tes3mp.SetObjectListPid(pid)
                tes3mp.SetObjectListCell(cellDescription)
                tes3mp.SetObjectRefId(door.refId)
                tes3mp.SetObjectRefNum(splitIndex[1])
                tes3mp.SetObjectMpNum(splitIndex[2])
                tes3mp.SetObjectDoorTeleportState(true)
                --tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "door.DestinationCell: " .. tostring(door.DestinationCell))
                tes3mp.SetObjectDoorDestinationCell(door.DestinationCell)
                tes3mp.SetObjectDoorDestinationPosition(door.position[1], door.position[2], door.position[3])
                tes3mp.SetObjectDoorDestinationRotation(door.rotation.x, door.rotation.z)
                tes3mp.AddObject()

                tes3mp.SendDoorState(false)
                tes3mp.SendDoorDestination(false)

                --tes3mp.LogAppend(enumerations.log.INFO, "------------------------- " .. "load_doordestination_packets has ran")
            end
        end
    end
end

--events--
customCommandHooks.registerCommand("paste", SpawnVanillaDoors)
customCommandHooks.registerCommand("copy", setDoorSelectionState)
customCommandHooks.registerCommand("setdoor", CustomDoors.set_door_destination)
customCommandHooks.registerCommand("removedoor", removeDoor)
customCommandHooks.registerCommand("realmofdoors", warpToDoorRealm)

customCommandHooks.setRankRequirement("copy", 2)
customCommandHooks.setRankRequirement("paste", 2)
customCommandHooks.setRankRequirement("setdoor", 2)
customCommandHooks.setRankRequirement("removeDoor", 2)
customCommandHooks.setRankRequirement("realmofdoors", 2)

customEventHooks.registerValidator("OnObjectHit", CustomDoors.get_door_info)

customEventHooks.registerHandler("OnObjectActivate", CustomDoors.load_doordestination_packets)
customEventHooks.registerHandler("OnServerPostInit", CustomDoors.OnServerPostInitHandler)
customEventHooks.registerHandler("OnPlayerAuthentified", OnPlayerAuthentifiedHandler)

return CustomDoors
