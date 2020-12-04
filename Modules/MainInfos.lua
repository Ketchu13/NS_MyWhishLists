-- Author      : ketch
-- Create Date : 12/1/2020 7:16:01 PM


local addonname, NS_MyWishList = ...
local _G = getfenv(0)
local NS_MyWishList =_G.NS_MyWishList

function NS_MyWishList:getPlayerInfos()
    NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].infos = {}
    local localizedClass, englishClass, classIndex                                         = UnitClass("player");
    NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].infos.name                  = NS_MyWishList.player_name;
    NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].infos.race                  = UnitRace("player");
    NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].infos.level                 = UnitLevel("player");
    NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].infos.classe                = {}
    NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].infos.classe.englishClass   = englishClass
    NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].infos.classe.localizedClass = localizedClass
    NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].infos.classe.classIndex     = classIndex
    return NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].infos
end
