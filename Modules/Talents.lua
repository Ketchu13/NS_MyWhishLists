-- Author      : ketch
-- Create Date : 12/1/2020 6:39:43 PM


local addonname, NS_MyWishList = ...
local _G = getfenv(0)
local NS_MyWishList =_G.NS_MyWishList

--scan Talents
function NS_MyWishList:scanTalents()
    local trees = {}
    local numTabs = GetNumTalentTabs()
    for t = 1, numTabs do
        local tree = {}    
        tree.id, tree.name, tree.description, tree.iconTexture, tree.pointsSpent, tree.background = GetTalentTabInfo(t)
        tree.talents  = {}
        local numTalents = GetNumTalents(t)
        for i = 1, numTalents do
            local talent = {}
            talent.name, talent.iconTexture, talent.row, talent.column, talent.rank, talent.maxRank, _, talent.available = GetTalentInfo(t, i)
            if not G then
                G = LibStub("LibGratuity-3.0")
            end
            local n = 0
            while (n<2) do
                G:SetTalent(t, i, inspect)
                n = G:NumLines()        
                talent.tips = G:GetLine(n)
            end
            tinsert(tree.talents, talent)
        end
        tinsert(trees, tree)
    end
    NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].Talents =  trees
    return NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].Talents
end

