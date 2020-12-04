--[[-----------------------------------------------------------------------------
Frame Container
-------------------------------------------------------------------------------]]
local Type, Version = "FrameSurvey", 26
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs, assert, type = pairs, assert, type
local wipe = table.wipe
local min, max, floor = math.min, math.max, math.floor

-- WoW APIs
local PlaySound = PlaySound
local CreateFrame, UIParent = CreateFrame, UIParent
local item_ = {}
-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: CLOSE
--[[-----------------------------------------------------------------------------
Support functions
-------------------------------------------------------------------------------]]
local function FixScrollOnUpdate(frame)
    frame:SetScript("OnUpdate", nil)
    frame.obj:FixScroll()
end
--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Button_OnClick(frame)
    PlaySound(799) -- SOUNDKIT.GS_TITLE_OPTION_EXIT
    frame.obj:Hide()
end

local function Frame_OnShow(frame)
    frame.obj:Fire("OnShow")
end

local function Frame_OnClose(frame)
    frame.obj:Fire("OnClose")
end

local function Frame_OnMouseDown(frame)
    AceGUI:ClearFocus()
end
--TITLE
local function Title_OnMouseDown(frame)
    frame:GetParent()
    AceGUI:ClearFocus()
end

local function MoverSizer_OnMouseUp(mover)
    local frame = mover:GetParent()
    frame:StopMovingOrSizing()
    local self = frame.obj
    local statuspos = self.statuspos or self.localstatuspos
    statuspos.width = frame:GetWidth()
    statuspos.height = frame:GetHeight()
    statuspos.top = frame:GetTop()
    statuspos.left = frame:GetLeft()
end

local function StatusBar_OnEnter(frame)
    frame.obj:Fire("OnEnterStatusBar")
end

local function StatusBar_OnLeave(frame)
    frame.obj:Fire("OnLeaveStatusBar")
end
--**--
local function ScrollFrame_OnMouseWheel(frame, value)
    frame.obj:MoveScroll(value)
end

local function ScrollFrame_OnSizeChanged(frame)
    frame:SetScript("OnUpdate", FixScrollOnUpdate)
end

local function ScrollBar_OnScrollValueChanged(frame, value)
    frame.obj:SetScroll(value)
end

local function Item_OnClick(frame, value)

end
--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
    ["OnAcquire"] = function(self)
        self:SetScroll(0)
        self.scrollframe:SetScript("OnUpdate", FixScrollOnUpdate)
        self.frame:SetParent(UIParent)
        self.frame:SetFrameStrata("FULLSCREEN_DIALOG")
        self:SetTitle()
        self:ApplyStatus()
        self:SetLabel()
        self:SetImage(nil)
        self:SetImageSize(44, 44)
        self:Show()
    end,

    ["OnRelease"] = function(self)
        self.status = nil
        wipe(self.localstatus)
        self.scrollframe:SetPoint("BOTTOMRIGHT")
        self.scrollbar:Hide()
        self.scrollBarShown = nil
        self.content.height, self.content.width, self.content.original_width = nil, nil, nil
        self.statuspos = nil
        wipe(self.localstatuspos)
    end,

    ["SetScroll"] = function(self, value)
        local status = self.status or self.localstatus
        local viewheight = self.scrollframe:GetHeight()
        local height = self.content:GetHeight()
        local offset

        if viewheight > height then
            offset = 0
        else
            offset = floor((height - viewheight) / 1000.0 * value)
        end
        self.content:ClearAllPoints()
        self.content:SetPoint("TOPLEFT", 0, offset)
        self.content:SetPoint("TOPRIGHT", 0, offset)
        status.offset = offset
        status.scrollvalue = value
    end,

    ["MoveScroll"] = function(self, value)
        local status = self.status or self.localstatus
        local height, viewheight = self.scrollframe:GetHeight(), self.content:GetHeight()

        if self.scrollBarShown then
            local diff = height - viewheight
            local delta = 1
            if value < 0 then
                delta = -1
            end
            self.scrollbar:SetValue(min(max(status.scrollvalue + delta*(1000/(diff/45)),0), 1000))
        end
    end,

    ["FixScroll"] = function(self)
        if self.updateLock then return end
        self.updateLock = true
        local status = self.status or self.localstatus
        local height, viewheight = self.scrollframe:GetHeight(), self.content:GetHeight()
        local offset = status.offset or 0
        -- Give us a margin of error of 2 pixels to stop some conditions that i would blame on floating point inaccuracys
        -- No-one is going to miss 2 pixels at the bottom of the frame, anyhow!
        if viewheight < height + 2 then
            if self.scrollBarShown then
                self.scrollBarShown = nil
                self.scrollbar:Hide()
                self.scrollbar:SetValue(0)
                self.scrollframe:SetPoint("BOTTOMRIGHT")
                if self.content.original_width then
                    self.content.width = self.content.original_width
                end
                self:DoLayout()
            end
        else
            if not self.scrollBarShown then
                self.scrollBarShown = true
                self.scrollbar:Show()
                self.scrollframe:SetPoint("BOTTOMRIGHT", -20, 0)
                if self.content.original_width then
                    self.content.width = self.content.original_width - 20
                end
                self:DoLayout()
            end
            local value = (offset / (viewheight - height) * 1000)
            if value > 1000 then value = 1000 end
            self.scrollbar:SetValue(value)
            self:SetScroll(value)
            if value < 1000 then
                self.content:ClearAllPoints()
                self.content:SetPoint("TOPLEFT", 0, offset)
                self.content:SetPoint("TOPRIGHT", 0, offset)
                status.offset = offset
            end
        end
        self.updateLock = nil
    end,

    ["LayoutFinished"] = function(self, width, height)
        self.content:SetHeight(height or 0 + 20)

        -- update the scrollframe
        self:FixScroll()

        -- schedule another update when everything has "settled"
        self.scrollframe:SetScript("OnUpdate", FixScrollOnUpdate)
    end,

    ["OnWidthSet"] = function(self, width)
        local content = self.content
        local contentwidth = width - 34
        if contentwidth < 0 then
            contentwidth = 0
        end
        content:SetWidth(contentwidth)
        content.width = contentwidth
    end,

    ["OnHeightSet"] = function(self, height)
        local content = self.content
        local contentheight = height - 57
        if contentheight < 0 then
            contentheight = 0
        end
        content:SetHeight(contentheight)
        content.height = contentheight
    end,

    ["SetTitle"] = function(self, title)
        self.titletext:SetText(title)
        self.titlebg:SetWidth((self.titletext:GetWidth() or 0) + 20)
    end,
    
    ["Hide"] = function(self)
        self.frame:Hide()
    end,

    ["Show"] = function(self)
        self.frame:Show()
    end,

    ["SetItem"] = function(self, value)
        self.item_ = value
        self:SetLabel(item_.name)
    end,
    
    ["SetStatusTable"] = function(self, status)
        assert(type(status) == "table")
        self.status = status
        if not status.scrollvalue then
            status.scrollvalue = 0
        end
    end,
    -- called to set an external table to store status in
    ["SetStatusPosTable"] = function(self, statuspos)
        assert(type(statuspos) == "table")
        self.statuspos = statuspos
        self:ApplyStatus()
    end,        
    
    ["ApplyStatus"] = function(self)
        local statuspos = self.statuspos or self.localstatuspos
        local frame = self.frame
        self:SetWidth(statuspos.width or 700)
        self:SetHeight(statuspos.height or 500)
        frame:ClearAllPoints()
        if statuspos.top and statuspos.left then
            frame:SetPoint("TOP", UIParent, "BOTTOM", 0, statuspos.top)
            frame:SetPoint("LEFT", UIParent, "LEFT", statuspos.left, 0)
        else
            frame:SetPoint("CENTER")
        end
    end,
    
    ["SetLabel"] = function(self, text)
        if text and text ~= "" then
            self.item_label:Show()
            self.item_label:SetText(text)            
        else
            self.item_label:Hide()            
        end
    end,

    ["SetExtra"] = function(self, text)
        if text and text ~= "" then
            self.item_extra:Show()
            self.item_extra:SetText(text)
        else
            self.item_extra:Hide()
        end
    end,    

    ["SetImage"] = function(self, path, ...)
        local image = self.item_image
        image:SetTexture(path)        
    end,

    ["SetImageSize"] = function(self, width, height)
        self.item_image:SetWidth(width)
        self.item_image:SetHeight(height)
        --self.frame:SetWidth(width + 30)        
    end,
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]



local function Constructor()
    local frame = CreateFrame("Frame", nil, UIParent)
    local num = AceGUI:GetNextWidgetNum(Type)
    
    frame:Show()
    
    --Main FRAME
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetResizable(true)
    frame:SetFrameStrata("FULLSCREEN_DIALOG")
    frame:SetBackdrop(FrameBackdrop)
    frame:SetBackdropColor(0, 0, 0, 1)
    frame:SetMinResize(400, 200)
    frame:SetToplevel(true)
    frame:SetScript("OnShow", Frame_OnShow)
    frame:SetScript("OnHide", Frame_OnClose)
    frame:SetScript("OnMouseDown", Frame_OnMouseDown)
    frame:SetHeight(500)
    frame:SetWidth(400)

    --CLOSE BUTTON
    local closebutton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    closebutton:SetScript("OnClick", Button_OnClick)
    closebutton:SetPoint("BOTTOMRIGHT", -27, 17)
    closebutton:SetHeight(20)
    closebutton:SetWidth(100)
    closebutton:SetText(CLOSE)

    --FRAME TITLE
    local titlebg = frame:CreateTexture(nil, "OVERLAY")
    titlebg:SetTexture(131080) -- Interface\\DialogFrame\\UI-DialogBox-Header
    titlebg:SetTexCoord(0.31, 0.67, 0, 0.63)
    titlebg:SetPoint("TOP", 0, 12)
    titlebg:SetWidth(100)
    titlebg:SetHeight(40)

    local title = CreateFrame("Frame", nil, frame)
    title:EnableMouse(true)
    title:SetScript("OnMouseDown", Title_OnMouseDown)
    title:SetScript("OnMouseUp", MoverSizer_OnMouseUp)
    title:SetAllPoints(titlebg)

    local titletext = title:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titletext:SetPoint("TOP", titlebg, "TOP", 0, -14)

    local titlebg_l = frame:CreateTexture(nil, "OVERLAY")
    titlebg_l:SetTexture(131080) -- Interface\\DialogFrame\\UI-DialogBox-Header
    titlebg_l:SetTexCoord(0.21, 0.31, 0, 0.63)
    titlebg_l:SetPoint("RIGHT", titlebg, "LEFT")
    titlebg_l:SetWidth(30)
    titlebg_l:SetHeight(40)

    local titlebg_r = frame:CreateTexture(nil, "OVERLAY")
    titlebg_r:SetTexture(131080) -- Interface\\DialogFrame\\UI-DialogBox-Header
    titlebg_r:SetTexCoord(0.67, 0.77, 0, 0.63)
    titlebg_r:SetPoint("LEFT", titlebg, "RIGHT")
    titlebg_r:SetWidth(30)
    titlebg_r:SetHeight(40)

    --ITEM TO VOTE 
    local item_frame = CreateFrame("Button", nil, frame)
    item_frame:Hide()
    item_frame:SetWidth(110)
    item_frame:SetHeight(48)
    item_frame:EnableMouse(true)    
    item_frame:SetPoint("TOPLEFT", 10 , -20)
    item_frame:SetScript("OnEnter", function()
        PlaySoundFile("Sound/Interface/Iuiinterfacebuttona.Ogg");
        GameTooltip:SetOwner(item_frame, "ANCHOR_CURSOR");
        GameTooltip:ClearLines();
        GameTooltip:SetItemByID(item_.itemid);
        GameTooltip:AddLine("\nPrio: " .. item_.forname, 1, 0, 1)
        GameTooltip:Show()
        GameTooltip:SetItemByID(item.itemid);
        GameTooltip:AddLine("\nPrio: " .. item_.forname, 1, 0.5, 1)
        GameTooltip:Show()
        -- GameTooltip:SetItemByID(item.itemid);
    end)
    item_frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
    item_frame:SetScript("OnClick", function(widget, event, button, down)
        --NS_WishLists:Print(button)
        if button == "LeftButton" then
            if IsControlKeyDown() then
                DressUpItemLink(itemLink)
            elseif IsShiftKeyDown() then
                ChatEdit_InsertLink(itemLink)
            elseif IsAltKeyDown() then
                ChatEdit_InsertLink(itemLink)

            end
        end
    end)

    local item_image = item_frame:CreateTexture(nil, "BACKGROUND")
    item_image:SetWidth(44)
    item_image:SetHeight(44)
    item_image:SetPoint("TOPLEFT", 2, -2)

    local item_label = item_frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    item_label:SetPoint("TOPLEFT", item_image, "TOPRIGHT", 2, -0)
    item_label:SetJustifyH("LEFT")
    item_label:SetHeight(12)

    local item_extra = item_frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    item_extra:SetPoint("BOTTOMLEFT", item_image, "BOTTOMRIGHT", 0, 3)
    item_extra:SetJustifyH("LEFT")
    item_extra:SetHeight(10)
    
    local item_highlight = item_frame:CreateTexture(nil, "HIGHLIGHT")
    item_highlight:SetAllPoints(item_image)
    item_highlight:SetTexture(136580) -- Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight
    item_highlight:SetTexCoord(0, 1, 0.23, 0.77)
    item_highlight:SetBlendMode("ADD")
    
    -- ScrollFrame
    local scrollMotherFrame = CreateFrame("Frame", nil, frame)
    scrollMotherFrame:SetBackdrop(backdrop)
    scrollMotherFrame:SetBackdropColor(0, 0, 0)
    scrollMotherFrame:SetBackdropBorderColor(0.4, 0.4, 0.4)

    local scrollframe = CreateFrame("ScrollFrame", nil, scrollMotherFrame)
    scrollframe:ClearAllPoints()
    scrollframe:SetPoint("TOPLEFT")
    scrollframe:SetPoint("BOTTOMRIGHT")
    scrollframe:EnableMouseWheel(true)
    scrollframe:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel)
    scrollframe:SetScript("OnSizeChanged", ScrollFrame_OnSizeChanged)

    local scrollbar = CreateFrame("Slider", ("AceConfigDialogScrollFrame%dScrollBar"):format(num), scrollframe, "UIPanelScrollBarTemplate")
    scrollbar:SetPoint("TOPLEFT", scrollframe, "TOPRIGHT", 4, -16)
    scrollbar:SetPoint("BOTTOMLEFT", scrollframe, "BOTTOMRIGHT", 4, 16)
    scrollbar:SetMinMaxValues(0, 1000)
    scrollbar:SetValueStep(1)
    scrollbar:SetValue(0)
    scrollbar:SetWidth(16)

    -- set the script as the last step, so it doesn't fire yet
    scrollbar:SetScript("OnValueChanged", ScrollBar_OnScrollValueChanged)

    local scrollbg = scrollbar:CreateTexture(nil, "BACKGROUND")
    scrollbg:SetAllPoints(scrollbar)
    scrollbg:SetColorTexture(0, 0, 0, 0.9)

    local scrollfrbg = scrollframe:CreateTexture(nil, "BACKGROUND")
    scrollfrbg:SetAllPoints(scrollframe)
    scrollfrbg:SetColorTexture(0, 1, 0, 0.4)

    --Container Support
    local content = CreateFrame("Frame", nil, scrollframe)
    content:SetPoint("TOPLEFT")
    content:SetPoint("TOPRIGHT")
    content:SetFrameStrata('TOOLTIP')

    scrollframe:SetScrollChild(content)

    local widget = {
        localstatus          = { scrollvalue = 0 },
        localstatuspos      = {},
        titletext          = titletext,
        statustext          = statustext,

        item_frame          = item_frame,
         item_image          = item_image,
         item_label          = item_label,
         item_extra          = item_extra,

        scrollMotherFrame = scrollMotherFrame,
         scrollframe      = scrollframe,
         scrollbar          = scrollbar,

        titlebg              = titlebg,        
        content              = content,
        frame              = frame,
        type              = Type
    }
    for method, func in pairs(methods) do
        widget[method] = func
    end
    item.obj, scrollMotherFrame.obj, scrollframe.obj, scrollbar.obj, closebutton.obj = widget, widget, widget, widget, widget

    return AceGUI:RegisterAsContainer(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
