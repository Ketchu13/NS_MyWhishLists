--[[-----------------------------------------------------------------------------
Frame Container
-------------------------------------------------------------------------------]]
local Type, Version = "TalentsFrame2", 26
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

local ICON_WIDTH = 30--48
local ICON_SPACE = ICON_WIDTH/2
local TAB_SIZE_X = 220
local TAB_SIZE_Y = 355
local TOP_TALENT_FRAME_OFFSET = 28
local dropdown

local clr_lines = {
    r =0.2,
    g = 0.2,
    b = 0.4,
    a = 0.2
}
local drk_lines = {
    r =0.4,
    g = 0.4,
    b = 0.8,
    a = 0.2
}
-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: CLOSE

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function CreateTexture(base, layer, path, blend)
    local t = base:CreateTexture(nil, layer)
    if path then t:SetTexture(path) end
    if blend then t:SetBlendMode(blend)    end
    return t
end
--talent icon mouse move
local function Button_OnEnter (self)
    local parent = self.iconid
    --SetTooltipInfo(self, parent.tab, self.id)
end

local function Button_OnLeave (self)
    --WowAddon5:HideTooltipInfo()
end
--create main talents frame buttons
local function CreateBaseButtons(parent)
    local points = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    points:SetJustifyH("RIGHT")
    points:SetSize(80, 14)
    points:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -40, -6)
    return points
end

--make empty talent slot
local function NewButton(parent)
    local button = CreateFrame("Button", nil, parent)
    -- ItemButtonTemplate (minus Count and Slot)
    button:SetSize(ICON_WIDTH, ICON_WIDTH)
    local t = CreateTexture(button, "BORDER")
    t:SetSize(47, 47)
    t:SetAllPoints(button)
    button.texture = t
    t = CreateTexture(button, nil, "Interface\\Buttons\\UI-Quickslot2")
    t:SetSize(47, 47)
    t:SetPoint("CENTER", 0, 0)
    button:SetNormalTexture(t)
    t = CreateTexture(button, nil, "Interface\\Buttons\\UI-Quickslot-Depress")
    t:SetSize(36, 36)
    t:SetPoint("CENTER")
    button:SetPushedTexture(t)
    t = CreateTexture(button, nil, "Interface\\Buttons\\ButtonHilight-Square", "ADD")
    t:SetSize(36, 36)
    t:SetPoint("CENTER")
    button:SetHighlightTexture(t)
    -- TalentButtonTemplate
    local texture = CreateTexture(button, "BACKGROUND", "Interface\\Buttons\\UI-EmptySlot-White")
    texture:SetSize(40, 40)
    texture:SetPoint("CENTER", 0, 0)
    button.slot = texture

    local tt = CreateTexture(button, "OVERLAY", "Interface\\Addons\\WowAddon5\\Textures\\border")
    tt:SetSize(ICON_WIDTH+10, ICON_WIDTH)
    tt:SetPoint("CENTER", button, "BOTTOMRIGHT")
    local fs = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    fs.texture = tt
    fs:SetPoint("CENTER", tt)

    button.rank =fs
    --todo
    button:SetScript("OnEnter", Button_OnEnter)
    button:SetScript("OnLeave", Button_OnLeave)

    return button
end
--rqst make empty talent slot
local function MakeButton(parent)
    return NewButton(parent)
end
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
            --self:GetParent().obj:Hide()--ReleaseChildren()
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

--calculate offset x and y for talent icon
local function offset(row, column)
    return (column) * ICON_SPACE + (column-1) * ICON_WIDTH, - (15 + (row) * ICON_SPACE + (row-1)* ICON_WIDTH)
end


local function FillUsersOnline(frame,users_infos_)
    local playerbank = frame.playerBank
    pair_ = false
    if playerbank and users_infos_ then
        playerbank.cnt:Hide()
        playerbank.cnt = CreateFrame("Frame", "_talent_playerBankcnt", playerbank.scrollMotherFrame)
        playerbank.cnt:SetPoint("TOPLEFT", playerbank.scrollFrame, "TOPLEFT", 5, 0)
        playerbank.cnt:SetPoint("TOPRIGHT", playerbank.scrollFrame, "TOPRIGHT", -5, 0)
        playerbank.cnt:SetHeight(300)
        playerbank.cnt:SetWidth(200)
        playerbank.cnt:Show()

        playerbank.scrollFrame:SetScrollChild(playerbank.cnt)

        local k_inc = 1
        for k, v in pairs(users_infos_) do
            local userInfos = users_infos[k]
            if not userInfos then
                return
            end
            local c = {}
            if pair_ then
                c = drk_lines
            else
                c = clr_lines
            end
            pair_ = not pair_
            local playerFrame = CreateFrame("Button", "_online_playerFrame"..k, playerbank.cnt)
                playerFrame:EnableMouse(true)
                playerFrame:SetWidth(180)
                playerFrame:SetHeight(20)
                playerFrame:SetScript("OnClick", function(self)
                    frame.obj:SetUser(users_infos[k], k)                
                end)
            local labelplayer = playerFrame:CreateFontString("_online_playerFrame_txt_"..k, "BACKGROUND", "GameFontHighlight")
                labelplayer:SetPoint("TOPLEFT",10,1)
                labelplayer:SetPoint("BOTTOMRIGHT",0,0)
                labelplayer:SetJustifyH("LEFT")
                labelplayer:SetJustifyV("MIDDLE")
                local classColor = RAID_CLASS_COLORS[userInfos.classe.englishClass] or RAID_CLASS_COLORS["PRIEST"]
                labelplayer:SetTextColor(classColor.r, classColor.g, classColor.b)
                labelplayer:SetText(k)
                labelplayer:SetHeight(19)
                labelplayer:SetWidth(180)
                local highlight1 = playerFrame:CreateTexture(nil, "HIGHLIGHT")
                    highlight1:SetAllPoints(labelplayer)
                    highlight1:SetColorTexture(0.5, 0.5, 0.9, 0.8)
                    highlight1:SetBlendMode("ADD")
                local highlight1bg = playerFrame:CreateTexture(nil, "BACKGROUND")
                    highlight1bg:SetAllPoints(labelplayer)
                    highlight1bg:SetColorTexture(c.r, c.g, c.b, c.a)
                    highlight1bg:SetBlendMode("ADD")
                playerFrame:SetPoint("TOPLEFT", 0, -(20+2)*(k_inc-1))
                k_inc = k_inc +1
        end
    end
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
        print(user_name)
        local trees = user.Talents
        local class = user.classe.englishClass
        self.content:Hide()
        self:Show()
        self.content = CreateFrame("Frame", nil, self.frame)
        self.content:SetPoint("TOPLEFT", 5, 0)
        self.content:SetPoint("BOTTOMRIGHT", -5,0)
        self.content:Show()
        --self.close.text(self, user_name)
        for tab, tree in ipairs(trees) do
            --request create tab view
            --create tab view
            local frameTab = CreateFrame("Frame", nil, self.content)
            frameTab:SetPoint("TOPLEFT", (tab-1) * TAB_SIZE_X, -TOP_TALENT_FRAME_OFFSET)
            frameTab:SetSize(TAB_SIZE_X,TAB_SIZE_Y-10)
            --[=[
            local pre_str = { string.match(tree.iconTexture, "([A-Z].*)([A-Z].*)")}
            local bg_file =  string.lower(table.concat(pre_str,"-"))
            --NS_WishLists:Print(bg_file)
            local backdrop = {
                bgFile = "Interface\\TALENTFRAME\\bg-"..bg_file,
            
                insets = { left = 0, right = 0, top = 0, bottom = -156 }
            }
            ]=]--
            local backdrop = {
                bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
                edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
                insets = { left = 4, right = 3, top = 4, bottom = 3 }
            }
            frameTab:SetBackdrop(backdrop)
            frameTab:SetBackdropColor(0, 0, 0, 1)
            frameTab:SetBackdropBorderColor(0.8, 0.0, 0.8)


            local fs = frameTab:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            fs:SetPoint("TOP", 0, 16)
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
                local button = MakeButton(frameTab)
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
        
        if users then 
            users_infos = users
            FillUsersOnline(self.frame, users_infos)
        end
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
    frame:SetSize(3 * TAB_SIZE_X + 10, TAB_SIZE_Y+28)
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
    frame:SetBackdropBorderColor(0.8, 0.0, 0.8)
    local close = CreateFrame("Frame", nil, frame)    
    


    
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

    local backdrop = {
        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
        edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
        insets = { left = 4, right = 3, top = 4, bottom = 3 }
    }
    -- ScrollingMessageFrame1
    local playerBank = CreateFrame("FRAME", "_TablayerBank", frame)
        playerBank:SetPoint("TOPLEFT",content,"TOPRIGHT",2,4)
        playerBank:SetHeight(335)
        playerBank:SetWidth(160)

    local Title = playerBank:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        Title:SetPoint("TOPLEFT",playerBank,"TOPLEFT",10,0)
        Title:SetJustifyH("LEFT")
        Title:SetHeight(19)
        Title:SetWidth(160)
        Title:SetText("Joueur(s) enregistré(s):")

        -- ScrollingMessageFrame1
        playerBank.scrollMotherFrame = CreateFrame("Frame",  "_TabplayerBank_scrollmother", playerBank)
        playerBank.scrollMotherFrame:SetPoint("TOPLEFT", 0, -20)
        playerBank.scrollMotherFrame:SetHeight(330)
        playerBank.scrollMotherFrame:SetWidth(160)
        playerBank.scrollMotherFrame:SetBackdrop(backdrop)
        playerBank.scrollMotherFrame:SetBackdropColor(0, 0, 0.1)
        playerBank.scrollMotherFrame:SetBackdropBorderColor(0.8, 0.0, 0.8)

        playerBank.scrollFrame = CreateFrame("ScrollFrame", nil, playerBank.scrollMotherFrame, "UIPanelScrollFrameTemplate")
        playerBank.scrollFrame:SetPoint("TOPLEFT", 5, -8)
        playerBank.scrollFrame:SetPoint("BOTTOMRIGHT", -30, 5)
        playerBank.scrollFrame:EnableMouseWheel(true)
        playerBank.scrollFrame:EnableMouse(true)

        playerBank.scrollbg2 = playerBank.scrollFrame:CreateTexture(nil, "BACKGROUND")
        playerBank.scrollbg2:SetAllPoints(true)
        playerBank.scrollbg2:SetColorTexture(0, 0, 0, 0.9)

        playerBank.cnt = CreateFrame("Frame", "_TabplayerBankcnt", playerBank.scrollMotherFrame)
        playerBank.cnt:SetPoint("TOPLEFT", playerBank.scrollFrame, "TOPLEFT", 0, 0)
        playerBank.cnt:SetPoint("TOPRIGHT", playerBank.scrollFrame, "TOPRIGHT", 0, 0)
        playerBank.cnt:SetHeight(300)
        playerBank.cnt:SetWidth(160)

        playerBank.scrollFrame:SetScrollChild(playerBank.cnt)

        playerBank.scrollbg3 = playerBank.cnt:CreateTexture(nil, "BACKGROUND")
        playerBank.scrollbg3:SetAllPoints(true)
        playerBank.scrollbg3:SetColorTexture(0, 0, 0, 0.9)

        pair_ = false
        --************
        ----CMD UI
        local scanButton = CreateFrame("Button", "_options_rfr_butt",playerBank , "UIPanelButtonTemplate")
            scanButton:SetPoint("TOPLEFT", playerBank.scrollMotherFrame, "BOTTOMLEFT", 0, -5)
            scanButton:SetHeight(24)
            scanButton:SetWidth(160)
            scanButton:SetText("Refresh")
        playerBank.scanButton = scanButton
        frame.playerBank = playerBank
        

---- OnClick DropDown Menu Option
    local widget = {
        content         = content,
        close           = close,
        frame           = frame,
        playerBank      = playerBank,
        type            = Type
    }
    for method, func in pairs(methods) do
        widget[method] = func
    end
    

    return AceGUI:RegisterAsContainer(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
