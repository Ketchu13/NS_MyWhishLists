--[[-----------------------------------------------------------------------------
Icon Widget
-------------------------------------------------------------------------------]]
local Type, Version = "IconUser", 21
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
        self:SetHeight(110)
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

    ["SetImage"] = function(self, path, ...)
        local image = self.image
        image:SetTexture(path)

        if image:GetTexture() then
            local n = select("#", ...)
            if n == 4 or n == 8 then
                image:SetTexCoord(...)
            else
                image:SetTexCoord(0, 1, 0, 1)
            end
        end
    end,

    ["SetImageSize"] = function(self, width, height)
        self.image:SetWidth(width)
        self.image:SetHeight(height)
        --self.frame:SetWidth(width + 30)
        
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

    frame:EnableMouse(true)
    frame:SetScript("OnEnter", Control_OnEnter)
    frame:SetScript("OnLeave", Control_OnLeave)
    frame:SetScript("OnClick", Button_OnClick)
    frame:SetWidth(138)
    frame:SetHeight(28)

    local image = frame:CreateTexture(nil, "BACKGROUND")
    image:SetWidth(24)
    image:SetHeight(24)
    image:SetPoint("TOPLEFT", 2, -2)

    local label = frame:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
    label:SetPoint("TOPLEFT", 33, 0)
    label:SetJustifyH("CENTER")
    label:SetJustifyV("MIDDLE")
    label:SetHeight(19)

    local highlight = frame:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetAllPoints(frame)
    highlight:SetTexture(136580) -- Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight
    highlight:SetTexCoord(0, 1, 0.23, 0.77)
    highlight:SetBlendMode("ADD")

    local widget = {
        label = label,
        image = image,
        frame = frame,
        type  = Type
    }
    for method, func in pairs(methods) do
        widget[method] = func
    end

    widget.SetText = function(self, ...) print("AceGUI-3.0-Icon: SetText is deprecated! Use SetLabel instead!"); self:SetLabel(...) end

    return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
