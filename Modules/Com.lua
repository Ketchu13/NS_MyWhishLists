-- Author      : ketch
-- Create Date : 12/1/2020 6:46:10 PM


local addonname, NS_MyWishList = ...
local _G = getfenv(0)
local NS_MyWishList =_G.NS_MyWishList

local LibCompress = LibStub("LibCompress")
local LibEncode = LibCompress:GetAddonEncodeTable()
local libS = LibStub("AceSerializer-3.0")
local commPrefix = NS_MyWishList.commPrefix

---=====================================================---
function NS_MyWishList:OnCommReceive(prefix, data, distribution, sender)
    if sender == UnitName("player") then
        return  --     skip player
    end
    local command, target_, value = data:match("^(%S+) (%w+) (.*)$")
    if not target_ then
        command, value = data:match("^(%S+) (.*)$")
    end
--    if command == "MYWL"  then

--        if target_ == "" or target_ == nil then --or target_ == UnitName("player") then
--            return
--        end
--        target_ = tonumber(target_)
--        local deserialized_data = NS_MyWishList:decodeData(value,sender,command,target_)
--        if deserialized_data then
--            if not NS_MyWishList_Data_001["receivedWLS"] then
--                NS_MyWishList_Data_001["receivedWLS"] = {}
--            end
--            if not NS_MyWishList_Data_001["receivedWLS"][sender] then
--                NS_MyWishList_Data_001["receivedWLS"][sender] = {}
--            end
--            if not NS_MyWishList_Data_001["receivedWLS"][sender][target_] then
--                NS_MyWishList_Data_001["receivedWLS"][sender][target_] = {}
--            end
--            NS_MyWishList_Data_001["receivedWLS"][sender][target_] = deserialized_data
--        end
--        return
--    elseif command == "MYINFOS"  then
--        local deserialized_data = NS_MyWishList:decodeData(value,sender,command)--:decodeData(value,sender,command,target_)--
--        if deserialized_data then
--            if not NS_MyWishList_Data_001["receivedUsers"] then
--                NS_MyWishList_Data_001["receivedUsers"] = {}
--            end
--            if not NS_MyWishList_Data_001["receivedUsers"][sender] then
--                NS_MyWishList_Data_001["receivedUsers"][sender] = {}
--            end
--            NS_MyWishList_Data_001["receivedUsers"][sender].infos = deserialized_data
--        end
--        return
--    elseif command == "MYTALENTS"  then
--        local deserialized_data = NS_MyWishList:decodeData(value,sender,command)--:decodeData(value,sender,command,target_)--
--        if deserialized_data then
--            if not NS_MyWishList_Data_001["receivedUsers"] then
--                NS_MyWishList_Data_001["receivedUsers"] = {}
--            end
--            if not NS_MyWishList_Data_001["receivedUsers"][sender] then
--                NS_MyWishList_Data_001["receivedUsers"][sender] = {}
--            end
--            NS_MyWishList_Data_001["receivedUsers"][sender].Talents = deserialized_data
--        end
--        return
--    elseif command == "MYSTUFF"  then
--        local deserialized_data = NS_MyWishList:decodeData(value,sender,command)--:decodeData(value,sender,command,target_)--
--        if deserialized_data then
--            if not NS_MyWishList_Data_001["receivedUsers"] then
--                NS_MyWishList_Data_001["receivedUsers"] = {}
--            end
--            if not NS_MyWishList_Data_001["receivedUsers"][sender] then
--                NS_MyWishList_Data_001["receivedUsers"][sender] = {}
--            end
--            NS_MyWishList_Data_001["receivedUsers"][sender].stuff = deserialized_data
--        end
--    elseif command == "MYLOCATION"  then
--        local deserialized_data = NS_MyWishList:decodeData(value,sender,command)--:decodeData(value,sender,command,target_)--
--        if deserialized_data then
--            if not NS_MyWishList_Data_001["receivedUsers"] then
--                NS_MyWishList_Data_001["receivedUsers"] = {}
--            end
--            if not NS_MyWishList_Data_001["receivedUsers"][sender] then
--                NS_MyWishList_Data_001["receivedUsers"][sender] = {}
--            end
--            NS_MyWishList_Data_001["receivedUsers"][sender].location = deserialized_data
--        end
--        return
--    elseif command == "MYFACTIONS"  then
--        local deserialized_data = NS_MyWishList:decodeData(value,sender,command)--:decodeData(value,sender,command,target_)--
--        if deserialized_data then
--            if not NS_MyWishList_Data_001["receivedUsers"] then
--                NS_MyWishList_Data_001["receivedUsers"] = {}
--            end
--            if not NS_MyWishList_Data_001["receivedUsers"][sender] then
--                NS_MyWishList_Data_001["receivedUsers"][sender] = {}
--            end
--            NS_MyWishList_Data_001["receivedUsers"][sender].factions = deserialized_data
--        end
--        return
--    elseif command == "MYWORKS"  then
--        local deserialized_data = NS_MyWishList:decodeData(value,sender,command)--:decodeData(value,sender,command,target_)--
--        if deserialized_data then
--            if not NS_MyWishList_Data_001["receivedUsers"] then
--                NS_MyWishList_Data_001["receivedUsers"] = {}
--            end
--            if not NS_MyWishList_Data_001["receivedUsers"][sender] then
--                NS_MyWishList_Data_001["receivedUsers"][sender] = {}
--            end
--            NS_MyWishList_Data_001["receivedUsers"][sender].works = deserialized_data
--        end
--        return
    if command == "LOCK" then
        local deserialized_data = NS_MyWishList:decodeData(value,sender,command,target_)
        if deserialized_data then
            if not NS_MyWishList_Data_001["locked_instances"] then
                NS_MyWishList_Data_001["locked_instances"] = {}
            end
            NS_MyWishList_Data_001["locked_instances"] = deserialized_data
            NS_MyWishList:LockUnlockWLs()
        end
        return
    elseif command == "VERSION" then
        local deserialized_data = NS_MyWishList:decodeData(value,sender,command)
        if deserialized_data then
            if not NS_MyWishList_Data_001["clients_versions"] then
                NS_MyWishList_Data_001["clients_versions"] = {}
            end
            NS_MyWishList_Data_001["clients_versions"][sender] = deserialized_data
            NS_MyWishList:newVersionAvailable()
        end
        return
    end
end
---=====================================================---
function isToLock(target)
    if not NS_MyWishList_Data_001["locked_instances"][target] then
        return false
    else
        if NS_MyWishList_Data_001["locked_instances"][target] == true then
            return true
        else
            return false
        end
    end
    return false
end
function NS_MyWishList:LockUnlockWLs()
    for instance_id,instance in pairs(NS_MyWishList.Instances) do
        if isToLock(instance_id) then
            if _G[addonname.."save_button_"..instance_id] then 
                _G[addonname.."save_button_"..instance_id]:Disable()
            end
        else
            if _G[addonname.."save_button_"..instance_id] then 
                _G[addonname.."save_button_"..instance_id]:Enable()
            end
        end
    end
end
---=====================================================---
function NS_MyWishList:decodeData(data, sender, command, target)
    local decoded_data = LibEncode:Decode(data)
    local decompressed_data, decompression_error = LibCompress:Decompress(decoded_data)
    if not target then
        target = "NA"
    end
    if not decompressed_data then
        --if  NS_MyWishList_Data_001.displayError.hide then
            NS_MyWishList:Print("decompression error: "..decompression_error.." from: "..sender.." cmd: "..command.." tgt: "..target)
        --end
        return data
    end
    local success, deserialized_data = libS:Deserialize(decompressed_data)
    if not success then
        --if  NS_MyWishList_Data_001.displayError.hide then
            NS_MyWishList:Print("deserialization error: "..deserialized_data.." from: "..sender.." cmd: "..command)
        --end
        return data
    end
    return deserialized_data
end
---=====================================================---
function NS_MyWishList:broadcast(msg, skip_yell)
    if (GetGuildInfo("player") ~= nil) then
        NS_MyWishList:SendCommMessage(commPrefix, msg, "GUILD","BULK");
    elseif (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance()) then
        NS_MyWishList:SendCommMessage(commPrefix, msg, "INSTANCE_CHAT");
    elseif (IsInRaid()) then
        NS_MyWishList:SendCommMessage(commPrefix, msg, "RAID");
    elseif (not skip_yell) then
        NS_MyWishList:SendCommMessage(commPrefix, msg, "YELL");
    else
        if (UnitName("player") == "Føcus") then -- debug
            NS_MyWishList:SendCommMessage(commPrefix, msg, "WHISPER","Føcus","BULK");
        else
            local targetName = UnitName("target");
            if targetName then 
                NS_MyWishList:SendCommMessage(commPrefix, msg, "WHISPER", targetName,"BULK");
            end
        end
    end
end
---=====================================================---
function NS_MyWishList:SendSerialized(msg_prefix, data)
    local serialized_data = libS:Serialize(data)--NS_MyWishList_Data_001["WL_allowed_broadcasters"]
    local compressed_data = LibCompress:Compress(serialized_data)
    local transmit_data = LibEncode:Encode(compressed_data)
    -- Construct a comm string for the compressed data.
    local commString = msg_prefix.." "..transmit_data
    NS_MyWishList:broadcast(commString, true);
end
---=====================================================---
--VERSION
function NS_MyWishList:broadcast_Version()
    local client = NS_MyWishList:GetClientVersion()
    if client then
        NS_MyWishList:SendSerialized("VERSION", client)
    end
end
--MY TOON INFOS
function NS_MyWishList:broadcast_MyInfos()
    local myinfos = NS_MyWishList:getPlayerInfos()
    if myinfos then
        NS_MyWishList:SendSerialized("MYINFOS", myinfos)
    end
end
--MY COMPS
function NS_MyWishList:broadcast_MyComps()
    local mycomps = NS_MyWishList:scanTalents()
    if mycomps then
       -- NS_MyWishList:SendSerialized("MYTALENTS", mycomps)
    end
end
--MY WORKS
function NS_MyWishList:broadcast_MyWorks()
    local myworks = NS_MyWishList:scanTalents()
    if myworks then
       -- NS_MyWishList:SendSerialized("MYWORKS", myworks)
    end
end
--MY STUFF
function NS_MyWishList:broadcast_MyStuff()
    local stuff = NS_MyWishList:getUserStuff()
    if stuff then
        NS_MyWishList:SendSerialized("MYSTUFF", stuff)
    end
end
--MY TALENTS
function NS_MyWishList:broadcast_MyTalents()
    local talents = NS_MyWishList:scanTalents()
    if talents then
        NS_MyWishList:SendSerialized("MYTALENTS", talents)
    end
end
--LOCATION
function NS_MyWishList:broadcast_MyLocation()
    local location = NS_MyWishList:getPlayerPositionText()
    if location then
        NS_MyWishList:SendSerialized("MYLOCATION", location)
    end
end
--WLs
function NS_MyWishList:broadcast_MyWLS()
    local mywls = NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"]
    if mywls then
        NS_MyWishList:SendSerialized("MYWLS", mywls)
    end
end
function NS_MyWishList:broadcast_MyWL(instance_id)
    local mywl = NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]
    if mywl then
        NS_MyWishList:SendSerialized("MYWL "..instance_id, mywl)
    end
end
--FACTIONS
function NS_MyWishList:broadcast_Factions()
    local factions
    if factions then
        NS_MyWishList:SendSerialized("MYFACTIONS", factions)
    end
end
---=====================================================---