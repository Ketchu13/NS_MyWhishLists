-- Author      : ketch
-- Create Date : 12/1/2020 6:59:41 PM


local addonname, NS_MyWishList = ...
local _G = getfenv(0)
local NS_MyWishList =_G.NS_MyWishList

--scan Stuff
function  NS_MyWishList:getUserStuff()
    NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].stuff = {}
    for invSlot = 0, 24 do
        local itemid = GetInventoryItemID("player", invSlot);
        if not itemid or itemid == 0 then
            itemid = -1
        end
        NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].stuff[invSlot] = itemid
    end
    return NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].stuff
end