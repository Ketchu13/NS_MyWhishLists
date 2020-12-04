-- Author      : ketch
-- Create Date : 12/1/2020 7:58:37 PM


local addonname, NS_MyWishList = ...
local _G = getfenv(0)
local NS_MyWishList =_G.NS_MyWishList


function NS_MyWishList:DrawItemsList(container, instance_id)
    local ItemsList = CreateFrame("Frame",addonname.."_ItemsList", container.content)
    ItemsList:SetSize(405,350);
    ItemsList:SetPoint("TOPLEFT",0,-17)
    ItemsList:SetToplevel(true);

    local c = NS_MyWishList.drk_lines
    local labelwhenH = ItemsList:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
        labelwhenH:SetPoint("TOPLEFT", 5,0)
        labelwhenH:SetPoint("TOPRIGHT",-5,0)
        labelwhenH:SetJustifyH("CENTER")
        labelwhenH:SetJustifyV("MIDDLE")
        labelwhenH:SetText("Tous Les Items Lootables")
        labelwhenH:SetHeight(19)
        local highlight1h = ItemsList:CreateTexture(nil, "HIGHLIGHT")
        highlight1h:SetAllPoints(labelwhenH)
        highlight1h:SetColorTexture(0.5, 0.5, 0.9, 0.8)
        highlight1h:SetBlendMode("ADD")
        local highlight1bgh = ItemsList:CreateTexture(nil, "BACKGROUND")
        highlight1bgh:SetAllPoints(labelwhenH)
        highlight1bgh:SetColorTexture(c.r, c.g, c.b, c.a)
        highlight1bgh:SetBlendMode("ADD")

    local backdrop1 = {
        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
        edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    }
    -- ScrollingMessageFrame
    local scrollMotherFrame = CreateFrame("Frame", addonname.."_Instance_"..instance_id.."_ItemList_ScrollMotherFrame", ItemsList)
    scrollMotherFrame:SetPoint("TOPLEFT", 0, -25)
    scrollMotherFrame:SetPoint("BOTTOMRIGHT", 0, 30)
    scrollMotherFrame:SetBackdrop(backdrop1)
    scrollMotherFrame:SetBackdropColor(0, 0, 0,0.5)
    scrollMotherFrame:SetBackdropBorderColor(0.8, 0, 0.8)

    local scrollFrame = CreateFrame("ScrollFrame", addonname.."_Instance_"..instance_id.."_ItemList_ScrollFrame", scrollMotherFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 5, -8)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 5)
    scrollFrame:EnableMouseWheel(true)
    scrollFrame:EnableMouse(true)

    local scrollbg2 = scrollFrame:CreateTexture(nil, "BACKGROUND")
    scrollbg2:SetAllPoints(scrollFrame.ScrollBar)
    scrollbg2:SetColorTexture(0, 0, 0, 0.9)

    ItemsList.cnt = CreateFrame("Frame", addonname.."_Instance_"..instance_id.."_ItemList_cnt", scrollFrame)
    ItemsList.cnt:SetPoint("TOPLEFT",scrollMotherFrame, "TOPLEFT", 0, 0)
    ItemsList.cnt:SetWidth(421)
    ItemsList.cnt:SetHeight(300)

    --NAME
    local labelTips1 = ItemsList:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        labelTips1:SetPoint("TOPLEFT", scrollMotherFrame,"BOTTOMLEFT",5, -5)
        labelTips1:SetJustifyH("LEFT")
        labelTips1:SetJustifyV("MIDDLE")
        labelTips1:SetText("Click Gauche pour ajouter l'item dans votre Wish liste")
        labelTips1:SetHeight(20)
        labelTips1:SetWidth(400)
    local labelTips2 = ItemsList:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        labelTips2:SetPoint("TOPLEFT", labelTips1,"BOTTOMLEFT",0, -5)
        labelTips2:SetJustifyH("LEFT")
        labelTips2:SetJustifyV("MIDDLE")
        labelTips2:SetText("Shift + Click Gauche pour cloner l'item dans votre WL |cFF555555(Unité X 2 max)|r")
        labelTips2:SetHeight(20)
        labelTips2:SetWidth(450)
    scrollFrame:SetScrollChild(ItemsList.cnt)

    ItemsList.scrollFrame = scrollFrame
    ItemsList.scrollMotherFrame = scrollMotherFrame

    pair_ = false

    return ItemsList
end

function NS_MyWishList:DrawMyWL(container, instance_id)
    local ItemsList = CreateFrame("Frame",addonname.."_MyList", container.content)
    ItemsList:SetSize(481,350);
    ItemsList:SetPoint("TOPLEFT",410,-17)
    ItemsList:SetToplevel(true);

    local c = NS_MyWishList.drk_lines
    local labelwhenH = ItemsList:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
        labelwhenH:SetPoint("TOPLEFT", 5,0)
        labelwhenH:SetPoint("TOPRIGHT", -5,0)
        labelwhenH:SetJustifyH("CENTER")
        labelwhenH:SetJustifyV("MIDDLE")
        labelwhenH:SetText("Votre Sélection")
        labelwhenH:SetHeight(19)
        local highlight1h = ItemsList:CreateTexture(nil, "HIGHLIGHT")
        highlight1h:SetAllPoints(labelwhenH)
        highlight1h:SetColorTexture(0.5, 0.5, 0.9, 0.8)
        highlight1h:SetBlendMode("ADD")
        local highlight1bgh = ItemsList:CreateTexture(nil, "BACKGROUND")
        highlight1bgh:SetAllPoints(labelwhenH)
        highlight1bgh:SetColorTexture(c.r, c.g, c.b, c.a)
        highlight1bgh:SetBlendMode("ADD")

    local backdrop1 = {
        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
        edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    }
    -- ScrollingMessageFrame
    local scrollMotherFrame = CreateFrame("Frame", addonname.."_Instance_"..instance_id.."_MyList_ScrollMotherFrame", ItemsList)
    scrollMotherFrame:SetPoint("TOPLEFT", 0, -25)
    scrollMotherFrame:SetPoint("BOTTOMRIGHT", 0, 30)
    scrollMotherFrame:SetBackdrop(backdrop1)
    scrollMotherFrame:SetBackdropColor(0, 0, 0,0.5)
    scrollMotherFrame:SetBackdropBorderColor(0.8, 0, 0.8)

    local scrollFrame = CreateFrame("ScrollFrame", addonname.."_Instance_"..instance_id.."_MyList_ScrollFrame", scrollMotherFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 5, -8)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 5)
    scrollFrame:EnableMouseWheel(true)
    scrollFrame:EnableMouse(true)

    local scrollbg2 = scrollFrame:CreateTexture(nil, "BACKGROUND")
    scrollbg2:SetAllPoints(scrollFrame.ScrollBar)
    scrollbg2:SetColorTexture(0, 0, 0, 0.9)

    ItemsList.cnt = CreateFrame("Frame", addonname.."_Instance_"..instance_id.."_MyList_cnt", scrollFrame)
    ItemsList.cnt:SetPoint("TOPLEFT",scrollMotherFrame, "TOPLEFT", 0, 0)
    ItemsList.cnt:SetWidth(421)
    ItemsList.cnt:SetHeight(300)


    scrollFrame:SetScrollChild(ItemsList.cnt)
            --close
    local closebutton = CreateFrame("Button", addonname.."save_button_"..instance_id, ItemsList, "UIPanelButtonTemplate")        
        closebutton:SetPoint("TOPRIGHT",scrollMotherFrame ,"BOTTOMRIGHT", 0, -5)
        closebutton:SetHeight(28)
        closebutton:SetWidth(100)
        closebutton:SetFrameLevel(9999)
        closebutton:EnableMouse(true)
        closebutton:SetScript("OnClick", function(self)
            NS_MyWishList:broadcast_MyWL(instance_id);
        end)
        closebutton:SetText("Envoyer")

    ItemsList.closebutton = closebutton
    ItemsList.scrollFrame = scrollFrame
    ItemsList.scrollMotherFrame = scrollMotherFrame
    return ItemsList
end

function NS_MyWishList:fillInstanceItems(ItemsList,instance_id, wl_target)
    if not ItemsList.cnt then print("error container is nil") end
    pair_ = false
    local ItemsButtons = {}
    local cpt_idx = 1

    local obj_name = addonname.."_Instance_"..instance_id.."_ItemList_cnt"
    if _G[obj_name] then
        _G[obj_name]:Hide()
        _G[obj_name] = nil
    end
    ItemsList.cnt = CreateFrame("Frame", addonname.."_Instance_"..instance_id.."_ItemList_cnt", ItemsList.scrollFrame)
    ItemsList.cnt:SetPoint("TOPLEFT",ItemsList.scrollMotherFrame, "TOPLEFT", 0, 0)
    ItemsList.cnt:SetWidth(421)
    ItemsList.cnt:SetHeight(300)
    ItemsList.scrollFrame:SetScrollChild(ItemsList.cnt)
    for k, itemid in ipairs(NS_MyWishList.Instances[instance_id]["items"]) do
        local name, _, quality, iLevel, reqLevel, item_type, item_subType, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemid)
        if name then
            local item_texture = GetItemIcon(itemid)
            local r, g, b, hex = GetItemQualityColor(quality)
            if _G[addonname.."whishButton"..itemid] then
                _G[addonname.."whishButton"..itemid]:Hide()
                _G[addonname.."whishButton"..itemid] = nil
            end
            local frameButton = CreateFrame("Button",addonname.."whishButton"..itemid,ItemsList.cnt)
                frameButton:SetPoint("TOPLEFT", ItemsList.cnt, "TOPLEFT", 5, 32-((32*cpt_idx-1)+2))
                frameButton:SetPoint("RIGHT", ItemsList.cnt, "RIGHT", -5, 0)
                frameButton:SetHeight(30)
                frameButton:EnableMouse(false)
                frameButton:SetScript("OnEnter", function(self)
                    PlaySoundFile("Sound/Interface/Iuiinterfacebuttona.Ogg");
                    GameTooltip:SetOwner(frameButton,"ANCHOR_CURSOR");
                    GameTooltip:ClearLines();
                    GameTooltip:SetItemByID(itemid);
                    GameTooltip:Show()
                    GameTooltip:SetItemByID(itemid);
                end)
                frameButton:SetScript("OnLeave", function(self)
                    GameTooltip:Hide()
                end)

                local Button_ = CreateFrame("Button",nil,frameButton)
                    Button_:SetWidth(30)
                    Button_:SetHeight(30)
                    Button_.icon = Button_:CreateTexture(nil,"ARTWORK");
                        Button_.icon:SetAllPoints();
                        Button_.icon:SetSize(28,28);
                        Button_.icon:SetTexture(item_texture);
                    Button_:SetPoint("TOPLEFT", frameButton, "TOPLEFT", 0, 0)

            --NAME
                local labelItemName = frameButton:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
                    labelItemName:SetPoint("TOPLEFT", Button_,"TOPRIGHT",5, -5)
                    labelItemName:SetJustifyH("LEFT")
                    labelItemName:SetJustifyV("MIDDLE")                    
                    labelItemName:SetText(name)
                    labelItemName:SetTextColor(r,g,b,1)
                    labelItemName:SetHeight(20)
                    labelItemName:SetWidth(300)

                local ButtonAdd = CreateFrame("Button",nil,frameButton)
                    ButtonAdd:SetWidth(30)
                    ButtonAdd:SetHeight(30)
                    ButtonAdd:Raise()
                    ButtonAdd:SetToplevel(true)
                    ButtonAdd.icon = ButtonAdd:CreateTexture(nil,"ARTWORK");
                        ButtonAdd.icon:SetAllPoints(ButtonAdd);
                        ButtonAdd.icon:SetSize(28,28);
                        ButtonAdd.icon:SetTexture("Interface\\AddOns\\"..addonname.."\\Images\\add_green.blp");
                    ButtonAdd:SetPoint("TOPLEFT", labelItemName,"TOPRIGHT",5, 5)
                    ButtonAdd:SetScript("OnClick", function(self, button)
                        --print("click")
                        local ad = NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]
                        local cpt_r = 0
                        local found1 = false
                        local found_twice1 = false
                        for k, v in pairs(NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]) do
                            cpt_r = cpt_r + 1
                           -- print("click k:"..k)
                           -- print("click v:"..v)
                            if v == itemid then
                                if found1 then 
                                    found_twice1 = true
                                end
                                found1 = true
                            end
                        end
                        if (not found1 or (found1 and button == "LeftButton" and IsShiftKeyDown())) and not found_twice1 then
                            NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]["prio_"..tostring(cpt_r+1)] = itemid
                        end
                        if found and not found_twice then
			                Button_.icon:SetVertexColor(0.5, 0, 0);
                            ButtonAdd.icon:SetVertexColor(0.5, 0, 0);
                            labelItemName:SetTextColor(0.8,0,0,1)
		                end
                        if found_twice then
			                Button_.icon:SetVertexColor(0.5, 0.5, 0.5);
                            ButtonAdd.icon:SetVertexColor(0.5, 0.5, 0.5);
                            labelItemName:SetTextColor(0.5,0.5,0.5,1)
		                end
                        if not found then
                            Button_.icon:SetVertexColor(1, 1, 1);
                            ButtonAdd.icon:SetVertexColor(1, 1, 1);
                            labelItemName:SetTextColor(r,g,b,1)
                        end
                        NS_MyWishList:fillMyWishList(instance_id)
                    end)
                local highlight = ButtonAdd:CreateTexture(nil, "HIGHLIGHT")
                    highlight:SetAllPoints(ButtonAdd)
                    highlight:SetTexture(136580) -- Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight
                    highlight:SetTexCoord(0, 1, 0.23, 0.77)
                    highlight:SetBlendMode("ADD")

                local found = false
                local found_twice = false
                for _, v in pairs(NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]) do
                    if v == itemid then
                        if found then 
                            found_twice = true
                        end
                        found = true
                    end
                end
                --print(cpt_r)
                if found and not found_twice then
			        Button_.icon:SetVertexColor(0.5, 0, 0);
                    ButtonAdd.icon:SetVertexColor(0.5, 0, 0);
                    labelItemName:SetTextColor(0.8,0,0,1)
                    highlight:SetTextColor(0.8,0,0,1)
		        end
                if found_twice then
			        Button_.icon:SetVertexColor(0.5, 0.5, 0.5);
                    ButtonAdd.icon:SetVertexColor(0.5, 0.5, 0.5);
                    labelItemName:SetTextColor(0.5,0.5,0.5,1)
                    highlight:SetTextColor(0.5,0.5,0.5,1)
		        end
                if not found then
                    Button_.icon:SetVertexColor(1, 1, 1);
                    ButtonAdd.icon:SetVertexColor(1, 1, 1);
                    labelItemName:SetTextColor(r,g,b,1)
                    highlight:SetTextColor(r,g,b,1)
                end

            frameButton.ButtonAdd = ButtonAdd
            ItemsButtons["ItemButton_"..instance_id.."_"..cpt_idx] = frameButton
            cpt_idx = cpt_idx + 1
        end
    end
end
function reSortWL(wl_table)
    local prio_count = 0
    for k, itemid in pairs(wl_table) do
        prio_count = prio_count + 1
    end
    local temp_wl_table = {}
    local new_index = 1
    for index = 1,prio_count+1 do
        if wl_table["prio_"..index] then
            temp_wl_table["prio_"..new_index] = wl_table["prio_"..index]
            new_index = new_index + 1
        else
            
        end
    end
    wl_table = temp_wl_table
    return wl_table
end
function NS_MyWishList:fillMyWishList(instance_id)
    --print("fillwl")
    local ItemsList = NS_MyWishList.currentWlTabMWL
    if not ItemsList then 
        --print("fillwlerrrrrrrrrrrrrrr")
        return
    end
    local obj_name = addonname.."_Instance_"..instance_id.."_MyList_cnt"
    if _G[obj_name] then
        _G[obj_name]:Hide()
        _G[obj_name] = nil
    end
    ItemsList.cnt = CreateFrame("Frame", addonname.."_Instance_"..instance_id.."_MyList_cnt", ItemsList.scrollFrame)
    ItemsList.cnt:SetPoint("TOPLEFT",ItemsList.scrollMotherFrame, "TOPLEFT", 0, 0)
    ItemsList.cnt:SetWidth(421)
    ItemsList.cnt:SetHeight(300)
    ItemsList.scrollFrame:SetScrollChild(ItemsList.cnt)

    if not ItemsList then print("error container is nil") end
    pair_ = false
    if not NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"] then 
        NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"] = {}
    end
    if not NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id] then 
        NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id] = {}
    end
    NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id] = reSortWL( NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id])
    pair_ = false
    local ItemsButtons = {}
    local prio_count = 0
    for k, itemid in pairs(NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]) do
        prio_count = prio_count + 1
    end
    --print("prio_count:"..prio_count)
    for index = 1,prio_count do
        local itemid = NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]["prio_"..tostring(index)]
        --print(itemid)
        if itemid then
            local name, _, quality, iLevel, reqLevel, item_type, item_subType, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemid)
            if name then
                --print(cpt_idx)
                
                local item_texture = GetItemIcon(itemid)
                local frameButton = CreateFrame("Button",nil,ItemsList.cnt)
                    frameButton:SetPoint("TOPLEFT", ItemsList.cnt, "TOPLEFT", 5, 32-((32*index-1)+2))
                    frameButton:SetPoint("RIGHT", ItemsList.cnt, "RIGHT", -5, 0)
                    --frameButton:SetWidth(30)
                    frameButton:SetHeight(30)
                    frameButton:EnableMouse(false)
                    frameButton:SetScript("OnEnter", function(self)
                        PlaySoundFile("Sound/Interface/Iuiinterfacebuttona.Ogg");
                        GameTooltip:SetOwner(frameButton,"ANCHOR_CURSOR");
                        GameTooltip:ClearLines();
                        GameTooltip:SetItemByID(itemid);
                        GameTooltip:Show()
                        GameTooltip:SetItemByID(itemid);
                    end)
                    frameButton:SetScript("OnLeave", function(self)
                        GameTooltip:Hide()
                    end)

                    local Button_ = CreateFrame("Button",nil,frameButton)
                        Button_:SetWidth(30)
                        Button_:SetHeight(30)
                        Button_.icon = Button_:CreateTexture(nil,"ARTWORK");
                            Button_.icon:SetAllPoints();
                            Button_.icon:SetSize(28,28);
                            Button_.icon:SetTexture(item_texture);
                        Button_:SetPoint("TOPLEFT", frameButton, "TOPLEFT", 0, 0)

                --NAME
                    local labelItemName = frameButton:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
                        labelItemName:SetPoint("TOPLEFT", Button_,"TOPRIGHT",5, -5)
                        labelItemName:SetJustifyH("LEFT")
                        labelItemName:SetJustifyV("MIDDLE")
                        local r, g, b, hex = GetItemQualityColor(quality)
                        labelItemName:SetText("|c"..hex..name.."|r")
                        labelItemName:SetHeight(20)
                        labelItemName:SetWidth(300)

                    local ButtonAdd = CreateFrame("Button",nil,frameButton)
                        ButtonAdd:SetWidth(30)
                        ButtonAdd:SetHeight(30)
                        ButtonAdd:Raise()
                        ButtonAdd:SetToplevel(true)
                        ButtonAdd.icon = ButtonAdd:CreateTexture(nil,"ARTWORK");
                            ButtonAdd.icon:SetAllPoints(ButtonAdd);
                            ButtonAdd.icon:SetSize(28,28);
                            ButtonAdd.icon:SetTexture("Interface\\AddOns\\"..addonname.."\\Images\\remove_red.blp");
                        ButtonAdd:SetPoint("TOPLEFT", labelItemName,"TOPRIGHT",5, 5)
                        ButtonAdd:SetScript("OnClick", function(self)
                           -- print("click")
                            local cpt_r = 0
                            local found = false
                            local index_ = 0
                            for k, v in pairs(NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]) do
                                cpt_r = cpt_r + 1
                                --print("click k:"..k)
                                --print("click v:"..v)
                                if v then
                                    if tonumber(v) == tonumber(itemid) then
                                        found = true
                                        index_ = k
                                    end
                                end
                                
                            end
                            --print(cpt_r)
                            if found then
                                NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id][index_] = nil
                            end

                            NS_MyWishList:fillMyWishList(instance_id)
                        end)
                        local highlight = ButtonAdd:CreateTexture(nil, "HIGHLIGHT")
                            highlight:SetAllPoints(ButtonAdd)
                            highlight:SetTexture(136580) -- Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight
                            highlight:SetTexCoord(0, 1, 0.23, 0.77)
                            highlight:SetBlendMode("ADD")
                    local backdrop1 = {
                        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
                        edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
                        insets = { left = 4, right = 4, top = 4, bottom = 4 }
                    }
                    local itemPrioFrame = CreateFrame("Frame",nil,frameButton)
                        itemPrioFrame:SetPoint("TOPLEFT", ButtonAdd,"TOPRIGHT",5, 0)
                        itemPrioFrame:SetWidth(30)
                        itemPrioFrame:SetHeight(30)
                        itemPrioFrame:SetBackdrop(backdrop1)
                        itemPrioFrame:SetBackdropColor(0, 0, 0,0.5)
                        itemPrioFrame:SetBackdropBorderColor(0.8, 0, 0.8)

                    local labelItemprio = itemPrioFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                        labelItemprio:SetPoint("TOPLEFT", itemPrioFrame,"TOPLEFT",0,0)
                        labelItemprio:SetJustifyH("CENTER")
                        labelItemprio:SetJustifyV("MIDDLE")
                        labelItemprio:SetText(index)
                        labelItemprio:SetHeight(30)
                        labelItemprio:SetWidth(30)

                    local itemPrioUpDwnFrame = CreateFrame("Frame",nil,frameButton)
                        itemPrioUpDwnFrame:SetPoint("TOPLEFT", itemPrioFrame,"TOPRIGHT",5, 0)
                        itemPrioUpDwnFrame:SetWidth(30)
                        itemPrioUpDwnFrame:SetHeight(30)


                    local ButtonUp = CreateFrame("Button",nil,itemPrioUpDwnFrame)
                        ButtonUp:SetWidth(30)
                        ButtonUp:SetHeight(15)
                        ButtonUp:Raise()
                        ButtonUp:SetToplevel(true)
                        ButtonUp.icon = ButtonUp:CreateTexture(nil,"ARTWORK");
                            ButtonUp.icon:SetAllPoints(ButtonUp);
                            ButtonUp.icon:SetSize(30,15);
                            ButtonUp.icon:SetTexture("Interface\\AddOns\\"..addonname.."\\Images\\Updown.blp");
                            ButtonUp.icon:SetTexCoord(0, 1, 0.5, 1)
                        ButtonUp:SetPoint("TOPLEFT",0,0)
                        ButtonUp:SetScript("OnClick", function(self)
                            local toDwn =  NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]["prio_"..tostring(index-1)]
                            --print("toDwn: "..toDwn)
                            NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]["prio_"..tostring(index-1)] = itemid
                            --print("toDwn: "..toDwn)
                            NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]["prio_"..tostring(index)] = toDwn
                            --print("toDwn: "..toDwn)
                            NS_MyWishList:fillMyWishList(instance_id)
                        end)
                        local highlight = ButtonUp:CreateTexture(nil, "HIGHLIGHT")
                            highlight:SetAllPoints(ButtonUp)
                            highlight:SetTexture(136580) -- Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight
                            highlight:SetTexCoord(0, 1, 0.23, 0.77)
                            highlight:SetBlendMode("ADD")
                    
                    local ButtonDwn = CreateFrame("Button",nil,itemPrioUpDwnFrame)
                        ButtonDwn:SetWidth(30)
                        ButtonDwn:SetHeight(15)
                        ButtonDwn:Raise()
                        ButtonDwn:SetToplevel(true)
                        ButtonDwn.icon = ButtonAdd:CreateTexture(nil,"ARTWORK");
                            ButtonDwn.icon:SetAllPoints(ButtonDwn);
                            ButtonDwn.icon:SetSize(30,15);
                            ButtonDwn.icon:SetTexture("Interface\\AddOns\\"..addonname.."\\Images\\Updown.blp");
                            ButtonDwn.icon:SetTexCoord(0, 1, 0, 0.5)
                        ButtonDwn:SetPoint("TOPLEFT",0,-15)
                        ButtonDwn:SetScript("OnClick", function(self)
                            local toUp =  NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]["prio_"..tostring(index+1)]
                            --print("toUp: "..toUp)
                            NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]["prio_"..tostring(index+1)] = itemid
                           -- print("toUp: "..toUp)
                            NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]["prio_"..tostring(index)] = toUp
                            --print("toUp: "..toUp)
                            NS_MyWishList:fillMyWishList(instance_id)
                        end)
                        local highlight = ButtonDwn:CreateTexture(nil, "HIGHLIGHT")
                            highlight:SetAllPoints(ButtonDwn)
                            highlight:SetTexture(136580) -- Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight
                            highlight:SetTexCoord(0, 1, 0.23, 0.77)
                            highlight:SetBlendMode("ADD")
                frameButton.ButtonAdd = ButtonAdd
                --ItemsButtonds["ItemButton_"..instance_id.."_"..cpt_idx] = frameButton

            end
        end
    end
end
