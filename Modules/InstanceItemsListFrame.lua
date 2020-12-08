-- Author      : ketch
-- Create Date : 12/1/2020 7:58:37 PM


local addonname, NS_MyWishList = ...
local _G = getfenv(0)
local NS_MyWishList =_G.NS_MyWishList


function NS_MyWishList:DrawItemsList(container, instance_id)
    if not NS_MyWishList_Data_001["config"] then NS_MyWishList_Data_001["config"] = {} end
    if not NS_MyWishList_Data_001["config"][instance_id] then NS_MyWishList_Data_001["config"][instance_id] = {} end
    if NS_MyWishList_Data_001["config"][instance_id]["UsableOnly"] == nil then
        NS_MyWishList_Data_001["config"][instance_id]["UsableOnly"] = true
    end
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

    pair_ = false
    --menu quality bouton===================================================================
    local menuLootQuality = CreateFrame("Frame", nil, ItemsList)
        menuLootQuality:SetSize(60, 26)
        menuLootQuality:SetPoint("TOPLEFT",scrollMotherFrame,"BOTTOMLEFT", 0,-3)

    local tleft = menuLootQuality:CreateTexture(nil, "BACKGROUND")
        tleft:SetSize(25,64)
        tleft:SetPoint("TOPLEFT", -18,18)
        tleft:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
        tleft:SetTexCoord(0, 0.1953125, 0, 1)
        
    local tmid = menuLootQuality:CreateTexture(nil, "BACKGROUND")
        tmid:SetSize(60,64)
        tmid:SetPoint("LEFT", tleft, "RIGHT",0,0)
        tmid:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
        tmid:SetTexCoord(0.1953125, 0.8046875, 0, 1)

    local tright = menuLootQuality:CreateTexture(nil, "BACKGROUND")
        tright:SetSize(25,64)
        tright:SetPoint("LEFT", tmid, "RIGHT",0,0)
        tright:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
        tright:SetTexCoord(0.8046875, 1, 0, 1)

    ItemsList.menuLootQuality = menuLootQuality

    local lootQualityDropmenu_str = ItemsList.menuLootQuality:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        lootQualityDropmenu_str:SetSize(100,10)
        lootQualityDropmenu_str:SetPoint("LEFT",tleft,"RIGHT",-15, 2)

    ItemsList.lootQualityDropmenu_str = lootQualityDropmenu_str

    ItemsList.menuLootQuality.text = (function (self, value) ItemsList.lootQualityDropmenu_str:SetText(value) end)
    if not NS_MyWishList_Data_001["config"][instance_id] then
        NS_MyWishList_Data_001["config"][instance_id] = {}
    end
    if not NS_MyWishList_Data_001["config"][instance_id]["itemQuality"] then
        NS_MyWishList_Data_001["config"][instance_id]["itemQuality"] = 0
    end
    local iv = NS_MyWishList_Data_001["config"][instance_id]["itemQuality"]
    if not iv then error("Something is going bad..") end
    local r, g, b, hex = GetItemQualityColor(iv)
    local color = "|c"..hex
    local colorend = "|r"
    ItemsList.menuLootQuality.text(self,(color.._G["ITEM_QUALITY"..iv.. "_DESC"]..colorend) or "Qualities:")
    ItemsList.menuLootQuality:SetScript("OnMouseUp", function(self)
        if ItemsList.lootQualityDropdown then
            ItemsList.lootQualityDropdown:Close()
        end
        if ItemsList.lootSlotDropdown then
            ItemsList.lootSlotDropdown:Close()
        end
        if ItemsList.lootTypeDropdown then
            ItemsList.lootTypeDropdown:Close()
        end
        local lootQualityDropdown = NS_MyWishList.AceGUI:Create("Dropdown-Pullout")
        lootQualityDropdown:SetWidth(110)
        local header = NS_MyWishList.AceGUI:Create("Dropdown-Item-Header")
        header:SetText("Qualities:")
        lootQualityDropdown:AddItem(header)
        lootQualityDropdown:AddItem(header)
        --lootQualityDropdown = NS_MyWishList.AceGUI:Create("Dropdown-Pullout")
        local itemsQuality = {}
        for i= 0, 7 do
            local r, g, b, hex = GetItemQualityColor(i)
            local qualityName = _G["ITEM_QUALITY" .. i .. "_DESC"]
            local colorend = "|r"
            local color = "|c"..hex
            local btn1 = NS_MyWishList.AceGUI:Create("Dropdown-Item-Execute")
            btn1:SetText((color.._G["ITEM_QUALITY"..i.. "_DESC"]..colorend))

            btn1:SetCallback("OnClick", function(self)
                container:ReleaseChildren()
                --self:SetText(color..qualityName..colorend)
                if not NS_MyWishList_Data_001["config"] then NS_MyWishList_Data_001["config"] = {} end
                if not NS_MyWishList_Data_001["config"][instance_id] then NS_MyWishList_Data_001["config"][instance_id] = {} end
                NS_MyWishList_Data_001["config"][instance_id]["itemQuality"] = i
                ItemsList.menuLootQuality.text(self, (color.._G["ITEM_QUALITY"..i.. "_DESC"]..colorend))
                NS_MyWishList:fillInstanceItems(ItemsList,instance_id)
                lootQualityDropdown:Close()
            end)
            lootQualityDropdown:AddItem(btn1)
        end
        local btn1 = NS_MyWishList.AceGUI:Create("Dropdown-Item-Execute")
        btn1:SetText(CLOSE)
        btn1:SetCallback("OnClick", function(self)
            container:ReleaseChildren()
            lootQualityDropdown:Close()
        end)
        lootQualityDropdown:AddItem(btn1)
        lootQualityDropdown:Open("TOP", self, "BOTTOM", 0, 5)
        lootQualityDropdown.frame:SetParent(self:GetParent())
        self:GetParent().lootQualityDropdown = lootQualityDropdown
    end)
    --menu Type bouton=================================================================
    local menuLootType = CreateFrame("Frame", nil, ItemsList)
        menuLootType:SetSize(60, 26)
        menuLootType:SetPoint("TOPLEFT",ItemsList.menuLootQuality,"TOPRIGHT", 40, 0)

    local tleft = menuLootType:CreateTexture(nil, "BACKGROUND")
        tleft:SetSize(25,64)
        tleft:SetPoint("TOPLEFT", -18,18)
        tleft:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
        tleft:SetTexCoord(0, 0.1953125, 0, 1)
        
    local tmid = menuLootType:CreateTexture(nil, "BACKGROUND")
        tmid:SetSize(60,64)
        tmid:SetPoint("LEFT", tleft, "RIGHT",0,0)
        tmid:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
        tmid:SetTexCoord(0.1953125, 0.8046875, 0, 1)

    local tright = menuLootType:CreateTexture(nil, "BACKGROUND")
        tright:SetSize(25,64)
        tright:SetPoint("LEFT", tmid, "RIGHT",0,0)
        tright:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
        tright:SetTexCoord(0.8046875, 1, 0, 1)

    ItemsList.menuLootType = menuLootType

    local lootTypeDropmenu_str = ItemsList.menuLootType:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        lootTypeDropmenu_str:SetSize(100,10)
        lootTypeDropmenu_str:SetPoint("LEFT",tleft,"RIGHT",-15, 2)

    ItemsList.lootTypeDropmenu_str = lootTypeDropmenu_str
    local TypeName1 = {[-1] = "Tous..", [2] = "Armes", [4] = "Armures"}
    ItemsList.menuLootType.text = (function (self, value) ItemsList.lootTypeDropmenu_str:SetText(value) end)
    text_ = "Types:"
    for k,v in pairs(TypeName1) do
        if k == NS_MyWishList_Data_001["config"][instance_id]["itemType"] then
            text_ = v
            break
        end
    end
    ItemsList.menuLootType.text(self,text_)
    ItemsList.menuLootType:SetScript("OnMouseUp", function(self)
        if ItemsList.lootQualityDropdown then
            ItemsList.lootQualityDropdown:Close()
        end
        if ItemsList.lootSlotDropdown then
            ItemsList.lootSlotDropdown:Close()
        end
        if ItemsList.lootTypeDropdown then
            ItemsList.lootTypeDropdown:Close()
        end
        local lootTypeDropdown = NS_MyWishList.AceGUI:Create("Dropdown-Pullout")
        lootTypeDropdown:SetWidth(110)
        local header = NS_MyWishList.AceGUI:Create("Dropdown-Item-Header")
        header:SetText(NS_MyWishList_Data_001["config"][instance_id]["itemType"] or "Types:")
        lootTypeDropdown:AddItem(header)
        lootTypeDropdown = NS_MyWishList.AceGUI:Create("Dropdown-Pullout")
        local itemsType = {}
        for idx_type, type_ in pairs(TypeName1) do
            local color = "|cFFAAAAAA"
            local btn1 = NS_MyWishList.AceGUI:Create("Dropdown-Item-Execute")
            btn1:SetText(color..type_..colorend)
            btn1:SetCallback("OnClick", function(self)
                container:ReleaseChildren()
                self:SetText(color..type_..colorend)
                if not NS_MyWishList_Data_001["config"] then NS_MyWishList_Data_001["config"] = {} end
                if not NS_MyWishList_Data_001["config"][instance_id] then NS_MyWishList_Data_001["config"][instance_id] = {} end
                NS_MyWishList_Data_001["config"][instance_id]["itemType"] = idx_type
                ItemsList.menuLootType.text(self, color..type_..colorend)
                NS_MyWishList:fillInstanceItems(ItemsList,instance_id)
                lootTypeDropdown:Close()
            end)
            lootTypeDropdown:AddItem(btn1)
        end
        lootTypeDropdown:Open("TOP", self, "BOTTOM", 0, 5)
        lootTypeDropdown.frame:SetParent(self:GetParent())
        ItemsList.lootTypeDropdown = lootTypeDropdown
    end)
    ItemsList:SetScript("OnEnter", function(self)
        if ItemsList.lootTypeDropdown then
            ItemsList.lootTypeDropdown:Close()
        end
    end)
    --menu slot bouton============================================================
    local menuLootSlot = CreateFrame("Frame", nil, ItemsList)
        menuLootSlot:SetSize(60, 26)
        menuLootSlot:SetPoint("TOPLEFT",ItemsList.menuLootType,"TOPRIGHT", 40, 0)

    local tleft = menuLootSlot:CreateTexture(nil, "BACKGROUND")
        tleft:SetSize(25,64)
        tleft:SetPoint("TOPLEFT", -18,18)
        tleft:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
        tleft:SetTexCoord(0, 0.1953125, 0, 1)
        
    local tmid = menuLootSlot:CreateTexture(nil, "BACKGROUND")
        tmid:SetSize(60,64)
        tmid:SetPoint("LEFT", tleft, "RIGHT",0,0)
        tmid:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
        tmid:SetTexCoord(0.1953125, 0.8046875, 0, 1)

    local tright = menuLootSlot:CreateTexture(nil, "BACKGROUND")
        tright:SetSize(25,64)
        tright:SetPoint("LEFT", tmid, "RIGHT",0,0)
        tright:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
        tright:SetTexCoord(0.8046875, 1, 0, 1)

    ItemsList.menuLootSlot = menuLootSlot

    local lootSlotDropmenu_str = ItemsList.menuLootSlot:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        lootSlotDropmenu_str:SetSize(100,10)
        lootSlotDropmenu_str:SetPoint("LEFT",tleft,"RIGHT",-15, 2)

    ItemsList.lootSlotDropmenu_str = lootSlotDropmenu_str

    ItemsList.menuLootSlot.text = (function (self, value) ItemsList.lootSlotDropmenu_str:SetText(value) end)
    text_ = "Slots:"
    for idx_slot, slot_text in pairs(NS_MyWishList.Slots) do
        if idx_slot == NS_MyWishList_Data_001["config"][instance_id]["SlotSelected"] then
            text_ = slot_text
            break
        end
    end
    ItemsList.menuLootSlot.text(self,text_)
    ItemsList.menuLootSlot:SetScript("OnMouseUp", function(self)
        if ItemsList.lootQualityDropdown then
            ItemsList.lootQualityDropdown:Close()
        end
        if ItemsList.lootSlotDropdown then
            ItemsList.lootSlotDropdown:Close()
        end
        if ItemsList.lootTypeDropdown then
            ItemsList.lootTypeDropdown:Close()
        end
        local lootSlotDropdown = NS_MyWishList.AceGUI:Create("Dropdown-Pullout")
        lootSlotDropdown:SetWidth(110)
        local header = NS_MyWishList.AceGUI:Create("Dropdown-Item-Header")
        header:SetText(NS_MyWishList_Data_001["config"][instance_id]["SlotSelected"] or "Slots:")
        lootSlotDropdown:AddItem(header)
        lootSlotDropdown = NS_MyWishList.AceGUI:Create("Dropdown-Pullout")
        local itemsSlot = {}
        for idx_slot, slot_text in pairs(NS_MyWishList.Slots) do
            local btn1 = NS_MyWishList.AceGUI:Create("Dropdown-Item-Execute")
            btn1:SetText(slot_text)
            btn1:SetCallback("OnClick", function(self)     
                container:ReleaseChildren()
                self:SetText(slot_text)
                if not NS_MyWishList_Data_001["config"] then NS_MyWishList_Data_001["config"] = {} end
                if not NS_MyWishList_Data_001["config"][instance_id] then NS_MyWishList_Data_001["config"][instance_id] = {} end
                NS_MyWishList_Data_001["config"][instance_id]["SlotSelected"] = idx_slot
                ItemsList.menuLootSlot.text(self, slot_text)
                lootSlotDropdown:Close()
                NS_MyWishList:fillInstanceItems(ItemsList,instance_id)
            end)
            lootSlotDropdown:AddItem(btn1)
        end
        lootSlotDropdown:Open("TOP", self, "BOTTOM", 0, 5)
        lootSlotDropdown.frame:SetParent(self:GetParent())
        self:GetParent().lootSlotDropdown = lootSlotDropdown
    end)
    --menu ou bouton============================================================
    local onlyUsable = CreateFrame("CheckButton", nil, ItemsList, "UICheckButtonTemplate");
        onlyUsable:SetPoint("TOPLEFT",ItemsList.menuLootSlot,"TOPRIGHT", 40, 2);
        onlyUsable.text:SetWidth(160);
        onlyUsable.text:SetText(" Equipable");
        onlyUsable.text:SetJustifyH("LEFT")
        onlyUsable.text:Show();
        onlyUsable:SetChecked(NS_MyWishList_Data_001["config"][instance_id]["UsableOnly"])
        onlyUsable:SetScript("OnMouseUp", function(self)
            self:SetChecked(self:GetChecked());
            --NS_MyWishList_Data_001["config"][instance_id]["UsableOnly"])
            NS_MyWishList_Data_001["config"][instance_id]["UsableOnly"] = not NS_MyWishList_Data_001["config"][instance_id]["UsableOnly"]
            NS_MyWishList:fillInstanceItems(ItemsList,instance_id)
        end)
    ItemsList.onlyUsable = onlyUsable
    -- ============================================================
    --TIPS
    local labelTips1 = ItemsList:CreateFontString(nil, "BACKGROUND", "GameFontNormalSmall")
        labelTips1:SetPoint("TOPLEFT", ItemsList.menuLootQuality,"BOTTOMLEFT",5, -2)
        labelTips1:SetJustifyH("LEFT")
        labelTips1:SetJustifyV("MIDDLE")
        labelTips1:SetText("Click Gauche pour ajouter l'item dans votre Wish liste.")
        labelTips1:SetHeight(20)
        labelTips1:SetWidth(400)
    local labelTips2 = ItemsList:CreateFontString(nil, "BACKGROUND", "GameFontNormalSmall")
        labelTips2:SetPoint("TOPLEFT", labelTips1,"BOTTOMLEFT",0, 8)
        labelTips2:SetJustifyH("LEFT")
        labelTips2:SetJustifyV("MIDDLE")
        labelTips2:SetText("Shift + Click Gauche pour cloner l'item dans votre WL. |cFF555555(Unité X 2 max)|r")
        labelTips2:SetHeight(20)
        labelTips2:SetWidth(450)
    scrollFrame:SetScrollChild(ItemsList.cnt)

    ItemsList.scrollFrame = scrollFrame
    ItemsList.scrollMotherFrame = scrollMotherFrame

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
local function IsUnique(itemid)
    
end
local function IsEquipableItem(itemClassID,itemSubClassID, myClass)
    --print(myClass)
    if itemClassID == 4 then
        for k,v in ipairs(NS_MyWishList.ClassArmorType[myClass]) do
            if itemSubClassID == k then 
                return true
            end
        end
    elseif itemClassID == 2 then
        for k,v in ipairs(NS_MyWishList.ClassWeaponType[myClass]) do
            if itemSubClassID == k then 
                return true
            end
        end
    else
        return true
    end
    return false
end
function GetItemSavedInfos(itemID)
    local item;
    local need_save = false;
    local name ,
          _,
          quality,
          iLevel,
          reqLevel,
          item_type,
          item_subType,
          maxStack,
          equipSlot,
          texture,
          vendorPrice,
          itemClassID,
          itemSubClassID,
          bindType,
          expacID,
          itemSetID,
          isCraftingReagent
    if not NS_MyWishList_Data_001["ItemsDB"] then
        NS_MyWishList_Data_001["ItemsDB"] = {}
    end
    if not NS_MyWishList_Data_001["ItemsDB"][itemID] or not NS_MyWishList_Data_001["ItemsDB"][itemID]["name"] then
        NS_MyWishList_Data_001["ItemsDB"][itemID] = {}
        name ,
        _,
        quality,
        iLevel,
        reqLevel,
        item_type,
        item_subType,
        maxStack,
        equipSlot,
        texture,
        vendorPrice,
        itemClassID,
        itemSubClassID,
        bindType,
        expacID,
        itemSetID,
        isCraftingReagent = GetItemInfo(itemID);
        if name and quality then
            need_save = true;
        end
    else
        name =              NS_MyWishList_Data_001["ItemsDB"][itemID]["name"]             
        quality=            NS_MyWishList_Data_001["ItemsDB"][itemID]["quality"]          
        iLevel=             NS_MyWishList_Data_001["ItemsDB"][itemID]["iLevel"]           
        reqLevel=           NS_MyWishList_Data_001["ItemsDB"][itemID]["reqLevel"]         
        item_type=          NS_MyWishList_Data_001["ItemsDB"][itemID]["item_type"]        
        item_subType=       NS_MyWishList_Data_001["ItemsDB"][itemID]["item_subType"]     
        maxStack=           NS_MyWishList_Data_001["ItemsDB"][itemID]["maxStack"]         
        equipSlot=          NS_MyWishList_Data_001["ItemsDB"][itemID]["equipSlot"]        
        texture=            NS_MyWishList_Data_001["ItemsDB"][itemID]["texture"]          
        vendorPrice=        NS_MyWishList_Data_001["ItemsDB"][itemID]["vendorPrice"]      
        itemClassID=        NS_MyWishList_Data_001["ItemsDB"][itemID]["itemClassID"]      
        itemSubClassID=     NS_MyWishList_Data_001["ItemsDB"][itemID]["itemSubClassID"]   
        bindType=           NS_MyWishList_Data_001["ItemsDB"][itemID]["bindType"]         
        expacID=            NS_MyWishList_Data_001["ItemsDB"][itemID]["expacID"]          
        itemSetID=          NS_MyWishList_Data_001["ItemsDB"][itemID] ["itemSetID"]        
        isCraftingReagent=  NS_MyWishList_Data_001["ItemsDB"][itemID]["isCraftingReagent"]
    end
    
    item = {
        ["name"]                = name,
        ["itemID"]              = itemID,
        ["quality"]             = quality,
        ["iLevel"]              = iLevel,
        ["reqLevel"]            = reqLevel,
        ["item_type"]           = item_type,
        ["item_subType"]        = item_subType,
        ["maxStack"]            = maxStack,
        ["equipSlot"]           = equipSlot,
        ["texture"]             = texture,
        ["vendorPrice"]         = vendorPrice,
        ["itemClassID"]         = itemClassID,
        ["itemSubClassID"]      = itemSubClassID,
        ["bindType"]            = bindType,
        ["expacID"]             = expacID,
        ["itemSetID"]           = itemSetID,
        ["isCraftingReagent"]   = isCraftingReagent
    };
    --need_save = true
    --save new item to db
    if need_save then SaveItemInDB(item) end

    return item
end
function SaveItemInDB(item)
    NS_MyWishList_Data_001["ItemsDB"][item.itemID] = item
end


function IsOverQuality(instance_id, quality)
    local q = NS_MyWishList_Data_001["config"][instance_id]["itemQuality"]
    if quality >= q or q == nil or q==0 then 
        return true
    end
    return false
end

local itemSlotTable = {
  -- Source: http://wowwiki.wikia.com/wiki/ItemEquipLoc
  ["INVTYPE_AMMO"] =           { 0 },
  ["INVTYPE_HEAD"] =           { 1 },
  ["INVTYPE_NECK"] =           { 2 },
  ["INVTYPE_SHOULDER"] =       { 3 },
  ["INVTYPE_BODY"] =           { 4 },
  ["INVTYPE_CHEST"] =          { 5 },
  ["INVTYPE_ROBE"] =           { 5 },
  ["INVTYPE_WAIST"] =          { 6 },
  ["INVTYPE_LEGS"] =           { 7 },
  ["INVTYPE_FEET"] =           { 8 },
  ["INVTYPE_WRIST"] =          { 9 },
  ["INVTYPE_HAND"] =           { 10 },
  ["INVTYPE_FINGER"] =         { 11, 12 },
  ["INVTYPE_TRINKET"] =        { 13, 14 },
  ["INVTYPE_CLOAK"] =          { 15 },
  ["INVTYPE_WEAPON"] =         { 16, 17 },
  ["INVTYPE_SHIELD"] =         { 17 },
  ["INVTYPE_2HWEAPON"] =       { 16 },
  ["INVTYPE_WEAPONMAINHAND"] = { 16 },
  ["INVTYPE_WEAPONOFFHAND"] =  { 17 },
  ["INVTYPE_HOLDABLE"] =       { 17 },
  ["INVTYPE_RANGED"] =         { 18 },
  ["INVTYPE_THROWN"] =         { 18 },
  ["INVTYPE_RANGEDRIGHT"] =    { 18 },
  ["INVTYPE_RELIC"] =          { 18 },
  ["INVTYPE_TABARD"] =         { 19 },
  ["INVTYPE_BAG"] =            { 20, 21, 22, 23 },
  ["INVTYPE_QUIVER"] =         { 20, 21, 22, 23 }
};

local function usableSlotID ( itemEquipLoc )
  return itemSlotTable[itemEquipLoc] or nil
end

function IsTargetSlot(instance_id, equipSlot)
    local eq = NS_MyWishList_Data_001["config"][instance_id]["SlotSelected"]

    local equipslotnum = usableSlotID(equipSlot)
    if equipslotnum then
        for k, equipSlot_id in ipairs(equipslotnum) do
            if equipSlot_id == eq or eq == nil or eq ==-1 then 
                return true
            end
        end
    else
        --print(equipSlot)
    end
    return false
end
function IsTargetType(instance_id, itemType)
    local it = NS_MyWishList_Data_001["config"][instance_id]["itemType"]
    if itemType == it or it == nil or it ==-1 then 
        return true
    end
    return false
end
function mustBeDisplayed(instance_id, item, my_class)
    if not NS_MyWishList_Data_001["config"] then
        NS_MyWishList_Data_001["config"] = {}
    end
    if not NS_MyWishList_Data_001["config"][instance_id] then
        NS_MyWishList_Data_001["config"][instance_id] = {}
    end
    if not NS_MyWishList_Data_001["config"][instance_id]["itemQuality"] then
        NS_MyWishList_Data_001["config"][instance_id]["itemQuality"] = 0
    end
    if not NS_MyWishList_Data_001["config"][instance_id]["SlotSelected"] then
        NS_MyWishList_Data_001["config"][instance_id]["SlotSelected"] = -1
    end
    if not NS_MyWishList_Data_001["config"][instance_id]["itemType"] then
        NS_MyWishList_Data_001["config"][instance_id]["itemType"] = -1
    end
     if NS_MyWishList_Data_001["config"][instance_id]["UsableOnly"] == nil then
        NS_MyWishList_Data_001["config"][instance_id]["UsableOnly"] = true
     end
    local goodQuality   = IsOverQuality(    instance_id,      item.quality)
    local goodSlot      = IsTargetSlot(     instance_id,      item.equipSlot)
    local goodType      = IsTargetType(     instance_id,      item.itemClassID)
    local equipable     = IsEquipableItem(  item.itemClassID, item.itemSubClassID, my_class)
    local displayEquip = false
    local displayItem = 0
    --no equip and dont want to see noeq
    if equipable == false and NS_MyWishList_Data_001["config"][instance_id]["UsableOnly"] == true then
        displayItem = 0
    end
    --not equip and dont care to see noeq
    if equipable == false and NS_MyWishList_Data_001["config"][instance_id]["UsableOnly"] == false then
       displayItem = 2
       displayEquip = true
    end
    --equip and dont want to see noeq
    if equipable == true and NS_MyWishList_Data_001["config"][instance_id]["UsableOnly"] == true then
        displayItem = 1
        displayEquip = true
    end
    if equipable == true and NS_MyWishList_Data_001["config"][instance_id]["UsableOnly"] == false then
       displayItem = 1
       displayEquip = true
    end

    return (goodQuality and goodSlot and goodType and displayEquip), displayItem
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
    local _, englishClass, _ = UnitClass("player");    
    for k, itemid in ipairs(NS_MyWishList.Instances[instance_id]["items"]) do
        local curr_item = GetItemSavedInfos(itemid)
        if curr_item.name then
            local toDisplay, displayItem = mustBeDisplayed(instance_id, curr_item, englishClass)
            if toDisplay then 
                local item_texture = GetItemIcon(itemid)
                local r, g, b, hex = GetItemQualityColor(curr_item.quality)
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
                labelItemName:SetText(curr_item.name)
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
                    
                local highlight = ButtonAdd:CreateTexture(nil, "HIGHLIGHT")
                    highlight:SetAllPoints(ButtonAdd)
                    highlight:SetTexture(136580) -- Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight
                    highlight:SetTexCoord(0, 1, 0.23, 0.77)
                    highlight:SetBlendMode("ADD")
                
                ButtonAdd:SetScript("OnClick", function(self, button)
                        local cpt_r = 0
                    local found1 = false
                    local found_twice1 = false
                    for k, v in pairs(NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]) do
                        cpt_r = cpt_r + 1
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
                    NS_MyWishList:fillInstanceItems(ItemsList,instance_id, wl_target)
                    NS_MyWishList:fillMyWishList(instance_id)
                end)

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
                --if found and IsUnique(itemid) then found_twice == true end
                if (found and not found_twice) and displayItem == 1 then
                    Button_.icon:SetVertexColor(0.5, 0.5, 0.5);
                    ButtonAdd.icon:SetVertexColor(0.8, 0.8, 0.8);
                    labelItemName:SetTextColor(0.5,0.5,0.5,1)
                    highlight:SetVertexColor(0.5, 0, 0)
                end
                if found_twice or displayItem == 2 then
                    Button_.icon:SetVertexColor(0.5,   0, 0);
                    ButtonAdd.icon:SetVertexColor(0,   0, 0);
                    labelItemName:SetTextColor( 0.5,   0, 0  , 1)
                    highlight:SetVertexColor(   0.5, 0.5, 0.5)
                    ButtonAdd:Hide();
                end
                if not found and displayItem == 1 then
                    Button_.icon:SetVertexColor(1, 1, 1);
                    ButtonAdd.icon:SetVertexColor(1, 1, 1);
                    labelItemName:SetTextColor(r,g,b,1)
                    highlight:SetVertexColor(1,1,1)
                    ButtonAdd:Show()
                end
                frameButton.ButtonAdd = ButtonAdd
                ItemsButtons["ItemButton_"..instance_id.."_"..cpt_idx] = frameButton
                cpt_idx = cpt_idx + 1
            end
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
    local ItemsList = NS_MyWishList.currentWlTabMWL
    local ItemsListBase = NS_MyWishList.currentWlTabIL
    if not ItemsList then 
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
    for index = 1,prio_count do
        local itemid = NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]["prio_"..tostring(index)]
        if itemid then
            local name, _, quality, iLevel, reqLevel, item_type, item_subType, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemid)
            if name then
                local item_texture = GetItemIcon(itemid)
                local frameButton = CreateFrame("Button",nil,ItemsList.cnt)
                    frameButton:SetPoint("TOPLEFT", ItemsList.cnt, "TOPLEFT", 5, 32-((32*index-1)+2))
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
                            local cpt_r = 0
                            local found = false
                            local index_ = 0
                            for k, v in pairs(NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]) do
                                cpt_r = cpt_r + 1
                                if v then
                                    if tonumber(v) == tonumber(itemid) then
                                        found = true
                                        index_ = k
                                    end
                                end
                            end
                            if found then
                                NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id][index_] = nil
                            end

                            NS_MyWishList:fillInstanceItems(ItemsListBase,instance_id, wl_target)
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
                            NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]["prio_"..tostring(index-1)] = itemid
                            NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]["prio_"..tostring(index)] = toDwn
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
                            NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]["prio_"..tostring(index+1)] = itemid
                            NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name]["MYWLS"][instance_id]["prio_"..tostring(index)] = toUp
                            NS_MyWishList:fillMyWishList(instance_id)
                        end)
                        local highlight = ButtonDwn:CreateTexture(nil, "HIGHLIGHT")
                            highlight:SetAllPoints(ButtonDwn)
                            highlight:SetTexture(136580) -- Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight
                            highlight:SetTexCoord(0, 1, 0.23, 0.77)
                            highlight:SetBlendMode("ADD")
                frameButton.ButtonAdd = ButtonAdd
            end
        end
    end
end
