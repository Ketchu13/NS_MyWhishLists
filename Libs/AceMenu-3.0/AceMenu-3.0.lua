--- AceMenu-3.0 provides event registration and secure dispatching.
--
-- **AceMenu-3.0** can be embeded into your addon, either explicitly by calling AceEvent:Embed(MyAddon) or by
-- specifying it as an embeded library in your AceAddon. All functions will be available on your addon object
-- and can be accessed directly, without having to explicitly call AceEvent itself.\\
-- It is recommended to embed AceEvent, otherwise you'll have to specify a custom `self` on all calls you
-- make into AceEvent.
-- @class file
-- @name AceMenu-3.0
-- @release $Id: AceMenu-3.0.lua 0001 2020-03-08 02:13:58Z hotcandy $

local MAJOR, MINOR = "AceMenu-3.0", 1 -- Bump minor on changes
local AceMenu = LibStub:NewLibrary(MAJOR, MINOR)
AceMenu.embeds = AceMenu.embeds or {}
if not AceMenu then return end -- No upgrade needed

-- Lua APIs
local tinsert = table.insert
local select, pairs, next, type = select, pairs, next, type
local error, assert = error, assert
local setmetatable, rawget = setmetatable, rawget
local math_max = math.max

-- WoW APIs
local UIParent = UIParent

function AceMenu:New()
    local ret = {}
    
    -- set the defaults
    ret.menuList = {}
    ret.anchor = 'cursor'; -- default at the cursor
    ret.x = nil;
    ret.y = nil;
    ret.displayMode = 'MENU'; -- default
    ret.autoHideDelay = nil;
    ret.menuFrame = nil; -- If not defined, :Show() will create a generic menu frame
    ret.uniqueID = 1

    -- import the functions
    for k,v in pairs(self) do
        ret[k] = v
    end
    
    -- return a copy of the class
    return ret
end

--[[
    Return the index where "text" lives.
    ; text : The text to search for.
--]]
function AceMenu:GetItemByText(text)
    for k,v in pairs(self.menuList) do
        if v.text == text then
            return k
        end
    end
end

--[[
    Add menu items
    ; text : The display text.
    ; func : The function to execute OnClick.
    ; isTitle : 1 if this is a header (usually the first one)
    returns the last index of the menu item that was just added.
--]]
function AceMenu:AddItem(text, func, isTitle)
    local info = {}
    
    info["text"] = text
    info["isTitle"] = isTitle    
    info["func"] = func

    table.insert(self.menuList, info)
    return #self.menuList
end

--[[
    Set an attribute for the menu item.
    Valid attributes are found in the FrameXML\UIDropDownMenu.lua file with their valid values.
    Arbitrary non-official attributes are allowed, but are only useful if you plan to access them with :GetAttribute().
    ; text : The text of the menu item or index of the menu item.
    ; attribute : Set this attribute to "value".
    ; value : The value to set the attribute to.
--]]
function AceMenu:SetAttribute(text, attribute, value)
    self.menuList[self:GetItemByText(text) or (self.menuList[text] and text) or 1][attribute or "uniqueID"] = value
end

--[[
    Get an attribute for the menu item.
    Valid attributes are found in the FrameXML\UIDropDownMenu.lua file with their valid values or any arbitrary attribute set with :SetAttribute().
    ; text : The text of the menu item or index of the menu item.
    ; attribute : Get this attribute.
--]]
function AceMenu:GetAttribute(text, attribute)
    return self.menuList[self:GetItemByText(text) or (self.menuList[text] and text) or 1][attribute or "uniqueID"]
end

--[[
    Remove the first item matching "text"
    ; text : The text to search for.
--]]
function AceMenu:RemoveItem(text)
    table.remove(self.menuList, self:GetItemByText(text))
end

--[[
    ; anchor : Set the anchor point. 
--]]
function AceMenu:SetAnchor(anchor)
    if anchor ~= 'cursor' then
        self.x = 0
        self.y = 0
    end
    self.anchor = anchor
end

--[[
    ; displayMode : "MENU"
--]]
function AceMenu:SetDisplayMode(displayMode)
    self.displayMode = displayMode
end

--[[
    ; autoHideDelay : How long, without a click, before the menu goes away.
--]]
function AceMenu:SetAutoHideDelay(autoHideDelay)
    self.autoHideDelay = tonumber(autoHideDelay)
end

--[[
    ; menuFrame : Should inherit a Drop Down Menu template.
--]]
function AceMenu:SetMenuFrame(menuFrame)
    self.menuFrame = menuFrame
end

function AceMenu:GetMenuList()
    return self.menuList
end

--[[
    ; x : X position
    ; save : When not nil, will add to the current value rather than replace it
--]]
function AceMenu:SetX(x, save)
    if save then
        self.x = self.x + x
    else
        self.x = x
    end
end

--[[
    ; y : Y position
    ; save : When not nil, will add to the current value rather than replace it
--]]
function AceMenu:SetY(y, save)
    if save then
        self.y = self.y + y
    else
        self.y = y
    end
end

function AceMenu:Activate()
    if not self.menuFrame then
        while _G['GenericAceMenuFrame'..self.uniqueID] do -- ensure that there's no namespace collisions
            self.uniqueID = self.uniqueID + 1
        end
        -- the frame must be named for some reason
        self.menuFrame = CreateFrame('Frame', 'GenericAceMenuFrame'..self.uniqueID, UIParent, "UIDropDownMenuTemplate")
    end
    self.menuFrame.menuList = self.menuList
end

--[[
    Show the menu.
--]]
function AceMenu:Show()
    self:Activate()
    EasyMenu(self.menuList, self.menuFrame, self.anchor, self.x, self.y, self.displayMode, self.autoHideDelay)
end
-- Embeds AceBucket into the target object making the functions from the mixins list available on target:..
-- @param target target object to embed AceBucket in
function AceMenu:Embed( target )
    for _, v in pairs( mixins ) do
        target[v] = self[v]
    end
    self.embeds[target] = true
    return target
end
