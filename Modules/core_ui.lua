-- Author      : ketch
-- Create Date : 3/17/2020 11:58:22 AM
local addonname, NS_MyWishList = ...
local _G = getfenv(0)
local NS_MyWishList =_G.NS_MyWishList

local LibDialog = LibStub("LibDialog-1.0")
local lwin = LibStub("LibWindow-1.1")


--NS_MyWishList.framelootsurvey_count = 0
local getn, PlaySound, GuildRoster = table.getn, PlaySound, GuildRoster

-- UI
function NS_MyWishList:HideAll()
    
    if NS_MyWishList.frameVAbout then
        NS_MyWishList.frameVAbout:Hide()
    end

    if NS_MyWishList.frameVersionsLogs then
        NS_MyWishList.frameVersionsLogs:Hide()
    end
    
    if NS_MyWishList.currentWlTabIL then
        NS_MyWishList.currentWlTabIL:Hide()
    end
    if NS_MyWishList.currentWlTabMWL then
        NS_MyWishList.currentWlTabMWL:Hide()
    end
    if NS_MyWishList.frame_talents then
        NS_MyWishList.frame_talents:HideDpD()
    end
    if NS_MyWishList.SourisGif then
        NS_MyWishList.SourisGif:Hide()
        NS_MyWishList.SourisGif.sourisGif:Hide()
        NS_MyWishList.SourisGif.TabAboutHtml:Hide()
    end
    if NS_MyWishList.frameTabStuff then
        NS_MyWishList.frameTabStuff:Hide()
    end
    if NS_MyWishList.ExportMyWL then
        NS_MyWishList.ExportMyWL:Hide()
    end
end
--Tabs Menu
function NS_MyWishList.SelectGroup(container, event, group)
    container:ReleaseChildren()
    -- todo factorise
    NS_MyWishList:HideAll()
    local target_id = 0
    if group == "tab1" then
        target_id = 409        
    elseif group == "tab2" then
        target_id = 249
    elseif group == "tab3" then
        target_id = 469
    elseif group == "tab4" then
        target_id = 309
    elseif group == "tab5" then
        target_id = 509
    elseif group == "tab6" then
        target_id = 531
    elseif group == "tab7" then
        target_id = 533
    elseif group == "tab8" then
        NS_MyWishList.ExportMyWL = NS_MyWishList:DrawExportMyWLTabs(container)-- DrawTabBank5(container)
    elseif group == "tab9" then
        NS_MyWishList.SourisGif = NS_MyWishList:DrawSourisGif(container)-- DrawTabBank5(container)
    end
    if target_id > 0 then 
        NS_MyWishList.currentWlTabIL = NS_MyWishList:DrawItemsList(container, target_id)
        NS_MyWishList:fillInstanceItems(NS_MyWishList.currentWlTabIL, target_id)
        NS_MyWishList.currentWlTabMWL = NS_MyWishList:DrawMyWL(container, target_id)
        NS_MyWishList:fillMyWishList(target_id)
    end
end
--SHOW
function NS_MyWishList:Show()
    NS_MyWishList.frame = NS_MyWishList.AceGUI:Create("FrameExt2",addonname.."_MainFrameName")
    NS_MyWishList.frame:SetTitle(NS_MyWishList.versionName)
    NS_MyWishList.frame:SetCallback("OnClose", function(widget) 
        NS_MyWishList.frame:Hide()
    end)
    -- Fill Layout - the TabGroup widget will fill the whole frame
    NS_MyWishList.frame:SetLayout("Fill")
    NS_MyWishList.frame:Show()
    NS_MyWishList.frame:SetWidth(970)
    NS_MyWishList.frame:SetHeight(500)
    -- Create the TabGroup
    local tab = NS_MyWishList.AceGUI:Create("TabGroup")
    tab:SetLayout("Flow")
    -- Setup which tabs to show
    tab:SetTabs({
        { text = "Molten Core"    , value = "tab1" },
        { text = "Onyxia"      , value = "tab2" },
        { text = "Blackwing Lair"         , value = "tab3" },
        { text = "Zul'Gurub"       , value = "tab4" },
        { text = "Ahn Quiraj 20"        , value = "tab5" },
        { text = "Ahn Quiraj 40"      , value = "tab6" },
        { text = "Naxxramas"      , value = "tab7" },
        { text = "Export"      , value = "tab8" },
        { text = "Options"        , value = "tab9" }
    })
    -- Register callback
    tab:SetCallback("OnGroupSelected", NS_MyWishList.SelectGroup)
    -- Set initial Tab (this will fire the OnGroupSelected callback)
    tab:SelectTab("tab1")
    -- add to the frame container
    NS_MyWishList.frame:AddChild(tab)
    NS_MyWishList.MainTabGroup = tab
    NS_MyWishList.frame:SetCallback("OnEvent", NS_MyWishList.OnEvent)
    _G[addonname.."_MainFrameName"] = NS_MyWishList.frame.frame--todo
    tinsert(UISpecialFrames,addonname.."_MainFrameName");
end
