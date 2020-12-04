--[[-----------------------------------------------------------------------------
Frame Container
-------------------------------------------------------------------------------]]
local Type, Version = "SimpleFrame2", 26
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs, assert, type = pairs, assert, type
local wipe = table.wipe

-- WoW APIs
local PlaySound = PlaySound
local CreateFrame, UIParent = CreateFrame, UIParent

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

local function Frame_OnMouseDown(frame)
    AceGUI:ClearFocus()
end

local function Title_OnMouseDown(frame)
    frame:GetParent():StartMoving()
    AceGUI:ClearFocus()
end



--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
    ["OnAcquire"] = function(self)
        self.frame:SetParent(UIParent)
        self.frame:SetFrameStrata("FULLSCREEN_DIALOG")
        self:Show()
    end,

    ["OnRelease"] = function(self)
    
    end,
    ["SetContentOffset"] = function(self, offx, offy)
        self.content:SetPoint("TOPLEFT", offx, offy)
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
    ["GetWidth"] = function(self, width)
        return self.frame:GetWidth()
    end,
--ffff
    ["GetBackdropBorderColor"] = function(self, backdropBorderColor)
        return self.frame:GetBackdropBorderColor()
    end,
    ["SetBackdropBorderColor"] = function(self, backdropBorderColor)
        self.frame:SetBackdropBorderColor(backdropBorderColor)
    end,
    
    ["GetBackdropColor"] = function(self, backdropColor)
        return self.frame:GetBackdropColor()
    end,
    ["SetBackdropColor"] = function(self, backdropColor)
        self.frame:SetBackdropColor(backdropColor)
    end,

    ["GetBackdrop"] = function(self, backdrop)
        return self.frame:GetBackdrop()
    end,
    ["SetBackdrop"] = function(self, backdrop)
        self.frame:SetBackdrop(backdrop)
    end,
--ffff
    ["Hide"] = function(self)
        self.frame:Hide()
    end,
    ["Show"] = function(self)
        self.frame:Show()
    end
}

--[[
-----------------------------------------------------------------------------
Constructor
-----------------------------------------------------------------------------
--]]

local FrameBackdrop = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
}

local function Constructor()
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:Hide()
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetResizable(true)
    frame:SetFrameStrata("FULLSCREEN_DIALOG")
    frame:SetBackdrop(FrameBackdrop)
    frame:SetBackdropColor(0, 0, 0, 1)
    frame:SetBackdropBorderColor(0.4, 0.4, 0.4)
    frame:SetMinResize(400, 500)
    frame:SetToplevel(true)
    frame:SetScript("OnShow", Frame_OnShow)
    frame:SetScript("OnHide", Frame_OnClose)
    frame:SetScript("OnMouseDown", Frame_OnMouseDown)    
    --Container Support
    local content = CreateFrame("Frame", nil, frame)
    content:SetPoint("TOPLEFT", 0, 0)
    content:SetPoint("BOTTOMRIGHT", 0,0)

    local widget = {
        content     = content,
        frame       = frame,
        type        = Type
    }
    for method, func in pairs(methods) do
        widget[method] = func
    end

    return AceGUI:RegisterAsContainer(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
