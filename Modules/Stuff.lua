-- Author      : ketch
-- Create Date : 12/1/2020 6:59:41 PM


local addonname, NS_MyWishList = ...
local _G = getfenv(0)
local NS_MyWishList =_G.NS_MyWishList

--scan Stuff
function  NS_MyWishList:getUserStuff()
    NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].stuff = {}
    for invSlot = 0, 24 do
        local item = {} 
        item.Id = GetInventoryItemID("player", invSlot);
        if not item.Id or item.Id == 0 then
            item.Id = -1
        end
        item.slot = invSlot
        tinsert(NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].stuff, item)
    end
    return NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].stuff
end