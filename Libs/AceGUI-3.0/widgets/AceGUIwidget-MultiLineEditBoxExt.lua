local Type, Version = "MultiLineEditBoxExt", 28
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs = pairs

-- WoW APIs
local GetCursorInfo, GetSpellInfo, ClearCursor = GetCursorInfo, GetSpellInfo, ClearCursor
local CreateFrame, UIParent = CreateFrame, UIParent
local _G = _G

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: ACCEPT, ChatFontNormal

--[[-----------------------------------------------------------------------------
Support functions
-------------------------------------------------------------------------------]]

if not AceGUIMultiLineEditBoxInsertLink then
    -- upgradeable hook
    hooksecurefunc("ChatEdit_InsertLink", function(...) return _G.AceGUIMultiLineEditBoxInsertLink(...) end)
end

function _G.AceGUIMultiLineEditBoxInsertLink(text)
    for i = 1, AceGUI:GetWidgetCount(Type) do
        local editbox = _G[("MultiLineEditBox%uEdit"):format(i)]
        if editbox and editbox:IsVisible() and editbox:HasFocus() then
            editbox:Insert(text)
            return true
        end
    end
end


local function Layout(self)
    self:SetHeight(self.numlines * 14 + (self.disablebutton and 19 or 41) + self.labelHeight)

    if self.labelHeight == 0 then
        self.scrollBar:SetPoint("TOP", self.frame, "TOP", 0, -23)
    else
        self.scrollBar:SetPoint("TOP", self.label1, "BOTTOM", 0, -19)
    end

    if self.disablebutton then
        self.scrollBar:SetPoint("BOTTOM", self.frame, "BOTTOM", 0, 21)
        self.scrollBG:SetPoint("BOTTOMLEFT", 0, 4)
    else
        self.scrollBar:SetPoint("BOTTOM", self.button, "TOP", 0, 18)
        self.scrollBG:SetPoint("BOTTOMLEFT", self.button, "TOPLEFT")
    end
end

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function OnClick_Validate(self)                                                     -- Button
    self = self.obj
    self:Fire("OnClick",  "Validate")
end

local function OnClick_Reset(self)                                                     -- Button
    self = self.obj
    self:Fire("OnClick", "Reset")
end

local function OnCursorChanged(self, _, y, _, cursorHeight)                      -- EditBox
    self, y = self.obj.scrollFrame, -y
    local offset = self:GetVerticalScroll()
    if y < offset then
        self:SetVerticalScroll(y)
    else
        y = y + cursorHeight - self:GetHeight()
        if y > offset then
            self:SetVerticalScroll(y)
        end
    end
end

local function OnEditFocusLost(self)                                             -- EditBox
    self:HighlightText(0, 0)
    self.obj:Fire("OnEditFocusLost")
end

local function OnEnter(self)                                                     -- EditBox / ScrollFrame
    self = self.obj
    if not self.entered then
        self.entered = true
        self:Fire("OnEnter")
    end
end

local function OnLeave(self)                                                     -- EditBox / ScrollFrame
    self = self.obj
    if self.entered then
        self.entered = nil
        self:Fire("OnLeave")
    end
end

local function OnMouseUp(self)                                                   -- ScrollFrame
    self = self.obj.editBox
    self:SetFocus()
    self:SetCursorPosition(self:GetNumLetters())
end

local function OnReceiveDrag(self)                                               -- EditBox / ScrollFrame
    local type, id, info = GetCursorInfo()
    if type == "spell" then
        info = GetSpellInfo(id, info)
    elseif type ~= "item" then
        return
    end
    ClearCursor()
    self = self.obj
    local editBox = self.editBox
    if not editBox:HasFocus() then
        editBox:SetFocus()
        editBox:SetCursorPosition(editBox:GetNumLetters())
    end
    editBox:Insert(info)
    --self.button:Enable()
end

local function OnSizeChanged(self, width, height)                                -- ScrollFrame
    self.obj.editBox:SetWidth(width)
end

local function OnTextChanged(self, userInput)                                    -- EditBox
    if userInput then
        self = self.obj
        self:Fire("OnTextChanged", self.editBox:GetText())
        --self.button:Enable()
    end
end

local function OnTextSet(self)                                                   -- EditBox
    self:HighlightText(0, 0)
    self:SetCursorPosition(self:GetNumLetters())
    self:SetCursorPosition(0)
    self.obj.button:Disable()
    self.obj.button:Hide()
    self.obj.Validate:Enable()
    self.obj.Reset:Enable()
end

local function OnVerticalScroll(self, offset)                                    -- ScrollFrame
    local editBox = self.obj.editBox
    editBox:SetHitRectInsets(0, 0, offset, editBox:GetHeight() - offset - self:GetHeight())
end

local function OnShowFocus(frame)
    frame.obj.editBox:SetFocus()
    frame:SetScript("OnShow", nil)
end

local function OnEditFocusGained(frame)
    AceGUI:SetFocus(frame.obj)
    frame.obj:Fire("OnEditFocusGained")
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
    ["OnAcquire"] = function(self)
        self.editBox:SetText("")
        self:SetDisabled(false)
        self:SetWidth(200)
        self:DisableButton(false)
        self:DisableButtonV(false)
        self:DisableButtonR(false)
        self:SetNumLines()
        self.entered = nil
        self:SetMaxLetters(0)
    end,

    ["OnRelease"] = function(self)
        self:ClearFocus()
    end,

    ["SetDisabled"] = function(self, disabled)
        local editBox = self.editBox
        if disabled then
            editBox:ClearFocus()
            editBox:EnableMouse(false)
            editBox:SetTextColor(0.5, 0.5, 0.5)
            self.label1:SetTextColor(0.5, 0.5, 0.5)
            self.label2:SetTextColor(0.5, 0.5, 0.5)
            self.scrollFrame:EnableMouse(false)
            self.Validate:Disable()
            self.button:Hide()
            self.Reset:Disable()
            self.button:Disable()
        else
            editBox:EnableMouse(true)
            editBox:SetTextColor(1, 1, 1)
            self.label1:SetTextColor(1, 0.82, 0)
            self.label2:SetTextColor(1, 0.82, 0)
            self.scrollFrame:EnableMouse(true)
            self.Validate:Enable()
            self.Reset:Enable()
            self.button:Enable()
            self.button:Hide()
        end
    end,

    ["SetLabelValidate"] = function(self, text)
        if text and text ~= "" then
            self.label1:SetText(text)
            if self.labelHeight ~= 10 then
                self.labelHeight = 10
                self.label1:Hide()
            end
        elseif self.labelHeight ~= 0 then
            self.labelHeight = 0
            self.label1:Hide()
        end
        --Layout(self)
    end,

    ["SetLabelReset"] = function(self, text)
        if text and text ~= "" then
            self.label2:SetText(text)
            if self.labelHeight ~= 10 then
                self.labelHeight = 10
                self.label2:Hide()
            end
        elseif self.labelHeight ~= 0 then
            self.labelHeight = 0
            self.label2:Hide()
        end
        
    end,

    ["SetNumLines"] = function(self, value)
        if not value or value < 4 then
            value = 4
        end
        self.numlines = value
        Layout(self)
    end,
    ["SetLabel"] = function(self, text)
        self.text:SetText(text)
    end,
    ["SetText"] = function(self, text)
        self.editBox:SetText(text)
    end,

    ["GetText"] = function(self)
        return self.editBox:GetText()
    end,

    ["SetMaxLetters"] = function (self, num)
        self.editBox:SetMaxLetters(num or 0)
    end,
    
    ["DisableButton"] = function(self, disabled)
        self.disablebutton = disabled
        if disabled then
            self.button:Hide()
        else
            self.button:Show()
            self.button:Hide()
        end
        Layout(self)
    end,
    
    ["DisableButtonV"] = function(self, disabled)
        self.disablebutton = disabled
        if disabled then
            self.Validate:Disable()
        else
            self.Validate:Enable()
        end
        --Layout(self)
    end,

    ["DisableButtonR"] = function(self, disabled)
        self.disablebutton = disabled
        if disabled then
            self.Reset:Disable()
        else
            self.Reset:Enable()
        end
        --Layout(self)
    end,
    ["Disable"] = function(self, disabled)
        self.disable = disabled
        if disabled then
            self.editBox:EnableMouse(false)
            self.editBox:EnableKeyboard(false)
            -- todo change text color self.editBox
        else
            self.editBox:EnableMouse(true)
            self.editBox:EnableKeyboard(true)
        end
        --Layout(self)
    end,
    ["ClearFocus"] = function(self)
        self.editBox:ClearFocus()
        self.frame:SetScript("OnShow", nil)
    end,

    ["SetFocus"] = function(self)
        self.editBox:SetFocus()
        if not self.frame:IsShown() then
            self.frame:SetScript("OnShow", OnShowFocus)
        end
    end,

    ["HighlightText"] = function(self, from, to)
        self.editBox:HighlightText(from, to)
    end,

    ["GetCursorPosition"] = function(self)
        return self.editBox:GetCursorPosition()
    end,

    ["SetCursorPosition"] = function(self, ...)
        return self.editBox:SetCursorPosition(...)
    end,


}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local backdrop = {
    bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
    edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
    insets = { left = 4, right = 3, top = 4, bottom = 3 }
}

local function Constructor()
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:Hide()

    local widgetNum = AceGUI:GetNextWidgetNum(Type)

    local label1 = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label1:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -4)
    label1:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -4)
    label1:SetJustifyH("LEFT")
    label1:SetText(ACCEPT)
    label1:SetHeight(10)
    label1:Hide()
    
    local button = CreateFrame("Button", ("%s%dButton"):format(Type, widgetNum), frame, "UIPanelButtonTemplate")
    button:SetPoint("BOTTOMLEFT", 0, 4)
    button:SetHeight(22)
    button:SetWidth(label1:GetStringWidth() + 24)
    button:SetText(ACCEPT)
    button:SetScript("OnClick", OnClick)
    button:Disable()
    button:Hide()
    
    local label2 = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label2:SetPoint("TOPLEFT", label1, "TOPLEFT", 0, -4)
    label2:SetPoint("TOPRIGHT", label1, "TOPRIGHT", 0, -4)
    label2:SetJustifyH("LEFT")
    label2:SetText(ACCEPT)
    label2:SetHeight(10)
    label2:Hide()

    local Validate = CreateFrame("Button", ("%s%dButton"):format(Type, widgetNum), frame, "UIPanelButtonTemplate")
    Validate:SetPoint("BOTTOMLEFT", 0, 4)
    Validate:SetHeight(22)
    Validate:SetWidth(label1:GetStringWidth() + 24)    
    Validate:SetText(ACCEPT)
    Validate:SetScript("OnClick", OnClick_Validate)
    Validate:Enable()
        
    -- 2. Reset
    local Reset = CreateFrame("Button", ("%s%dButton"):format(Type, widgetNum), frame, "UIPanelButtonTemplate")
    Reset:SetPoint("BOTTOMLEFT", Validate, "BOTTOMLEFT", label1:GetStringWidth() + 28, 0)
    Reset:SetHeight(22)
    Reset:SetWidth(label2:GetStringWidth() + 24)    
    Reset:SetText("Reset")
    Reset:SetScript("OnClick", OnClick_Reset)
    Reset:Enable()
    
    local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    text:ClearAllPoints()
    text:SetPoint("TOPLEFT", 0, 0)
    text:SetJustifyH("LEFT")
    text:SetText("Données à importer:")
    text:SetHeight(10)
    text:SetWidth(180)
    
    local scrollBG = CreateFrame("Frame", nil, frame)
    scrollBG:SetBackdrop(backdrop)
    scrollBG:SetBackdropColor(0, 0, 0)
    scrollBG:SetBackdropBorderColor(0.4, 0.4, 0.4)

    local scrollFrame = CreateFrame("ScrollFrame", ("%s%dScrollFrame"):format(Type, widgetNum), frame, "UIPanelScrollFrameTemplate")

    local scrollBar = _G[scrollFrame:GetName() .. "ScrollBar"]
    scrollBar:ClearAllPoints()
    scrollBar:SetPoint("TOP", label1, "BOTTOM", 0, -19)
    scrollBar:SetPoint("BOTTOM", button, "TOP", 0, 18)
    scrollBar:SetPoint("RIGHT", frame, "RIGHT")

    scrollBG:SetPoint("TOPRIGHT", scrollBar, "TOPLEFT", 0, 19)
    scrollBG:SetPoint("BOTTOMLEFT", button, "TOPLEFT")

    scrollFrame:SetPoint("TOPLEFT", scrollBG, "TOPLEFT", 5, -6)
    scrollFrame:SetPoint("BOTTOMRIGHT", scrollBG, "BOTTOMRIGHT", -4, 4)
    scrollFrame:SetScript("OnEnter", OnEnter)
    scrollFrame:SetScript("OnLeave", OnLeave)
    scrollFrame:SetScript("OnMouseUp", OnMouseUp)
    scrollFrame:SetScript("OnReceiveDrag", OnReceiveDrag)
    scrollFrame:SetScript("OnSizeChanged", OnSizeChanged)
    scrollFrame:HookScript("OnVerticalScroll", OnVerticalScroll)

    local editBox = CreateFrame("EditBox", ("%s%dEdit"):format(Type, widgetNum), scrollFrame)
    editBox:SetAllPoints()
    editBox:SetFontObject(ChatFontNormal)
    editBox:SetMultiLine(true)
    editBox:EnableMouse(true)
    editBox:SetAutoFocus(false)
    editBox:SetCountInvisibleLetters(false)
    editBox:SetScript("OnCursorChanged", OnCursorChanged)
    editBox:SetScript("OnEditFocusLost", OnEditFocusLost)
    editBox:SetScript("OnEnter", OnEnter)
    editBox:SetScript("OnEscapePressed", editBox.ClearFocus)
    editBox:SetScript("OnLeave", OnLeave)
    editBox:SetScript("OnMouseDown", OnReceiveDrag)
    editBox:SetScript("OnReceiveDrag", OnReceiveDrag)
    editBox:SetScript("OnTextChanged", OnTextChanged)
    editBox:SetScript("OnTextSet", OnTextSet)
    editBox:SetScript("OnEditFocusGained", OnEditFocusGained)

    scrollFrame:SetScrollChild(editBox)

    local widget = {
        button      = button,
        Validate    = Validate,
        Reset       = Reset,
        text        = text,
        editBox     = editBox,
        frame       = frame,
        label1       = label1,
        label2       = label2,
        labelHeight = 10,
        numlines    = 4,
        scrollBar   = scrollBar,
        scrollBG    = scrollBG,
        scrollFrame = scrollFrame,
        type        = Type
    }
    for method, func in pairs(methods) do
        widget[method] = func
    end
    button.obj, Validate.obj, Reset.obj, editBox.obj, scrollFrame.obj = widget, widget, widget , widget, widget

    return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
