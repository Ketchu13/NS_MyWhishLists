-- Author      : ketch
-- Create Date : 12/1/2020 8:29:13 PM


local addonname, NSCom = ...
local _G = getfenv(0)
local NS_MyWishList =_G.NS_MyWishList

-- Get the toc version of the current addon
function NS_MyWishList:GetClientVersion()
    local version = NS_MyWishList.version;
    local major, minor, patch = strsplit(".", version);
    local c_version = ((10000 * major) + (100 * minor) + (patch));
    local client_ = {}
    client_.version_str = version
    client_.version = c_version
    return client_
end

-- Check if current addon version is up to date (if < logged versions)
function NS_MyWishList:newVersionAvailable()
    local Curr_version = NS_MyWishList:GetClientVersion()
    for _, client in ipairs(NS_MyWishList_Data_001["clients_versions"]) do
        if client.version > Curr_version.version then
            NS_MyWishList:displayAvUpdt(client)
            return
        end
    end
end

--Display an alert
function NS_MyWishList:displayAvUpdt(new_version)
    local client = NS_MyWishList.version

    if not new_version == nill and not client == nil then
        local frame = AceGUI:Create("FrameExt")
            frame:SetTitle(NS_MyWishList.versionName)
            frame:SetCallback("OnClose", function(widget)
                AceGUI:Release(widget)
            end)
            frame:SetLayout("Fill")
            frame:SetHeight(150)
            frame:SetHeight(400)
            frame:Show()
            local statustext = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                statustext:SetPoint("TOPLEFT", 7, -2)
                statustext:SetPoint("BOTTOMRIGHT", -7, 2)
                statustext:SetHeight(20)
                statustext:SetJustifyH("CENTER")
                statustext:SetText("Une mise à jour est disponible..\nVotre version: "..new_version.version_str.." Version disponible: "..client.version_str)
                statustext:Show()
    end
end