-- Author      : ketch
-- Create Date : 11/19/2020 12:54:22 PM
local addonname, NS_MyWishList = ...
local _G = getfenv(0)
local NS_MyWishList =_G.NS_MyWishList
local initialOptionsFrame


NS_MyWishList.MinimapBtn = LibStub("LibDataBroker-1.1"):NewDataObject(addonname, {
    type = "data source",
    text = addonname,
    icon = "Interface\\AddOns\\"..addonname.."\\Images\\yrabbit1",
    OnClick = function(self, button)
	    if (button == "LeftButton") then
            if fr_shown then
                if NS_MyWishList.frame then NS_MyWishList.frame:Hide() end
            else
                if NS_MyWishList.frame then NS_MyWishList.frame:Show() else NS_MyWishList:Show() end
            end 
            NS_MyWishList.mainFrameIsVisible = not NS_MyWishList.mainFrameIsVisible
        else
           
        end
    end,
    OnTooltipShow = function(tooltip)
        if not tooltip or not tooltip.AddLine then return end
        tooltip:AddLine(addonname)
    end,
})

function NS_MyWishList:Config_OnInitialize()
    if NS_MyWishList_Data_001.displayError == nil then
        NS_MyWishList_Data_001.displayError = {
            ["hide"] = false,
        }
    end
    --if NS_MyWishList_Data_001.displaySplash == nil then
    --    NS_MyWishList_Data_001.displaySplash = {
    --        ["hide"] = false,
    --    }
    --end 
    if NS_MyWishList_Data_001.displayOnly4Me == nil then
        NS_MyWishList_Data_001.displayOnly4Me = true
    end
    if NS_MyWishList_Data_001.minimapPos == nil then
        NS_MyWishList_Data_001.minimapPos = {
            ["minimapPos"] = 90,
            ["hide"] = false,
        }
    end
    --NS_MyWishList:Print("init")
    NS_MyWishList.icon:Register(addonname, NS_MyWishList.MinimapBtn , NS_MyWishList_Data_001.minimapPos)
end

function NS_MyWishList:Config_UpdateOptions()
    NS_MyWishList.AceRegistry:NotifyChange(addonname)
end

function NS_MyWishList:Config_Show()
    if( not InterfaceOptionsFrame:IsVisible() ) then
        InterfaceOptionsFrame_Show()
    end
    NS_MyWishList:Config_UpdateOptions()
    InterfaceOptionsFrame_OpenToCategory(initialOptionsFrame)
end

-- Setup the options frame parent
local containerFrame = CreateFrame("Frame", nil, InterfaceOptionsFrame)
    containerFrame.name = addonname
    containerFrame:SetScript("OnShow", function()
        NS_MyWishList:Config_Show() 
    end)

    containerFrame:Hide()
InterfaceOptions_AddCategory(containerFrame)
NS_MyWishList.version = GetAddOnMetadata(addonname, "Version")
-- Create the options menu child frames
NS_MyWishList.options = {
    type = "group",
    name = format("%s |cffADFF2F%s|r", addonname, NS_MyWishList.version),
    args = {
        general = {
            type = "group",
            order = 1,
            name = "General",
            set = function(info, value)
                --NS_MyWishList_Data_001.db.profile[info[#(info)]] = value
            end,
            get = function(info)
                --return v--NS_MyWishList_Data_001.db.profile[info[#(info)]]
            end,
            args = {
                hideMinimap = {
                    order = 1,
                    type = "toggle",
                    name = "Hide minimap button",
                    desc = "Hide the minimap button.",
                    width = "full",
                    set = function(info, value)
                        NS_MyWishList_Data_001.minimap.hide = not NS_MyWishList_Data_001.minimap.hide
                        local LDI = LibStub("LibDBIcon-1.0", true)
                        if( LDI ) then
                            if( NS_MyWishList_Data_001.minimap.hide ) then
                                LDI:Hide("NS_MyWishList!")
                            else
                                LDI:Show("NS_MyWishList!")
                            end
                        end
                    end,
                    get = function(info)
                        return NS_MyWishList_Data_001.minimap.hide
                    end,
                },
                displayError = {
                    order = 2,
                    type = "toggle",
                    name = "Display errors",
                    desc = "Display error from com data.",
                    width = "full",
                    set = function(info, value)
                        NS_MyWishList_Data_001.displayError.hide = not NS_MyWishList_Data_001.displayError.hide
                    end,
                    get = function(info)
                        return NS_MyWishList_Data_001.displayError.hide
                    end,
                },
                displayOnly4Me = {
                    order = 3,
                    type = "toggle",
                    name = "Display only wearable items",
                    desc = "Display only items that you can equip or use.",
                    width = "full",
                    set = function(info, value)
                        NS_MyWishList_Data_001.displayOnly4Me = not NS_MyWishList_Data_001.displayOnly4Me
                    end,
                    get = function(info)
                        return NS_MyWishList_Data_001.displayOnly4Me
                    end,
                },
            }
        },
    },
}

NS_MyWishList.AceConfig:RegisterOptionsTable(addonname, NS_MyWishList.options)
initialOptionsFrame = NS_MyWishList.AceConfigDialog:AddToBlizOptions(addonname, NS_MyWishList.options.args.general.name, addonname, "general")
--hooksecurefunc("InterfaceOptionsList_DisplayPanel", NS_MyWishList.UpdateDistancePanel) -- navigating to MaxCam panel
--InterfaceOptionsFrame:HookScript("OnShow", NS_MyWishList.UpdateDistancePanel) -- opening straight to MaxCam panel




