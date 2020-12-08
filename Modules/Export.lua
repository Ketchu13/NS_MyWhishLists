-- Author      : ketch
-- Create Date : 12/5/2020 8:43:32 PM


local addonname, NS_MyWishList = ...
local _G = getfenv(0)
local NS_MyWishList =_G.NS_MyWishList


local LibCompress = LibStub("LibCompress")
local LibEncode = LibCompress:GetAddonEncodeTable()
local libS = LibStub("AceSerializer-3.0")
local clr_lines = {
    r =0.2,
    g = 0.2,
    b = 0.2,
    a = 0.2
}
local drk_lines = {
    r =0.4,
    g = 0.4,
    b = 0.4,
    a = 0.2
}
NS_MyWishList.backdrop1 = {
    bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
    edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
    insets = { left = 4, right = 3, top = 4, bottom = 3 }
}
local FrameBackdrop = {
    bgFile = "Interface\\AddOns\\NS_MyWishList\\Images\\dsf", -- "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = false,
    tileSize = 32,
    edgeSize = 32,
    borderColor = {1, 0, 0},
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
}
local function Button_OnClick(frame)
    PlaySound(799) -- SOUNDKIT.GS_TITLE_OPTION_EXIT
    frame:GetParent():Hide()
end

local function Frame_OnShow(frame)
   -- frame.obj:Fire("OnShow")
end

local function Frame_OnMouseDown(frame)
    NS_MyWishList.AceGUI:ClearFocus()
end

local function Title_OnMouseDown(frame)
    frame:GetParent():StartMoving()
    NS_MyWishList.AceGUI:ClearFocus()
end
local function Button_OnClick(frame)
    PlaySound(799) -- SOUNDKIT.GS_TITLE_OPTION_EXIT
    frame:GetParent():Hide()
    frame:Hide()
end
local function MoverSizer_OnMouseUp(mover)
    local frame = mover:GetParent()
    frame:StopMovingOrSizing()
end
function formatTimeColor(time_)
    local minutes,secondes = time_:match("([0-9]+)\:([0-9]+)");
    minutes = tonumber(minutes)
    secondes = tonumber(secondes)

    --math.random(); math.random(); math.random()
    --minutes = math.random(0,20)
    --secondes = math.random(0,59)
    local to_return;

    color_str = "|cff9999ff"

    if minutes <= 10 then
        color_str = "|cff55ff55"
    end
    if minutes <= 5 then
        color_str = "|cffff8200"
    end
    if minutes <= 1 then
        color_str = "|cffff5555"
    end
    minutes = string.format("%02d",minutes);
    secondes = string.format("%02d",secondes);
    to_return = color_str..minutes..":"..secondes.."|r"

    return to_return or time_
end
local function applyBackground(target)
    local background = CreateFrame("Frame", nil, target:GetParent())
        background:SetBackdrop(NS_MyWishList.backdrop1)
        background:SetBackdropColor(0, 0, 0)
        background:SetBackdropBorderColor(0.4, 0.4, 0.4)
        background:SetPoint("TOPLEFT", target, "TOPLEFT", -10, 10)
        background:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", -20, -5)
    return background
end
local function applyBackgrounduni(target)
    local background = CreateFrame("Frame", nil, target:GetParent())
        background:SetBackdrop(NS_MyWishList.backdrop1)
        background:SetBackdropColor(0, 0, 0)
        background:SetBackdropBorderColor(0.4, 0.4, 0.4)
        background:SetPoint("TOPLEFT", target, "TOPLEFT", -5, 2)
        background:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", 5, -4)
    return background
end

--CreateChatTabsFrame
function NS_MyWishList:DrawExportMyWLTabs(container, target_id)
    local exportFrame = CreateFrame("Frame",addonname.."_exportFrame", container.content)
    exportFrame:SetSize(605,350);
    exportFrame:SetPoint("TOPLEFT",0,-17)
    exportFrame:SetToplevel(true);

    local c = NS_MyWishList.drk_lines
    local labelTitle = exportFrame:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
        labelTitle:SetPoint("TOPLEFT", 5,0)
        labelTitle:SetPoint("TOPRIGHT",-5,0)
        labelTitle:SetJustifyH("CENTER")
        labelTitle:SetJustifyV("MIDDLE")
        labelTitle:SetText("Compessed data - Use Ctrl + C for copy")
        labelTitle:SetHeight(19)
        local highlight1h = exportFrame:CreateTexture(nil, "HIGHLIGHT")
        highlight1h:SetAllPoints(labelTitle)
        highlight1h:SetColorTexture(0.5, 0.5, 0.9, 0.8)
        highlight1h:SetBlendMode("ADD")
        local highlight1bgh = exportFrame:CreateTexture(nil, "BACKGROUND")
        highlight1bgh:SetAllPoints(labelTitle)
        highlight1bgh:SetColorTexture(c.r, c.g, c.b, c.a)
        highlight1bgh:SetBlendMode("ADD")

    local backdrop1 = {
        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
        edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    }
    -- ScrollingMessageFrame
    local scrollMotherFrame = CreateFrame("Frame", addonname.."_exportFrame_ScrollMotherFrame", exportFrame)
    scrollMotherFrame:SetPoint("TOPLEFT", 0, -25)
    scrollMotherFrame:SetPoint("BOTTOMRIGHT", 0, 30)
    scrollMotherFrame:SetBackdrop(backdrop1)
    scrollMotherFrame:SetBackdropColor(0, 0, 0,0.5)
    scrollMotherFrame:SetBackdropBorderColor(0.8, 0, 0.8)

    local scrollFrame = CreateFrame("ScrollFrame", addonname.."_exportFrame_ScrollFrame", scrollMotherFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 5, -8)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 5)
    scrollFrame:EnableMouseWheel(true)
    scrollFrame:EnableMouse(true)

    local scrollbg2 = scrollFrame:CreateTexture(nil, "BACKGROUND")
    scrollbg2:SetAllPoints(scrollFrame.ScrollBar)
    scrollbg2:SetColorTexture(0, 0, 0, 0.9)

    exportFrame.cnt = CreateFrame("Frame", addonname.."_exportFrame_cnt", scrollFrame)
    exportFrame.cnt:SetPoint("TOPLEFT",scrollMotherFrame, "TOPLEFT", 0, 0)
    exportFrame.cnt:SetWidth(550)
    exportFrame.cnt:SetHeight(300)

    local TxtBox = CreateFrame("EditBox", addonname.."_TxtBox", exportFrame.cnt)
        TxtBox:SetPoint("TOPLEFT",exportFrame.cnt,"TOPLEFT", 5, -5)
        TxtBox:SetHeight(300)
        TxtBox:SetWidth(550)
        TxtBox:SetFont('Fonts\\ARIALN.ttf', 14, 'THINOUTLINE')
        TxtBox:SetFontObject(ChatFontNormal)
        TxtBox:SetMultiLine(true)
        TxtBox:EnableMouse(true)
        TxtBox:SetAutoFocus(false)
        TxtBox:SetCountInvisibleLetters(false)

    if not NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"] then 
        NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"] = {}
    end
    local serialized_data = libS:Serialize(NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"])
    local table_str = "{\n"
    table_str = table_str.."    \"name\": \""..NS_MyWishList.player_name.."\",\n"
    table_str = table_str.."    \"class\": \""..NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].infos.classe.englishClass.."\",\n"
    table_str = table_str.."    \"race\": \""..NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].infos.race.."\",\n"
    table_str = table_str.."    \"level\": "..NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].infos.level..",\n"

    table_str = table_str.."    \"stuff\": [\n"
    for _,item in pairs(NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name].stuff) do
        if not item["Id"] then
            NS_MyWishList:getUserStuff()
            NS_MyWishList.SelectGroup(container, nil, "tab8")
            return
        end
        if item["Id"] > 1 and item["slot"] > 0 then
            table_str = table_str.."        {\n"
            table_str = table_str.."            \"id\": "..item["Id"]..",\n"
            table_str = table_str.."            \"slot\": "..item["slot"].."\n"
            table_str = table_str.."        },\n"
        end
    end
    table_str = table_str.sub(table_str,1, #table_str-2).."\n"
    table_str = table_str.."    ],\n"
    table_str = table_str.."    \"wls\": [\n"
    for instance_id,v in pairs(NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"]) do
        table_str = table_str.."        {\n"
        table_str = table_str.."            \"id\": "..instance_id..",\n"
        table_str = table_str.."            \"items\": {\n"
        for k1,v1 in pairs(NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]) do
            table_str = table_str.."                \""..k1.."\": "..v1..",\n"
        end
        table_str = table_str.sub(table_str, 1,#table_str-2).."\n"
        table_str = table_str.."            }\n"
        table_str = table_str.."        },\n"
    end
    table_str = table_str.sub(table_str,1, #table_str-2).."\n"
    table_str = table_str.."    ]\n"
    table_str = table_str.."}\n"

    local input_compressed = NS_MyWishList:Compress(table_str)
    local printable_com_input = NS_MyWishList:PrintCompressed(input_compressed)
    TxtBox:SetText(printable_com_input)
    local com_input = NS_MyWishList:RecompressPrintable(printable_com_input)
    local decom_input = NS_MyWishList:Decompress(com_input)
    TxtBox:SetText(TxtBox:GetText().."\n"..decom_input)
    scrollFrame:SetScrollChild(exportFrame.cnt)

    return exportFrame
end