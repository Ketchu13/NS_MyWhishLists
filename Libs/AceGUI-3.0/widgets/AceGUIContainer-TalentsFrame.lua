--[[-----------------------------------------------------------------------------
Frame Container
-------------------------------------------------------------------------------]]
local Type, Version = "TalentsFrame", 26
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs, assert, type = pairs, assert, type
local wipe = table.wipe

-- WoW APIs
local PlaySound = PlaySound
local CreateFrame, UIParent = CreateFrame, UIParent
local users_infos
local GREEN_FONT_COLOR = GREEN_FONT_COLOR
local GREY_FONT_COLOR = GRAY_FONT_COLOR
local ICON_SPACE = 13
local ICON_WIDTH = 48
local TAB_SIZE_X = 257
local TAB_SIZE_Y = 450
local TOP_TALENT_FRAME_OFFSET = 32
local dropdown
-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: CLOSE

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]

local function Frame_OnShow(frame)
    frame.obj:Fire("OnShow")
end

local function Frame_OnClose(frame)
    frame.obj:Fire("OnClose")

end
local function CloseButton_OnClick(self)
    self:GetParent().obj:SetDDMenu(users_infos)
    if dropdown then
        dropdown:Close()
        dropdown = nil
    end
    dropdown = AceGUI:Create("Dropdown-Pullout")
    local header = AceGUI:Create("Dropdown-Item-Header")
    header:SetText("Raideurs")
    dropdown:AddItem(header)
    for user in pairs(users_infos) do 
        local btn1 = AceGUI:Create("Dropdown-Item-Execute")
        btn1:SetText(user)
        btn1:SetCallback("OnClick", function() 
            self:GetParent().obj:Hide()--ReleaseChildren()
            self:GetParent().obj:SetUser(users_infos[user], user) 
            dropdown:Close()
        end)
        dropdown:AddItem(btn1)
    end        
    dropdown:Open("TOP", self, "BOTTOM", 0, 5)
end
local function Frame_OnMouseDown(frame)
    AceGUI:ClearFocus()
end

local function Title_OnMouseDown(frame)
    frame:GetParent():StartMoving()
    AceGUI:ClearFocus()
end

local function offset(row, column)
    return (column) * ICON_SPACE + (column-1) * ICON_WIDTH, - (15 + (row) * ICON_SPACE + (row-1)* ICON_WIDTH)
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
    ["OnAcquire"] = function(self)
        self.frame:SetFrameStrata("FULLSCREEN_DIALOG")
        self:Show()
    end,

    ["OnRelease"] = function(self)
    
    end,

    ["Hide"] = function(self)
        self.frame:Hide()
    end,
    ["HideDpD"] = function(self)
        if dropdown then dropdown:Close() end
    end,

    ["SetMinSize"] = function(self, width, height)
        self.frame:SetMinResize(width, height)        
    end,

    ["SetHeight"] = function(self, height)
        self.frame:SetHeight(height)
    end,

    ["GetHeight"] = function(self, height)
        return self.frame:GetHeight()
    end,

    ["SetWidth"] = function(self, width)
        self.frame:SetWidth(width)        
    end,

    ["Show"] = function(self)
        self.frame:Show()
    end,

    ["SetUser"] = function(self, user, user_name)
        --Print(user)
        local trees = user.Talents
        local class = user.classe.englishClass
        self.content:Hide()
        self.content = CreateFrame("Frame", nil, self.frame)
        self.content:SetPoint("TOPLEFT", 5, 0)
        self.content:SetPoint("BOTTOMRIGHT", -5,0)
        self.content:Show()
        self.close.text(self, user_name)
        for tab, tree in ipairs(trees) do
            --request create tab view
            --create tab view
            local frameTab = CreateFrame("Frame", nil, self.content)
            frameTab:SetPoint("TOPLEFT", (tab-1) * TAB_SIZE_X, -TOP_TALENT_FRAME_OFFSET)
            frameTab:SetSize(TAB_SIZE_X,TAB_SIZE_Y-10)
            local pre_str = { string.match(tree.iconTexture, "([A-Z].*)([A-Z].*)")}
            local bg_file =  string.lower(table.concat(pre_str,"-"))
            --NS_WishLists:Print(bg_file)
            local backdrop = {
                bgFile = "Interface\\TALENTFRAME\\bg-"..bg_file,
            
                insets = { left = 0, right = 0, top = 0, bottom = -186 }
            }
            frameTab:SetBackdrop(backdrop)


            local fs = frameTab:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            fs:SetPoint("TOP", 0, -4)
            fs:SetJustifyH("CENTER")
            fs:SetText(tree.id)
            fs:SetHeight(12)
            frameTab.name = fs

            local overlay = CreateFrame("Frame", nil, frameTab)
            overlay:SetAllPoints(frameTab)

            frameTab.overlay = overlay
            frameTab:Show()

            frameTab.tab = tab
            frameTab.name = tree.name

            --add all icon of all talents of this tree
            for index, talent in ipairs(tree.talents) do
                --create new buton for this talent
                local button = NS_WishLists:MakeButton(frameTab)
                button.id = index
                button.iconid = talent.iconTexture
                button.icon = talent.iconTexture 
                button:SetPoint("TOPLEFT", offset(talent.row, talent.column))
                button.texture:SetTexture(talent.iconTexture)
                button:Show()
                button:SetScript("OnEnter", function()
                    PlaySoundFile("Sound/Interface/Iuiinterfacebuttona.Ogg");
                    GameTooltip:SetOwner(button, "ANCHOR_CURSOR");
                    GameTooltip:ClearLines();
                    GameTooltip:AddLine(talent.name,1,1,1);
                    GameTooltip:AddLine(talent.rank.."/"..talent.maxRank,0,1,0,1);
                    GameTooltip:AddLine(talent.tips,1,1,0,1);
                    GameTooltip:Show()                
                    
                    -- GameTooltip:SetItemByID(item.itemid);
                end)
                button:SetScript("OnLeave", function() GameTooltip:Hide() end)

                --rank
                local color = GREEN_FONT_COLOR
                button.rank:Show()
                button.rank.texture:Show()
                button.rank:SetText(talent.rank)
                local desatured = false
                if talent.rank == 0 then
                    color = GREY_FONT_COLOR
                    desatured = true
                end
                button.texture:SetDesaturated(desatured)
                button.slot:SetVertexColor(color.r, color.g, color.b)
                button.rank:SetVertexColor(color.r, color.g, color.b)
            end        
        end
    end,

    ["SetDDMenu"] = function(self, users)
        users_infos = users
        
    end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]


local function Constructor()
    local CreateTexture = (function (base, layer, path, blend)
        local t = base:CreateTexture(nil, layer)
        if path then t:SetTexture(path) end
        if blend then t:SetBlendMode(blend)    end
        return t
    end)
    local frame = CreateFrame("Frame", "NS_WishListsTalentFrame", UIParent)
    
    frame:SetFrameStrata("FULLSCREEN_DIALOG")
    frame:EnableMouse(true)
    frame:SetToplevel(true)
    frame:SetSize(3 * TAB_SIZE_X + 60, TAB_SIZE_Y+28)
    frame:SetBackdrop({
        bgFile = "Interface\\TutorialFrame\\TutorialFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        edgeSize = 16,
        tileSize = 32,
        insets = {
            left = 5,
            right = 5,
            top = 5,
            bottom = 5
        }
    })
    frame:SetBackdropColor(1,1,1,1)
    local close = CreateFrame("Frame", nil, frame)    
    

    --close:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    close:SetScript("OnMouseUp", function(self)
        CloseButton_OnClick(self)
    end)
    close:SetSize(130, 26)
    local tleft = close:CreateTexture(nil, "BACKGROUND")
    tleft:SetSize(25,64) -- Interface\\Buttons\\UI-CheckBox-Highlight
    tleft:SetPoint("TOPLEFT", -18,18)
    tleft:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
    tleft:SetTexCoord(0, 0.1953125, 0, 1)
    local tmid = close:CreateTexture(nil, "BACKGROUND")
    tmid:SetSize(115,64) -- Interface\\Buttons\\UI-CheckBox-Highlight
    tmid:SetPoint("LEFT", tleft, "RIGHT")
    tmid:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
    tmid:SetTexCoord(0.1953125, 0.8046875, 0, 1)
    local tright = close:CreateTexture(nil, "BACKGROUND")
    tright:SetSize(25,64) -- Interface\\Buttons\\UI-CheckBox-Highlight
    tright:SetPoint("LEFT", tmid, "RIGHT")
    tright:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
    tright:SetTexCoord(0.8046875, 1, 0, 1)
    local dropmenu_str = close:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    dropmenu_str:SetSize(135,10)
    dropmenu_str:SetPoint("RIGHT",tright, -43, 2)
    close.text = (function (self, value) dropmenu_str:SetText(value) end)
    close.text(self,"Raideurs")
    close:SetScript('OnMouseDown', CloseButton_OnClick)
    close:SetPoint("TOPLEFT", 5,-5)
    
    local points =     frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    points:SetJustifyH("RIGHT")
    points:SetSize(80, 14)
    points:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -40, -6)
    frame.points = points

    
    
    frame:Show()

    --Container Support
    local content = CreateFrame("Frame", nil, frame)
    content:SetPoint("TOPLEFT", 0, 0)
    content:SetPoint("BOTTOMRIGHT", 0,0)

    local widget = {
        content     = content,
        close        = close,
        frame       = frame,
        type        = Type
    }
    for method, func in pairs(methods) do
        widget[method] = func
    end
    

    return AceGUI:RegisterAsContainer(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
