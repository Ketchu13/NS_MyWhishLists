-- Author      : ketch
-- Create Date : 12/1/2020 7:10:22 PM


local addonname, NS_MyWishList = ...
local _G = getfenv(0)
local NS_MyWishList =_G.NS_MyWishList
local function getLocationText()
    local subZoneText = GetSubZoneText()
    local zoneText = GetZoneText()
    if (subZoneText == "") then
        locationText = zoneText
    else
        locationText = format("%s - %s", zoneText, subZoneText)
    end
    return locationText
end
function NS_MyWishList:getPlayerPositionText(isWorldMap)
    local posText, crdsText, posX, posY
    local crdsTextTemplate = "%%.%df,%%.%df"
    local acc = isWorldMap

    local uiMapID = C_Map.GetBestMapForUnit("player")
    local posXY = nil
    if (uiMapID) then
        posXY = C_Map.GetPlayerMapPosition(uiMapID, "player") or nil
    end

    crdsText = crdsTextTemplate:format(acc, acc)

    if ( IsInInstance() ) then
        posX = 0
        posY = 0
    elseif (posXY) then
        posX, posY = posXY:GetXY()
    end
    --local loctext = getLocationText()
    --if not loctext then
    --    loctext = getLocationText()
    --    loctext = " "
    --end
    --if not loctext then
    --    loctext = " "
    --end
    --posText = loctext..","..(posX and posX*100 or 0)..","..(posY and posY*100 or 0)
    --print(posText)
    local location = {}
       -- location.text = loctext
        location.posx = posX and posX*100 or 0
        location.posy = posY and posY*100 or 0
        location.uiMapID = uiMapID
    NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].location = location
    return NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].location
end