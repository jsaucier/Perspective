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
    self.CategoryEditor = self.Options:FindChild("CategoryEditor")

    -- Options settings
    self.Settings = self.Options:FindChild("Settings")

    -- Register our addon with the interface menu.
	Apollo.RegisterEventHandler("InterfaceMenuListHasLoaded", 		"OnInterfaceMenuListHasLoaded", self)
	Apollo.RegisterEventHandler("InterfaceMenuClicked", 			"OnInterfaceMenuClicked", self)

	-- Register the slash command	
	Apollo.RegisterSlashCommand("perspective", "ShowOptions", self)
	Apollo.RegisterSlashCommand("pti", "ShowTargetInfo", self)
end

function PerspectiveOptions:OnEnable()
	if Apollo.GetAddon("Rover") then
		SendVarToRover("PerspectiveOptions", self)
	end
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

		if type(value) == "table" then
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
	else
		text = L["Please select a target first."]
	end

	self:ShowDialog(L["Perspective Target Information"], text, true, true, L["Get Current Target"], "ShowTargetInfo")
end

function PerspectiveOptions:OnDialogClose()
	self.Dialog:Show(false, true)
end

function PerspectiveOptions:LoadDefaults()
	return {
		profile = {
			default = {
				settings = { 
					disabled = false,
					max = 10,
					inArea = 100,
					draw = 0,
					slow = 1,
					fast = 100,
					queue = 0 },
				names = {
					[L["Return Teleporter"]]			= { category = "instancePortal" },
					[L["Bruxen"]]						= { category = "instancePortal",	display = L["Ship to Thayd"] },
					[L["Tanxox"]]						= { category = "instancePortal",	display = L["Ship to Thayd"] },
					[L["Gus Oakby"]]					= { category = "instancePortal",	display = L["Ship to Crimson Badlands"] },
					[L["Lilly Startaker"]]				= { category = "instancePortal",	display = L["Ship to Grimvault"] },
					[L["Transportation Expert Conner"]]	= { category = "instancePortal",	display = L["Ship to Farside"] },
					[L["Warrant Officer Burke"]]		= { category = "instancePortal",	display = L["Ship to Whitevale"] },
					[L["Venyanna Skywind"]]				= { category = "instancePortal",	display = L["Ship to Northern Wastes"] },
					[L["Captain Karaka"]]				= { category = "instancePortal", 	display = L["Ship to Crimson Badlands"] },
					[L["Captain Cryzin"]]				= { category = "instancePortal",	display = L["Ship to Grimvault"] },
					[L["Captain Petronia"]]				= { category = "instancePortal",	display = L["Ship to Farside"] },
					[L["Captain Visia"]]				= { category = "instancePortal",	display = L["Ship to Whitevale"] },
					[L["Captain Zanaar"]]				= { category = "instancePortal",	display = L["Ship to Northern Wastes"] },
					[L["Servileia Uticeia"]]			= { category = "instancePortal",	display = L["Ship to Ilium"] },
					[L["Empirius"]]						= { category = "wotwChampion" },
					[L["Sagittaurus"]]					= { category = "wotwChampion" },
					[L["Lectro"]]						= { category = "wotwChampion" },
					[L["Krule"]]						= { category = "wotwChampion" },
					[L["Zappo"]]						= { category = "wotwChampion" },
					[L["Ignacio"]]						= { category = "wotwChampion" },
					[L["Police Patrolman"]]				= { category = "cowPolice" },
					[L["Police Constable"]]				= { category = "cowPolice" },
					[L["Water"]]						= { category = "mtWater" },
					[L["Water Barrel"]]					= { category = "mtWater" },
					[L["Invisible Water Dowsing Unit"]]	= { category = "mtWater" },
					[L["Cheese"]]						= { category = "mtFood" },
					[L["Chicken"]]						= { category = "mtFood" },
					[L["Roan Steak"]]					= { category = "mtFood" },
					[L["Fruit"]]						= { category = "mtFood" },
					[L["Food Crate"]]					= { category = "mtFood" },
					[L["Large Feed Sack"]]				= { category = "mtFeed" },
					[L["Feed Sack"]]					= { category = "mtFeed" },
					[L["Hay Bale"]]						= { category = "mtFeed" },
					[L["Roving Chompacabra"]]			= { category = "mtEnemy" },
					[L["Dustback Gnasher"]]				= { category = "mtEnemy" },
					[L["Dustback Gnawer"]]				= { category = "mtEnemy" } },
				challengeUnits = {
					-- Challenge specific fixes
					[L["Roan Skull"]]					= { challenge = 576 } },
				categories = {
					default = {
						disabled = false,
						disableInCombat = false,
						disableOccluded = false,
						display = false,
						font = "CRB_Pixel_O",
						fontColor = "ffffffff",
						icon = "IconSprites:Icon_Windows32_UI_CRB_InterfaceMenu_Map",
						iconColor = "ffffffff",
						iconHeight = 48,
						iconWidth = 48,
						limitBy = "category", -- valid options are nil, "name", "category", "quest", "challenge"
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
						header = L["Set All"], 
						module = L["All"] },
					target = {
						header = L["Target"],
						module = L["Miscellaneous"],
						disabled = true,				
						lineColor = "ff00ffff",
						iconColor = "ffffffff",
						icon = "IconSprites:Icon_Windows_UI_CRB_Attribute_ShieldCap",
						maxIcons = 1,
						maxLines = 1,
						iconHeight = 48,
						iconWidth = 48 },
					focus = {
						header = L["Focus"],
						module = L["Miscellaneous"],
						lineColor = "ffff7dda",
						iconColor = "ffff7dda",
						icon = "IconSprites:Icon_Windows_UI_CRB_Attribute_Grit",
						maxIcons = 1,
						maxLines = 1,
						iconHeight = 48,
						iconWidth = 48 },
					group = {
						header = L["Group"],
						module = L["Player"],
						fontColor = "ff7482c1",
						lineColor = "ff7482c1",
						iconColor = "ff7482c1",
						icon = "PerspectiveSprites:guild",
						showLines = false,
						maxLines = 4,
						max = 4,
						useRange = true,
						rangeColor = "ff00ff00",
						rangeIcon = true,
						rangeLine = true,
						rangeFont = true },
					raid = {
						header = L["Raid"],
						module = L["Player"],
						fontColor = "ff00ffff",
						lineColor = "ff00ffff",
						iconColor = "ff00ffff",
						icon = "PerspectiveSprites:guild",
						showLines = false,
						maxLines = 40,
						max = 40,
						useRange = true,
						rangeColor = "ff00ff00",
						rangeIcon = true,
						rangeLine = true,
						rangeFont = true },
					guild = {
						header = L["Guild"],
						module = L["Player"],
						fontColor = "ff00ff00",
						lineColor = "ff00ff00",
						iconColor = "ff00ff00",
						icon = "PerspectiveSprites:guild",
						showLines = false },
					exile = {
						header = L["Exile"],
						module = L["Player"],
						icon = "charactercreate:sprCharC_Ico_Exile_Lrg",
						iconWidth = 32,
						iconHeight = 32,
						showLines = false,
						disabled = true	},
					dominion = {
						header = L["Dominion"],
						module = L["Player"],
						icon = "charactercreate:sprCharC_Ico_Dominion_Lrg",
						iconWidth = 32,
						iconHeight = 32,
						showLines = false,
						disabled = true	},
					friend = {
						header = L["Friend"],
						module = L["Player"],
						icon = "IconSprites:Icon_MapNode_Map_Friend",
						showLines = false },
					rival = {
						header = L["Rival"],
						module = L["Player"],
						icon = "IconSprites:Icon_MapNode_Map_Rival",
						showLines = false },
					friendly = {
						header = L["Friendly Normal"],
						module = L["NPC"],
						disabled = true,
						fontColor = "ff00ff00",
						lineColor = "ff00ff00",
						iconColor = "ff00ff00",
						icon = "PerspectiveSprites:Circle-Outline",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 8,
						iconWidth = 8 },	
					friendlyPrime = {
						header = L["Friendly Prime"],
						module = L["NPC"],
						disabled = true,
						fontColor = "ff00ff00",
						lineColor = "ff00ff00",
						iconColor = "ff00ff00",
						icon = "PerspectiveSprites:Circle-Outline",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 16,
						iconWidth = 16 },	
					friendlyElite = {
						header = L["Friendly Elite"],
						module = L["NPC"],
						disabled = true,
						fontColor = "ff00ff00",
						lineColor = "ff00ff00",
						iconColor = "ff00ff00",
						icon = "PerspectiveSprites:Circle-Outline",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 32,
						iconWidth = 32 },
					neutral = {
						header = L["Neutral Normal"],
						module = L["NPC"],
						disabled = true,
						fontColor = "ffffff00",
						lineColor = "ffffff00",
						iconColor = "ffffff00",
						icon = "PerspectiveSprites:Circle-Outline",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 8,
						iconWidth = 8 },	
					neutralPrime = {
						header = L["Neutral Prime"],
						module = L["NPC"],
						disabled = true,
						fontColor = "ffffff00",
						lineColor = "ffffff00",
						iconColor = "ffffff00",
						icon = "PerspectiveSprites:Circle-Outline",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 16,
						iconWidth = 16 },	
					neutralElite = {
						header = L["Neutral Elite"],
						module = L["NPC"],
						disabled = true,
						fontColor = "ffffff00",
						lineColor = "ffffff00",
						iconColor = "ffffff00",
						icon = "PerspectiveSprites:Circle-Outline",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 32,
						iconWidth = 32 },	
					hostile = {
						header = L["Hostile Normal"],
						module = L["NPC"],
						fontColor = "ffff0000",
						lineColor = "ffff0000",
						iconColor = "ffff0000",
						icon = "PerspectiveSprites:Circle-Outline",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 8,
						iconWidth = 8,
						rangeIcon = true,
						rangeColor = "ffff00ff"	},
					hostilePrime = {
						header = L["Hostile Prime"],
						module = L["NPC"],
						fontColor = "ffff0000",
						lineColor = "ffff0000",
						iconColor = "ffff0000",
						icon = "PerspectiveSprites:Circle-Outline",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 16,
						iconWidth = 16,
						rangeIcon = true,
						rangeColor = "ffff00ff"	},
					hostileElite = {
						header = L["Hostile Elite"],
						module = L["NPC"],
						fontColor = "ffff0000",
						lineColor = "ffff0000",
						iconColor = "ffff0000",
						icon = "PerspectiveSprites:Circle-Outline",
						showLines = false,
						showName = false,
						showDistance = false,
						max = 10,
						iconHeight = 32,
						iconWidth = 32,
						rangeIcon = true,
						rangeColor = "ffff00ff"	},
					questObjective = {
						header = L["Objective"],
						module = L["Quest"],
						icon = "PerspectiveSprites:target",
						max = 3,
						limitBy = "category",
						lineColor = "ffff8000",
						iconHeight = 36,
						iconWidth = 36,
						iconColor = "ffff8000" },
					questInteractable = {
						header = L["Interactable"],
						module = L["Quest"],
						icon = "PerspectiveSprites:gear",
						max = 3,
						iconHeight = 36,
						iconWidth = 36,
						limitBy = "category",
						lineColor = "ffff8000",
						iconColor = "ffff8000" },
					questNew = {
						header = L["Start"],
						module = L["Quest"],
						icon = "ClientSprites:MiniMapNewQuest",
						lineColor = "ff00ff00" },
					questTalkTo = {
						header = L["Talk To"],
						module = L["Quest"],
						icon = "IconSprites:Icon_MapNode_Map_Chat",
						iconColor = "ffff8000",
						lineColor = "ffff8000" },
					questReward = {
						header = L["Complete"],
						module = L["Quest"],
						icon = "IconSprites:Icon_Windows_UI_CRB_Checkmark",
						iconHeight = 38,
						iconWidth = 38,
						lineColor = "ff00ff00" },	
					questLocation = {
						header = L["Quest Location"],
						module = L["Quest"],
						limitBy = "quest",
						max = 1,
						drawLine = false,
						icon = "Crafting_CoordSprites:sprCoord_AdditivePreviewSmall",
						iconWidth = 64,
						iconHeight = 64	,
						maxDistance = 9999,
						minDistanace = 100,
						iconColor = "ffffa600"},
					eventLocation = {
						header = L["Event Location"],
						module = L["Quest"],
						limitBy = "category",
						max = 1,
						drawLine = false,
						icon = "Crafting_CoordSprites:sprCoord_AdditivePreviewSmall",
						iconWidth = 64,
						iconHeight = 64,
						maxDistance = 9999,
						minDistanace = 100,
						iconColor = "ff00ff00" },
					challengeLocation = {
						header = L["Challenge Location"],
						iconColor = "ffff8000",
						module = L["Challenge"],
						limitBy = "challenge",
						max = 1,
						drawLine = false,
						maxDistance = 9999,
						minDistanace = 100,
						icon = "Crafting_CoordSprites:sprCoord_AdditivePreviewSmall",
						iconWidth = 64,
						iconHeight = 64	},
					challenge = {
						header = L["Objective"],
						module = L["Challenge"],
						icon = "PerspectiveSprites:QuestObjective",
						lineColor = "ffff0000",
						iconColor = "ffff0000" },
					farmer = {
						header = L["Farmer"],
						module = L["Harvest"],
						max = 5,
						fontColor = "ffffff00",
						icon = "IconSprites:Icon_MapNode_Map_Node_Plant",
						lineColor = "ffffff00" },
					miner = {
						header = L["Mining"],
						module = L["Harvest"],
						max = 5,
						fontColor = "ff0078ce",
						icon = "IconSprites:Icon_MapNode_Map_Node_Mining",
						lineColor = "ff0078ce" },
					relichunter = {
						header = L["Relic Hunter"],
						module = L["Harvest"],
						max = 5,
						fontColor = "ffff7fed",
						icon = "IconSprites:Icon_MapNode_Map_Node_Relic",
						lineColor = "ffff7fed" },
					survivalist = {
						header = L["Survivalist"],
						module = L["Harvest"],
						max = 5,
						fontColor = "ffce9967",
						icon = "IconSprites:Icon_MapNode_Map_Node_Tree",
						lineColor = "ffce9967" },
					flightPath = {
						header = L["Flight Path"],
						module = L["Travel"],
						fontColor = "ffabf8cb",
						icon = "IconSprites:Icon_MapNode_Map_Taxi",
						showLines = false },
					instancePortal = {
						header = L["Portal"],
						module = L["Travel"],
						fontColor = "ffabf8cb",
						icon = "IconSprites:Icon_MapNode_Map_Portal",
						max = 10,
						showLines = false },
					bindPoint = {
						header = L["Bind Point"],
						module = L["Travel"],
						fontColor = "ffabf8cb",
						icon = "IconSprites:Icon_MapNode_Map_Gate",
						showLines = false },
					marketplace = {
						header = L["Commodities Exchange"],
						module = L["Town"],
						fontColor = "ffabf8cb",
						icon = "IconSprites:Icon_MapNode_Map_CommoditiesExchange",
						showLines = false },
					auctionHouse = {
						header = L["Auction House"],
						module = L["Town"],
						fontColor = "ffabf8cb",
						icon = "IconSprites:Icon_MapNode_Map_AuctionHouse",
						showLines = false },
					mailBox = {
						header = L["Mailbox"],
						module = L["Town"],
						fontColor = "ffabf8cb",
						icon = "IconSprites:Icon_MapNode_Map_Mailbox",
						showLines = false },
					vendor = {
						header = L["Vendor"],
						module = L["Town"],
						fontColor = "ffabf8cb",
						icon = "IconSprites:Icon_MapNode_Map_Vendor",
						showLines = false },
					craftingStation = {
						header = L["Crafting Station"],
						module = L["Town"],
						fontColor = "ffabf8cb",
						icon = "IconSprites:Icon_MapNode_Map_Tradeskill",
						showLines = false },
					tradeskillTrainer = {
						header = L["Tradeskill Trainer"],
						module = L["Town"],
						fontColor = "ffabf8cb",
						icon = "IconSprites:Icon_MapNode_Map_Trainer",
						showLines = false },
					dye = {
						header = L["Appearance Modifier"],
						module = L["Town"],
						fontColor = "ffabf8cb",
						icon = "IconSprites:Icon_MapNode_Map_DyeSpecialist",
						showLines = false },
					bank = {
						header = L["Bank"],
						module = L["Town"],
						fontColor = "ffabf8cb",
						icon = "IconSprites:Icon_MapNode_Map_Bank",
						showLines = false },
					dungeon = {
						header = L["Dungeon"],
						module = L["Travel"],
						fontColor = "ff00ffff",
						icon = "IconSprites:Icon_MapNode_Map_Dungeon",
						showLines = false },
					lore = {
						header = L["Lore"],
						module = L["Miscellaneous"],
						fontColor  = "ff7abcff",
						icon = "CRB_MegamapSprites:sprMap_IconCompletion_Lore_Stretch",
						lineColor = "ff7abcff",
						showLines = true,
						maxLines = 1 },
					pathLocation = {
						header = L["Mission Location"],
						module = L["Path"],
						limitBy = "path",
						max = 1,
						iconColor = "ffffffff",
						drawLine = false,
						iconHeight = 64,
						iconWidth = 64,
						maxDistance = 9999,
						max = 1 },
					scientist = {
						header = L["Scientist"],
						module = L["Path"],
						fontColor = "ffc759ff",
						icon = "CRB_PlayerPathSprites:spr_Path_Scientist_Stretch",
						lineColor = "ffc759ff",
						showLines = false,
						maxLines = 1 },
					scientistScans = {
						header = L["Scientist Scans"],
						module = L["Path"],
						fontColor = "ffc759ff",
						icon = "CRB_PlayerPathSprites:spr_Path_Scientist_Stretch",
						lineColor = "ffc759ff",
						maxLines = 1 },
					solider = {
						header = L["Soldier"],
						module = L["Path"],
						fontColor = "ffc759ff",
						icon = "CRB_PlayerPathSprites:spr_Path_Soldier_Stretch",
						lineColor = "ffc759ff",
						maxLines = 1 },
					settler = {
						header = L["Settler"],
						module = L["Path"],
						fontColor = "ffc759ff",
						icon = "CRB_PlayerPathSprites:spr_Path_Settler_Stretch",
						lineColor = "ffc759ff",
						maxLines = 1 },
					settlerResources = {
						header = L["Settler Resources"],
						module = L["Path"],
						fontColor = "ffc759ff",
						icon = "CRB_PlayerPathSprites:spr_Path_Settler_Stretch",
						lineColor = "ffc759ff",
						maxLines = 1 },
					explorer = {
						header = L["Explorer"],
						module = L["Path"],
						fontColor = "ffc759ff",
						icon = "CRB_PlayerPathSprites:spr_Path_Explorer_Stretch",
						lineColor = "ffc759ff",
						maxLines = 1 },
					questLoot = {
						header = L["Loot"],
						module = L["Quest"],
						icon = "ClientSprites:GroupLootIcon",
						showLines = false,
						iconWidth = 32,
						iconHeight = 32 },
					subdue = {
						header = L["Weapon Subdue"],
						module = L["Miscellaneous"],
						lineColor = "ffff8000",
						iconColor = "ffff8000",
						icon = "ClientSprites:GroupWarriorIcon",
						lineWidth = 10,
						iconHeight = 32,
						iconWidth = 32 },
					wotwChampion = {
						header = L["Enemy Champion"],
						module = L["War of the Wilds"],
						icon = "IconSprites:Icon_MapNode_Map_PvP_BattleAlert",
						showLines = false },
					[L["Energy Node"]] = {
						header = L["Energy Node"],
						module = L["War of the Wilds"],
						icon = "CRB_InterfaceMenuList:spr_InterfaceMenuList_SilverFlagStretch",
						showLines = false },
					[L["Moodie Totem"]] = {
						header = L["Moodie Totem"],
						module = L["War of the Wilds"],
						icon = "CRB_InterfaceMenuList:spr_InterfaceMenuList_RedFlagStretch",
						iconColor = "ffff3300",
						showLines = false },
					[L["Skeech Totem"]] = {
						header = L["Skeech Totem"],
						module = L["War of the Wilds"],
						icon = "CRB_InterfaceMenuList:spr_InterfaceMenuList_BlueFlagStretch",
						showLines = false },
					cowPolice = {
						header = L["Police"],
						module = L["Crimelords of Whitevale"],
						icon = "PerspectiveSprites:Circle-Outline",
						showLines = false,
						showName = false,
						showDistance = false,
						iconColor = "ff00ff00" },
					[L["Food Table"]] = {
						header = L["Food Table"],
						module = L["Harvest"],
						icon = "IconSprites:Icon_Guild_UI_Guild_Sandwich",
						iconColor = "ff9d8734",
						lineColor = "ff9d8734",
						fontColor = "ff9d8734",
						iconHeight = 32,
						iconWidth = 32,
						max = 1 },
					[L["Butcher Block"]] = {
						header = L["Butcher Block"],
						module = L["Harvest"],
						icon = "IconSprites:Icon_Guild_UI_Guild_Steak",
						iconColor = "ff9d3838",
						lineColor = "ff9d3838",
						fontColor = "ff9d3838",
						iconHeight = 32,
						iconWidth = 32,
						max = 1 },
					[L["Tanning Rack"]] = {
						header = L["Tanning Rack"],
						module = L["Harvest"],
						icon = "IconSprites:Icon_Guild_UI_Guild_Skull",
						iconColor = "ffb2aa73",
						lineColor = "ffb2aa73",
						fontColor = "ffb2aa73",
						iconHeight = 32,
						iconWidth = 32,
						max = 1 },
					mtWater = {
						header = L["Water"],
						module = L["The Malgrave Trail"],
						icon = "IconSprites:Icon_Windows_UI_CRB_Adventure_Malgrave_Water",
						showLines = false },
					[L["Caravan Member"]] = {
						header = L["Caravan Member"],
						module = L["The Malgrave Trail"],
						icon = "IconSprites:Icon_Windows_UI_CRB_Adventure_Malgrave_Survivor",
						showLines = false },
					mtFood = {
						header = L["Food"],
						module = L["The Malgrave Trail"],
						icon = "IconSprites:Icon_Windows_UI_CRB_Adventure_Malgrave_Food",
						showLines = false },
					mtFeed = {
						header = L["Feed"],
						module = L["The Malgrave Trail"],
						icon = "IconSprites:Icon_Windows_UI_CRB_Adventure_Malgrave_Feed",
						showLines = false },
					mtEnemy = {
						header = L["Enemy"],
						module = L["The Malgrave Trail"],
						icon = "IconSprites:Icon_MapNode_Map_PvP_BattleAlert",
						showLines = false },
					[L["Cactus Fruit"]] = {
						header = L["Cactus Fruit"],
						module = L["The Malgrave Trail"], 
						icon = "IconSprites:Icon_Mission_Scientist_ScanPlant",
						showLines = false },
					[L["Medical Grenade"]] = {
						header = L["Medical Grenade"],
						module = L["The Malgrave Trail"],
						icon = "IconSprites:Icon_Mission_Soldier_Demolition",
						showLines = false },
					[L["Bug Bomb"]] = {
						header = L["Bug Bomb"],
						module = L["The Malgrave Trail"],
						icon = "IconSprites:Icon_Mission_Scientist_ScanCreature",
						showLines = false },
					mainTank = {
						header = L["Main Tank"],
						module = L["Player"],
						icon = "IconSprites:Icon_Windows_UI_CRB_Attribute_DeflectCritical",
						showLines = false },
					mainAssist = {
						header = L["Main Assist"],
						module = L["Player"],
						icon = "IconSprites:Icon_Windows_UI_CRB_Attribute_BruteForce",
						showLines = false },
					tank = {
						header = L["Tank"],
						module = L["Player"],
						icon = "IconSprites:Icon_Windows_UI_CRB_Attribute_Deflect",
						showLines = false },
					healer = {
						header = L["Healer"],
						module = L["Player"],
						icon = "IconSprites:Icon_Windows_UI_CRB_Attribute_Health",
						showLines = false },
					dps = {
						header = L["DPS"],
						module = L["Player"],
						icon = "IconSprites:Icon_Windows_UI_CRB_Attribute_CriticalSeverity",
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
				NewButton				= {												text = L["New Category"],				tooltip = L["Create a new category."] },
				DefaultButton 			= { 											text = L["Default ALL"],				tooltip = L["Reset ALL addon settings back to the defaults."] },
				ExportButton			= {												text = L["Export"],						tooltip = L["Export your current settings."] },
				ImportButton			= {												text = L["Import"],						tooltip = L["Import your current settings."] } },
			CheckButtons 				= {
				CategoriesCheck 		= {	checked = true,								text = L["Categories"],					tooltip = L[""] },
				SettingsCheck 			= {												text = L["Settings"], 					tooltip = L[""] } } },
		CategoryEditor 					= {
			CheckButtons				= {
				DisableCheck 			= { option = "disabled",						text = L["Disable"], 					tooltip = L["Disable this category."] },
				CombatDisableCheck 		= { option = "disableInCombat",					text = L["Hide When In Combat"], 		tooltip = L["Hide this category while in combat."] },
				OccludedDisableCheck 	= { option = "disableOccluded",					text = L["Hide When Occluded"], 		tooltip = L["Hide this category whhen it is occluded."] },
				ShowIconCheck 			= { option = "showIcon",						text = L["Show Icon"], 					tooltip = L["Show the icon for this category."] },
				ShowNameCheck 			= { option = "showName",						text = L["Show Name"], 					tooltip = L["Show the name for this category."] },
				ShowDistanceCheck 		= { option = "showDistance",					text = L["Show Distance"], 				tooltip = L["Show the distance for this category."] },
				ShowLinesCheck 			= { option = "showLines",						text = L["Show Lines"], 				tooltip = L["Show the line to this cateogry."] },
				ShowOutlineCheck 		= { option = "showLineOutline",					text = L["Show Line Outline"], 			tooltip = L["Show the outline of the line to this category."] },
				ShowOffScreenLineCheck 	= { option = "showLinesOffscreen",				text = L["Show Lines Offscreen"], 		tooltip = L["Show the line to this category even it is offscreen."] },
				RangeFontCheck 			= { option = "rangeFont",						text = L["Color Font By Range Color"], 	tooltip = L["Use the range color for the font color."] },
				RangeIconCheck 			= { option = "rangeIcon",						text = L["Color Icon By Range Color"], 	tooltip = L["Use the range color for the icon color."] },
				RangeLineCheck 			= { option = "rangeLine",						text = L["Color Line By Range Color"], 	tooltip = L["Use the range color for the line color."] } },
			TextBoxes					= {
				ModuleText				= { option = "module",							label = L["Module"],					tooltip = L["Edit the module for this category."] },
				DisplayText				= { option = "display",							label = L["Display As"],				tooltip = L["Set a display name to be used instead of the unit's name."] },
				IconText				= { option = "icon",							label = L["Icon"],						tooltip = L["Set the icon to be displayed for this category."] },
				IconHeightText			= { option = "iconHeight",	isNumber = true,	label = L["Icon Height"], 				tooltip = L["Set the icon height for this category."] },
				IconWidthText			= { option = "iconWidth",	isNumber = true,	label = L["Icon Width"], 				tooltip = L["Set the icon width for this category."] },
				MinDistanceText			= { option = "minDistance",	isNumber = true,	label = L["Min Distance"], 				tooltip = L["Set the minimium distance for which to show this category."] },
				MaxDistanceText			= { option = "maxDistance",	isNumber = true,	label = L["Max Distance"], 				tooltip = L["Set the maximium distance for which to show this category."] },
				ZDistanceText			= { option = "zDistance",	isNumber = true,	label = L["Z Distance"], 				tooltip = L["Set the maximium vertical distance for which to show this category."] },
				LineWidthText			= { option = "lineWidth",	isNumber = true,	label = L["Line Width"], 				tooltip = L["Set the line width for the category."] },
				MaxIconsText			= { option = "max",			isNumber = true,	label = L["Limit Icons"], 				tooltip = L["Set the maximium limit of icons to be displayed on screen at once."] },
				MaxLinesText			= { option = "maxLines",	isNumber = true,	label = L["Limit Lines"], 				tooltip = L["Set the maximium limit of lines to be displayed on screen at once."] },
				RangeLimitText			= { option = "rangeLimit",	isNumber = true,	label = L["Range Limit"], 				tooltip = L["Set the range limit for this category.  This can be used to determine if your skills are in range of certain targets."] } },
			ColorButtons				= {
				FontColor				= { option = "fontColor",						label = L["Font Color"],				tooltip = L["Set the font color for this category."] },
				IconColor				= { option = "iconColor",						label = L["Icon Color"],				tooltip = L["Set the icon color for this category."] },
				LineColor				= { option = "lineColor",						label = L["Line Color"],				tooltip = L["Set the line color for this category."] },
				RangeColor				= { option = "rangeColor",						label = L["Range Color"],				tooltip = L["Set the range color for this category."] } },
			Buttons 					= { 
				BackButton				= { 																					tooltip = L["Back to the categories list view."] },
				DeleteButton			= { 											text = L["Delete"], 					tooltip = L["Delete this category."] },
				DefaultButton			= { 											text = L["Default"],					tooltip = L["Reset this category to the default settings."] } }	},
		Settings = {}
	}
end

function PerspectiveOptions:GetOptionValue(ui, option, category)
	local category = category or ui.category or "default"

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
		path = "Explorer"
	elseif PlayerPathLib.GetPlayerPathType() == PlayerPathLib.PlayerPathType_Scientist then
		path = "Scientist"
	elseif PlayerPathLib.GetPlayerPathType() == PlayerPathLib.PlayerPathType_Settler then
		path = "Settler"
	elseif PlayerPathLib.GetPlayerPathType() == PlayerPathLib.PlayerPathType_Soldier then
		path = "Soldier"
	end

	return "CRB_PlayerPathSPrites:spr_Path_" .. path .. "_Stretch"
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

	-- Initialize the settings 
	self:Settings_CheckInit("Disable", 		"disabled")

	self:Settings_TimerInit("DrawUpdate", 	"draw", 0, "ms", 1000, 	"OnTimerTicked_Draw")
	self:Settings_TimerInit("FastUpdate", 	"fast", 1, "ms", 1000, 	"OnTimerTicked_Fast")
	self:Settings_TimerInit("SlowUpdate", 	"slow", 1, "secs", 1,	"OnTimerTicked_Slow")

	self:Settings_TextInit("Max", 			"max", 		true)
	--self:Settings_TextInit("InArea", 		"inArea", 	true)

		-- Sort the lists.
	self:ArrangeChildren(self.CategoryList)
	self:ArrangeChildren(self.ModuleList)

	if not self.initialized then
		-- Set the All module as the selected module
		self.module = L["All"]

		-- Check the All button
		self.ModuleList:FindChild("ModuleItem" .. self.module):FindChild("Button"):SetCheck(true)
	else
		-- Set the module button as checked.
		local module = self.ModuleList:FindChild("ModuleItem" .. self.module)

		if not module then
			module = self.ModuleList:FindChild("ModuleItem" .. L["All"])
		end

		local button = module:FindChild("Button")

		self:ModuleItemChecked(nil, button, nil)
	end	



		

	-- Let the addon know we are now fully initialized.
	self.initialized = true
end

function PerspectiveOptions:ModuleItemInitialize(category, module)
	--module = module or L["Unknown"]

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
	local sortBy = module == L["All"] and "_first" or module

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
		if m == module or module == L["All"] or m == L["All"] then
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

	local button

	if not item then
		-- Create a new category item.
		item = Apollo.LoadForm(self.xmlDoc, "CategoryItem", self.CategoryList, self)

		button = item:FindChild("Button")
		
		button:AddEventHandler("ButtonSignal", "CategoryItemClicked")
	else
		button = item:FindChild("Button")
	end

	-- Set the category for the button
	button:SetData(category)

	-- Set the name for the item.
	item:SetName("CategoryItem" .. category)

	-- Get the sortBy value.
	local sortBy = category == "all" and "_first" or self:GetOptionValue(nil, "header", category)

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
	text.strText = self:GetOptionValue(nil, "header", category)
	text.flagsText = { DT_VCENTER = true }
	button:UpdatePixie(2, text)
end

function PerspectiveOptions:CategoryItemClicked(handler, control, button)
	-- Set the currently selected category
	self.category = control:GetData()

	-- Show the category editor.
	self:CategoryEditorInitialize(self.category)
end

function PerspectiveOptions:CategoryEditorInitialize(category)

	local function loadDropDown(name, category, option)
		-- Get the control by name
		local control = self.CategoryEditor:FindChild(name .. "DropDownButton")

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
		local menu = self.CategoryEditor:FindChild(name .. "DropDownMenu")

		-- Set the control value.
		control:SetText(self:GetOptionValue(nil, option, category))

		-- Make sure we haven't already set the event handlers
		if not control:GetData() then
			control:AddEventHandler("ButtonSignal", "CategoryEditor_OnDropDown")

			for k, v in pairs(menu:GetChildren()) do
				v:AddEventHandler("ButtonCheck", 	"CategoryEditor_OnDropDownItem")
				v:AddEventHandler("ButtonUncheck", 	"CategoryEditor_OnDropDownItem")
			end
		end

		-- Set the data for the control.
		control:SetData({ category = category, option = option, menu = menu })

		-- Set the data for the menu.
		menu:SetData({ button = control })
	end

	local header = 	self:GetOptionValue(nil, "header", 		category)
	local icon = 	self:GetOptionValue(nil, "icon", 		category)
	local color = 	self:GetOptionValue(nil, "iconColor", 	category)

	-- Set the category editor image pixie
	self:SetPixie(self.CategoryEditor, 1, { sprite = icon, color = color })

	local custom = self:GetOptionValue(nil, "custom", category)
	
	local catEdit = self.CategoryEditor:FindChild("CategoryEdit")

	-- Set the rename text
	catEdit:SetText(header)

	if not catEdit:GetData() then
		catEdit:AddEventHandler("EditBoxReturn", 	"TextBoxReturnCategoryEditorCategoryEdit")
		catEdit:AddEventHandler("EditBoxTab", 		"TextBoxReturnCategoryEditorCategoryEdit")
		catEdit:AddEventHandler("EditBoxEscape", 	"TextBoxEscapeCategoryEditorCategoryEdit")
	end

	catEdit:SetData(category)

	-- Set the module
	self.CategoryEditor:SetData(self:GetOptionValue(nil, "module", category))

	-- Initialize the buttons
	for name, options in pairs(controls.CategoryEditor.Buttons) do
		self:ButtonInitialize("CategoryEditor", name, category, options)
	end

	-- Initialize the checkbuttons
	for name, options in pairs(controls.CategoryEditor.CheckButtons) do
		self:CheckButtonInitialize("CategoryEditor", name, category, options)
	end

	-- Initialize the textboxes
	for name, options in pairs(controls.CategoryEditor.TextBoxes) do
		self:TextBoxInitialize("CategoryEditor", name, category, options)
	end

	-- Initialize the colorbuttons
	for name, options in pairs(controls.CategoryEditor.ColorButtons) do
		self:ColorButtonInitialize("CategoryEditor", name, category, options)
	end

	-- Show the rename edit box if this is a custom item
	if custom then
		-- Show the edit box border
		self:SetPixie(self.CategoryEditor, 2, { sprite = "BK3:UI_BK3_Holo_InsetSimple" })
		-- Allow edits
		catEdit:SetStyleEx("ReadOnly", false)
		-- Show the delete button
		self.CategoryEditor:FindChild("DeleteButton"):Show(true, true)
	else
		-- Hide the edit box border
		self:SetPixie(self.CategoryEditor, 2, { sprite = "" })
		-- Do not allow edits
		catEdit:SetStyleEx("ReadOnly", true)
		-- Hide the delete button
		self.CategoryEditor:FindChild("DeleteButton"):Show(false, true)
	end

	--[[loadDropDown("LimitBy",			category, "limitBy")

	for k, v in pairs(fonts) do
		self.CategoryEditor:FindChild("FontDropDown"):FindChild("DropDown"):AddItem(k)
	end]]

	self.ModuleList:GetParent():Show(false, true)
	self.CategoryList:GetParent():Show(false, true)
	self.CategoryEditor:Show(true, true)
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

	self.CategoryEditor:Show(false, true)
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

	-- Set the control toolip.
	control:SetTooltip(options.tooltip)

	-- category checkbutton
	control:SetText(options.text)

	-- Make sure we haven't already set the event handlers
	if not control:GetData() then
		--Setup the event handlers
		control:AddEventHandler("ButtonSignal", "ButtonClicked" .. parent .. name)
	end

	-- Set the data for the control.
	control:SetData({ category = category, options = options })
end

function PerspectiveOptions:ButtonClickedOptionsNewButton(handler, control, button)
	self.db.profile[self.profile].categories[L["Custom Unit"]] = {
		header = L["Custom Unit"],
		module = L["Custom"],
		custom = true }

	self:InitializeOptions()

	self:CategoryEditorInitialize(L["Custom Unit"])
end

function PerspectiveOptions:ButtonClickedOptionsDefaultButton(handler, control, button)
	self.db:ResetDB()

	self:InitializeOptions()

	self.CategoryEditor:Show(false, true)
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

function PerspectiveOptions:ButtonClickedOptionsImportButton(handler, control, button)
	self:ShowDialog(L["Perspective Settings Import"], "", false, false, L["Import"], "ImportSettings")
end

function PerspectiveOptions:ButtonClickedOptionsExportButton(handler, control, button)
	local profile = JSON.encode(self.db.profile)
	self:ShowDialog(L["Perspective Settings Export"], profile, true, true, L["Close"], "CloseDialog")
end

function PerspectiveOptions:ButtonClickedCategoryEditorBackButton(handler, control, button)
	self.CategoryEditor:Show(false, true)
	self.ModuleList:GetParent():Show(true, true)
	self.CategoryList:GetParent():Show(true, true)
end

function PerspectiveOptions:ButtonClickedCategoryEditorDeleteButton(handler, control, button)
	local data = control:GetData()

	self.db.profile[self.profile].categories[data.category] = nil

	self:InitializeOptions()

	self.CategoryEditor:Show(false, true)
	self.ModuleList:GetParent():Show(true, true)
	self.CategoryList:GetParent():Show(true, true)

	-- Update all the uis
	Perspective:UpdateOptions(nil, true)
end

function PerspectiveOptions:ButtonClickedCategoryEditorDefaultButton(handler, control, button)
	local data = control:GetData()

	self.db.profile[self.profile].categories[data.category] = {}
	for k, v in pairs(self.db.defaults.profile[self.profile].categories[data.category]) do
		self.db.profile[self.profile].categories[data.category][k] = v
	end

	self:CategoryEditorInitialize(data.category)
end

-----------------------------------------------------------------------------------------
-- CheckButton
-----------------------------------------------------------------------------------------

function PerspectiveOptions:CheckButtonInitialize(parent, name, category, options)
	-- Get the control by name
	local control = self[parent]:FindChild(name)

	-- Set the control toolip.
	control:SetTooltip(options.tooltip)

	-- Set the checkbutton value.
	if category then
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

	else
		control:SetCheck(options.checked or self.db.profile[self.profile].settings[options.option])
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

function PerspectiveOptions:CheckButtonClickedCategoryEditor(handler, control, button)
	-- Get the control's data
	local data = control:GetData()
	
	-- Get the control's value
	local val = control:IsChecked()

	-- Check to see if we need to set the value for all categories
	if data.category == "all" then
		for category, cat in pairs(self.db.profile[self.profile].categories) do
			if (self.module == L["All"] and category ~= "default") or cat.module == self.module then
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

	-- Set the control toolip.
	control:SetTooltip(options.tooltip .. " " .. L["Press enter to save the new value."])

	-- Set the textbox label.
	self:SetPixie(control, 1, { text = options.label, flagsText = { DT_VCENTER = true } })

	-- Set the textbox value.
	if category then
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
	else
		-- Settings checkbutton
		edit:SetText(self.db.profile[self.profile].settings[options.option])
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

function PerspectiveOptions:TextBoxReturnCategoryEditor(handler, control)
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
			if (self.module == L["All"] and category ~= "default") or cat.module == self.module then
				cat[data.options.option] = val
				if data.options.option == "icon" then
					self:CategoryEditor_UpdateIcon(category)
				end
			end
		end
	else
		self.db.profile[self.profile].categories[data.category][data.options.option] = val	

		if data.options.option == "icon" then
			self:CategoryEditor_UpdateIcon(data.category)
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

function PerspectiveOptions:TextBoxEscapeCategoryEditor(handler, control)
	-- Get the control's data
	local data = control:GetData()

	-- Load the previous value
	control:SetText(self:GetOptionValue(nil, data.options.option, data.category) or "")
end

function PerspectiveOptions:TextBoxReturnCategoryEditorCategoryEdit(handler, control)
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
		Print("Not allowed")
	else
		self.db.profile[self.profile].categories[category] = {}
		
		for k, v in pairs(self.db.profile[self.profile].categories[oldCategory] or {}) do
			self.db.profile[self.profile].categories[category][k] = v
		end

		-- Update the header
		self.db.profile[self.profile].categories[category].header = category

		-- Delete the custom unit
		self.db.profile[self.profile].categories[oldCategory] = nil

		-- Reinit the options
		self:InitializeOptions()

		-- Show our new category.
		self:CategoryEditorInitialize(category)

		-- Update the ui options
		Perspective:UpdateOptions(nil, true)
	end
end


-----------------------------------------------------------------------------------------
-- ColorButton
-----------------------------------------------------------------------------------------

function PerspectiveOptions:ColorButtonInitialize(parent, name, category, options)
	-- Get the control by name
	local control = self[parent]:FindChild(name)
	local button = control:FindChild("Button")

	local color

	-- Set the control tooltip.
	control:SetTooltip(options.tooltip)

	-- Set the textbox label.
	self:SetPixie(control, 1, { text = options.label, flagsText = { DT_VCENTER = true } })

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

function PerspectiveOptions:ColorButtonClickedCategoryEditor(handler, control, button)
	local function setColor(data)

		-- Convert the color back to str
		local color = self:CColorToString(self.color)

		-- Set the control color
		control:SetBGColor(color)

		-- Update the settings
		if data.category == "all" then
			for category, cat in pairs(self.db.profile[self.profile].categories) do
				if (self.module == L["All"] and category ~= "default") or cat.module == self.module then
					cat[data.options.option] = color

					if data.option == "iconColor" then
						self:CategoryEditor_UpdateIcon(category)
					end
				end
			end
		else
			self.db.profile[self.profile].categories[data.category][data.options.option] = color

			if data.options.option == "iconColor" then
				self:CategoryEditor_UpdateIcon(data.category)
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







function PerspectiveOptions:CategoryEditor_OnDropDown(handler, control, button)
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

function PerspectiveOptions:CategoryEditor_OnDropDownItem(handler, control, button)
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
			if (self.module == L["All"] and category ~= "default") or cat.module == self.module then
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

function PerspectiveOptions:CategoryEditor_OnColorClick(handler, control, button)

	local function setColor(data)
		-- Convert the color back to str
		local color = self:CColorToString(self.color)
		
		-- Set the control color
		control:SetBGColor(color)

		-- Update the settings
		if data.category == "all" then
			for category, cat in pairs(self.db.profile[self.profile].categories) do
				if (self.module == L["All"] and category ~= "default") or cat.module == self.module then
					cat[data.option] = color

					if data.option == "iconColor" then
						self:CategoryEditor_UpdateIcon(category)
					end
				end
			end
		else
			self.db.profile[self.profile].categories[data.category][data.option] = color

			if data.option == "iconColor" then
				self:CategoryEditor_UpdateIcon(data.category)
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

function PerspectiveOptions:CategoryEditor_UpdateIcon(category)
	-- Get our category item button
	local button  = self.CategoryList:FindChild("CategoryItem" .. category):FindChild("Button")

	-- Get the icon and icon color.
	local icon = self:GetOptionValue(nil, "icon", category)
	local iconColor = self:GetOptionValue(nil, "iconColor", category)

	if category == self.category or category == "all" then
		-- Update the category editor icon.
		local pixie = self.CategoryEditor:GetPixieInfo(1)
		pixie.strSprite = icon
		pixie.cr = iconColor
		self.CategoryEditor:UpdatePixie(1, pixie)
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

function PerspectiveOptions:Settings_TimerInit(control, value, numDecimal, unit, divBy, tickFunc)
	local slider = self.Settings:FindChild(control .. "Slider")
	local text = self.Settings:FindChild(control .. "Text")

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