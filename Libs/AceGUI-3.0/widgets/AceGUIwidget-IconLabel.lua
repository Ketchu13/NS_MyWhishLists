--[[-----------------------------------------------------------------------------
Icon Widget
-------------------------------------------------------------------------------]]
local Type, Version = "IconLabel", 21
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local select, pairs, print = select, pairs, print

-- WoW APIs
local CreateFrame, UIParent = CreateFrame, UIParent

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Control_OnEnter(frame)
    frame.obj:Fire("OnEnter")
end

local function Control_OnLeave(frame)
    frame.obj:Fire("OnLeave")
end

local function Button_OnClick(frame, button)
    frame.obj:Fire("OnClick", button)
    AceGUI:ClearFocus()
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
    ["OnAcquire"] = function(self)
        self:SetHeight(28)
        self:SetWidth(110)
        self:SetLabel()
        self:SetImage(nil)
        self:SetImageSize(24, 24)
        self:SetDisabled(false)
    end,

    -- ["OnRelease"] = nil,

    ["SetLabel"] = function(self, text)
        if text and text ~= "" then
            self.label:Show()
            self.label:SetText(text)
        else
            self.label:Hide()
        end
    end,

    ["SetExtra"] = function(self, text)
        if text and text ~= "" then
            self.extra:Show()
            self.extra:SetText(text)
        else
            self.extra:Hide()
        end
    end,

    ["SetImage"] = function(self, path, ...)
        local image = self.image
        image:SetTexture(path)        
    end,

    ["SetImageSize"] = function(self, width, height)
        self.image:SetWidth(width)
        self.image:SetHeight(height)
        --self.frame:SetWidth(width + 30)
        if self.label:IsShown() then
            self:SetHeight(height + 4)
        else
            self:SetHeight(height + 4)
        end
    end,

    ["SetDisabled"] = function(self, disabled)
        self.disabled = disabled
        if disabled then
            self.frame:Disable()
            self.label:SetTextColor(0.5, 0.5, 0.5)
            self.image:SetVertexColor(0.5, 0.5, 0.5, 0.5)
        else
            self.frame:Enable()
            self.label:SetTextColor(1, 1, 1)
            self.image:SetVertexColor(1, 1, 1, 1)
        end
    end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
    local frame = CreateFrame("Button", nil, UIParent)
    frame:Hide()
    frame:SetWidth(110)
    frame:SetHeight(28)
    frame:EnableMouse(true)
    frame:SetScript("OnEnter", Control_OnEnter)
    frame:SetScript("OnLeave", Control_OnLeave)
    frame:SetScript("OnClick", Button_OnClick)

    local image = frame:CreateTexture(nil, "BACKGROUND")
    image:SetWidth(26)
    image:SetHeight(26)
    image:SetPoint("TOPLEFT", 0, 0)

    local label = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetPoint("TOPLEFT", image, "TOPRIGHT", 0, 0)
    label:SetJustifyH("LEFT")
    label:SetHeight(12)

    local extra = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    extra:SetPoint("BOTTOMLEFT", image, "BOTTOMRIGHT", 0, 0)
    extra:SetJustifyH("LEFT")
    extra:SetHeight(10)
    
    local highlight = frame:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetAllPoints(image)
    highlight:SetTexture(136580) -- Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight
    highlight:SetTexCoord(0, 1, 0.23, 0.77)
    highlight:SetBlendMode("ADD")

    local widget = {
        label = label,
        extra = extra,
        image = image,
        frame = frame,
        type  = Type
    }
    for method, func in pairs(methods) do
        widget[method] = func
    end

    widget.SetText = (function(self, ...)
        print("AceGUI-3.0-Icon: SetText is deprecated! Use SetLabel instead!");
        self:SetLabel(...)
    end)

    return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
