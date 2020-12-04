-- Author      : ketch
-- Create Date : 12/3/2020 6:46:23 PM


local addonname, NSCom = ...
local _G = getfenv(0)
local NS_MyWishList =_G.NS_MyWishList
local image_index = 1
function NS_MyWishList:DrawSourisGif(container)
    local MainFrame = CreateFrame("Frame",addonname.."_MFsourisGif", container.content)
    MainFrame:SetPoint("TOPLEFT",0,-17)
    MainFrame:SetPoint("BOTTOMRIGHT",0,30)
    MainFrame:SetToplevel(true);
    local content = "<html><body><h1>"..NS_MyWishList.versionName.."-"..NS_MyWishList.versionSubName.."</h1><br/><p align='center'>|cffee4400'Peace is a lie. There is only Passion.'|r</p><br/><p align='center'><img src='Interface\\AddOns\\WowAddon5\\rabbit1' height='32' width='32' align='right' /></p><br/><p>Peace is a lie. There is only Passion.<br/>Through Passion I gain Strength.<br/>Through Strength I gain Power.<br/>Through Power I gain Victory.<br/>Through Victory my chains are Broken.<br/>The Force shall free me.</p></body></html>"    --print(content)
    local TabAbout = CreateFrame("Frame", nil, container.content);
        TabAbout:SetPoint("TOPLEFT",0,-10)
        TabAbout:SetPoint("BOTTOMRIGHT",0,0)
    local TabAboutHtml = CreateFrame("SimpleHTML", nil, TabAbout);
        TabAboutHtml:SetPoint("TOPLEFT",0,0)
        TabAboutHtml:SetPoint("BOTTOMRIGHT",0,0)
        TabAboutHtml:SetText(content);
        TabAboutHtml:SetFont('Fonts\\FRIZQT__.TTF', 11);

    local sourisGif = CreateFrame("Frame",addonname.."_sourisGif", MainFrame)
    sourisGif:SetPoint("CENTER",-10,0)
    sourisGif:SetPoint("TOP",0,50)
    sourisGif:SetWidth(256)
    sourisGif:SetHeight(512)
    sourisGif:SetToplevel(true);
    sourisGif.images = {}
    for index=1, 49 do
        local texture_name = string.format("Interface\\AddOns\\"..addonname.."\\Images\\L%02d.nlp", index)
        local image = sourisGif:CreateTexture(nil,"ARTWORK");
        image:SetAllPoints(sourisGif);
        image:SetTexture(texture_name)
        image:Hide()
        sourisGif.images[index] = image
    end

    NS_MyWishList.changePic = (function()
        if image_index > 49 then
            sourisGif.images[49]:Hide()
            sourisGif.images[1]:Show()
            image_index = 1
        else
            if image_index > 1 then
                sourisGif.images[image_index-1]:Hide()
            end
            sourisGif.images[image_index]:Show()
        end
        image_index = image_index + 1
    end)
    NS_MyWishList.playAnim = (function(self)
        C_Timer.After(0.05, function()
            if MainFrame:IsShown() and MainFrame:IsVisible() then
                NS_MyWishList.changePic();
                NS_MyWishList.playAnim();
            end
        end)
    end)
    
    NS_MyWishList.changePic();
    NS_MyWishList.playAnim();
    MainFrame.sourisGif = sourisGif
    MainFrame.TabAboutHtml = TabAboutHtml
    return MainFrame
end
    