-- Author      : ketch
-- Create Date : 11/22/2020 9:11:30 AM

local addonname, NSCom = ...
local _G = getfenv(0)
local NS_MyWishList =_G.NS_MyWishList

local table, tinsert, tremove, pairs, ipairs, unpack, math, tostring, tonumber, select, _G, strlen, setmetatable, string, print, next, type, rawget, date = 
	  table, tinsert, tremove, pairs, ipairs, unpack, math, tostring, tonumber, select, _G, strlen, setmetatable, string, print, next, type, rawget, date
local SendAddonMessage, SendChatMessage, UnitIsRaidOfficer, UnitIsUnit, UnitIsGroupLeader, GetMasterLootCandidate, GetNumLootItems, GetLootSlotLink, GiveMasterLoot, UnitName, GetUnitName, CreateFrame, GetCVar, GetCVarBool, GetTime, StaticPopup_Show, GetItemInfo, GameTooltip, LibStub, ITEM_QUALITY_COLORS, InCombatLockdown, ERR_TRADE_COMPLETE, GetPlayerTradeMoney, GetTargetTradeMoney, GetItemIcon, ClearCursor, GetNumGroupMembers, GetRaidRosterInfo, GetLootThreshold, GetLootSlotType, GetLootSlotInfo, EditBox_HandleTabbing, GetCursorInfo, PickupItem, IsInRaid, IsInGroup, SendMail, SetSendMailMoney, ClearSendMail =
	  SendAddonMessage, SendChatMessage, UnitIsRaidOfficer, UnitIsUnit, UnitIsGroupLeader, GetMasterLootCandidate, GetNumLootItems, GetLootSlotLink, GiveMasterLoot, UnitName, GetUnitName, CreateFrame, GetCVar, GetCVarBool, GetTime, StaticPopup_Show, GetItemInfo, GameTooltip, LibStub, ITEM_QUALITY_COLORS, InCombatLockdown, ERR_TRADE_COMPLETE, GetPlayerTradeMoney, GetTargetTradeMoney, GetItemIcon, ClearCursor, GetNumGroupMembers, GetRaidRosterInfo, GetLootThreshold, GetLootSlotType, GetLootSlotInfo, EditBox_HandleTabbing, GetCursorInfo, PickupItem, IsInRaid, IsInGroup, SendMail, SetSendMailMoney, ClearSendMail
local _
local UIParent, MailFrame = UIParent, MailFrame

function NS_MyWishList:getItemId(itemlink)--todo update
    --print(itemlink)
    if itemlink  then
        local _, _, _, _, Id, _, _, _, _, _, _, _, _, Name = string.find(itemlink,"|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
        return Id
    end
    return -1
end
function NS_MyWishList.tableMerge(t1, t2)
    if not t1 then return t2 end
    if not t2 then return t1 end
    if not t1 and not t2 then return nil end
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                NS_MyWishList.tableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

function NS_MyWishList.try(f, catch_f)
    local status, exception = pcall(f)
    if not status then
        catch_f(exception)
    end
end
---- Function to remove RealmName
function NS_MyWishList:RemoveRealmPName(playerName)
    --print(playerName)
    return string.gsub(playerName, "(.*)%-.*$", "%1", 1)
end

function NS_MyWishList:IsRaidOfficer()
	return IsInRaid() and UnitIsRaidOfficer("player")
end

function NS_MyWishList:IsRaidLeader()
	return IsInRaid() and UnitIsGroupLeader("player")
end

function NS_MyWishList:LootSlotIsItem(i)
	return (GetLootSlotType(i) == 1)
end

function NS_MyWishList:round(num, places)
	return tonumber(string.format("%."..(places or 0).."f",num))
end

function NS_MyWishList:CreateGuid()
  local random = math.random;
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx';

  return string.gsub(template, '[xy]', function (c)
      local v = (c == 'x') and random(0, 0xf) or random(8, 0xb);
      return string.format('%x', v);
  end);
end