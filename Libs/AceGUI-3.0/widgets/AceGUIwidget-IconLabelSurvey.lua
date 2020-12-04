--[[-----------------------------------------------------------------------------
Icon Widget
-------------------------------------------------------------------------------]]
local Type, Version = "IconLabelSurvey", 21
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
        self:SetDisabled(false)
    end,

    -- ["OnRelease"] = nil,

    ["SetDisabled"] = function(self, disabled)
        self.disabled = disabled
        if disabled then
            self.frame:Disable()
        else
            self.frame:Enable()
        end
    end,

    -- ["OnRelease"] = nil,

    ["SetItem"] = function(self, item)
        self.button:SetImage(GetItemIcon(item.itemid))    
        self.button:SetLabel(item.name)    
        self.button:SetExtra(item.forname)
        local _, itemLink = GetItemInfo(item.itemid)
        self.button:SetCallback("OnClick", function(widget, event, button, down)
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
        self.button:SetCallback("OnEnter", function(widget)
            PlaySoundFile("Sound/Interface/Iuiinterfacebuttona.Ogg");
            GameTooltip:SetOwner(widget.frame, "ANCHOR_CURSOR");
            GameTooltip:ClearLines();
            GameTooltip:SetItemByID(item.itemid);
            GameTooltip:AddLine("\nPrio: " .. item.forname, 1, 0, 1)
            GameTooltip:Show()
            GameTooltip:SetItemByID(item.itemid);
            GameTooltip:AddLine("\nPrio: " .. item.forname, 1, 0.5, 1)
            GameTooltip:Show()
            -- GameTooltip:SetItemByID(item.itemid);
        end)
    end,

    -- ["OnRelease"] = nil,

    ["SetUsers"] = function(self, users)
        self.users = users
        if disabled then
            self.frame:Disable()
        else
            self.frame:Enable()
        end
    end,
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
    local frame = AceGUI:Create("FrameExt")
    frame:SetTitle("NS Loot Survey")
    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    -- Fill Layout - the TabGroup widget will fill the whole frame
    frame:SetLayout("Flow")
    frame:Show()

    local button = AceGUI:Create("IconLabel")
    button:SetImageSize(26, 26)
    
    button:SetLabel("Aucun")
    button:SetExtra("Personne")
    button:SetCallback("OnLeave", function(widget) GameTooltip:Hide() end)
    
    local anchor = "TOPLEFT"
    button:SetPoint(anchor)

    frame:AddChild(button)

    local scrollFrame = AceGUI:Create("ScrollFrameExt")
    scrollFrame:SetPoint("TOPLEFT", 0, 0)
    scrollFrame:SetHeight("BOTTOMRIGHT", -30, 30)

    frame:AddChild(scrollFrame)


    local widget = {
        scrollFrame = scrollFrame,
        button = button,
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
