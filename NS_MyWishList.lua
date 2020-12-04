--NS_MyWishList

local addonname, NS_MyWishList = ...
local NS_MyWishList = {}
NS_MyWishList = LibStub("AceAddon-3.0"):NewAddon("NS_MyWishList",
	"AceConsole-3.0",
	"AceEvent-3.0"  ,
	"AceBucket-3.0" ,
	"AceComm-3.0"   ,
	"AceTimer-3.0"  ,
	"AceHook-3.0")
_G.NS_MyWishList = NS_MyWishList

--LIBS
--NS_MyWishList.dragonLib = LibStub("HereBeDragons-2.0");
--NS_MyWishList.dragonLibPins = LibStub("HereBeDragons-Pins-2.0");
NS_MyWishList.AceGUI = LibStub("AceGUI-3.0")
NS_MyWishList.AceConfigDialog = LibStub("AceConfigDialog-3.0")
NS_MyWishList.AceConfig = LibStub("AceConfig-3.0")
NS_MyWishList.AceRegistry = LibStub("AceConfigRegistry-3.0")
NS_MyWishList.icon = LibStub("LibDBIcon-1.0")
--ADDON COM
NS_MyWishList.commPrefix = addonname.."1";

--ADDON INFOS
NS_MyWishList.versionDescription = GetAddOnMetadata(addonname, "Notes")
NS_MyWishList.version            = GetAddOnMetadata(addonname, "Version")
NS_MyWishList.versionName        = GetAddOnMetadata(addonname, "Title")
NS_MyWishList.versionSubName     = GetAddOnMetadata(addonname, "CommVersion")
NS_MyWishList.versionSubName     = "CrispyClouds"
NS_MyWishList.tocversion         = select(4, GetBuildInfo())
NS_MyWishList.isClassic          = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)

--VARS
NS_MyWishList.mainFrameIsVisible = false

--DEBUG MODE
NS_MyWishList.debug = true

--EVENTS
function NS_MyWishList:OnInitialize()
        self:InitLoadData()
    	self:RegisterChatCommand("NS_MyWishList", "ChatCommand")
		-- Called when the addon is loaded

		-- Print a message to the chat frame
		self:Print("OnInitialize Event Fired: Hello")
end
function NS_MyWishList:InitLoadData()
    if not NS_MyWishList_Data_001 then
    	NS_MyWishList_Data_001 = {}
    end
    if not NS_MyWishList_Data_001["Toons"] then
        NS_MyWishList_Data_001["Toons"] = {}
    end
    NS_MyWishList.player_name = UnitName("player")
    if not NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name] then
        NS_MyWishList_Data_001["Toons"][NS_MyWishList.player_name] = {}
    end
    self:SaveMyToon()
end
function NS_MyWishList:SaveMyToon()
    
end
function NS_MyWishList:OnEnable()
   
    self:Config_OnInitialize()
    self:RegisterComm(NS_MyWishList.commPrefix, "OnCommReceive")
--COMM=============================================================
    NS_MyWishList.broadcastAllData = (function()
        self:broadcast_Version()
        self:newVersionAvailable()
        self:broadcast_MyInfos()        -- username, class, race, level
        --self:broadcast_MyComps()        -- competences
        --self:broadcast_MyWorks()        -- métiers
        self:broadcast_MyStuff()        -- stuff
        self:broadcast_MyTalents()      -- talents
        self:broadcast_MyWLS()          -- wls
        self:broadcast_MyLocation()     -- location
        --self:broadcast_MyReputations()  -- réputations
    end)
    NS_MyWishList.shareData = (function(self)
        C_Timer.After(300, function()
            NS_MyWishList.broadcastAllData();
            NS_MyWishList.shareData();
        end)
    end)
    
    NS_MyWishList.broadcastAllData();
    NS_MyWishList.shareData();
    ---================================================================

    --Display or not the splashscreen
    if NS_MyWishList_Data_001.displaySplash.hide then
        NS_MyWishList:DrawSpashScr(UIPraent)
    end
    --Welcame message
    self:Print("NS_WL> Hello "..NS_MyWishList.player_name)
end

function NS_MyWishList:OnDisable()
		-- Called when the addon is disabled
end
