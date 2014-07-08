--[[ TODO: 
		New Category
]]

local GeminiAddon = Apollo.GetPackage("Gemini:Addon-1.1").tPackage

local PerspectiveOptions = GeminiAddon:NewAddon("PerspectiveOptions", "Perspective")

local Perspective

local JSON

local L = {}
	
local fonts = {
	{ name = "Courier" },
	{ name = "CRB_AlienLarge" },
	{ name = "CRB_AlienMedium" },
	{ name = "CRB_AlienSmall" },
	{ name = "CRB_Button" },
	{ name = "CRB_ButtonHeader" },
	{ name = "CRB_Dialog", 			styles = { "I"	} },
	{ name = "CRB_Dialog_Heading", 	styles = { "Huge", "Small" } },
	{ name = "CRB_FloaterGigantic",	styles= { "O" } },
	{ name = "CRB_FloaterHuge" },
	{ name = "CRB_FloaterLarge" },
	{ name = "CRB_FloaterMedium" },
	{ name = "CRB_FloaterSmall" },
	{ name = "CRB_Header9", 		styles = { "O" } },
	{ name = "CRB_Header10", 		styles = { "O" } },
	{ name = "CRB_Header11", 		styles = { "O" } },
	{ name = "CRB_Header12", 		styles = { "O" } },
	{ name = "CRB_Header13", 		styles = { "O" } },
	{ name = "CRB_Header14", 		styles = { "O" } },
	{ name = "CRB_Header16", 		styles = { "O" } },
	{ name = "CRB_Header20", 		styles = { "O" } },
	{ name = "CRB_Header24", 		styles = { "O" } },
	{ name = "CRB_HeaderGigantic",	styles = { "O" } },
	{ name = "CRB_HeaderHuge", 		styles = { "O" } },
	{ name = "CRB_HeaderLarge", 	styles = { "O" } },
	{ name = "CRB_HeaderMedium", 	styles = { "O" } },
	{ name = "CRB_HeaderSmall", 	styles = { "O" } },
	{ name = "CRB_HeaderTiny", 		styles = { "O" } },
	{ name = "CRB_Interface9", 		styles = { "B", "BB", "BBO", "BO", "I", "O" } },
	{ name = "CRB_Interface10", 	styles = { "B", "BB", "BBO", "BO", "I", "O" } },
	{ name = "CRB_Interface11", 	styles = { "B", "BB", "BBO", "BO", "I", "O" } },
	{ name = "CRB_Interface12", 	styles = { "B", "BB", "BBO", "BO", "I", "O" } },
	{ name = "CRB_Interface14", 	styles = { "B", "BB", "BBO", "BO", "I", "O" } },
	{ name = "CRB_Interface16", 	styles = { "B", "BB", "BBO", "BO", "I", "O" } },
	{ name = "CRB_InterfaceLarge",	styles = { "B", "BB", "BBO", "BO", "I", "O" } },
	{ name = "CRB_InterfaceMedium",	styles = { "B", "BB", "BBO", "BO", "I", "O" } },
	{ name = "CRB_InterfaceSmall",	styles = { "BB", "I", "O" } },
	{ name = "CRB_Pixel", 			styles = { "O" } },
	{ name = "CRB_ResourceOnly" },
	{ name = "Default" },
	{ name = "DefaultButton" },
	{ name = "Nameplates" },
	{ name = "Subtitle" },
	{ name = "Thick" } }

local controls = {}

function PerspectiveOptions:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self 

	return o
end

function PerspectiveOptions:OnInitialize()
	self.profile = "default"

	-- Load our localization
	L = GeminiAddon:GetAddon("PerspectiveLocale"):LoadLocalization()

	JSON = Apollo.GetPackage("Lib:dkJSON-2.5").tPackage

	Perspective = GeminiAddon:GetAddon("Perspective")

	-- Load our default values
	local defaults = self:LoadDefaults()

	-- Load our controls
	controls = self:LoadControls();

	-- Load the default values into the db.
	self.db = Apollo.GetPackage("Gemini:DB-1.0").tPackage:New(self, defaults)

	-- Load the xml document
	self.xmlDoc = XmlDoc.CreateFromFile("Perspective.xml")

	-- Dialog window
    self.Dialog = Apollo.LoadForm(self.xmlDoc, "Dialog", nil, self)
    self.Dialog:FindChild("CloseButton"):AddEventHandler("ButtonSignal", "CloseDialog")

	-- Options window
    self.Options = Apollo.LoadForm(self.xmlDoc, "Options", nil, self)
    
    -- Options categories list
    self.CategoryList = self.Options:FindChild("CategoryList"):FindChild("Categories")
    
    -- Options modules list
    self.ModuleList = self.Options:FindChild("CategoryList"):FindChild("Modules")

    -- Options category editor
    self.Editor = self.Options:FindChild("Editor")

    -- Options settings
    self.Settings = self.Options:FindChild("Settings")

    -- Register our addon with the interface menu.
	Apollo.RegisterEventHandler("InterfaceMenuListHasLoaded", 		"OnInterfaceMenuListHasLoaded", self)
	Apollo.RegisterEventHandler("InterfaceMenuClicked", 			"OnInterfaceMenuClicked", self)

	-- Register the slash command	
	Apollo.RegisterSlashCommand("perspective", "ShowOptions", self)
	Apollo.RegisterSlashCommand("pti", "ShowTargetInfo", self)
	Apollo.RegisterSlashCommand("deadzone", "DeadzoneInfo", self)
end

function PerspectiveOptions:DeadzoneInfo()
	Print("Deadzone:")
	Print(Perspective.Player:GetOverheadAnchor().y)
	Print(GameLib.GetUnitScreenPosition(Perspective.Player).nY)
	Print(GameLib.GetPlayerUnit():GetOverheadAnchor().y)
	Print(GameLib.GetUnitScreenPosition(GameLib.GetPlayerUnit()).nY)
end


function PerspectiveOptions:OnEnable()
	if Apollo.GetAddon("Rover") then
		SendVarToRover("PerspectiveOptions", self)
	end
end

function PerspectiveOptions:OnDialogClose()
	self.Dialog:Show(false, true)
end

function PerspectiveOptions:LoadDefaults()
	return {
		profile 											= {
			default 										= {
				settings 									= { 
					disabled  								= false,
					max 									= 10,
					offsetLines  							= true,
					draw 									= 0,
					slow 									= 1,
					fast  									= 100,
					queue 									= 0 },
				names 										= {
					[L.Unit_Return_Teleporter]				= { category = "instancePortal" },
					[L.Unit_Bruxen]							= { category = "instancePortal",	display = L.Unit_Traval_Thayd },
					[L.Unit_Tanxox]							= { category = "instancePortal",	display = L.Unit_Traval_Thayd },
					[L.Unit_Gus_Oakby]						= { category = "instancePortal",	display = L.Unit_Travel_Crimson_Badlands },
					[L.Unit_Lilly_Startaker]				= { category = "instancePortal",	display = L.Unit_Travel_Grimvault },
					[L.Unit_Transportation_Expert_Conner]	= { category = "instancePortal",	display = L.Unit_Travel_Farside },
					[L.Unit_Warrant_Officer_Burke]			= { category = "instancePortal",	display = L.Unit_Travel_Whitevale },
					[L.Unit_Venyanna_Skywind]				= { category = "instancePortal",	display = L.Unit_Travel_Northern_Wastes },
					[L.Unit_Captain_Karaka]					= { category = "instancePortal", 	display = L.Unit_Travel_Crimson_Badlands },
					[L.Unit_Captain_Cryzin]					= { category = "instancePortal",	display = L.Unit_Travel_Grimvault },
					[L.Unit_Captain_Petronia]				= { category = "instancePortal",	display = L.Unit_Travel_Farside },
					[L.Unit_Captain_Visia]					= { category = "instancePortal",	display = L.Unit_Travel_Whitevale },
					[L.Unit_Captain_Zanaar]					= { category = "instancePortal",	display = L.Unit_Travel_Northern_Wastes },
					[L.Unit_Servileia_Uticeia]				= { category = "instancePortal",	display = L.Unit_Travel_Ilium },
					[L.Unit_Police_Patrolman]				= { category = "cowPolice" },
					[L.Unit_Police_Constable]				= { category = "cowPolice" },
					[L.Unit_Water]							= { category = "mtWater" },
					[L.Unit_Water_Barrel]					= { category = "mtWater" },
					[L.Unit_Invisible_Water_Dowsing_Unit]	= { category = "mtWater" },
					[L.Unit_Cheese]							= { category = "mtFood" },
					[L.Unit_Chicken]						= { category = "mtFood" },
					[L.Unit_Roan_Steak]						= { category = "mtFood" },
					[L.Unit_Fruit]							= { category = "mtFood" },
					[L.Unit_Food_Crate]						= { category = "mtFood" },
					[L.Unit_Large_Feed_Sack]				= { category = "mtFeed" },
					[L.Unit_Feed_Sack]						= { category = "mtFeed" },
					[L.Unit_Hay_Bale]						= { category = "mtFeed" },
					[L.Unit_Roving_Chompacabra]				= { category = "mtEnemy" },
					[L.Unit_Dustback_Gnasher]				= { category = "mtEnemy" },
					[L.Unit_Dustback_Gnawer]				= { category = "mtEnemy" } },
				buffs 										= {},
				debuffs										= { 
					[L.Debuff_Moodie_Mask_Neutral]			= { category = "wtCarrier", disposition = true, zone = 69 },
					[L.Debuff_Moodie_Mask_Dominion]			= { category = "wtCarrier", disposition = true, zone = 69 },
					[L.Debuff_Moodie_Mask_Exile]			= { category = "wtCarrier", disposition = true, zone = 69 } },
				challengeUnits 								= {
					-- Challenge specific fixes
					[L.Unit_Roan_Skull]						= { challenge = 576 } },
				categories = {
					default = {
						disabled = false,
						disableInCombat = false,
						disableOccluded = false,
						display = false,
						font = "CRB_Pixel_O",
						fontColor = "ffffffff",
						icon = "PerspectiveSprites:Pin",
						iconColor = "ffffffff",
						iconHeight = 48,
						iconWidth = 48,
						limitBy = "category", -- valid options are nil, "name", "category", "quest", "challenge", "module"
						lineColor = "ffffffff",
						lineWidth = 2,
						max = 2,
						maxLines = 1,
						minDistance = 0,
						maxDistance = 500,
						zDistance = 500,
						showDistance = true,
						showIcon = true,
						showName = true,
						showLineOutline = true,
						showLines = true,
						showLinesOffscreen = true,
						rangeColor = "ff00ff00",
						rangeIcon = false,
						rangeFont = false,
						rangeLine = false,
						rangeLimit = 15	},
					all = {
						title = L.Category_Set_All ,
						module = L.Module_All },
					target = {
						title = L.Category_Misc_Target,
						module = L.Module_Misc,
						disabled = true,				
						lineColor = "ffff00ff",
						iconColor = "ffff00ff",
						icon = "PerspectiveSprites:Quest-Objective",
						maxIcons = 1,
						maxLines = 1,
						iconHeight = 48,
						iconWidth = 48 },
					focus = {
						title = L.Category_Misc_Focus,
						module = L.Module_Misc,
						lineColor = "ffff65aa",
						iconColor = "ffff65aa",
						icon = "PerspectiveSprites:Misc-Focus",
						maxIcons = 1,
						maxLines = 1,
						iconHeight = 48,
						iconWidth = 48 },
					lore = {
						title = L.Category_Misc_Lore,
						module = L.Module_Misc,
						fontColor  = "ff7abcff",
						iconColor  = "ff7abcff",
						lineColor = "ff7abcff",
						icon = "PerspectiveSprites:Misc-Lore",
						showLines = true,
						iconHeight = 36,
						iconWidth = 36,
						maxLines = 1 },
					subdue = {
						title = L.Category_Misc_Weapon_Subdue,
						module = L.Module_Misc,
						lineColor = "ffff8000",
						iconColor = "ffffffff",
						icon = "ClientSprites:Subdue-sword",
						lineWidth = 10,
						iconHeight = 72,
						iconWidth = 72 },
					group = {
						title = L.Category_Player_Group,
						module = L.Module_Player,
						fontColor = "ff7482c1",
						lineColor = "ff7482c1",
						iconColor = "ff7482c1",
						icon = "PerspectiveSprites:player-guild",
						showLines = false,
						maxLines = 4,
						max = 4,
						iconWidth = 36,
						iconHeight = 36,
						useRange = true,
						rangeColor = "ff00ff00",
						rangeIcon = true,
						rangeLine = true,
						rangeFont = true },
					raid = {
						title = L.Category_Player_Raid,
						module = L.Module_Player,
						fontColor = "ff00ffff",
						lineColor = "ff00ffff",
						iconColor = "ff00ffff",
						icon = "PerspectiveSprites:player-guild",
						showLines = false,
						maxLines = 40,
						max = 40,
						iconWidth = 36,
						iconHeight = 36,
						useRange = true,
						rangeColor = "ff00ffff",
						rangeIcon = true,
						rangeLine = true,
						rangeFont = true },
					guild = {
						title = L.Category_Player_Guild,
						module = L.Module_Player,
						fontColor = "ff00ff00",
						lineColor = "ff00ff00",
						iconColor = "ff00ff00",
						iconWidth = 36,
						iconHeight = 36,
						icon = "PerspectiveSprites:player-guild",
						showLines = false },
					exile = {
						title = L.Category_Player_Exile,
						module = L.Module_Player,
						icon = "PerspectiveSprites:Player-Exile",
						iconColorMode = "disposition",
						iconColor = "ff8dffa4",
						iconWidth = 36,
						iconHeight = 36,
						showLines = false,
						disabled = true	},
					dominion = {
						title = L.Category_Player_Dominion,
						module = L.Module_Player,
						icon = "PerspectiveSprites:Player-Dominion",
						iconColorMode = "disposition",
						iconColor = "ff8dffa4",
						iconWidth = 36,
						iconHeight = 36,
						showLines = false,
						disabled = true	},
					friend = {
						title = L.Category_Player_Friend,
						module = L.Module_Player,
						icon = "IconSprites:Icon_Windows_UI_CRB_Friend",
						iconHeight = 36,
						iconWidth = 36,
						showLines = false },
					rival = {
						title = L.Category_Player_Rival,
						module = L.Module_Player,
						icon = "IconSprites:Icon_Windows_UI_CRB_Rival",
						iconHeight = 36,
						iconWidth = 36,
						showLines = false },
					mainTank = {
						title = L.Category_Player_Main_Tank,
						module = L.Module_Player,
						icon = "PerspectiveSprites:Player-MainTank",
						iconHeight = 36,
						iconWidth = 36,
						iconColor = "ff00ffff",
						rangeColor = "ff00ff00",
						showLines = false },
					mainAssist = {
						title = L.Category_Player_Main_Assist,
						module = L.Module_Player,
						icon = "PerspectiveSprites:Player-MainAssist",
						iconHeight = 36,
						iconWidth = 36,
						iconColor = "ff00ffff",
						rangeColor = "ff00ff00",
						showLines = false },
					tank = {
						title = L.Category_Player_Tank,
						module = L.Module_Player,
						icon = "PerspectiveSprites:Player-Tank",
						iconHeight = 36,
						iconColor = "ff00ffff",
						rangeColor = "ff00ff00",
						iconWidth = 36,
						showLines = false },
					healer = {
						title = L.Category_Player_Healer,
						module = L.Module_Player,
						icon = "PerspectiveSprites:Player-Healer",
						iconHeight = 36,
						iconColor = "ff00ffff",
						rangeColor = "ff00ff00",
						iconWidth = 36,
						showLines = false },
					dps = {
						title = L.Category_Player_DPS,
						module = L.Module_Player,
						icon = "PerspectiveSprites:Player-DPS",
						iconHeight = 36,
						iconColor = "ff00ffff",
						rangeColor = "ff00ff00",
						iconWidth = 36,
						showLines = false },
					-- [[ PVP ]]
					friendlyPvpStalker = {
						title = L.Category_PVP_Friendly_Stalker,
						module = L.Module_PVP,
						iconColor = "ff00ff00",
						icon = "PerspectiveSprites:PVP-Stalker",
						showLines = false },
					friendlyPvpWarrior = {
						title = L.Category_PVP_Friendly_Warrior,
						module = L.Module_PVP,
						iconColor = "ff00ff00",
						icon = "PerspectiveSprites:PVP-Warrior",
						showLines = false },
					friendlyPvpEngineer = {
						title = L.Category_PVP_Friendly_Engineer,
						module = L.Module_PVP,
						iconColor = "ff00ff00",
						icon = "PerspectiveSprites:PVP-Engineer",
						showLines = false },
					friendlyPvpMedic = {
						title = L.Category_PVP_Friendly_Medic,
						module = L.Module_PVP,
						iconColor = "ff00ff00",
						icon = "PerspectiveSprites:PVP-Medic",
						showLines = false },
					friendlyPvpEsper = {
						title = L.Category_PVP_Friendly_Esper,
						module = L.Module_PVP,
						iconColor = "ff00ff00",
						icon = "PerspectiveSprites:PVP-Esper",
						showLines = false },
					friendlyPvpSpellslinger = {
						title = L.Category_PVP_Friendly_Spellslinger,
						module = L.Module_PVP,
						iconColor = "ff00ff00",
						icon = "PerspectiveSprites:PVP-Spellslinger",
						showLines = false },
					hostilePvpStalker = {
						title = L.Category_PVP_Hostile_Stalker,
						module = L.Module_PVP,
						iconColor = "ffff0000",
						icon = "PerspectiveSprites:PVP-Stalker",
						showLines = false },
					hostilePvpWarrior = {
						title = L.Category_PVP_Hostile_Warrior,
						module = L.Module_PVP,
						iconColor = "ffff0000",
						icon = "PerspectiveSprites:PVP-Warrior",
						showLines = false },
					hostilePvpEngineer = {
						title = L.Category_PVP_Hostile_Engineer,
						module = L.Module_PVP,
						iconColor = "ffff0000",
						icon = "PerspectiveSprites:PVP-Engineer",
						showLines = false },
					hostilePvpMedic = {
						title = L.Category_PVP_Hostile_Medic,
						module = L.Module_PVP,
						iconColor = "ffff0000",
						icon = "PerspectiveSprites:PVP-Medic",
						showLines = false },
					hostilePvpEsper = {
						title = L.Category_PVP_Hostile_Esper,
						module = L.Module_PVP,
						iconColor = "ffff0000",
						icon = "PerspectiveSprites:PVP-Esper",
						showLines = false },
					hostilePvpSpellslinger = {
						title = L.Category_PVP_Hostile_Spellslinger,
						module = L.Module_PVP,
						iconColor = "ffff0000",
						icon = "PerspectiveSprites:PVP-Spellslinger",
						showLines = false },
					-- [[ Walatiki Temple ]]
					wtCarrierFriendly = {
						title = L.Category_Walatiki_Carrier_Friendly,
						module = L.Module_Walatiki,
						icon = "PerspectiveSprites:Walatiki-Mask",
						iconColor = "ff00ff00",
						lineColor = "ff00ff00" },
					wtCarrierHostile = {
						title = L.Category_Walatiki_Carrier_Hostile,
						module = L.Module_Walatiki,
						icon = "PerspectiveSprites:Walatiki-Mask",
						iconColor = "ffff0000",
						lineColor = "ffff0000" },
					[L.Unit_Walatiki_Mask_Dominion] = {
						title = L.Category_Walatiki_Mask_Dominion,
						module = L.Module_Walatiki,
						icon = "PerspectiveSprites:Walatiki-Mask",
						iconColor = "ffff0000",
						lineColor = "ffff0000" },
					[L.Unit_Walatiki_Mask_Exile] = {
						title = L.Category_Walatiki_Mask_Exile,
						module = L.Module_Walatiki,
						icon = "PerspectiveSprites:Walatiki-Mask",
						iconColor = "ff00ff00",
						lineColor = "ff00ff00" },
					[L.Unit_Walatiki_Mask] = {
						title = L.Category_Walatiki_Mask,
						module = L.Module_Walatiki,
						icon = "PerspectiveSprites:Walatiki-Mask",
						
						iconColor = "ffffff00",
						lineColor = "ffffff00",
						 },
					[L.Unit_Walatiki_Totem_Exile] = {
						title = L.Category_Walatiki_Totem_Exile,
						module = L.Module_Walatiki,
						icon = "PerspectiveSprites:Walatiki-Totem",
						iconColor = "ff00ff00",
						lineColor = "ff00ff00",
						showLines = false },
					[L.Unit_Walatiki_Totem_Dominion] = {
						title = L.Category_Walatiki_Totem_Dominion,
						module = L.Module_Walatiki,
						icon = "PerspectiveSprites:Walatiki-Totem",
						iconColor = "ffff0000",
						lineColor = "ffff0000",
						showLines = false },
					-- [[ NPC ]]
					friendly = {
						title = L.Category_NPC_Friendly_Normal,
						module = L.Module_NPC,
						disabled = true,
						fontColor = "ff00ff00",
						lineColor = "ff00ff00",
						iconColor = "ff00ff00",
						icon = "PerspectiveSprites:NPC-Normal",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 32,
						iconWidth = 32 },	
					friendlyPrime = {
						title = L.Category_NPC_Friendly_Prime,
						module = L.Module_NPC,
						disabled = true,
						fontColor = "ff00ff00",
						lineColor = "ff00ff00",
						iconColor = "ff00ff00",
						icon = "PerspectiveSprites:NPC-Prime",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 32,
						iconWidth = 32 },	
					friendlyElite = {
						title = L.Category_NPC_Friendly_Elite,
						module = L.Module_NPC,
						disabled = true,
						fontColor = "ff00ff00",
						lineColor = "ff00ff00",
						iconColor = "ff00ff00",
						icon = "PerspectiveSprites:NPC-Elite",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 32,
						iconWidth = 32 },
					neutral = {
						title = L.Category_NPC_Neutral_Normal,
						module = L.Module_NPC,
						disabled = true,
						fontColor = "ffffff00",
						lineColor = "ffffff00",
						iconColor = "ffffff00",
						icon = "PerspectiveSprites:NPC-Normal",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 32,
						iconWidth = 32 },	
					neutralPrime = {
						title = L.Category_NPC_Neutral_Prime,
						module = L.Module_NPC,
						disabled = true,
						fontColor = "ffffff00",
						lineColor = "ffffff00",
						iconColor = "ffffff00",
						icon = "PerspectiveSprites:NPC-Prime",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 32,
						iconWidth = 32 },	
					neutralElite = {
						title = L.Category_NPC_Neutral_Elite,
						module = L.Module_NPC,
						disabled = true,
						fontColor = "ffffff00",
						lineColor = "ffffff00",
						iconColor = "ffffff00",
						icon = "PerspectiveSprites:NPC-Elite",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 32,
						iconWidth = 32 },	
					hostile = {
						title = L.Category_NPC_Hostile_Normal,
						module = L.Module_NPC,
						fontColor = "ff96f4c4",
						lineColor = "ff96f4c4",
						iconColor = "ff96f4c4",
						icon = "PerspectiveSprites:NPC-Normal",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 32,
						iconWidth = 32,
						rangeIcon = true,
						rangeColor = "ffff00ff"	},
					hostilePrime = {
						title = L.Category_NPC_Hostile_Prime,
						module = L.Module_NPC,
						fontColor = "fffa7e58",
						lineColor = "fffa7e58",
						iconColor = "fffa7e58",
						icon = "PerspectiveSprites:NPC-Prime",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 32,
						iconWidth = 32,
						rangeIcon = true,
						rangeColor = "ffff00ff"	},
					hostileElite = {
						title = L.Category_NPC_Hostile_Elite,
						module = L.Module_NPC,
						fontColor = "ff96f4c4",
						lineColor = "ff96f4c4",
						iconColor = "ff96f4c4",
						icon = "PerspectiveSprites:NPC-Elite",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 32,
						iconWidth = 32,
						rangeIcon = true,
						rangeColor = "ffff00ff"	},
					questObjective = {
						title = L.Category_Quest_Objective,
						module = L.Module_Quest,
						icon = "PerspectiveSprites:Quest-Objective",
						max = 3,
						limitBy = "category",
						lineColor = "ffff8000",
						iconHeight = 36,
						iconWidth = 36,
						iconColor = "ffff8000" },
					questInteractable = {
						title = L.Category_Quest_Interactable,
						module = L.Module_Quest,
						icon = "PerspectiveSprites:quest-interactive",
						max = 3,
						iconHeight = 36,
						iconWidth = 36,
						limitBy = "category",
						lineColor = "ffff8000",
						iconColor = "ffff8000" },
					questNew = {
						title = L.Category_Quest_Start,
						module = L.Module_Quest,
						icon = "PerspectiveOptions:Quest-Available",
						iconWidth = 42,
						iconHeight = 36,
						lineColor = "ff00ff00" },
					questTalkTo = {
						title = L.Category_Quest_TalkTo,
						module = L.Module_Quest,
						icon = "PerspectiveOptions:Quest-TalkTo",
						iconWidth = 36,
						iconHeight = 36,
						lineColor = "ffff8000" },
					questReward = {
						title = L.Category_Quest_Complete,
						module = L.Module_Quest,
						icon = "PerspectiveOptions:Quest-TurnIn",
						iconHeight = 36,
						iconWidth = 36,
						lineColor = "ff00ff00" },	
					questLocation = {
						title = L.Category_Quest_Location,
						module = L.Module_Quest,
						limitBy = "quest",
						max = 1,
						drawLine = false,
						icon = "Crafting_CoordSprites:sprCoord_AdditivePreviewSmall",
						iconWidth = 64,
						iconHeight = 64	,
						maxDistance = 9999,
						minDistance = 100,
						iconColor = "ffffa600"},
					eventLocation = {
						title = L.Category_Event_Location,
						module = L.Module_Quest,
						limitBy = "category",
						max = 1,
						drawLine = false,
						icon = "Crafting_CoordSprites:sprCoord_AdditivePreviewSmall",
						iconWidth = 64,
						iconHeight = 64,
						maxDistance = 9999,
						minDistance = 100,
						iconColor = "ff00ff00" },
					questLoot = {
						title = L.Category_Quest_Loot,
						module = L.Module_Quest,
						icon = "PerspectiveSprites:Quest-Loot",
						showLines = false,
						iconWidth = 28,
						iconHeight = 28 },
					challengeLocation = {
						title = L.Category_Challenge_Location,
						iconColor = "ffff8000",
						module = L.Module_Challenge,
						limitBy = "challenge",
						max = 1,
						drawLine = false,
						maxDistance = 9999,
						minDistance = 100,
						icon = "Crafting_CoordSprites:sprCoord_AdditivePreviewSmall",
						iconWidth = 64,
						iconHeight = 64	},
					challenge = {
						title = L.Category_Challenge_Objective,
						module = L.Module_Challenge,
						icon = "PerspectiveSprites:Quest-Objective",
						lineColor = "ffff0000",
						iconColor = "ffff0000" },
					farmer = {
						title = L.Category_Harvest_Farmer,
						module = L.Module_Harvest,
						max = 5,
						fontColor = "ffffff00",
						icon = "IconSprites:Icon_MapNode_Map_Node_Plant",
						lineColor = "ffffff00" },
					miner = {
						title = L.Category_Harvest_Mining,
						module = L.Module_Harvest,
						max = 5,
						fontColor = "ff0078ce",
						icon = "IconSprites:Icon_MapNode_Map_Node_Mining",
						lineColor = "ff0078ce" },
					relichunter = {
						title = L.Category_Harvest_Relic_Hunter,
						module = L.Module_Harvest,
						max = 5,
						fontColor = "ffff7fed",
						icon = "IconSprites:Icon_MapNode_Map_Node_Relic",
						lineColor = "ffff7fed" },
					survivalist = {
						title = L.Category_Harvest_Survivalist,
						module = L.Module_Harvest,
						max = 5,
						fontColor = "ffce9967",
						icon = "IconSprites:Icon_MapNode_Map_Node_Tree",
						lineColor = "ffce9967" },
					[L.Unit_Food_Table] = {
						title = L.Category_Harvest_Food_Table,
						module = L.Module_Harvest,
						icon = "PerspectiveSprites:Harvest-Table",
						iconColor = "ffffffff",
						lineColor = "ff9d8734",
						fontColor = "ff9d8734",
						iconHeight = 32,
						iconWidth = 32,
						max = 1 },
					[L.Unit_Butcher_Block] = {
						title = L.Category_Harvest_Butcher_Block,
						module = L.Module_Harvest,
						icon = "PerspectiveSprites:Harvest-Butcher",
						iconColor = "ffffffff",
						lineColor = "ff9d3838",
						fontColor = "ff9d3838",
						iconHeight = 36,
						iconWidth = 36,
						max = 1 },
					[L.Unit_Tanning_Rack] = {
						title = L.Category_Harvest_Tanning_Rack,
						module = L.Module_Harvest,
						icon = "PerspectiveSprites:Harvest-Hide",
						iconColor = "ffb2aa73",
						lineColor = "ffb2aa73",
						fontColor = "ffb2aa73",
						iconHeight = 36,
						iconWidth = 36,
						max = 1 },
					flightPath = {
						title = L.Category_Travel_Taxi,
						module = L.Module_Travel,
						fontColor = "ffabf8cb",
						icon = "PerspectiveSprites:Travel-Taxi",
						iconHeight = 36,
						iconWidth = 36,
						showLines = false },
					instancePortal = {
						title = L.Category_Travel_Portal,
						module = L.Module_Travel,
						fontColor = "ffabf8cb",
						icon = "PerspectiveSprites:Travel-Portal",
						iconColor = "ff9c00ff",
						iconHeight = 42,
						iconWidth = 42,
						max = 10,
						showLines = false },
					bindPoint = {
						title = L.Category_Travel_Bind_Point,
						module = L.Module_Travel,
						fontColor = "ffabf8cb",
						icon = "PerspectiveSprites:Travel-Bind",
						iconColor = "ff00ffff",
						iconHeight = 36,
						iconWidth = 36,
						showLines = false },
					dungeon = {
						title = L.Category_Travel_Dungeon,
						module = L.Module_Travel,
						fontColor = "ff00ffff",
						icon = "PerspectiveSprites:Travel-Dungeon",
						iconHeight = 36,
						iconWidth = 36,
						showLines = false },
					marketplace = {
						title = L.Category_Town_Commodities_Exchange,
						module = L.Module_Town,
						fontColor = "ffabf8cb",
						icon = "PerspectiveSprites:Town-Commodity",
						iconWidth = 36,
						iconHeight = 36,
						showLines = false },
					auctionHouse = {
						title = L.Category_Town_Auction_House,
						module = L.Module_Town,
						fontColor = "ffabf8cb",
						icon = "PerspectiveSprites:Town-Auction",
						iconWidth = 36,
						iconHeight = 36,
						showLines = false },
					mailBox = {
						title = L.Category_Town_Mailbox,
						module = L.Module_Town,
						fontColor = "ffabf8cb",
						icon = "PerspectiveSprites:Town-Mail",
						iconWidth = 36,
						iconHeight = 36,
						showLines = false },
					vendor = {
						title = L.Category_Town_Vendor,
						module = L.Module_Town,
						fontColor = "ffabf8cb",
						icon = "PerspectiveSprites:Town-Vendor",
						iconWidth = 36,
						iconHeight = 36,
						showLines = false },
					craftingStation = {
						title = L.Category_Town_Crafting_Station,
						module = L.Module_Town,
						fontColor = "ffabf8cb",
						icon = "PerspectiveSprites:Town-Craft",
						iconWidth = 36,
						iconHeight = 36,
						showLines = false },
					engravingStation = {
						title = L.Category_Town_Engraving_Station,
						module = L.Module_Town,
						fontColor = "ffabf8cb",
						icon = "PerspectiveSprites:Town-Engrave",
						iconWidth = 36,
						iconHeight = 36,
						showLines = false },
					tradeskillTrainer = {
						title = L.Category_Town_Tradeskill_Trainer,
						module = L.Module_Town,
						fontColor = "ffabf8cb",
						icon = "PerspectiveSprites:Town-CTrainer",
						iconWidth = 36,
						iconHeight = 36,
						showLines = false },
					dye = {
						title = L.Category_Town_Appearance_Modifier,
						module = L.Module_Town,
						fontColor = "ffabf8cb",
						icon = "PerspectiveSprites:Town-Dye",
						iconWidth = 36,
						iconHeight = 36,
						showLines = false },
					bank = {
						title = L.Category_Town_Bank,
						module = L.Module_Town,
						fontColor = "ffabf8cb",
						icon = "PerspectiveSprites:Town-Bank",
						iconWidth = 36,
						iconHeight = 36,
						showLines = false },
					guildBank = {
						title = L.Category_Town_Guild_Bank,
						module = L.Module_Town,
						fontColor = "ffabf8cb",
						showLines = false, 
						iconWidth = 36,
						iconHeight = 36,
						icon = "PerspectiveSprites:Town-GBank" },
					guildRegistrar = {
						title = L.Category_Town_Guild_Registrar,
						module = L.Module_Town,
						fontColor = "ffabf8cb",
						showLines = false, 
						iconWidth = 36,
						iconHeight = 36,
						icon = "PerspectiveSprites:Town-Registrar" },
					cityDirections = {
						title = L.Category_Town_City_Guard,
						module = L.Module_Town,
						disabled = true,
						fontColor = "ffabf8cb",
						showLines = false, 
						iconWidth = 36,
						iconHeight = 36,
						icon = "PerspectiveSprites:Town-Directions" },
					pathLocation = {
						title = L.Category_Path_Mission_Location,
						module = L.Module_Path,
						limitBy = "path",
						max = 1,
						iconColor = "ffffffff",
						drawLine = false,
						iconHeight = 64,
						iconWidth = 64,
						maxDistance = 9999,
						max = 1 },
					scientist = {
						title = L.Category_Path_Scientist,
						module = L.Module_Path,
						fontColor = "ffc759ff",
						icon = "PerspectiveSprites:Path-Scientist",
						lineColor = "ffc759ff",
						showLines = false,
						iconHeight = 36,
						iconWidth = 36,
						maxLines = 1 },
					scientistScans = {
						title = L.Category_Path_Scientist_Scans,
						module = L.Module_Path,
						fontColor = "ffc759ff",
						icon = "PerspectiveSprites:Path-Scientist",
						lineColor = "ffc759ff",
						iconHeight = 36,
						iconWidth = 36,
						maxLines = 1 },
					solider = {
						title = L.Category_Path_Soldier,
						module = L.Module_Path,
						fontColor = "ffc759ff",
						icon = "PerspectiveSprites:Path-Soldier",
						lineColor = "ffc759ff",
						iconHeight = 36,
						iconWidth = 36,
						maxLines = 1 },
					settler = {
						title = L.Category_Path_Settler,
						module = L.Module_Path,
						fontColor = "ffc759ff",
						icon = "PerspectiveSprites:Path-Settler",
						lineColor = "ffc759ff",
						iconHeight = 36,
						iconWidth = 36,
						maxLines = 1 },
					settlerResources = {
						title = L.Category_Path_Settler_Resources,
						module = L.Module_Path,
						fontColor = "ffc759ff",
						icon = "PerspectiveSprites:Path-Settler",
						lineColor = "ffc759ff",
						iconHeight = 36,
						iconWidth = 36,
						maxLines = 1 },
					explorer = {
						title = L.Category_Path_Explorer,
						module = L.Module_Path,
						fontColor = "ffc759ff",
						icon = "PerspectiveSprites:Path-Explorer",
						lineColor = "ffc759ff",
						iconHeight = 36,
						iconWidth = 36,
						maxLines = 1 },
					wotwChampion = {
						title = L.Category_WotW_Enemy_Champion,
						module = L.Module_WotW,
						icon = "IconSprites:Icon_MapNode_Map_PvP_BattleAlert",
						showLines = false },
					[L.Unit_Energy_Node] = {
						title = L.Category_WotW_Energy_Node,
						module = L.Module_WotW,
						icon = "PerspectiveSprites:Wilds-EnergyNode",
						iconHeight = 48,
						iconWidth = 48,
						showLines = false },
					[L.Unit_Moodie_Totem] = {
						title = L.Category_WotW_Moodie_Totem,
						module = L.Module_WotW,
						icon = "PerspectiveSprites:Wilds-MoodieTotem",
						iconHeight = 48,
						iconWidth = 48,
						showLines = false },
					[L.Unit_Skeech_Totem] = {
						title = L.Category_WotW_Skeech_Totem,
						module = L.Module_WotW,
						icon = "PerspectiveSprites:Wilds-SkeechTotem",
						iconHeight = 48,
						iconWidth = 48,
						showLines = false },
					cowPolice = {
						title = L.Category_Crimelords_Police,
						module = L.Module_Crimelords,
						icon = "PerspectiveSprites:Circle-Outline",
						showLines = false,
						showName = false,
						showDistance = false,
						iconColor = "ff00ff00" },
					mtWater = {
						title = L.Category_Malgrave_Water,
						module = L.Module_Malgrave,
						icon = "PerspectiveSprites:Malgrave-Water",
						iconColor = "ffe759d3",
						iconHeight = 36,
						iconWidth = 36,
						showLines = false },
					[L.Unit_Caravan_Member] = {
						title = L.Category_Malgrave_Caravan_Member,
						module = L.Module_Malgrave,
						icon = "PerspectiveSprites:Malgrave-Member",
						iconColor = "ffe759d3",
						iconHeight = 36,
						iconWidth = 36,
						showLines = false },
					mtFood = {
						title = L.Category_Malgrave_Food,
						module = L.Module_Malgrave,
						icon = "PerspectiveSprites:Malgrave-Food",
						iconColor = "ffe759d3",
						iconHeight = 36,
						iconWidth = 36,
						showLines = false },
					mtFeed = {
						title = L.Category_Malgrave_Feed,
						module = L.Module_Malgrave,
						icon = "PerspectiveSprites:Malgrave-Feed",
						iconColor = "ffe759d3",
						iconHeight = 36,
						iconWidth = 36,
						showLines = false },
					mtEnemy = {
						title = L.Category_Malgrave_Enemy,
						module = L.Module_Malgrave,
						icon = "IconSprites:Icon_MapNode_Map_PvP_BattleAlert",
						showLines = false },
					[L.Unit_Cactus_Fruit] = {
						title = L.Category_Malgrave_Cactus_Fruit,
						module = L.Module_Malgrave,
						icon = "PerspectiveSprites:Malgrave-Fruit",
						iconColor = "ffe759d3",
						iconHeight = 36,
						iconWidth = 36,
						showLines = false },
					[L.Unit_Medical_Grenade] = {
						title = L.Category_Malgrave_Medical_Grenade,
						module = L.Module_Malgrave,
						iconColor = "ffe759d3",
						iconHeight = 36,
						iconWidth = 36,
						icon = "PerspectiveSprites:Malgrave-Grenade",
						showLines = false },
					[L.Unit_Bug_Bomb] = {
						title = L.Category_Malgrave_Bug_Bomb,
						module = L.Module_Malgrave,
						iconColor = "ffe759d3",
						iconHeight = 36,
						iconWidth = 36,
						icon = "PerspectiveSprites:Malgrave-Bomb",
						showLines = false },
				}
			}
		}
	}
end

function PerspectiveOptions:LoadControls()
	return {
		Options 						= {
			Buttons 					= {
				NewButton				= {},
				DefaultButton 			= {},
				ExportButton			= {},
				ImportButton			= {} },
			CheckButtons 				= {
				CategoriesCheck 		= {	checked = true },
				SettingsCheck 			= {} } },
		Editor 							= {
			CheckButtons				= {
				DisableCheck 			= { option = "disabled" },
				CombatDisableCheck 		= { option = "disableInCombat" },
				OccludedDisableCheck 	= { option = "disableOccluded" },
				ShowIconCheck 			= { option = "showIcon" },
				ShowNameCheck 			= { option = "showName" },
				ShowDistanceCheck 		= { option = "showDistance" },
				ShowLinesCheck 			= { option = "showLines" },
				ShowOutlineCheck 		= { option = "showLineOutline" },
				ShowOffScreenLineCheck 	= { option = "showLinesOffscreen" },
				RangeFontCheck 			= { option = "rangeFont" },
				RangeIconCheck 			= { option = "rangeIcon" },
				RangeLineCheck 			= { option = "rangeLine" } },
			TextBoxes					= {
				ModuleText				= { option = "module" },
				DisplayText				= { option = "display" },
				IconText				= { option = "icon" },
				IconHeightText			= { option = "iconHeight",	isNumber = true },
				IconWidthText			= { option = "iconWidth",	isNumber = true },
				MinDistanceText			= { option = "minDistance",	isNumber = true },
				MaxDistanceText			= { option = "maxDistance",	isNumber = true },
				ZDistanceText			= { option = "zDistance",	isNumber = true },
				LineWidthText			= { option = "lineWidth",	isNumber = true },
				MaxIconsText			= { option = "max",			isNumber = true },
				MaxLinesText			= { option = "maxLines",	isNumber = true },
				RangeLimitText			= { option = "rangeLimit",	isNumber = true } },
			ColorButtons				= {
				FontColor				= { option = "fontColor" },
				IconColor				= { option = "iconColor" },
				LineColor				= { option = "lineColor" },
				RangeColor				= { option = "rangeColor" } } ,
			Buttons 					= { 
				BackButton				= {},
				DeleteButton			= {},
				DefaultButton			= {} } },
		Settings 						= {
			CheckButtons 				= {
				DisableCheck 			= { option = "disabled" },
				OffsetCheck 			= { option = "offsetLines" } },
			TextBoxes 					= {
				MaxUnitsText 			= { option = "max",			isNumber = true } },
			Sliders 					= {
				DrawSlider 				= {},
				FastSlider				= {},
				SlowSlider				= {} } } }
end

function PerspectiveOptions:ShowTargetInfo()
	local text = ""

	local function appendLine(txt, bNoReturn)
		text = text .. txt .. (not bNoReturn and "\n" or "")
	end

	local function getIndent(indent)
		local txt = ""

		for i = 1, indent do
			txt = txt .. "    "
		end

		return txt
	end

	local function deepPrint(key, value, indent)
		local txt = ""

		-- Cheat the metatable, we only want buff name anyhow.
		if key == "splEffect" then
			txt = txt .. getIndent(indent) .. "name: " .. value:GetName() .. "\n"
			txt = txt .. getIndent(indent) .. "id: " .. value:GetId()
			--value = value:GetName()
			--key = "strName"
			return txt
		end

		if type(value) == "table" or type(value) == "metatable" then
			txt = txt .. "\n" .. getIndent(indent) .. key .. ": {"
			for k, v in pairs(value) do
				txt = txt .. "\n" .. deepPrint(k, v, indent + 1)
			end
			txt = txt .. " }"
		else
			txt = txt .. getIndent(indent) .. key .. ": " .. tostring(value)
		end

		return txt
	end

	local indent = 1
	local target = GameLib.GetTargetUnit()

	if target then
		local rewards = target:GetRewardInfo()
		local state = target:GetActivationState()
		local zone = GameLib.GetCurrentZoneMap()
		local buffs = target:GetBuffs()

		appendLine("Name: " .. target:GetName())
		appendLine("ID: " .. target:GetId())
		appendLine("IsDead: " .. tostring(target:IsDead()))
		appendLine("IsValid: " .. tostring(target:IsValid()))
		appendLine("Disposition: " .. tostring(target:GetDispositionTo(GameLib.GetPlayerUnit())))
		appendLine("Difficulty: " .. tostring(target:GetDifficulty()))
		appendLine("Eliteness: " .. tostring(target:GetEliteness()))
		appendLine("Faction: " .. tostring(target:GetFaction()))
		appendLine("Title: " .. tostring(target:GetTitle()))
		appendLine("IsPvpFlagged: " .. tostring(target:IsPvpFlagged()))
		appendLine("Zone: " .. zone.strName .. " [" .. zone.id .. "]")
		appendLine("Type: " .. target:GetType())
		appendLine("MouseOverType: " .. target:GetMouseOverType())

		if rewards then
			local txt = ""
			for k, v in pairs(rewards) do
				txt = txt .. deepPrint(k, v, indent + 1)
			end

			if txt ~= "" then
				appendLine("RewardInfo: {", true)
				appendLine(txt .. " }")
			else
				appendLine("RewardInfo: {}")
			end
		else
			appendLine("RewardInfo: nil")
		end

		if state then
			local txt = ""
			for k, v in pairs(state) do
				txt = txt .. deepPrint(k, v, indent + 1)
			end

			if txt ~= "" then
				appendLine("ActivationState: {", true)
				appendLine(txt .. " }")
			else
				appendLine("ActivationState: {}")
			end
		else
			appendLine("ActivationState: nil")
		end

		if buffs then
			local txt = ""
			for k, v in pairs(buffs) do
				txt = txt .. deepPrint(k, v, indent + 1)
			end

			if txt ~= "" then
				appendLine("Buffs: {", true)
				appendLine(txt .. " }")
			else
				appendLine("Buffs: {}")
			end
		else
			appendLine("Buffs: nil")
		end
	else
		text = L.UI_Dialog_PTI_Error
	end

	self:ShowDialog(L.UI_Dialog_PTI_Header, text, true, true, L.UI_Dialog_PTI_Button_Text, "ShowTargetInfo")
end

function PerspectiveOptions:GetOptionValue(ui, option, category)
	local category = category 
	
	if not category and ui then
		category = ui.category or "default"
	end

	-- Get the category option value
	if self.db.profile[self.profile].categories[category] and
		self.db.profile[self.profile].categories[category][option] ~= nil then
		return self.db.profile[self.profile].categories[category][option]
	-- Failback to the default option value
	elseif self.db.defaults.profile[self.profile].categories.default[option] ~= nil then
		if category == "pathLocation" and option == "icon" then
			return self:GetPathIcon()
		else
			return self.db.defaults.profile[self.profile].categories.default[option]
		end
	end
	
	return nil
end

function PerspectiveOptions:GetPathIcon()
	local path

	if PlayerPathLib.GetPlayerPathType() == PlayerPathLib.PlayerPathType_Explorer then
		path = "explorer"
	elseif PlayerPathLib.GetPlayerPathType() == PlayerPathLib.PlayerPathType_Scientist then
		path = "scientist"
	elseif PlayerPathLib.GetPlayerPathType() == PlayerPathLib.PlayerPathType_Settler then
		path = "settler"
	elseif PlayerPathLib.GetPlayerPathType() == PlayerPathLib.PlayerPathType_Soldier then
		path = "soldier"
	end

	return self.db.profile[self.profile].categories[path].icon
	--return "PerspectiveSprites:Path-" .. path
end

function PerspectiveOptions:OnInterfaceMenuListHasLoaded()
	Event_FireGenericEvent("InterfaceMenuList_NewAddOn", "Perspective", {"InterfaceMenuClicked", "", "IconSprites:Icon_Windows32_UI_CRB_InterfaceMenu_Map"})
end

function PerspectiveOptions:OnInterfaceMenuClicked(arg1, arg2, arg3)
	if not self.initialized then
		self:InitializeOptions()
	end

	self.Options:Show(not self.Options:IsShown(), true)
end

---------------------------------------------------------------------------------------------------
-- UI Functions
---------------------------------------------------------------------------------------------------

function PerspectiveOptions:OnConfigure()
	if not self.initialized then
		self:InitializeOptions()
	end

	self.Options:Show(true, true)
end

function PerspectiveOptions:ShowOptions()
	if not self.initialized then
		self:InitializeOptions()
	end

	self.Options:Show(true, true)
end

function PerspectiveOptions:OnCloseButton()
	self.Options:Show(false, true)
end

function PerspectiveOptions:SetPixie(window, index, options)
	--local window = self.Options:FindChild(parent)
	local pi = window:GetPixieInfo(index)

	pi.strText = options.text or pi.strText
	pi.crText = options.textColor or pi.crText
	pi.strSprite = options.sprite or pi.strSprite
	pi.cr = options.color or pi.cr
	pi.flagsText = options.flagsText or pi.flagsText

	window:UpdatePixie(index, pi)
end

function PerspectiveOptions:CColorToString(color)
	return string.format("%02X%02X%02X%02X", 
		math.floor(color.a * 255 + 0.5),
		math.floor(color.r * 255 + 0.5), 
		math.floor(color.g * 255 + 0.5), 
		math.floor(color.b * 255 + 0.5))
end

function PerspectiveOptions:StringToCColor(str)
	local r, g, b, a = 0, 0, 0, 0

	-- Get the alpha values.
	local alpha = string.sub(str, 1, 2)

	-- Convert to hex
	alpha = tonumber(alpha, 16)

	str = string.sub(str, 3)

	local val = tonumber(str, 16)

	if val then
		r = math.floor(val / 65536) 
		g = math.floor(val / 256) % 256
		b = val % 256
		a = alpha % 256
	end

	return CColor.new(r / 255, g / 255, b / 255, a / 255)
end

function PerspectiveOptions:ArrangeChildren(window, type)
	local sort = function (a, b) 
		a = a:GetData().sortValue
		b = b:GetData().sortValue

		a = (a == "_first" and " " or a) or "zzzz"
		b = (b == "_first" and " " or b) or "zzzz"

		return a < b
	end

	window:ArrangeChildrenVert(0, sort)
end

function PerspectiveOptions:InitializeOptions()
	-- Only run these actions on the first initialize
	if not self.initialized then
		-- Setup the event handlers for the options window
		self.Options:AddEventHandler("WindowMoved", 		"OnOptions_AnchorsChanged")
		self.Options:AddEventHandler("WindowSizeChanged", 	"OnOptions_AnchorsChanged")
	end

	-- Load the window position
	local pos = self.db.profile.position

	if pos ~= nil then
		self.Options:SetAnchorOffsets(pos.left, pos.top, pos.right, pos.bottom)
	end

	-- Initialize Options Buttons
	for name, options in pairs(controls.Options.Buttons) do
		self:ButtonInitialize("Options", name, nil, options)
	end

	-- Initialize Options CheckButtons
	for name, options in pairs(controls.Options.CheckButtons) do
		self:CheckButtonInitialize("Options", name, nil, options)
	end

	-- List of modules to check against
	local modules = {}

	-- Initialize the categories
	for category, cat in pairs(self.db.profile[self.profile].categories) do
		if category ~= "default" then
			if cat.module then
				-- Create the category buttons
				self:CategoryItemInitialize(category, cat.module)

				-- Create the module buttons
				self:ModuleItemInitialize(category, cat.module)

				-- Add the module to the list.
				modules[cat.module] = true
			end
		end
	end

	-- Check to make sure all our items still exist
	for i, item in pairs(self.CategoryList:GetChildren()) do
		if not self.db.profile[self.profile].categories[item:GetData().category] then
			item:Destroy()
		end
	end

	-- Check to make sure all our items still exist
	for i, item in pairs(self.ModuleList:GetChildren()) do
		if not modules[item:GetData().module] then
			item:Destroy()
		end
	end

	-- Initialize Settings Tab
	for name, options in pairs(controls.Settings.CheckButtons) do
		self:CheckButtonInitialize("Settings", name, "settings", options)
	end

	-- Initialize Options CheckButtons
	for name, options in pairs(controls.Settings.Sliders) do
		--self:SliderInitialize("Settings", name, nil, options)
	end

	-- Initialize Options TextBoxes
	for name, options in pairs(controls.Settings.TextBoxes) do
		self:TextBoxInitialize("Settings", name, "settings", options)
	end

	--self:Settings_CheckInit("Disable", 		"disabled")

	self:Settings_TimerInit("DrawSlider", 	"draw", 0, "ms", 1000, 	"OnTimerTicked_Draw")
	self:Settings_TimerInit("FastSlider", 	"fast", 1, "ms", 1000, 	"OnTimerTicked_Fast")
	self:Settings_TimerInit("SlowSlider", 	"slow", 1, "secs", 1,	"OnTimerTicked_Slow")

	--self:Settings_TextInit("Max", 			"max", 		true)
	--self:Settings_TextInit("InArea", 		"inArea", 	true)

		-- Sort the lists.
	self:ArrangeChildren(self.CategoryList)
	self:ArrangeChildren(self.ModuleList)

	if not self.initialized then
		-- Set the All module as the selected module
		self.module = L.Module_All

		-- Check the All button
		self.ModuleList:FindChild("ModuleItem" .. self.module):FindChild("Button"):SetCheck(true)
	else
		-- Set the module button as checked.
		local module = self.ModuleList:FindChild("ModuleItem" .. self.module)

		if not module then
			module = self.ModuleList:FindChild("ModuleItem" .. L.Module_All)
		end

		local button = module:FindChild("Button")

		self:ModuleItemChecked(nil, button, nil)
	end	



		

	-- Let the addon know we are now fully initialized.
	self.initialized = true
end

function PerspectiveOptions:ModuleItemInitialize(category, module)
	local item = self.ModuleList:FindChild("ModuleItem" .. module)
	local button

	if not item then
		-- Create a new module item.
		item = Apollo.LoadForm(self.xmlDoc, "ModuleItem", self.ModuleList, self)
		
		-- Get the button
		button = item:FindChild("Button")
		
		-- Setup the button event handlers
		button:AddEventHandler("ButtonCheck", "ModuleItemChecked")
		button:AddEventHandler("ButtonUncheck", "ModuleItemChecked")
	else
		-- Get the button
		button = item:FindChild("Button")
	end

	-- Set the module for the button
	button:SetData(module)

	-- Set the name for the item.
	item:SetName("ModuleItem" .. module)

	-- Get the sortBy value.
	local sortBy = module == L.Module_All and "_first" or module

	-- Set the data for the item.
	item:SetData({ module = module, sortValue = sortBy })

	local text = button:GetPixieInfo(1)
	text.strText = module
	text.flagsText = { DT_VCENTER = true }
	button:UpdatePixie(1, text)
end

function PerspectiveOptions:ModuleItemChecked(handler, control, button)
	-- Get the module for the item
	local module = control:GetData()

	-- Iterrate the category items and show only the items for the selected module.
	for index, item in pairs(self.CategoryList:GetChildren()) do
		-- Get the module for the list item.
		local m = item:GetData().module

		-- If the module matches or we are showing all, then show the item, otherwise hide it.
		if m == module or module == L.Module_All or m == L.Module_All then
			item:Show(true, true)
		else
			item:Show(false, true)
		end
	end

	if self.module and self.module ~= module then
		-- Uncheck the previous module button
		local modItem = self.ModuleList:FindChild("ModuleItem" .. self.module)

		if modItem then
			modItem:FindChild("Button"):SetCheck(false)
		end
	end

	-- Save the selected module for later.
	self.module = module

	-- Arrange the list items.
	self:ArrangeChildren(self.CategoryList)

	-- Scroll the list to the top
	self.CategoryList:SetVScrollPos(0)
end

function PerspectiveOptions:CategoryItemInitialize(category, module)
	
	local item = self.CategoryList:FindChild("CategoryItem" .. category)

	local button, check

	if not item then
		-- Create a new category item.
		item = Apollo.LoadForm(self.xmlDoc, "CategoryItem", self.CategoryList, self)

		button = item:FindChild("Button")

		check = button:FindChild("Check")
		
		button:AddEventHandler("ButtonSignal", "CategoryItemClicked")
		check:AddEventHandler("ButtonCheck", "CategoryItemChecked")
		check:AddEventHandler("ButtonUncheck", "CategoryItemChecked")
	else
		button = item:FindChild("Button")

		check = button:FindChild("Check")
		check:AddEventHandler("ButtonCheck", "CategoryItemChecked")
		check:AddEventHandler("ButtonUncheck", "CategoryItemChecked")
	end

	-- Set the category for the button
	button:SetData(category)
	check:SetData(category)

	check:SetCheck(not self:GetOptionValue(nil, "disabled", category))

	-- Set the name for the item.
	item:SetName("CategoryItem" .. category)

	-- Get the sortBy value.
	local sortBy = category == "all" and "_first" or self:GetOptionValue(nil, "title", category)

	-- Set the data for the item.
	item:SetData({ 
		category = category, 
		module = module,
		sortValue = sortBy
	})

	local icon = button:GetPixieInfo(1)
	icon.strSprite = self:GetOptionValue(nil, "icon", category)
	icon.cr = self:GetOptionValue(nil, "iconColor", category)
	button:UpdatePixie(1, icon)

	local text= button:GetPixieInfo(2)
	text.strText = self:GetOptionValue(nil, "title", category)
	text.flagsText = { DT_VCENTER = true }
	button:UpdatePixie(2, text)
end

function PerspectiveOptions:CategoryItemClicked(handler, control, button)
	-- Set the currently selected category
	self.category = control:GetData()

	-- Show the category editor.
	self:EditorInitialize(self.category)
end

function PerspectiveOptions:CategoryItemChecked(handler, control, button)
	-- Get the category
	local category = control:GetData()

	-- Disable/Enable the category
	self.db.profile[self.profile].categories[category].disabled = not control:IsChecked()
	
	if category == "all" then
		for c, cat in pairs(self.db.profile[self.profile].categories) do
			if (self.module == L.Module_All and c ~= "default") or cat.module == self.module then
				-- Toggle the category
				cat.disabled = not control:IsChecked()

				-- Get the category checkbox
				self.CategoryList:FindChild("CategoryItem" .. c):FindChild("Check"):SetCheck(not cat.disabled)
			end
		end
	else
		-- Toggle the category
		self.db.profile[self.profile].categories[category].disabled = not control:IsChecked()
	end	

	-- Update all the ui options.
	Perspective:UpdateOptions(nil, true) 
end

function PerspectiveOptions:EditorInitialize(category)

	local function loadDropDown(name, category, option)
		-- Get the control by name
		local control = self.Editor:FindChild(name .. "DropDownButton")

		-- Disable the line texts
		if option == "limitBy" then
			if category == "pathLocation" or 
				category == "questLocation" or
				category == "eventLocation" or
				category == "challengeLocation" then
				control:Enable(false)
			else
				control:Enable(true)
			end
		end		

		-- Get the menu associated with the control
		local menu = self.Editor:FindChild(name .. "DropDownMenu")

		-- Set the control value.
		control:SetText(self:GetOptionValue(nil, option, category))

		-- Make sure we haven't already set the event handlers
		if not control:GetData() then
			control:AddEventHandler("ButtonSignal", "Editor_OnDropDown")

			for k, v in pairs(menu:GetChildren()) do
				v:AddEventHandler("ButtonCheck", 	"Editor_OnDropDownItem")
				v:AddEventHandler("ButtonUncheck", 	"Editor_OnDropDownItem")
			end
		end

		-- Set the data for the control.
		control:SetData({ category = category, option = option, menu = menu })

		-- Set the data for the menu.
		menu:SetData({ button = control })
	end

	local title = 	self:GetOptionValue(nil, "title", 		category)
	local icon = 	self:GetOptionValue(nil, "icon", 		category)
	local color = 	self:GetOptionValue(nil, "iconColor", 	category)

	-- Set the category editor image pixie
	self:SetPixie(self.Editor, 1, { sprite = icon, color = color })

	local custom = self:GetOptionValue(nil, "custom", category)
	
	local catEdit = self.Editor:FindChild("CategoryEdit")

	-- Set the rename text
	catEdit:SetText(title)

	if not catEdit:GetData() then
		catEdit:AddEventHandler("EditBoxReturn", 	"TextBoxReturnEditorCategoryEdit")
		catEdit:AddEventHandler("EditBoxTab", 		"TextBoxReturnEditorCategoryEdit")
		catEdit:AddEventHandler("EditBoxEscape", 	"TextBoxEscapeEditorCategoryEdit")
	end

	catEdit:SetData(category)

	-- Set the module
	self.Editor:SetData(self:GetOptionValue(nil, "module", category))

	-- Initialize the buttons
	for name, options in pairs(controls.Editor.Buttons) do
		self:ButtonInitialize("Editor", name, category, options)
	end

	-- Initialize the checkbuttons
	for name, options in pairs(controls.Editor.CheckButtons) do
		self:CheckButtonInitialize("Editor", name, category, options)
	end

	-- Initialize the textboxes
	for name, options in pairs(controls.Editor.TextBoxes) do
		self:TextBoxInitialize("Editor", name, category, options)
	end

	-- Initialize the colorbuttons
	for name, options in pairs(controls.Editor.ColorButtons) do
		self:ColorButtonInitialize("Editor", name, category, options)
	end

	-- Show the rename edit box if this is a custom item
	if custom then
		-- Show the edit box border
		self:SetPixie(self.Editor, 2, { sprite = "BK3:UI_BK3_Holo_InsetSimple" })
		-- Allow edits
		catEdit:SetStyleEx("ReadOnly", false)
		-- Show the delete button
		self.Editor:FindChild("DeleteButton"):Show(true, true)
	else
		-- Hide the edit box border
		self:SetPixie(self.Editor, 2, { sprite = "" })
		-- Do not allow edits
		catEdit:SetStyleEx("ReadOnly", true)
		-- Hide the delete button
		self.Editor:FindChild("DeleteButton"):Show(false, true)
	end

	--[[loadDropDown("LimitBy",			category, "limitBy")

	for k, v in pairs(fonts) do
		self.Editor:FindChild("FontDropDown"):FindChild("DropDown"):AddItem(k)
	end]]

	self.ModuleList:GetParent():Show(false, true)
	self.CategoryList:GetParent():Show(false, true)
	self.Editor:Show(true, true)
end

-----------------------------------------------------------------------------------------
-- Dialog
-----------------------------------------------------------------------------------------

function PerspectiveOptions:ShowDialog(title, text, readOnly, hasCopy, buttonText, buttonFunc)
	local copyButton = self.Dialog:FindChild("CopyButton")
	local textBox = self.Dialog:FindChild("TextBox")
	local mainButton = self.Dialog:FindChild("MainButton")

	self:SetPixie(self.Dialog, 5, { text = title, flagsText = { DT_CENTER = true, DT_VCENTER = true } })

	mainButton:SetText(buttonText)

	if buttonFunc then
		mainButton:AddEventHandler("ButtonSignal", buttonFunc)
	else
		mainButton:FindChild("MainButton"):RemoveEventHandler("ButtonSignal")
	end

	textBox:SetText(text)

	if hasCopy then
		copyButton:Show(true, true)
		copyButton:SetActionData(GameLib.CodeEnumConfirmButtonType.CopyToClipboard, text)
	else
		copyButton:Show(false, true)
	end

	textBox:SetStyleEx("ReadOnly", readOnly)

	self.Dialog:Show(true, true)

	self.Dialog:ToFront()
end

function PerspectiveOptions:CloseDialog()
	self.Dialog:Show(false, false)
end

function PerspectiveOptions:ImportSettings()
	-- Parse the dialog text.
	local profile = JSON.decode(self.Dialog:FindChild("TextBox"):GetText())
	
	for k, v in pairs(profile) do
		self.db.profile[k] = {}
		self.db.profile[k] = v
	end
	-- Save the import to your profile.
	self.db.profile = profile

	-- Do a full update on the uis
	Perspective:UpdateOptions(nil, true)

	self:InitializeOptions()

	self.Editor:Show(false, true)
	self.ModuleList:GetParent():Show(true, true)
	self.CategoryList:GetParent():Show(true, true)

	Perspective:Stop()
	Perspective:Start()

	self.Dialog:Show(false, false)
end

-----------------------------------------------------------------------------------------
-- Button
-----------------------------------------------------------------------------------------

function PerspectiveOptions:ButtonInitialize(parent, name, category, options)
	-- Get the control by name
	local control = self[parent]:FindChild(name)

	-- Set the text
	control:SetText(L["UI_" .. parent .. "_" .. name .. "_Text"])

	-- Set the control toolip.
	control:SetTooltip(L["UI_" .. parent .. "_" .. name .. "_Tooltip"])	

	-- Make sure we haven't already set the event handlers
	if not control:GetData() then
		--Setup the event handlers
		control:AddEventHandler("ButtonSignal", "ButtonClicked" .. parent .. name)
	end

	-- Set the data for the control.
	control:SetData({ category = category, options = options })
end

function PerspectiveOptions:ButtonClickedOptionsNewButton(handler, control, button)
	self.db.profile[self.profile].categories[L.Unit_Custom] = {
		title = L.Unit_Custom,
		module = L.Module_Custom,
		custom = true }

	self:InitializeOptions()

	self:EditorInitialize(L.Unit_Custom)
end

function PerspectiveOptions:ButtonClickedOptionsDefaultButton(handler, control, button)
	if button == 1 then
		self.db:ResetDB()

		self:InitializeOptions()

		self.Editor:Show(false, true)
		self.ModuleList:GetParent():Show(true, true)
		self.CategoryList:GetParent():Show(true, true)

		-- Update all the uis
		Perspective:UpdateOptions(nil, true)

		-- Restart Perspective
		Perspective:Stop()
		Perspective:Start()

		-- Update the markers.
		Perspective:MarkersInit()
	end
end

function PerspectiveOptions:ButtonClickedOptionsImportButton(handler, control, button)
	self:ShowDialog(L.UI_Dialog_Import_Header, "", false, false, L.UI_Options_ImportButton_Text, "ImportSettings")
end

function PerspectiveOptions:ButtonClickedOptionsExportButton(handler, control, button)
	local profile = JSON.encode(self.db.profile)
	self:ShowDialog(L.UI_Dialog_Export_Header, profile, true, true, L.UI_Options_ExportButton_Text , "CloseDialog")
end

function PerspectiveOptions:ButtonClickedEditorBackButton(handler, control, button)
	self.Editor:Show(false, true)
	self.ModuleList:GetParent():Show(true, true)
	self.CategoryList:GetParent():Show(true, true)
end

function PerspectiveOptions:ButtonClickedEditorDeleteButton(handler, control, button)
	local data = control:GetData()

	self.db.profile[self.profile].categories[data.category] = nil

	self:InitializeOptions()

	self.Editor:Show(false, true)
	self.ModuleList:GetParent():Show(true, true)
	self.CategoryList:GetParent():Show(true, true)

	-- Update all the uis
	Perspective:UpdateOptions(nil, true)
end

function PerspectiveOptions:ButtonClickedEditorDefaultButton(handler, control, button)
	local data = control:GetData()

	self.db.profile[self.profile].categories[data.category] = {}
	for k, v in pairs(self.db.defaults.profile[self.profile].categories[data.category]) do
		self.db.profile[self.profile].categories[data.category][k] = v
	end

	self:InitializeOptions()

	self:EditorInitialize(data.category)

	-- Update all the uis
	Perspective:UpdateOptions(nil, true)	
end

-----------------------------------------------------------------------------------------
-- CheckButton
-----------------------------------------------------------------------------------------

function PerspectiveOptions:CheckButtonInitialize(parent, name, category, options)
	-- Get the control by name
	local control = self[parent]:FindChild(name)

	-- Set the control text.
	control:SetText(L["UI_" .. parent .. "_" .. name .. "_Text"])
	
	-- Set the control toolip.
	control:SetTooltip(L["UI_" .. parent .. "_" .. name .. "_Tooltip"] or "")

	-- Set the checkbutton value.
	if category == "settings" then
		control:SetCheck(options.checked or self.db.profile[self.profile].settings[options.option])
	elseif category then
		-- category checkbutton
		control:SetCheck(self:GetOptionValue(nil, options.option, category))

		-- Show the checkbutton
		control:Show(true, true)

		-- Disable the location checkbuttons
		if category == "questLocation" or
			category == "eventLocation" or
			category == "pathLocation" or
			category == "challengeLocation" then
			if options.option == "disableInCombat" or 
				options.option == "disableOccluded" or
				options.option == "showLines" or
				options.option == "showLineOutline" or
				options.option == "showLinesOffscreen" or
				options.option == "rangeFont" or
				options.option == "rangeIcon" or
				options.option == "rangeLine" then
				-- Hide the checkbutton
				control:Show(false, true)
			end
		end
	end

	-- Make sure we haven't already set the event handlers
	if not control:GetData() then
		if category then
			--Setup the event handlers
			control:AddEventHandler("ButtonCheck", 		"CheckButtonClicked" .. parent)
			control:AddEventHandler("ButtonUncheck", 	"CheckButtonClicked" .. parent)
		else
			control:AddEventHandler("ButtonCheck", 		"CheckButtonClicked" .. parent .. name)
			control:AddEventHandler("ButtonUncheck", 	"CheckButtonClicked" .. parent .. name)
		end
	end

	-- Set the data for the control.
	control:SetData({ category = category, options = options })
end

function PerspectiveOptions:CheckButtonClickedEditor(handler, control, button)
	-- Get the control's data
	local data = control:GetData()
	
	-- Get the control's value
	local val = control:IsChecked()

	-- Check to see if we need to set the value for all categories
	if data.category == "all" then
		for category, cat in pairs(self.db.profile[self.profile].categories) do
			if (self.module == L.Module_All and category ~= "default") or cat.module == self.module then
				cat[data.options.option] = val
			end
		end
	else
		self.db.profile[self.profile].categories[data.category][data.options.option] = val	
	end

	if data.category == "questLocation" or
		data.category == "eventLocation" or
		data.category == "pathLocation" or
		data.category == "challengeLocation" then
		-- Update the markers.
		Perspective:MarkersInit()
	else
		-- Update all the ui options.
		Perspective:UpdateOptions(nil, (data.options.option == "disabled")) 
	end
end

function PerspectiveOptions:CheckButtonClickedSettings(handler, control, button)
	-- Get the control's data
	local data = control:GetData()
	
	-- Get the control's value
	local val = control:IsChecked()

	self.db.profile[self.profile].settings[data.options.option] = val	

	if data.options.option == "disabled" then
		if val then
			Perspective:Stop()
		else
			Perspective:Start()
		end
	elseif data.options.option == "offsetLines" then
		Perspective.offsetLines = val
	end
end

function PerspectiveOptions:CheckButtonClickedOptionsCategoriesCheck(handler, control, button)
	self:OnHeaderButtonClicked("Categories")

	control:SetCheck(true)
end

function PerspectiveOptions:CheckButtonClickedOptionsSettingsCheck(handler, control, button)
	self:OnHeaderButtonClicked("Settings")

	control:SetCheck(true)
end

-----------------------------------------------------------------------------------------
-- TextBox
-----------------------------------------------------------------------------------------

function PerspectiveOptions:TextBoxInitialize(parent, name, category, options)
	-- Get the control by name
	local control = self[parent]:FindChild(name)
	local edit = control:FindChild("EditBox")

	-- Set the textbox label.
	self:SetPixie(control, 1, { text = L["UI_" .. parent .. "_" .. name .. "_Text"], flagsText = { DT_VCENTER = true } })

	-- Set the control toolip.
	control:SetTooltip(L["UI_" .. parent .. "_" .. name .. "_Tooltip"] .. "  " .. L.UI_Options_Tooltip_Action)
	
	-- Set the textbox value.
	if category == "settings" then
		-- Settings checkbutton
		edit:SetText(self.db.profile[self.profile].settings[options.option])
	else
		-- Category textbox
		edit:SetText(self:GetOptionValue(nil,  options.option, category) or "")

		-- Show the textbox
		control:Show(true, true)

		-- Disable the location checkbuttons
		if category == "questLocation" or
			category == "eventLocation" or
			category == "pathLocation" or
			category == "challengeLocation" then
			if options.option == "maxLines" or 
				options.option == "lineWidth" or
				options.option == "zDistance" or
				options.option == "display" or
				options.option == "rangeLimit" then
				-- Hide the textbox
				control:Show(false, true)
			end
		end
	end

	-- Make sure we haven't already set the event handlers
	if not edit:GetData() then
		--Setup the event handlers
		edit:AddEventHandler("EditBoxReturn", 	"TextBoxReturn" .. parent)
		edit:AddEventHandler("EditBoxTab", 		"TextBoxReturn" .. parent)
		edit:AddEventHandler("EditBoxEscape", 	"TextBoxEscape" .. parent)
	end
	
	-- Set the data for the control.
	edit:SetData({ category = category, options = options })
end

function PerspectiveOptions:TextBoxReturnEditor(handler, control)
	-- Get the control's data
	local data = control:GetData()

	-- Get the control's value
	local val = control:GetText()

	-- Check to see if the textbox is expecting a number
	if data.options.isNumber then
		if not tonumber(val) then
			val = self:GetOptionValue(nil, data.options.option, data.category)
		else
			val = tonumber(val)
		end
	end

	-- If the option is blank, load the default setting.
	if val == "" then 
		val = self:GetOptionValue(nil, data.options.option, data.category)
	end

	-- Check to see if we need to set the value for all categories
	if data.category == "all" then
		for category, cat in pairs(self.db.profile[self.profile].categories) do
			if (self.module == L.Module_All and category ~= "default") or cat.module == self.module then
				cat[data.options.option] = val
				if data.options.option == "icon" then
					self:Editor_UpdateIcon(category)
				end
			end
		end
	else
		self.db.profile[self.profile].categories[data.category][data.options.option] = val	

		if data.options.option == "icon" then
			self:Editor_UpdateIcon(data.category)
		end
	end

	if data.options.option ~= "module" then
		if data.category == "questLocation" or
			data.category == "eventLocation" or
			data.category == "pathLocation" or
			data.category == "challengeLocation" then
			-- Update the markers.
			Perspective:MarkersInit()
		else
			-- Update all the ui options.
			Perspective:UpdateOptions() 
		end
	else
		self:InitializeOptions()
	end
end

function PerspectiveOptions:TextBoxEscapeEditor(handler, control)
	-- Get the control's data
	local data = control:GetData()

	-- Load the previous value
	control:SetText(self:GetOptionValue(nil, data.options.option, data.category) or "")
end

function PerspectiveOptions:TextBoxReturnEditorCategoryEdit(handler, control)
	-- Get the data from the control
	local oldCategory = control:GetData()

	-- Get the new category
	local category = control:GetText()

	if self.db.profile[self.profile].categories[category] or
		category == "all" or
		category == "default" or
		category == "oldCategory" then
		-- Category already exists or is not allowed.
		control:SetText(oldCategory)
	else
		self.db.profile[self.profile].categories[category] = {}
		
		for k, v in pairs(self.db.profile[self.profile].categories[oldCategory] or {}) do
			self.db.profile[self.profile].categories[category][k] = v
		end

		-- Update the title
		self.db.profile[self.profile].categories[category].title = category

		-- Delete the custom unit
		self.db.profile[self.profile].categories[oldCategory] = nil

		-- Reinit the options
		self:InitializeOptions()

		-- Show our new category.
		self:EditorInitialize(category)

		-- Update the ui options
		Perspective:UpdateOptions(nil, true)
	end
end

function PerspectiveOptions:TextBoxReturnSettings(handler, control)
	-- Get the control's data
	local data = control:GetData()

	-- Get the control's value
	local val = control:GetText()

	-- Check to see if the textbox is expecting a number
	if data.options.isNumber then
		if not tonumber(val) then
			val = self.db.profile[self.profile].settings[options.option]
		else
			val = tonumber(val)
		end
	end

	-- If the option is blank, load the default setting.
	if val == "" then 
		val = self.db.profile[self.profile].settings[options.option]
	end

	self.db.profile[self.profile].settings[data.options.option] = val	

	-- Update the markers.
	Perspective:MarkersInit()

	-- Update all the ui options.
	Perspective:UpdateOptions() 
end

function PerspectiveOptions:TextBoxEscapeSettings(handler, control)
	-- Get the control's data
	local data = control:GetData()

	-- Load the previous value
	control:SetText(self.db.profile[self.profile].settings[data.options.option])
end

-----------------------------------------------------------------------------------------
-- ColorButton
-----------------------------------------------------------------------------------------

function PerspectiveOptions:ColorButtonInitialize(parent, name, category, options)
	-- Get the control by name
	local control = self[parent]:FindChild(name)
	local button = control:FindChild("Button")

	local color

	-- Set the textbox label.
	self:SetPixie(control, 1, { text = L["UI_" .. parent .. "_" .. name .. "_Text"], flagsText = { DT_VCENTER = true } })
	
	-- Set the control tooltip.
	control:SetTooltip(L["UI_" .. parent .. "_" .. name .. "_Tooltip"])	

	-- Set the button value
	if category then
		-- category color button
		color = self:GetOptionValue(nil, options.option, category)

		-- Show the checkbutton
		control:Show(true, true)

		-- Disable the location checkbuttons
		if category == "questLocation" or
			category == "eventLocation" or
			category == "pathLocation" or
			category == "challengeLocation" then
			if options.option == "lineColor" or 
				options.option == "rangeColor" then
				-- Hide the checkbutton
				control:Show(false, true)
			end
		end
	else
		-- Setting color button
		color = self.db.profile[self.profile].settings[options.option]
	end

	-- Make sure we haven't already set the event handlers
	if not button:GetData() then
		-- Setup the event handlers
		button:AddEventHandler("ButtonSignal", "ColorButtonClicked" .. parent)
	end

	button:SetBGColor(color)

	-- Set the data for the control.
	button:SetData({ category = category, options = options, color = color })
end

function PerspectiveOptions:ColorButtonClickedEditor(handler, control, button)
	local function setColor(data)

		-- Convert the color back to str
		local color = self:CColorToString(self.color)

		-- Set the control color
		control:SetBGColor(color)

		-- Update the settings
		if data.category == "all" then
			for category, cat in pairs(self.db.profile[self.profile].categories) do
				if (self.module == L.Module_All and category ~= "default") or cat.module == self.module then
					cat[data.options.option] = color

					if data.option == "iconColor" then
						self:Editor_UpdateIcon(category)
					end
				end
			end
		else
			self.db.profile[self.profile].categories[data.category][data.options.option] = color

			if data.options.option == "iconColor" then
				self:Editor_UpdateIcon(data.category)
			end
		end

		if data.category == "questLocation" or
			data.category == "eventLocation" or
			data.category == "pathLocation" or
			data.category == "challengeLocation" then
			-- Update the markers.
			Perspective:MarkersInit()
		else
			-- Update all the ui options.
			Perspective:UpdateOptions() 
		end

		-- Set the data for the control.
		control:SetData({ category = data.category, options = data.options, color = color })
	end

	-- Get the data for the control
	local data = control:GetData()

	-- Convert the color string
	self.color = self:StringToCColor(data.color)

	-- Show the color picker.
	if ColorPicker then
		ColorPicker.AdjustCColor(self.color, true, setColor, data)
	else
		ChatSystemLib.PostOnChannel(ChatSystemLib.ChatChannel_Realm, "This option requires the ColorPicker addon to be installed.")
	end
end	







function PerspectiveOptions:Editor_OnDropDown(handler, control, button)
	-- Get the control's data.
	local data = control:GetData()

	-- Set the selected value
	for k, v in pairs(data.menu:GetChildren()) do
		if v:GetText() == control:GetText() then
			v:SetCheck(true)
		else
			v:SetCheck(false)
		end
	end

	-- Show the menu and bring it to the top
	data.menu:Show(true, true)--:BringChildToTop(data.menu)
end

function PerspectiveOptions:Editor_OnDropDownItem(handler, control, button)
	-- Get the data for the control
	local data = control:GetParent():GetData()

	-- Get the button that called the menu
	local button = data.button

	-- Get the data for the button
	data = button:GetData()

	-- Get the text of the selected dropdownmenu button
	local val = control:GetText()

	-- Update the button text for the caller button
	button:SetText(val)

	-- Hide the dropdownmenu immediately
	control:GetParent():Show(false, true)

	-- Update the settings.
	if data.category == "all" then
		for category, cat in pairs(self.db.profile[self.profile].categories) do
			if (self.module == L.Module_All and category ~= "default") or cat.module == self.module then
				cat[data.option] = val
			end
		end
	else
		self.db.profile[self.profile].categories[data.category][data.option] = val
	end

	-- Update all the ui options.
	Perspective:UpdateOptions()

	-- Update the markers.
	Perspective:MarkersInit()
end

function PerspectiveOptions:Editor_OnColorClick(handler, control, button)

	local function setColor(data)
		-- Convert the color back to str
		local color = self:CColorToString(self.color)
		
		-- Set the control color
		control:SetBGColor(color)

		-- Update the settings
		if data.category == "all" then
			for category, cat in pairs(self.db.profile[self.profile].categories) do
				if (self.module == L.Module_All and category ~= "default") or cat.module == self.module then
					cat[data.option] = color

					if data.option == "iconColor" then
						self:Editor_UpdateIcon(category)
					end
				end
			end
		else
			self.db.profile[self.profile].categories[data.category][data.option] = color

			if data.option == "iconColor" then
				self:Editor_UpdateIcon(data.category)
			end
		end

		-- Update all the ui options.
		Perspective:UpdateOptions() 

		-- Update the markers.
		Perspective:MarkersInit()
	end

	-- Get the data for the control
	local data = control:GetData()

	-- Convert the color string
	self.color = self:StringToCColor(data.color)

	-- Show the color picker.
	if ColorPicker then
		ColorPicker.AdjustCColor(self.color, false, setColor, data)
	else
		ChatSystemLib.PostOnChannel(ChatSystemLib.ChatChannel_Realm, "This option requires the ColorPicker addon to be installed.")
	end
end

function PerspectiveOptions:Editor_UpdateIcon(category)
	-- Get our category item button
	local button  = self.CategoryList:FindChild("CategoryItem" .. category):FindChild("Button")

	-- Get the icon and icon color.
	local icon = self:GetOptionValue(nil, "icon", category)
	local iconColor = self:GetOptionValue(nil, "iconColor", category)

	if category == self.category or category == "all" then
		-- Update the category editor icon.
		local pixie = self.Editor:GetPixieInfo(1)
		pixie.strSprite = icon
		pixie.cr = iconColor
		self.Editor:UpdatePixie(1, pixie)
	end

	-- Update our icon pixie
	local pixie = button:GetPixieInfo(1)
	pixie.strSprite = icon
	pixie.cr = iconColor
	button:UpdatePixie(1, pixie)
end

function PerspectiveOptions:Settings_CheckInit(name, option)
	local control = self.Settings:FindChild(name .. "Check")

	-- Set the check value.
	control:SetCheck(self.db.profile[self.profile].settings[option])

	-- Make sure we haven't already set the event handlers
	if not control:GetData() then
		--Setup the event handlers
		control:AddEventHandler("ButtonCheck", 		"Settings_OnChecked")
		control:AddEventHandler("ButtonUncheck", 	"Settings_OnChecked")	
	end

	-- Set the data for the control.
	control:SetData({ option = option })
end

function PerspectiveOptions:Settings_TimerInit(name, value, numDecimal, unit, divBy, tickFunc)
	local control = self["Settings"]:FindChild(name)
	
	control:SetTooltip(L["UI_Settings_" .. name .. "_Tooltip"])

	control:FindChild(name .. "Label"):SetText(L["UI_Settings_" .. name .. "_Text"])
	
	local slider = control:FindChild("Slider")
	
	local text = self.Settings:FindChild(name .. "Text")

	local val = tonumber(Apollo.FormatNumber(self.db.profile[self.profile].settings[value], numDecimal))

	if val then
		-- Set the slider value.
		slider:SetValue(val)

		-- Set the text value.
		text:SetText(val .. " " .. unit)
		
		-- Make sure we haven't already set the event handlers
		if not slider:GetData() then
			-- Set the event handler
			slider:AddEventHandler("SliderBarChanged", "Settings_OnTimerChanged")
		end

		-- Associate the text control with the slider.
		slider:SetData({ 
			text = text, 
			value = value, 
			numDecimal = numDecimal, 
			unit = unit,
			divBy = divBy,
			tickFunc = tickFunc 
		})
	end
end

function PerspectiveOptions:Settings_TextInit(name, option, isNumber)
	-- Get the control by name
	local control = self.Settings:FindChild(name .. "Text")

	-- Set the text value.
	control:SetText(self.db.profile[self.profile].settings[option])

	-- Make sure we haven't already set the event handlers
	if not control:GetData() then
		--Setup the event handlers
		control:AddEventHandler("EditBoxReturn", 	"Settings_OnTextReturn")
		control:AddEventHandler("EditBoxTab", 		"Settings_OnTextReturn")
		control:AddEventHandler("EditBoxEscape", 	"Settings_OnTextEscape")
	end
		
	-- Set the data for the control.
	control:SetData({ option = option, isNumber = isNumber })
end

function PerspectiveOptions:Settings_OnChecked(handler, control, button)
	-- Get the control's data
	local data = control:GetData()
	
	-- Get the control's value
	local val = control:IsChecked()

	-- Set the settings value
	self.db.profile[self.profile].settings[data.option] = val	

	if data.option == "disabled" then
		if val then
			Perspective:Stop()
		else
			Perspective:Start()
		end	
	end
end

function PerspectiveOptions:Settings_OnTimerChanged(handler, control, button)
	-- Get the control's data.
	local data = control:GetData()

	-- Get the timer vale
	local val = tonumber(Apollo.FormatNumber(control:GetValue(), data.numDecimal))

	if val then
		-- Set the control's text.
		data.text:SetText(val .. " " .. data.unit)

		-- Save the value.
		self.db.profile[self.profile].settings[data.value] = val

		-- Only create new timers if the addon isn't disabled.
		if not self.db.profile[self.profile].settings.disabled then
			Perspective:SetTimers()
		end
	end
end

function PerspectiveOptions:Settings_OnTextReturn(handler, control)
	-- Get the control's data
	local data = control:GetData()

	-- Get the control's value
	local val = control:GetText()

	-- Check to see if the textbox is expecting a number
	if data.isNumber then
		if not tonumber(val) then
			val = self.db.profile[self.profile].settings[data.option]
		else
			val = tonumber(val)
		end
	end

	-- If the option is blank, load the default setting.
	if val == "" then 
		val = self.db.profile[self.profile].settings[data.option]
	end

	-- Set the option value
	self.db.profile[self.profile].settings[data.option] = val

	if data.option == "inArea" then
		Perspective:MarkersUpdate()
	end
end

function PerspectiveOptions:Settings_OnTextEscape(handler, control)
	-- Get the control's data
	local data = control:GetData()
	
	-- Load the previous value
	control:SetText(self.db.profile[self.profile].settings[data.option])
end

---------------------------------------------------------------------------------------------------
-- Options Events
---------------------------------------------------------------------------------------------------

function PerspectiveOptions:OnOptions_AnchorsChanged()
	local l, t, r, b = self.Options:GetAnchorOffsets()

	self.db.profile.position = {
		left = l,
		top = t,
		right = r,
		bottom = b
	}
end

function PerspectiveOptions:OnHeaderButtonClicked(panel)
	local panels = {
		"Categories",
		"Settings"
	}

	for k, v in pairs(panels) do
		if v == panel then
			self.Options:FindChild(v):Show(true, true)
		else
			self.Options:FindChild(v):Show(false, true)
		end
	end
end