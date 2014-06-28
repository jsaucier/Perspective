require "Window"
require "GameLib"
require "Apollo"

local Perspective = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:NewAddon("Perspective", true)

local defaults = {
	profile = {
		settings = { 
			disabled = false,
			max = 10,
			drawTimer = 30,
			slowTimer = 1,
			fastTimer = 100,
			--skillRange = 15,
		},
		categories = {
			default = {
				order = 0,
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
				maxDistance = 9999,
				zDistance = 9999,
				showDistance = true,
				showIcon = true,
				showName = true,
				showLineOutline = true,
				showLines = true,
				showLinesOffscreen = true,
				rangeColor = "ffffffff",
				rangeIcon = false,
				rangeFont = false,
				rangeLine = false,
				rangeLimit = 15,
			},
			all = {
				header = "Set All"
			},
			target = {
				disabled = true,
				header = "Target",
				lineColor = "ffff00ff",
				iconColor = "ffff00ff",
				icon = "PerspectiveSprites:Circle-Outline",
				maxIcons = 1,
				maxLines = 1,
				iconHeight = 24,
				iconWidth = 24,
				rangeColor = "ffffccff",
				rangeLine = true,
				rangeIcon = true,
			},
			group = {
				header = "Player - Party",
				fontColor = "ff7482c1",
				lineColor = "ff7482c1",
				iconColor = "ff7482c1",
				icon = "IconSprites:Icon_Windows32_UI_CRB_InterfaceMenu_Character",
				showLines = false,
				maxLines = 4,
				max = 4,
				useRange = true,
				rangeColor = "ff00ff00",
				rangeIcon = true,
				rangeLine = true,
				rangeFont = true,
			},
			guild = {
				header = "Player - Guild",
				fontColor = "ff00ff00",
				lineColor = "ff00ff00",
				iconColor = "ff00ff00",
				icon = "IconSprites:Icon_Windows32_UI_CRB_InterfaceMenu_GroupFinder",
				showLines = false,
			},
			friendly = {
				header = "NPC - Friendly Normal",
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
				iconWidth = 8
			},	
			friendlyPrime = {
				header = "NPC - Friendly Prime",
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
				iconWidth = 16
			},	
			friendlyElite = {
				header = "NPC - Friendly Elite",
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
				iconWidth = 32
			},
			neutral = {
				header = "NPC - Neutral Normal",
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
				iconWidth = 8
			},	
			neutralPrime = {
				header = "NPC - Neutral Prime",
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
				iconWidth = 16
			},	
			neutralElite = {
				header = "NPC - Neutral Elite",
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
				iconWidth = 32
			},	
			hostile = {
				header = "NPC - Hostile Normal",
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
				rangeColor = "ffff00ff"
			},
			hostilePrime = {
				header = "NPC - Hostile Prime",
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
				rangeColor = "ffff00ff"
			},
			hostileElite = {
				header = "NPC - Hostile Elite",
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
				rangeColor = "ffff00ff"
			},
			questObjective = {
				header = "Quest - Objective",
				icon = "PerspectiveSprites:QuestObjective",
				max = 3,
				limitBy = "category",
				lineColor = "ffff8000",
			},
			questNew = {
				header = "Quest - Start",
				icon = "ClientSprites:MiniMapNewQuest",
				lineColor = "ff00ff00",
			},
			questTalkTo = {
				header = "Quest - Talk To",
				icon = "IconSprites:Icon_MapNode_Map_Chat",
				iconColor = "ffff8000",
				lineColor = "ffff8000",
			},
			questReward = {
				header = "Quest - Complete",
				icon = "IconSprites:Icon_MapNode_Map_Checkmark",
				lineColor = "ff00ff00",
			},			
			challenge = {
				header = "Challenge Objective",
				icon = "PerspectiveSprites:QuestObjective",
				lineColor = "ffff0000",
				iconColor = "ffff0000",
			},
			farmer = {
				header = "Harvest - Farmer",
				max = 5,
				fontColor = "ffffff00",
				icon = "IconSprites:Icon_MapNode_Map_Node_Plant",
				lineColor = "ffffff00",
			},
			miner = {
				header = "Harvest - Mine",
				max = 5,
				fontColor = "ff0078ce",
				icon = "IconSprites:Icon_MapNode_Map_Node_Mining",
				lineColor = "ff0078ce",
			},
			relichunter = {
				header = "Harvest - Relic Hunter",
				max = 5,
				fontColor = "ffff7fed",
				icon = "IconSprites:Icon_MapNode_Map_Node_Relic",
				lineColor = "ffff7fed",
			},
			survivalist = {
				header = "Harvest - Survivalist",
				max = 5,
				fontColor = "ffce9967",
				icon = "IconSprites:Icon_MapNode_Map_Node_Tree",
				lineColor = "ffce9967",
			},
			flightPath = {
				header = "Flight Path",
				fontColor = "ffabf8cb",
				icon = "IconSprites:Icon_MapNode_Map_Taxi",
				showLines = false,
			},
			instancePortal = {
				header = "Instance Portal",
				fontColor = "ffabf8cb",
				icon = "IconSprites:Icon_MapNode_Map_Portal",
				showLines = false,
			},
			bindPoint = {
				header = "Bind Point",
				fontColor = "ffabf8cb",
				icon = "IconSprites:Icon_MapNode_Map_Gate",
				showLines = false,
			},
			marketplace = {
				header = "Town - Commodities Exchange",
				fontColor = "ffabf8cb",
				icon = "IconSprites:Icon_MapNode_Map_CommoditiesExchange",
				showLines = false,
			},
			auctionHouse = {
				header = "Town - Auction House",
				fontColor = "ffabf8cb",
				icon = "IconSprites:Icon_MapNode_Map_AuctionHouse",
				showLines = false,
			},
			mailBox = {
				header = "Town - Mailbox",
				fontColor = "ffabf8cb",
				icon = "IconSprites:Icon_MapNode_Map_Mailbox",
				showLines = false,
			},
			vendor = {
				header = "Town - Vendor",
				fontColor = "ffabf8cb",
				icon = "IconSprites:Icon_MapNode_Map_Vendor",
				showLines = false,
			},
			craftingStation = {
				header = "Town - Crafting Station",
				fontColor = "ffabf8cb",
				icon = "IconSprites:Icon_MapNode_Map_Tradeskill",
				showLines = false,
			},
			tradeskillTrainer = {
				header = "Town - Tradeskill Trainer",
				fontColor = "ffabf8cb",
				icon = "IconSprites:Icon_MapNode_Map_Trainer",
				showLines = false,
			},
			dye = {
				header = "Town - Appearance Modifier",
				fontColor = "ffabf8cb",
				icon = "IconSprites:Icon_MapNode_Map_DyeSpecialist",
				showLines = false,
			},
			bank = {
				header = "Town - Bank",
				fontColor = "ffabf8cb",
				icon = "IconSprites:Icon_MapNode_Map_Bank",
				showLines = false,
			},
			dungeon = {
				header = "Dungeon",
				fontColor = "ff00ffff",
				icon = "IconSprites:Icon_MapNode_Map_Dungeon",
				showLines = false,
			},
			lore = {
				header = "Lore",
				fontColor  = "ff7abcff",
				icon = "CRB_MegamapSprites:sprMap_IconCompletion_Lore_Stretch",
				lineColor = "ff7abcff",
				showLines = true,
				maxLines = 1,
			},
			scientist = {
				header = "Path - Scientist",
				fontColor = "ffc759ff",
				icon = "CRB_PlayerPathSprites:spr_Path_Scientist_Stretch",
				lineColor = "ffc759ff",
				showLines = false,
				maxLines = 1,
			},
			scientistScans = {
				header = "Path - Scientist Scans",
				fontColor = "ffc759ff",
				icon = "CRB_PlayerPathSprites:spr_Path_Scientist_Stretch",
				lineColor = "ffc759ff",
				maxLines = 1,
			},
			solider = {
				header = "Path - Soldier",
				fontColor = "ffc759ff",
				icon = "CRB_PlayerPathSprites:spr_Path_Soldier_Stretch",
				lineColor = "ffc759ff",
				maxLines = 1,
			},
			settler = {
				header = "Path - Settler",
				fontColor = "ffc759ff",
				icon = "CRB_PlayerPathSprites:spr_Path_Settler_Stretch",
				lineColor = "ffc759ff",
				maxLines = 1,
			},
			settlerResources = {
				header = "Path - Settler Resources",
				fontColor = "ffc759ff",
				icon = "CRB_PlayerPathSprites:spr_Path_Settler_Stretch",
				lineColor = "ffc759ff",
				maxLines = 1,
			},
			explorer = {
				header = "Path - Explorer",
				fontColor = "ffc759ff",
				icon = "CRB_PlayerPathSprites:spr_Path_Explorer_Stretch",
				lineColor = "ffc759ff",
				maxLines = 1,
			},
			questLoot = {
				header = "Quest - Loot",
				icon = "ClientSprites:GroupLootIcon",
				showLines = false,
				iconWidth = 32,
				iconHeight = 32,
			},
			subdue = {
				header = "Subdue - Weapon",
				lineColor = "ffff8000",
				iconColor = "ffff8000",
				icon = "ClientSprites:GroupWarriorIcon",
				lineWidth = 10,
				iconHeight = 32,
				iconWidth = 32
			},
			["Bruxen"] = {
				header = "Crimson Badlands - Thayd Portal",
				display = "Ship to Thayd",
				fontColor = "ffabf8cb",
				icon = "IconSprites:Icon_MapNode_Map_Portal",
				showLines = false,
			},
			["Gus Oakby"] = {
				header = "Thayd - Crimson Badlands Portal",
				display = "Ship to Crimson Badlands",
				fontColor = "ffabf8cb",
				icon = "IconSprites:Icon_MapNode_Map_Portal",
				showLines = false,
			},
			["Lilly Startaker"] = {
				header = "Thayd - Grimvault Portal",
				display = "Ship to Grimvault",
				fontColor = "ffabf8cb",
				icon = "IconSprites:Icon_MapNode_Map_Portal",
				showLines = false,
			},
			["Transportation Expert Conner"] = {
				header = "Thayd - Farside Portal",
				display = "Ship to Farside",
				fontColor = "ffabf8cb",
				icon = "IconSprites:Icon_MapNode_Map_Portal",
				showLines = false,
			},
			["Warrant Officer Burke"] = {
				header = "Thayd - Whitevale Portal",
				display = "Ship to Whitevale",
				fontColor = "ffabf8cb",
				icon = "IconSprites:Icon_MapNode_Map_Portal",
				showLines = false,
			},
			["Empirius"] = {
				header = "War of the Wilds - Empirius",
				icon = "IconSprites:Icon_MapNode_Map_PvP_BattleAlert",
				showLines = false,
			},
			["Sagittaurus"] = {
				header = "War of the Wilds - Sagittaurus",
				icon = "IconSprites:Icon_MapNode_Map_PvP_BattleAlert",
				showLines = false,
			}, 
			["Lectro"] = {
				header = "War of the Wilds - Lectro",
				icon = "IconSprites:Icon_MapNode_Map_PvP_BattleAlert",
				showLines = false,
			},
			["Krule"] = {
				header = "War of the Wilds - Krule",
				icon = "IconSprites:Icon_MapNode_Map_PvP_BattleAlert",
				showLines = false,
			},
			["Zappo"] = {
				header = "War of the Wilds - Zappo",
				icon = "IconSprites:Icon_MapNode_Map_PvP_BattleAlert",
				showLines = false,
			},
			["Ignacio"] = {
				header = "War of the Wilds - Ignacio",
				icon = "IconSprites:Icon_MapNode_Map_PvP_BattleAlert",
				showLines = false,
			},
			["Energy Node"] = {
				header = "War of the Wilds - Energy Node",
				icon = "CRB_InterfaceMenuList:spr_InterfaceMenuList_SilverFlagStretch",
				showLines = false,
			},
			["Moodie Totem"] = {
				header = "War of the Wilds - Moodie Totem",
				icon = "CRB_InterfaceMenuList:spr_InterfaceMenuList_RedFlagStretch",
				iconColor = "ffff3300",
				showLines = false,
			},
			["Skeech Totem"] = {
				header = "War of the Wilds - Skeech Totem",
				icon = "CRB_InterfaceMenuList:spr_InterfaceMenuList_BlueFlagStretch",
				showLines = false,
			},
			["Police Patrolman"] = {
				header = "Crimelords of Whitevale - Police Patrolman",
				icon = "PerspectiveSprites:Circle-Outline",
				showLines = false,
				showName = false,
				showDistance = false,
				iconColor = "ff00ff00"
			},
			["Police Constable"] = {
				header = "Crimelords of Whitevale - Police Constable",
				icon = "PerspectiveSprites:Circle-Outline",
				showLines = false,
				showName = false,
				showDistance = false,
				iconColor = "ff00ff00"
			},
		},
		markers = {
			quest = {
				header = "Quest",
				icon = "Crafting_CoordSprites:sprCoord_AdditivePreviewSmall",
				iconHeight = 64,
				iconWidth = 64,
				font = "CRB_Pixel_O",
				fontColor = "ffffffff",
				maxPer = 1,
				inAreaRange = 100,
			},
			path = {
				header = "Path",
				soldierIcon = "CRB_PlayerPathSprites:spr_Path_Solider_Stretch",
				settlerIcon = "CRB_PlayerPathSprites:spr_Path_Settler_Stretch",
				explorerIcon = "CRB_PlayerPathSprites:spr_Path_Explorer_Stretch",
				scientistIcon ="CRB_PlayerPathSprites:spr_Path_Scientist_Stretch",
				iconHeight = 64,
				iconWidth = 64,
				font = "CRB_Pixel_O",
				fontColor = "ffffffff",
				maxPer = 1,
			},
			event = {
				header = "Event",
				icon = "Crafting_CoordSprites:sprCoord_AdditiveTargetRed",
				iconHeight = 64,
				iconWidth = 64,
				font = "CRB_Pixel_O",
				fontColor = "ffffffff",
				maxPer = 1,
				inAreaRange = 100,
			},	
		},
		blacklist = {},
	}
}

function Perspective:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 

    return o
end

function Perspective:OnInitialize()
	Apollo.LoadSprites("PerspectiveSprites.xml")

	self.db = Apollo.GetPackage("Gemini:DB-1.0").tPackage:New(self, defaults)
	
	self.xmlDoc = XmlDoc.CreateFromFile("Perspective.xml")

    self.Options = Apollo.LoadForm(self.xmlDoc, "Options", nil, self)
    self.CategoryList = self.Options:FindChild("CategoryList")
    self.CategoryEditor = self.Options:FindChild("CategoryEditor")

    self.NewCategory = Apollo.LoadForm(self.xmlDoc, "NewCategory", self.Options, self)

	self.Overlay = Apollo.LoadForm(self.xmlDoc, "Overlay", "InWorldHudStratum", self)
	self.Overlay:Show(true, true)

	-- Register the slash command	
	Apollo.RegisterSlashCommand("perspective", "OnShowOptions", self)
	
	-- Table containing every unit we currently are aware of
	self.units = {}

	-- Track our prioritized units, the closest to the player.
	self.prioritized = {}

	-- Track our categorized units
	self.categorized = {}
	
	self.challenges = {}

	-- Path marker windows
	self.markers = {}
	self.markersInitialized = false
	
	-- Register our addon events				
	Apollo.RegisterEventHandler("UnitCreated", 						"OnUnitCreated", self)
	Apollo.RegisterEventHandler("UnitDestroyed", 					"OnUnitDestroyed", self)
	Apollo.RegisterEventHandler("ChangeWorld", 						"OnWorldChanged", self)
	
	Apollo.RegisterEventHandler("QuestInit", 						"OnQuestInit", self)
	Apollo.RegisterEventHandler("QuestObjectiveUpdated", 			"OnQuestObjectiveUpdated", self)
	Apollo.RegisterEventHandler("QuestStateChanged", 				"OnQuestStateChanged", self)
	Apollo.RegisterEventHandler("QuestTrackedChanged", 				"OnQuestTrackedChanged", self)
	
	Apollo.RegisterEventHandler("ChallengeActivate", 				"OnChallengeActivated", self) 
	Apollo.RegisterEventHandler("ChallengeAbandon", 				"OnChallengeRemoved", self)
	Apollo.RegisterEventHandler("ChallengeCompleted", 				"OnChallengeRemoved", self)
	Apollo.RegisterEventHandler("ChallengeFailArea", 				"OnChallengeRemoved", self)
	Apollo.RegisterEventHandler("ChallengeFailTime", 				"OnChallengeRemoved", self)
	Apollo.RegisterEventHandler("ChallengeFailGeneric", 			"OnChallengeRemoved", self)

	Apollo.RegisterEventHandler("PlayerPathMissionActivate", 		"OnPlayerPathMissionActivate", self)
	Apollo.RegisterEventHandler("PlayerPathMissionAdvanced", 		"OnPlayerPathMissionAdvanced", self)
	Apollo.RegisterEventHandler("PlayerPathMissionComplete", 		"OnPlayerPathMissionComplete", self)
	Apollo.RegisterEventHandler("PlayerPathMissionDeactivate", 		"OnPlayerPathMissionDeactivate", self)
	Apollo.RegisterEventHandler("PlayerPathMissionUnlocked", 		"OnPlayerPathMissionUnlocked", self)
	Apollo.RegisterEventHandler("PlayerPathMissionUpdate", 			"OnPlayerPathMissionUpdate", self)

	Apollo.RegisterEventHandler("TargetUnitChanged",				"OnTargetUnitChanged", self)
	
	Apollo.RegisterEventHandler("InterfaceMenuListHasLoaded", 		"OnInterfaceMenuListHasLoaded", self)
	Apollo.RegisterEventHandler("InterfaceMenuClicked", 			"OnInterfaceMenuClicked", self)

	Apollo.RegisterEventHandler("PublicEventStart", 					"OnPublicEventUpdate", self)
	Apollo.RegisterEventHandler("PublicEventObjectiveUpdate", 			"OnPublicEventUpdate", self)
	
	Apollo.RegisterEventHandler("PublicEventLocationAdded", 			"OnPublicEventUpdate", self)
	Apollo.RegisterEventHandler("PublicEventLocationRemoved", 			"OnPublicEventUpdate", self)
	Apollo.RegisterEventHandler("PublicEventObjectiveLocationAdded", 	"OnPublicEventUpdate", self)
	Apollo.RegisterEventHandler("PublicEventObjectiveLocationRemoved", 	"OnPublicEventUpdate", self)
	Apollo.RegisterEventHandler("PublicEventCleared", 					"OnPublicEventEnd", self)
	Apollo.RegisterEventHandler("PublicEventEnd", 						"OnPublicEventEnd", self)
	Apollo.RegisterEventHandler("PublicEventLeave",						"OnPublicEventEnd", self)
end

function Perspective:OnEnable()
	self:InitializeOptions()

	self.fastTimer = ApolloTimer.Create(self.db.profile.settings.fastTimer / 1000, 	true, "OnTimerTicked_Fast", self)
	self.slowTimer = ApolloTimer.Create(self.db.profile.settings.slowTimer, 		true, "OnTimerTicked_Slow", self)	
	self.drawTimer = ApolloTimer.Create(self.db.profile.settings.drawTimer / 1000,	true, "OnTimerTicked_Draw", self)

		-- Get the player's path type
	if  PlayerPathLib:GetPlayerPathType() == PlayerPathLib.PlayerPathType_Soldier then
		self.path = "solider"
	elseif PlayerPathLib:GetPlayerPathType() == PlayerPathLib.PlayerPathType_Settler then
		self.path = "settler"
	elseif PlayerPathLib:GetPlayerPathType() == PlayerPathLib.PlayerPathType_Scientist then
		self.path = "scientist"
	elseif PlayerPathLib:GetPlayerPathType() == PlayerPathLib.PlayerPathType_Explorer then
		self.path = "explorer"
	end

	self.loaded = true

	if Apollo.GetAddon("Rover") then
		SendVarToRover("Perspective", self)
	end
end

function Perspective:Start()
	self.db.profile.settings.disabled = false

	self.drawTimer:Start()
	self.slowTimer:Start()
	self.fastTimer:Start()
		
	self:MarkersInit();
end

function Perspective:Stop()
	self.db.profile.settings.disabled = true

	self.categorized = {}
	self.markers = {}
end

function Perspective:OnTimerTicked_Draw()

	-- Determines if we are allowed to draw the unit
	local function addPixies(ui, pPos, pixies, items, lines)
		local unit = GameLib.GetUnitById(ui.id)
		
		if unit then
				
			local isOccluded = unit:IsOccluded()

			if table.getn(pixies) < self.db.profile.settings.max
				and (not isOccluded or (isOccluded and not ui.disableOccluded)) then

				-- Update the units position
				local uPos = GameLib.GetUnitScreenPosition(unit)
			
				if uPos then
					local showItem = true
					local showLine = true

					-- Determine if we can show the line
					if not ui.showLines or (not uPos.bOnScreen and not ui.showLinesOffscreen) then
						showLine = false
					end

					-- Determine if we can show the icon
					if not uPos.bOnScreen then
						showItem = false
					end

					-- We've determined either the lines or icons can be show, now
					-- we need to see if we hit our display limit.
					if (showItem or showLine) and ui.limitBy and ui.limitId then
						for i, id in pairs(ui.limitId) do
							-- Determine if our item is within limit.
							if (items[ui.limitBy][id] or 0) >= ui.max then
								showItem = false
							end

							-- Determine if our line is within limit.
							if (lines[ui.limitBy][id] or 0) >= ui.maxLines then
								showLine = false
							end
						end
					end

					-- Either the item or line are able to be shown.
					if showItem or showLine then
						-- Add the unit to the draw list.
						table.insert(pixies, { 
							ui = ui, 
							unit = unit, 
							uPos = uPos, 
							pPos = pPos, 
							showItem = showItem, 
							showLine = showLine 
						})
						
						-- Increase our limits.
						if ui.limitBy and ui.limitId then
							for i, id in pairs(ui.limitId) do
								-- Increase the item limit count
								if showItem then
									items[ui.limitBy][id] = (items[ui.limitBy][id] or 0) + 1
								end

								-- Increase the line limit count
								if showLine then
									lines[ui.limitBy][id] = (lines[ui.limitBy][id] or 0) + 1
								end
							end
						end
					end
				end
			end
		end
	end

	-- Draw the pixie on screen
	local function drawPixie(ui, unit, uPos, pPos, showItem, showLine)
		-- Draw the line first, if it needs to be drawn
		if showLine then
			-- Get the unit's position and vector
			local pos = unit:GetPosition()
			local vec = Vector3.New(pos.x, pos.y, pos.z)

			-- Get the screen position of the unit by it's vector
			local lPos = GameLib.WorldLocToScreenPoint(vec)

			-- Draw the background line to give the outline if required
			if ui.showLineOutline then
				self.Overlay:AddPixie({
					bLine = true,
					fWidth = ui.lineWidth + 2,
					cr = "ff000000",
					loc = {
						fPoints = {0, 0, 0, 0},
						nOffsets = {
							lPos.x, 
							lPos.y, 
							pPos.nX, 
							pPos.nY
						}
					}
				})
			end

			-- Draw the actual line to the unit's vector
			self.Overlay:AddPixie({
				bLine = true,
				fWidth = ui.lineWidth,
				cr = ui.cLineColor,
				loc = {
					fPoints = {0, 0, 0, 0},
					nOffsets = {
						pPos.nX, 
						pPos.nY,
						lPos.x, 
						lPos.y, 					
					}
				}
			})
		end

		-- Draw the icon and text if it needs to be drawn.
		if showItem then
			-- Draw the icon first
			if ui.showIcon then
				self.Overlay:AddPixie({
					strSprite = ui.icon,
					cr = ui.cIconColor,
					loc = {
						fPoints = { 0, 0, 0, 0 },
						nOffsets = {
							uPos.nX - (ui.scaledWidth / 2), 
							uPos.nY - (ui.scaledHeight / 2), 
							uPos.nX + (ui.scaledWidth / 2),
							uPos.nY + (ui.scaledHeight / 2)
						}
					}
				})
			end		
			
			-- Draw the text
			if ui.showName or ui.showDistance then
				local text = ""

				if ui.showName then
					text = ui.display or unit:GetName() or ""
				end

				text = (ui.showDistance and ui.distance >= ui.rangeLimit) and text .. " (" .. math.ceil(ui.distance) .. "m)" or text

				self.Overlay:AddPixie({
					strText = text,
					strFont = ui.font,
					crText = ui.cFontColor,
					loc = {
						fPoints = {0,0,0,0},
						nOffsets = {
							uPos.nX - 50, 
							uPos.nY + (ui.scaledHeight / 2) + 0, 
							uPos.nX + 50, 
							uPos.nY + (ui.scaledHeight / 2) + 100 
						}
					},
					flagsText = {
						DT_CENTER = true,
						DT_WORDBREAK = true
					}
				})
			end
		end
	end

	-- Stop our draw timer
	self.drawTimer:Stop()

	-- Check to see if the addon was disabled.
	if self.db.profile.settings.disabled then 
		-- Destroy all our pixies
		self.Overlay:DestroyAllPixies()

		return
	end

	-- This list will contain all the pixies we we'll need to draw.
	local pixies = {}

	-- Get the player's current screen position
	local pPos = GameLib.GetUnitScreenPosition(GameLib.GetPlayerUnit())

	-- We want to make sure we can get the unit's screen position	
	if pPos then

		-- The limits tables
		local items = {	unit = {}, category = {}, quest = {}, challenge = {} }
		local lines = {	unit = {}, category = {}, quest = {}, challenge = {} }

		-- Check our prioritized units first, they are the closest to our player
		for index, ui in pairs(self.prioritized) do
			addPixies(ui, pPos, pixies, items, lines)
		end

		-- Finally check our categorized units.
		for index, ui in pairs(self.categorized) do
			addPixies(ui, pPos, pixies, items, lines)			
		end

		-- Destroy all our pixies
		self.Overlay:DestroyAllPixies()

		-- Finally, lets draw some pixies!

		-- Draw the markers, they are most likely going to be the farthest pixies from the player
		-- so we want them "behind" our other units.
		self:MarkersDraw()

		-- Now, for the pixies, we'll draw them in reverse, because the lists were sorted by
		-- distance, closest to farthest.  This will ensure our farthers are drawn first and 
		-- "behind" our closer pixies.
		for i = #pixies, 1, -1 do
			-- Get our next pixie
			pixie = pixies[i]

			-- Drw the pixie
			drawPixie(
				pixie.ui, 
				pixie.unit, 
				pixie.uPos, 
				pixie.pPos, 
				pixie.showItem, 
				pixie.showLine)
		end

	end

	self.drawTimer:Start()
end

-- Updates all the units we know about as well as loading options if its needed.
-- Categorizes and prioritizes our units.
function Perspective:OnTimerTicked_Slow()
	-- Stop the timer while we process the units.
	self.slowTimer:Stop()

	-- Check to make sure the addon isn't disabled.
	if self.db.profile.settings.disabled then 
		return
	end

	local player = GameLib.GetPlayerUnit()

	if player then
		local pos = player:GetPosition()
	
		if pos then
			-- Get the player's current vector from position.
			local vector = Vector3.New(pos.x, pos.y, pos.z)
			
			-- Determine if we are currently in combat.
			local inCombat = GameLib.GetPlayerUnit():IsInCombat()

			-- Update all the uncategorized and unprioritized units.
			for index, ui in pairs(self.units) do
				self:UpdateUnit(ui,  inCombat, "units", index)
			end

			-- Update the categorized units.
			for index, ui in pairs(self.categorized) do
				self:UpdateUnit(ui, inCombat, "categorized", index)
			end

			table.sort(self.categorized, function(a, b) return (a.distance or 0) < (b.distance or 0) end)
			
			if self.markersInitialized then
				self:MarkersUpdate(vector)
			else
				self:MarkersInit()
			end

		end
	end

	-- Restart our timer now that we are finished processing
	self.slowTimer:Start()
end

-- Updates our prioritized (close) units faster than the farther ones.
-- We'll keep this as light weight as possible, only updating the distance and relevant info.
function Perspective:OnTimerTicked_Fast()
	-- Stop the timer while we process the units.
	self.fastTimer:Stop()

	-- Check to make sure the addon isn't disabled.
	if self.db.profile.settings.disabled then 
		return
	end

	local player = GameLib.GetPlayerUnit()

	if player then
		local pos = player:GetPosition()
	
		if pos then
			-- Get the player's current vector from position.
			local vector = Vector3.New(pos.x, pos.y, pos.z)

			-- Determine if we are currently in combat.
			local inCombat = GameLib.GetPlayerUnit():IsInCombat()

			-- Update the prioritized units.
			for index, ui in pairs(self.prioritized) do
				self:UpdateUnit(ui, inCombat, "prioritized", index)
			end

			-- Sort the units by distance.
			table.sort(self.prioritized, function(a, b) return (a.distance or 0) < (b.distance or 0) end)
		end
	end

	-- Restart our timer now that we are finished processing
	self.fastTimer:Start()
end

-- Updates the unit to determine category, loads its setttings, and calculates its current distance
-- from the player.
function Perspective:UpdateUnit(ui, inCombat, list, index)

	-- List of containing information on uis that need to be shifted to a different list.
	local shift ={}

	local unit = GameLib.GetUnitById(ui.id)

	if unit then
		-- Get the unit's position
		local category = ui.category
		local pos = unit:GetPosition()
		local name = unit:GetName()

		local track = false

		-- reset the category as it might have changed
		ui.category = nil				

		-- We only care about units that we can determine a current position on.
		-- Also make sure the unit has a name, otherwise we might end up with 
		-- "Hostile Invisible Units for Fields" under settler depots.
		if pos and
			ui.name ~= "" then

			local busy

			if unit == GameLib.GetTargetUnit() and
				not self.db.profile.categories.target.disabled then
				ui.category = "target"
				track = true
			elseif self.db.profile.categories[name] then
				-- This is a custom category, it has priority over all other category types except
				-- target and focus.
				ui.category = name
				track = true
			else
				-- Updates the activation state for the unit and determines if it is busy, if it is
				-- busy then we do not care for this unit at this time.
				busy, track = self:UpdateActivation(ui, unit)
			end

			-- We only care about non busy units.
			if not busy then
				-- Only continue looking for a category if it has not be found by now, unless its a 
				-- scientist item, then we'll further check the rewards to see if its an active scan
				-- mission target, it will then be reclassified as such.
				if not ui.category or 
					ui.category == "scientist" then

					local type = unit:GetType()

					-- Determines if any rewards for this unit exist, such as quest objectvies, 
					-- challenge objectives or scientist scan target.
					local rewards = self:GetRewardInfo(ui, unit)

					-- Attempt to categorize the unit by type.
					if type == "Player" then
						self:UpdatePlayer(ui, unit)
						track = true
					elseif type == "NonPlayer" then
						self:UpdateNonPlayer(ui, unit, rewards)
						track = true
					elseif type == "Simple" or type == "SimpleCollidable" then
						self:UpdateSimple(ui, unit, rewards)
						track = true
					elseif type == "Collectible" then
						self:UpdateCollectible(ui, unit, rewards)
						track = true
					elseif type == "Harvest" then
						self:UpdateHarvest(ui, unit)
						track = true
					elseif type == "Pickup" then
						self:UpdatePickup(ui, unit)
						track = true
					elseif unit:GetLoot() then
						self:UpdateLoot(ui, unit)
						track = true
					end

				end

				-- If a category has still not been found for the unit, then determine its disposition
				-- and difficulty and categorize it as such.
				if not ui.category and 
					unit:GetType() == "NonPlayer" and
					not unit:IsDead() then

					local disposition = "friendly"
					local difficulty = ""

					if unit:GetDispositionTo(GameLib.GetPlayerUnit())  == 0 then
						disposition = "hostile"
					elseif unit:GetDispositionTo(GameLib.GetPlayerUnit()) == 1 then
						disposition = "neutral"
					end

					-- Not sure how accurate this is
					-- Rank 1: 			Minion
					-- Rank 2:			Grunt
					-- Rank 3:			Challenger
					-- Rank 4:			Superior
					-- Rank 5:			Prime
					-- Difficulty 1:	Minion, Grunt, Challenger
					-- Difficulty 3:	Prime
					-- Difficulty 4:	5 Man? - XT Destroyer (Galeras)
					-- Difficulty 5:	10 Man?
					-- Difficulty 6:	20 Man? - Doomthorn the Ancient (Galeras)
					-- Eliteness 1:		5 Man + (Dungeons?)
					-- Eliteness 2:		20 Man? - Doomthorn the Ancient (Galeras)
					if unit:GetDifficulty() == 3 then
						difficulty = "Prime"
					elseif unit:GetEliteness() >= 1 then
						difficulty =  "Elite"
					end

					local npcType = disposition .. difficulty

					if not self.db.profile.categories[npcType].disabled then
						ui.category = npcType
					end
				end

				-- Finally determine that our category has been successfully set and we can
				-- update the unit.
				if ui.category then

					-- Unit has never had its options updated or its category has changed, so
					-- we need to update the options for it.
					if not ui.loaded or ui.category ~= category then 	
						self:UpdateOptions(ui)
					end

					-- Unit is not disabled and we have our options loaded for it, lets categorize it.
					if not ui.disabled then
						if ui.limitBy and ui.limitBy ~= "none" then	
							if 	   ui.limitBy == "name"			then ui.limitId = { name }
							elseif ui.limitBy == "category" 	then ui.limitId = { ui.category }
							elseif ui.limitBy == "quest" 		then ui.limitId = ui.quest
							elseif ui.limitBy == "challenge"	then ui.limitId = ui.challenge
							end
						else
							ui.limitId = nil
						end
						
						self:UpdateDistance(ui, unit)
					end

					track = true

				end

			end
		end

		if track then
			-- We'll just strip its data down to just the basics because:
			-- The unit could not be categorized
			-- The unit was out of range
			-- The unit is disabled in combat.
			-- The unit is disabled.
			-- The unit name, distance, and lines are all not shown.
			-- The unit wasn't loaded for some reason.
			if not ui.category or 
				not ui.inRange or
				ui.disabled or
				(inCombat and ui.disableInCombat) or
				(not ui.showIcon and not ui.showName and not ui.showDistance and not ui.showLines) then

				ui = { id = ui.id, invalid = ui.invalid }

				-- We have no need to know about this unit right now, strip it down and move it
				-- back to the units list if its not already there.
				if list ~= "units" then
					table.insert(shift, { index = index, new = "units", old = list })
				end
			else
				local newList = "units"

				-- Move the unit to the prioritized or categorized list depending on its needs.
				if ui.distance <= ui.rangeLimit + 20 then
					newList = "prioritized"
				elseif ui.category then
					newList = "categorized"
				end

				if newList ~= list then
					table.insert(shift, { index = index, new = newList, old = list })
				end
			end
		else
			-- We don't need to track this unit, remove the ui.
			table.insert(shift, { index = index, new = "none", old = list })
		end
	else
		-- This is an invalid unit, so add it to the shift list to be removed.
		--table.insert(shift, { index = index, new = "none", old = list })
	end

	for k, v in pairs(shift) do
		if v.new == "none" then
			-- Remove the ui from the list.
			table.remove(self[v.old], v.index)
		else
			-- Get the ui to be shifted.
			local u = self[v.old][v.index]

			-- Shift it to the new list.
			table.insert(self[v.new], u)

			-- Remove it from the old list.
			table.remove(self[v.old], v.index)
		end
	end			
end

function Perspective:UpdateDistance(ui, unit)
	-- Update the players position and vector
	local pPos = GameLib.GetPlayerUnit():GetPosition()
	local pVec = Vector3.New(pPos.x, pPos.y, pPos.z)

	-- Update the units position and vector
	local uPos = unit:GetPosition()
	ui.vector = Vector3.New(uPos.x, uPos.y, uPos.z)

	-- Calculate z axis (really y axis) distance
	local zVec = Vector3.New(pPos.x, uPos.y, pPos.z)
	local zDistance = (pVec - zVec):Length()

	-- Get the distance from the player.
	ui.distance = (pVec - ui.vector):Length()
	
	-- Get the scale size based on distance.
	ui.scale = math.min(1 / (ui.distance / 100), 1)
	
	-- Determine if the unit is in range of display.
	ui.inRange = (ui.distance > ui.minDistance and 
				  ui.distance < ui.maxDistance and 
				  zDistance <= ui.zDistance)

	-- Determine if the unit is in skill range.
	ui.inRangeLimit = (ui.distance <= ui.rangeLimit)

	-- Scale our icon based on the dimensions and scale factor.			  
	ui.scaledWidth = ui.iconWidth * math.max(ui.scale, .5)
	ui.scaledHeight = ui.iconHeight * math.max(ui.scale, .5)

	-- Calculate colors based on range
	ui.cLineColor = (ui.inRangeLimit and ui.rangeLine) and ui.rangeColor or ui.lineColor
	ui.cFontColor = (ui.inRangeLimit and ui.rangeFont) and ui.rangeColor or ui.fontColor
	ui.cIconColor = (ui.inRangeLimit and ui.rangeIcon) and ui.rangeColor or ui.iconColor
end

function Perspective:UpdateOptions(ui)

	local function updateOptions(ui)
		for k, v in pairs(self.db.defaults.profile.categories.default) do
			ui[k] = self:GetOptionValue(ui, k)
		end

		--ui.display = self:GetOptionValue(ui, "display")
		
		ui.loaded = true
	end
	
	if ui then
		-- Update only the specific unit information
		updateOptions(ui)
	else
		-- Update all the prioritized units
		for i, ui in pairs(self.prioritized) do
			updateOptions(ui)
		end

		-- Update all the categorized units
		for i, ui in pairs(self.categorized) do
			updateOptions(ui)
		end

		-- Update the remaining units
		for i, ui in pairs(self.units) do
			updateOptions(ui)
		end
	end
end

function Perspective:MarkersDraw()
	for id, marker in pairs(self.markers) do
		local marks = 0

		for index, region in pairs(marker.regions) do
			-- Get the screen position of the unit by it's vector
			local uPos = GameLib.WorldLocToScreenPoint(region.vector)

			-- Make sure the point is onscreen and in front of us.
			if marks < self.db.profile.markers[marker.type].maxPer and
				uPos.z > 0 and
				not region.inArea then
				self.Overlay:AddPixie({
					strSprite = marker.icon,
					--cr = ui.iconColor,
					loc = {
						fPoints = { 0, 0, 0, 0 },
						nOffsets = {
							uPos.x - (32), 
							uPos.y - (32), 
							uPos.x + (32),
							uPos.y + (32)
						}
					}
				})

				self.Overlay:AddPixie({
					strText = marker.name .. " (" .. (region.distance or 99999) .. "m)",
					strFont = "CRB_Pixel_O",
					crText = "ffffffff",
					loc = {
						fPoints = { 0, 0, 0, 0 },
						nOffsets = {
							uPos.x - (64), 
							uPos.y + (32), 
							uPos.x + (64),
							uPos.y + (100)
						}
					},
					flagsText = {
						DT_CENTER = true,
						DT_WORDBREAK = true
					}
				})

				marks = marks + 1
			end
		end
	end
end

function Perspective:MarkersInit()
	local _, __

	-- Set the markers as no longer initialized
	self.markersInitialized = false

	-- Destroy any current makers
	for _, id in pairs(self.markers) do
		--self:MarkerDestroy(id)
		self.markers = {}
	end

	local episodes = PlayerPathLib:GetPathEpisodeForZone()

	if episodes then
		for _, mission in pairs(episodes:GetMissions()) do
			self:MarkerPathUpdate(mission)
		end
	end		

	episodes = QuestLib:GetTrackedEpisodes()

	if episodes then
		for _, episode in pairs(episodes) do
			for __, quest in pairs(episode:GetTrackedQuests()) do
				self:MarkerQuestUpdate(quest)
			end
		end
	end

	local events = PublicEventsLib.GetActivePublicEventList()

	if events then
		for id, event in pairs(events) do
			self:MarkerEventUpdate(event, id)
		end
	end

	-- Set the markers as having been initialized
	self.markersInitialized = true
end

function Perspective:MarkersUpdate(vector)
	local _

	-- Update all the episode markers
	for _, marker in pairs(self.markers) do
		self:MarkerUpdate(marker, vector)
	end
end

function Perspective:MarkerEventUpdate(event)
	local id = "event" .. event:GetName()

	if event:IsActive() and table.getn(event:GetObjectives()) > 0 then
		self.markers[id] = {
			name = event:GetName(),
			type = "event",
			regions = {},
			icon = self.db.profile.markers.event.icon
		}
		for index, objective in pairs(event:GetObjectives()) do
			for index, region in pairs(objective:GetMapRegions()) do
				self.markers[id].regions[index] = {
					vector = Vector3.New(region.tIndicator.x, region.tIndicator.y, region.tIndicator.z)
				}
				self:MarkerUpdate(self.markers[id])
			end
		end
	else
		self.markers[id] = nil
	end
end

function Perspective:MarkerPathUpdate(mission, deactivated)
	local id = "path" .. mission:GetId()

	if mission:IsStarted() and not mission:IsComplete() and not deactivated then
		if table.getn(mission:GetMapRegions()) > 0 then
			self.markers[id] = {
				name = mission:GetName(),
				type = "path",
				regions = {},
				mission = mission,
				icon = self.db.profile.markers.path[self.path .. "Icon"]
			}
			for index, region in pairs(mission:GetMapRegions()) do
				self.markers[id].regions[index] = {
					vector = Vector3.New(region.tIndicator.x, region.tIndicator.y, region.tIndicator.z)
				}
				self:MarkerUpdate(self.markers[id])
			end
		end
	else
		self.markers[id] = nil
	end
end

function Perspective:MarkerQuestUpdate(quest)
	local id = "quest" .. quest:GetId()
		
	if quest:IsTracked() and 
	  (quest:GetState() == Quest.QuestState_Accepted or 
	   quest:GetState() == Quest.QuestState_Achieved) then
	  	-- Make sure we have actual map regions
	  	if table.getn(quest:GetMapRegions()) > 0 then
		  	-- Create the quest marker
		  	self.markers[id] = {
		  		name = quest:GetTitle(),
		  		type = "quest",
		  		regions = {},
		  		icon = self.db.profile.markers.quest.icon
		  	}
			-- Create a marker for every quest region
			for index, region in pairs(quest:GetMapRegions()) do
				self.markers[id].regions[index] = {
					vector = Vector3.New(region.tIndicator.x, region.tIndicator.y, region.tIndicator.z)
				}
				self:MarkerUpdate(self.markers[id])
			end
		end
	else
		self.markers[id] = nil
	end
end

function Perspective:MarkerDestroy(id)
	self.markers[id] = nil
end

-- Updates the marker information
-- vector is the players current position vector.
function Perspective:MarkerUpdate(marker, vector)
	local player
	local pos

	if not vector then

		local player = GameLib.GetPlayerUnit()

		if player then
			local pos = player:GetPosition()

			if pos then
				vector = Vector3.New(pos.x, pos.y, pos.z)
			end
		end
	end

	if vector then
		local inArea = false

		if marker.type == "path" and marker.mission:IsInArea() then
			inArea = true
		end

		for index, region in pairs(marker.regions) do
			-- Get the distance to the marker
			region.distance = math.ceil((vector - region.vector):Length())
				
			-- Determine if the player is in the region
			if marker.type == "quest" then
				-- No direct call that I can find to determine if the player is
				-- in the area, so make it anywhere closer than 100m
				region.inArea = (region.distance <= self.db.profile.markers.quest.inAreaRange)
			elseif marker.type == "path" then
				region.inArea = inArea
			end
		end

		table.sort(marker.regions, function(a, b) return (a.distance or 0) < (b.distance or 0) end)
	end
end


function Perspective:GetOptionValue(ui, option, category)
	local category = category or ui.category or "default"
		-- Get the category option value
		if self.db.profile.categories[category] and
			self.db.profile.categories[category][option] ~= nil then
			return self.db.profile.categories[category][option]
		-- Failback to the default option value
		elseif self.db.defaults.profile.categories.default[option] ~= nil then
			return self.db.defaults.profile.categories.default[option]
		end
		
		return nil
	--end
end

function Perspective:OnInterfaceMenuListHasLoaded()
	Event_FireGenericEvent("InterfaceMenuList_NewAddOn", "Perspective", {"InterfaceMenuClicked", "", "IconSprites:Icon_Windows32_UI_CRB_InterfaceMenu_Map"})
end

function Perspective:OnInterfaceMenuClicked(arg1, arg2, arg3)
	self.Options:Show(not self.Options:IsShown(), true)
end

---------------------------------------------------------------------------------------------------
-- Addon Event Functions
---------------------------------------------------------------------------------------------------

function Perspective:OnUnitCreated(unit)
	local tracked = false

	for i, ui in pairs(self.units) do
		if ui.id == unit:GetId() then
			tracked = true
			break
		end
	end
	
	if not tracked then
		table.insert(self.units, { id = unit:GetId() })
	end	
end

function Perspective:OnUnitDestroyed(unit)
	for i, v in pairs(self.units) do
		if v.id == unit:GetId() then
			table.remove(self.units, i)
			break
		end
	end

end

function Perspective:OnTargetUnitChanged(unit)
	
	if not self.db.profile.categories.target.disabled then
		-- Update the units immediately
		self:OnTimerTicked_Slow()
		self:OnTimerTicked_Fast()
	end
	
end

function Perspective:OnWorldChanged()
	if self.loaded then
		self:MarkersInit()
	end
end

function Perspective:OnQuestInit()
	if self.loaded then
		self:MarkersInit()
	end
end

function Perspective:OnQuestTrackedChanged(quest)
	if self.loaded then
		self:MarkerQuestUpdate(quest)
	end
end

function Perspective:OnQuestObjectiveUpdated(quest)
	if self.loaded then
		self:MarkerQuestUpdate(quest)
	end
end

function Perspective:OnQuestStateChanged(quest)
	if self.loaded then
		self:MarkerQuestUpdate(quest)
	end
end

function Perspective:OnPlayerPathMissionActivate(mission)
	if self.loaded then
		self:MarkerPathUpdate(mission)
	end
end

function Perspective:OnPlayerPathMissionAdvanced(mission)
	if self.loaded then
		self:MarkerPathUpdate(mission)
	end
end

function Perspective:OnPlayerPathMissionComplete(mission)
	if self.loaded then
		self:MarkerPathUpdate(mission)
	end
end

function Perspective:OnPlayerPathMissionDeactivate(mission)
	if self.loaded then
		self:MarkerPathUpdate(mission, true)
	end
end

function Perspective:OnPlayerPathMissionUnlocked(mission)
	if self.loaded then
		self:MarkerPathUpdate(mission)
	end
end

function Perspective:OnPlayerPathMissionUpdate(mission)
	if self.loaded then
		self:MarkerPathUpdate(mission)
	end
end

function Perspective:OnChallengeActivated(challenge)
	self.challenges[challenge:GetId()] = true
end

function Perspective:OnChallengeRemoved(challenge)
	if type(challenge) == "number" then
		self.challenges[challenge] = nil
	elseif type(challenge) == "userdata" and
		challenge:GetId() then
		self.challenges[challenge:GetId()] = nil
	else
		Print("Perspective: Unexpected challenge failure - type: " .. type(challenge))
	end
end

function Perspective:OnPublicEventUpdate(event)
	-- Check for the GetName() function, it can cause an error if not found on the event.
	if self.loaded and event["GetName"] then
		self:MarkerEventUpdate(event)
	end
end

function Perspective:OnPublicEventEnd(event)
	-- Check for the GetName() function, it can cause an error if not found on the event.
	if self.loaded and event["GetName"] then
		self.markers["event" .. event:GetName()] = nil
	end
end

function Perspective:UpdatePlayer(ui, unit)
	local player = GameLib.GetPlayerUnit()
	
	-- We don't care about ourselves
	if unit:IsThePlayer() then return end
	
	-- Check to see if the unit is in our group
	if 	unit:IsInYourGroup() and 
		not self.db.profile.categories.group.disabled then
		ui.category = "group"			
	-- Check to see if the unit is in our guild
	elseif 	player and player:GetGuildName() and 
			unit:GetGuildName() == player:GetGuildName() and
			not self.db.profile.categories.guild.disabled then
		ui.category = "guild"
	end
end

function Perspective:UpdateNonPlayer(ui, unit, rewards)
	if 	rewards then
		-- Quest target mob
		if 	rewards.quest and not unit:IsDead() and
			not self.db.profile.categories.questObjective.disabled then
			ui.category = "questObjective"
			ui.quest = rewards.quest
		-- Challenge target mob
		elseif rewards.challenge and not unit:IsDead() and
			not self.db.profile.categories.challenge.disabled then
			ui.category = "challenge"
			ui.challenge = rewards.challenge
		elseif rewards.path and 
			not self.db.profile.categories[rewards.path].disabled then
			ui.category = rewards.path
		end
	end	
end

function Perspective:UpdateSimple(ui, unit, rewards)
	local state = unit:GetActivationState()

	if state.Interact and state.Interact.bIsActive and rewards then
		-- Quest target
		if	rewards.quest and 
			not self.db.profile.categories.questObjective.disabled then
			ui.category = "questObjective"
			ui.quest = rewards.quest
		-- Challenge collectible
		elseif rewards.challenge and
			not self.db.profile.categories.questObjective.disabled then
			ui.category = "challenge"
			ui.challenge = rewards.challenge
		elseif rewards.path and 
			not self.db.profile.categories[rewards.path].disabled then
			ui.category = rewards.path
		end
	end
end

function Perspective:UpdateCollectible(ui, unit, rewards)
	if rewards then
		-- Quest collectible
		if rewards.quest and 
			not self.db.profile.categories.questObjective.disabled then
			ui.category = "questObjective"
			ui.quest = rewards.quest
		-- Challenge collectible
		elseif rewards.challenge and
			not self.db.profile.categories.questObjective.disabled then
			ui.category = "challenge"
			ui.challenge = rewards.challenge
		elseif rewards.path and 
			not self.db.profile.categories[rewards.path].disabled then
			ui.category = rewards.path
		end
	end
end

function Perspective:UpdateHarvest(ui, unit)
	local skill = unit:GetHarvestRequiredTradeskillName()
	local category
	
	if not unit:IsDead() then
		if skill == "Farmer" then
			category = "farmer"
		elseif skill == "Mining" then
			category = "miner"
		elseif skill == "Relic Hunter" then
			category = "relichunter"
		elseif skill == "Survivalist" then
			category = "survivalist" 
		end
		
		if category and not self.db.profile.categories[category].disabled then
			ui.category = category
		end
	end
end

function Perspective:UpdatePickup(ui, unit)
	if string.find(unit:GetName(), GameLib.GetPlayerUnit():GetName()) and
		not self.db.profile.categories.subdue.disabled then
		ui.category = "subdue"
	end
end

function Perspective:UpdateLoot(ui, unit)

	local loot = unit:GetLoot()

	if loot and 
		loot.eLootItemType and 
		loot.eLootItemType == 6 and
		not self.db.profile.categories.questLoot.disabled then
		category = "questLoot"
	end

end

function Perspective:UpdateActivation(ui, unit)
	local state = unit:GetActivationState()

	local states = {
		{ state = "QuestReward", 			category = "questReward" },
		--{ state = "QuestReceivingTradekill",category = "questReward" },
		{ state = "QuestNewMain", 			category = "questNew" },
		{ state = "QuestNew", 				category = "questNew" },
		{ state = "QuestNewRepeatable", 	category = "questNew" },
		--{ state = "QuestGivingTradeskill", 	category = "questNew" },
		{ state = "QuestNewTradeskill",		category = "questNew" },
		{ state = "TalkTo", 				category = "questTalkTo" },
		{ state = "Datacube", 				category = "lore" },
		{ state = "ExplorerInterest", 		category = "explorer" },
		{ state = "ExplorerActivate", 		category = "explorer" },
		{ state = "ExplorerDoor", 			category = "explorer" },
		{ state = "SettlerActivate", 		category = "settler" },
		{ state = "SoldierActivate", 		category = "solider" },
		{ state = "SoldierKill", 			category = "solider" },
		{ state = "ScientistScannable", 	category = "scientist" },
		{ state = "ScientistActivate", 		category = "scientist" },
		{ state = "Public Event",			category = "questLoot" },
		{ state = "FlightPath", 			category = "flightPath" },
		{ state = "InstancePortal", 		category = "instancePortal" },
		{ state = "BindPoint", 				category = "bindPoint" },
		{ state = "CommodityMarketplace", 	category = "marketplace" },
		{ state = "ItemAuctionhouse", 		category = "auctionHouse" },
		{ state = "Mail", 					category = "mailBox" },
		{ state = "TradeskillTrainer", 		category = "tradeskillTrainer" },
		{ state = "Vendor", 				category = "vendor" },
		{ state = "CraftingStation", 		category = "craftingStation" },
		{ state = "Dye", 					category = "dye" },
		{ state = "Bank", 					category = "bank" },
		{ state = "GuildBank", 				category = "bank" },
		{ state = "Dungeon", 				category = "dungeon" },
	}

	local busy, track = false, false
	
	if state.Busy and
		state.Busy.bIsActive then

		busy = true

	end

	for k, v in pairs(states) do

		if not track then
			track = state[v.state] ~= nil
		end

		if state[v.state] and 
			state[v.state].bIsActive and
			not self.db.profile.categories[v.category].disabled then

			ui.category = v.category

			if v.state == "Datacube" and 
				PlayerPathLib:GetPlayerPathType() == PlayerPathLib.PlayerPathType_Scientist and 
				string.find(unit:GetName(), "DATACUBE:") then
				ui.category = "scientistScans"
			end	

			break

		end

	end

	if not ui.category then

		if state.Collect and 
			state.Collect.bUsePlayerPath and 
			state.Collect.bCanInteract and
			state.Collect.bIsActive then

			if self.path == "settler" then
				ui.category = "settlerResources"
			else
				ui.category = self.path
			end

		elseif state.Interact and 
			state.Interact.bUsePlayerPath and 
			state.Interact.bCanInteract and
			state.Interact.bIsActive then
			
			ui.category = self.path

		end

	end

	return busy, track
end

function Perspective:GetRewardInfo(ui, unit)
	local rewardInfo = unit:GetRewardInfo()
	local rewards = {}
	
	if rewardInfo and type(rewardInfo) == "table" then
		for i = 1, #rewardInfo do
			local type = rewardInfo[i].strType
			
			if type == "Quest" then
				rewards.quest = rewards.quest or {}
				table.insert(rewards.quest, rewardInfo[i].idQuest)
			elseif type == "Challenge" and
				self.challenges[rewardInfo[i].idChallenge] then
				rewards.challenge = rewards.challenge or {}
				table.insert(rewards.challenge, rewardInfo[i].idChallenge)
			elseif type == "Scientist" and 
				rewardInfo[i].pmMission and
				not rewardInfo[i].pmMission:IsComplete() then
				rewards.path = "scientistScans"
			end
		end
	end
	
	return rewards
end


---------------------------------------------------------------------------------------------------
-- UI Functions
---------------------------------------------------------------------------------------------------

function Perspective:OnConfigure()
	self.Options:Show(true, true)
end

function Perspective:OnShowOptions()
	self.Options:Show(true, true)
end

function Perspective:OnCloseButton()
	self.Options:Show(false, true)
end

function Perspective:CColorToString(color)
	return string.format("FF%02X%02X%02X", 
		math.floor(color.r * 255 + 0.5), 
		math.floor(color.g * 255 + 0.5), 
		math.floor(color.b * 255 + 0.5))
end

function Perspective:StringToCColor(str)
	local r, g, b = 0, 0, 0
	
	str = string.sub(str, 3)

	local val = tonumber(str, 16)

	if val then
		r = math.floor(val / 65536) 
		g = math.floor(val / 256) % 256
		b = val % 256
	end

	return CColor.new(r / 255, g / 255, b / 255, 1)
end

function Perspective:InitializeOptions()
	if not self.optionsInitialized then
		-- Load the window position
		local pos = self.db.profile.position

		if pos ~= nil then
			self.Options:SetAnchorOffsets(pos.left, pos.top, pos.right, pos.bottom)
		end

		-- Setup the event handlers for the options window
		self.Options:AddEventHandler("WindowMoved", 		"OnOptions_AnchorsChanged")
		self.Options:AddEventHandler("WindowSizeChanged", 	"OnOptions_AnchorsChanged")
		self.Options:FindChild("NewButton"):AddEventHandler("ButtonSignal",		"OnOptions_NewClicked")
		self.Options:FindChild("DefaultButton"):AddEventHandler("ButtonSignal",	"OnOptions_DefaultClicked")

		local categories = self.Options:FindChild("CategoriesButton")
		local markers = self.Options:FindChild("MarkersButton")
		local blacklist = self.Options:FindChild("BlacklistButton")
		local settings = self.Options:FindChild("SettingsButton")

		categories:AddEventHandler("ButtonCheck", 	"OnOptions_HeaderButtonChecked")
		categories:AddEventHandler("ButtonUncheck",	"OnOptions_HeaderButtonChecked")

		markers:AddEventHandler("ButtonCheck", 		"OnOptions_HeaderButtonChecked")
		markers:AddEventHandler("ButtonUncheck", 	"OnOptions_HeaderButtonChecked")

		blacklist:AddEventHandler("ButtonCheck", 	"OnOptions_HeaderButtonChecked")
		blacklist:AddEventHandler("ButtonUncheck", 	"OnOptions_HeaderButtonChecked")

		settings:AddEventHandler("ButtonCheck", 	"OnOptions_HeaderButtonChecked")
		settings:AddEventHandler("ButtonUncheck", 	"OnOptions_HeaderButtonChecked")

		

		self.Options:FindChild("CategoriesButton"):SetCheck(true)

		

		--self:InitializeWindow_EditCategory()
		self:InitializeWindow_NewCategory()


		self.optionsInitialized = true

	end

	local default

	-- Initialize the categories
	for k, v in pairs(self.db.profile.categories) do
		v = v or self.db.defaults.profile.categories[k]
		if k ~= "default" then
			local categoryItem = self.CategoryList:FindChild("CategoryItem_" .. k)

			self:CategoryItem_Init(k, v.header, v.whitelist, categoryItem)
		end
	end

	-- Check to make sure all our items still exist
	for i, item in pairs(self.CategoryList:GetChildren()) do
		local category = item:GetData()

		if not self.db.profile.categories[category] then
			item:Destroy()
		end
	end

	-- Initialize the category editor
	self.CategoryEditor:FindChild("Back"):AddEventHandler("ButtonSignal", "CategoryEditor_OnBackClick")

	-- Initialize the settings 
	self:SettingsTimer_Init("DrawUpdate", "drawTimer", 0, "ms", 1000, 	"OnTimerTicked_Draw")
	self:SettingsTimer_Init("FastUpdate", "fastTimer", 1, "ms", 1000, 	"OnTimerTicked_Fast")
	self:SettingsTimer_Init("SlowUpdate", "slowTimer", 1, "secs", 1,	"OnTimerTicked_Slow")	

	self:CategoryItems_Arrange()
end

function Perspective:CategoryItem_Init(category, header, whitelist, item)
	local button
	--local data = { category = category, header = header }

	if not item then
		item = Apollo.LoadForm(self.xmlDoc, "CategoryItem", self.CategoryList, self)
		item:SetName("CategoryItem_" .. category)
		item:SetData(category)

		button = item:FindChild("Button")
		button:SetData(category)
		button:AddEventHandler("ButtonSignal", "CategoryItem_Clicked")
	end

	local icon = button:GetPixieInfo(1)
	icon.strSprite = self.db.profile.categories[category].icon or self.db.profile.categories.default.icon
	icon.cr = self.db.profile.categories[category].iconColor or self.db.profile.categories.default.iconColor
	button:UpdatePixie(1, icon)

	local text= button:GetPixieInfo(2)
	text.strText = header
	text.flagsText = { DT_VCENTER = true }
	button:UpdatePixie(2, text)

	return item
end

function Perspective:CategoryItem_Clicked(handler, control, button)
	-- Show the category editor.
	self:CategoryEditor_Show(control:GetData())
end

function Perspective:CategoryEditor_Show(category)

	local function loadCheck(name, category, option)
		-- Get the control by name
		local control = self.CategoryEditor:FindChild(name .. "Check")

		-- Set the check value.
		control:SetCheck(self:GetOptionValue(nil, option, category))

		-- Make sure we haven't already set the event handlers
		if not control:GetData() then
			--Setup the event handlers
			control:AddEventHandler("ButtonCheck", 		"CategoryEditor_OnChecked")
			control:AddEventHandler("ButtonUncheck", 	"CategoryEditor_OnChecked")	
		end

		-- Set the data for the control.
		control:SetData({ category = category, option = option })
	end

	local function loadText(name, category, option, isNumber)
		-- Get the control by name
		local control = self.CategoryEditor:FindChild(name .. "Text")

		-- Set the text value.
		control:SetText(self:GetOptionValue(nil,  option, category) or "")

		-- Make sure we haven't already set the event handlers
		if not control:GetData() then
			--Setup the event handlers
			control:AddEventHandler("EditBoxReturn", 	"CategoryEditor_OnReturn")
			control:AddEventHandler("EditBoxTab", 		"CategoryEditor_OnReturn")
			control:AddEventHandler("EditBoxEscape", 	"CategoryEditor_OnEscape")
		end
		
		-- Set the data for the control.
		control:SetData({ category = category, option = option, isNumber = isNumber })
	end

	local function loadDropDown(name, category, option)
		-- Get the control by name
		local control = self.CategoryEditor:FindChild(name .. "DropDownButton")

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

	local function loadColor(name, category, option)
		-- Get the control by name
		local control = self.CategoryEditor:FindChild(name .. "Button")

		-- Get the color for the control
		local color =  self:GetOptionValue(nil, option, category)

		-- Set the color for the control
		control:SetBGColor(color)
			
		-- Makre sure we haven't already set the event handlers
		if not control:GetData() then
			control:AddEventHandler("ButtonSignal", "CategoryEditor_OnColorClick")
		end

		-- Set the data for the control.
		control:SetData({ category = category, option = option, color = color })
	end

	local header = 	self:GetOptionValue(nil, "header", 		category)
	local icon = 	self:GetOptionValue(nil, "icon", 		category)
	local color = 	self:GetOptionValue(nil, "iconColor", 	category)

	self.CategoryEditor:FindChild("Category"):SetText(header)
	self.CategoryEditor:FindChild("Icon"):SetSprite(icon)
	self.CategoryEditor:FindChild("Icon"):SetBGColor(color)

	local whitelist = self:GetOptionValue(nil, "whitelist", category)
	
	-- Set the rename text
	self.CategoryEditor:FindChild("RenameText"):SetText(category)
	
	-- Show the rename edit box if this is a whitelist item
	self.CategoryEditor:FindChild("RenameTextBG"):Show(whitelist, true)
	
	-- Show the category name if this is not a whitelist item
	self.CategoryEditor:FindChild("Category"):Show(not whitelist, true)

	loadCheck("Disable", 			category, "disabled")
	loadCheck("CombatDisable", 		category, "disableInCombat")
	loadCheck("ShowIcon", 			category, "showIcon")
	loadCheck("ShowName", 			category, "showName")
	loadCheck("ShowDistance", 		category, "showDistance")
	loadCheck("ShowLines", 			category, "showLines")
	loadCheck("ShowOutline", 		category, "showLineOutline")
	loadCheck("ShowOffScreenLine", 	category, "showLinesOffscreen")
	loadCheck("RangeFont", 			category, "rangeFont")
	loadCheck("RangeIcon", 			category, "rangeIcon")
	loadCheck("RangeLine", 			category, "rangeLine")

	loadText("Font", 				category, "font", 			false)
	loadText("Icon", 				category, "icon", 			false)
	loadText("IconHeight",			category, "iconHeight", 	true)
	loadText("IconWidth", 			category, "iconWidth", 		true)
	loadText("MaxIcons", 			category, "max", 			true)
	loadText("MaxLines", 			category, "maxLines", 		true)
	loadText("LineWidth", 			category, "lineWidth", 		true)
	loadText("ZDistance",			category, "zDistance", 		true)
	loadText("MinDistance",			category, "minDistance", 	true)
	loadText("MaxDistance",			category, "maxDistance", 	true)
	loadText("Display", 			category, "display", 		false)
	loadText("RangeLimit",			category, "rangeLimit",		true)

	loadColor("FontColor",			category, "fontColor")
	loadColor("IconColor", 			category, "iconColor")
	loadColor("LineColor", 			category, "lineColor")
	loadColor("RangeColor", 		category, "rangeColor")

	loadDropDown("LimitBy",			category, "limitBy")

	self.CategoryList:Show(false, true)
	self.CategoryEditor:Show(true, true)
end

function Perspective:CategoryEditor_OnBackClick(handler, control, button)
	self.CategoryEditor:Show(false, true)
	self.CategoryList:Show(true, true)
end

function Perspective:CategoryEditor_OnChecked(handler, control, button)
	-- Get the control's data
	local data = control:GetData()
	
	-- Get the control's value
	local val = control:IsChecked()

	-- Check to see if we need to set the value for all categories
	if data.category == "all" then
		for k, v in pairs(self.db.profile.categories) do
			self.db.profile.categories[k][data.option] = val
		end
	else
		self.db.profile.categories[data.category][data.option] = val	
	end

	-- Update all the ui options.
	self:UpdateOptions()
end

function Perspective:CategoryEditor_OnReturn(handler, control)
	-- Get the control's data
	local data = control:GetData()

	-- Get the control's value
	local val = control:GetText()

	-- Check to see if the textbox is expecting a number
	if data.isNumber then
		if not tonumber(val) then
			val = self:GetOptionValue(nil, data.option, data.category)
		else
			val = tonumber(val)
		end
	end

	-- If the option is blank, load the default setting.
	if val == "" then 
		val = self:GetOptionValue(nil, data.option, data.category)
	end

	-- Check to see if we need to set the value for all categories
	if data.category == "all" then
		for k, v in pairs(self.db.profile.categories) do
			self.db.profile.categories[k][data.option] = val
		end
	else
		self.db.profile.categories[data.category][data.option] = val	
	end

	-- Update the category list icons.
	if data.option == "icon" then
		self:CategoryEditor_UpdateIcon(data.category, "icon")
	end

	-- Update all the ui options.
	self:UpdateOptions()
end

function Perspective:CategoryItem_OnEscape(handler, control)
	-- Get the control's data
	local data = control:GetData()
	
	-- Load the previous value
	control:SetText(self:GetOptionValue(nil, data.option, data.category))
end

function Perspective:CategoryEditor_OnDropDown(handler, control, button)
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

function Perspective:CategoryEditor_OnDropDownItem(handler, control, button)
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
		for k, v in pairs(self.db.profile.categories) do
			self.db.profile.categories[k][data.option] = val
		end
	else
		self.db.profile.categories[data.category][data.option] = val
	end

	-- Update all the ui options.
	self:UpdateOptions()
end

function Perspective:CategoryEditor_OnColorClick(handler, control, button)

	local function setColor(data)
		-- Convert the color back to str
		local color = self:CColorToString(self.color)
		
		-- Set the control color
		control:SetBGColor(self.color)

		-- Update the settings
		if data.category == "all" then
			for _, category in pairs(self.db.profile.categories) do
				category[data.option] = color
			end
		else
			self.db.profile.categories[data.category][data.option] = color
		end

		-- Update the category list icons.
		if data.option == "iconColor" then
			self:CategoryEditor_UpdateIcon(data.category, "iconColor")
		end

		-- Update all the ui options.
		self:UpdateOptions() 
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

function Perspective:CategoryEditor_UpdateIcon(category, type)
	local function setPixie(category, icon, color)
		-- Exclude the default category, we dont have a button for it.
		if category ~= "default" then
			-- Get our category item button
			local button  = self.CategoryList:FindChild("CategoryItem_" .. category):FindChild("Button")

			-- Update our icon pixie
			local pixie = button:GetPixieInfo(1)
			pixie.strSprite = icon
			pixie.cr = color
			button:UpdatePixie(1, pixie)
		end
	end

	-- Get the icon and icon color.
	local icon = self:GetOptionValue(nil, "icon", category)
	local iconColor = self:GetOptionValue(nil, "iconColor", category)

	-- Update the category editor icon.
	self.CategoryEditor:FindChild("Icon"):SetBGColor(iconColor)
	self.CategoryEditor:FindChild("Icon"):SetSprite(icon)

	-- Update our icon pixies
	if category == "all" then
		for cat, settings in pairs(self.db.profile.categories) do
			-- Get the icon and icon color.
			local i = self:GetOptionValue(nil, "icon", cat)
			local ic = self:GetOptionValue(nil, "iconColor", cat)

			if type == "iconColor" then
				setPixie(cat, i, iconColor)
			elseif type == "icon" then
				setPixie(cat, icon, ic)
			end
		end
	else
		if type == "iconColor" then
			setPixie(category, icon, iconColor)
		elseif type == "icon" then
			setPixie(category, icon, iconColor)
		end
	end

end





















function Perspective:InitializeWindow_NewCategory()
	-- Setup the event handlers for the newcategory window
	local ok = self.NewCategory:FindChild("OKButton")
	local cancel = self.NewCategory:FindChild("CancelButton")

	ok:AddEventHandler("ButtonSignal", 			"OnNewCategory_OKClicked")
	cancel:AddEventHandler("ButtonSignal",		"OnNewCategory_CancelClicked")
end

function Perspective:SettingsTimer_Init(control, value, numDecimal, unit, divBy, tickFunc)
	local slider = self.Options:FindChild(control .. "Slider")
	local text = self.Options:FindChild(control .. "Text")

	local val = round(self.db.profile.settings[value], numDecimal)

	-- Associate the text control with the slider.
	slider:SetData({ 
		text = text, 
		value = value, 
		numDecimal = numDecimal, 
		unit = unit,
		divBy = divBy,
		tickFunc = tickFunc 
	})

	-- Set the slider value.
	slider:SetValue(val)

	-- Set the text value.
	text:SetText(val .. " " .. unit)

	-- Set the event handler
	slider:AddEventHandler("SliderBarChanged", "SettingsTimer_OnChanged")
end

function Perspective:CategoryItems_Arrange()
	local sort = function (a, b) 
		a = self:GetOptionValue(nil, "header", a:GetData())
		b = self:GetOptionValue(nil, "header", b:GetData())

		a = a == "Set All" and " " or a
		b = b == "Set All" and " " or b

		return a < b
	end

	self.CategoryList:ArrangeChildrenVert(0, sort)
end

function Perspective:CategoryItem_Toggle(item)
	local data = item:GetData()

	if data.expanded then
		item:SetAnchorOffsets(0, 5, 0, 365)
		item:FindChild("Content"):Show(true, true)
	else
		item:SetAnchorOffsets(0, 5, 0, 53)
		item:FindChild("Content"):Show(false, true)
	end

	self:CategoryItems_Arrange()
end

---------------------------------------------------------------------------------------------------
-- Options Events
---------------------------------------------------------------------------------------------------

function Perspective:OnOptions_AnchorsChanged()
	local l, t, r, b = self.Options:GetAnchorOffsets()

	self.db.profile.position = {
		left = l,
		top = t,
		right = r,
		bottom = b
	}
end

function Perspective:OnOptions_NewClicked(handler, control, button)
	self.NewCategory:FindChild("NameText"):SetText("")
	self.NewCategory:FindChild("DisplayText"):SetText("")
	self.NewCategory:Show(true, true)
end

function Perspective:OnOptions_DefaultClicked(handler, control, button)
	self.db:ResetDB()

	self:InitializeOptions()

	self:UpdateOptions()
end

function Perspective:OnOptions_HeaderButtonChecked(handler, control, button)
	local panels = {
		"Categories",
		"Markers",
		"Blacklist",
		"Settings"
	}

	for k, v in pairs(panels) do
		if v .. "Button" == control:GetName() then
			self.Options:FindChild(v):Show(true, true)
		else
			self.Options:FindChild(v):Show(false, true)
		end
	end
end

---------------------------------------------------------------------------------------------------
-- NewCategory Events
---------------------------------------------------------------------------------------------------

function Perspective:OnNewCategory_OKClicked(handler, control, button)
	local name = self.NewCategory:FindChild("NameText"):GetText()
	local display = self.NewCategory:FindChild("DisplayText"):GetText()

	if display == "" then
		display = nil
	end

	self.db.profile.categories[name] = self.db.profile.categories[name] or {
		header = "Unit Name - " .. name,
		whitelist = true,
		display = display
	}

	self:CategoryItem_Init(name, "Unit Name - " .. name, true)

	self:CategoryItems_Arrange()

	self.NewCategory:Show(false, true)
end

function Perspective:OnNewCategory_CancelClicked(handler, control, button)
	self.NewCategory:Show(false, true)
end

---------------------------------------------------------------------------------------------------
-- CategoryItem Events
---------------------------------------------------------------------------------------------------

function Perspective:OnCategoryItem_HeaderClicked(handler, control, button)
	local parent = control:GetParent():GetParent()

	local data = parent:GetData()

	data.expanded = not data.expanded

	parent:SetData(data)

	self:CategoryItem_Toggle(parent)

	-- Update the checkbox
	parent:FindChild("HeaderCheck"):SetCheck(data.expanded)
end

function Perspective:OnCategoryItem_HeaderChecked(handler, control, button)
	local parent = control:GetParent():GetParent()

	local data = parent:GetData()

	data.expanded = not data.expanded

	parent:SetData(data)

	self:CategoryItem_Toggle(parent)
end

function Perspective:OnCategoryItem_DeleteClicked(handler, control, button)

	local item = control:GetData().item
	local args = item:GetData()

	self.db.profile.categories[args.category] = nil

	item:Destroy()

	self:CategoryItems_Arrange()

end

function Perspective:OnCategoryItem_DefaultClicked(handler, control, button)

	local item = control:GetData().item
	local args = item:GetData()

	if self.db.defaults.profile.categories[args.category] then
		self.db.profile.categories[args.category] = self.db.defaults.profile.categories[args.category]
	else
		self.db.profile.categories[args.category] = self.db.defaults.profile.categories.default
	end

	if args.whitelist then
		self.db.profile.categories[args.category].header = "Unit - " .. args.category
		self.db.profile.categories[args.category].whitelist = true
	end

	self:CategoryItem_Init(args.category, header, whitelist, item)

	self:UpdateOptions()

end

function Perspective:OnCategoryItem_DropDownButtonClicked(handler, control, button)
	local args = control:GetData()

	for k, v in pairs(args.menu:GetChildren()) do
		if v:GetText() == control:GetText() then
			v:SetCheck(true)
		else
			v:SetCheck(false)
		end
	end

	args.menu:Show(true, true)
	self.Options:BringChildToTop(args.menu)
end

function Perspective:OnCategoryItem_DropDownItemButtonChecked(handler, control, button)
	-- Get the args for the dropdownmenu
	local args = control:GetParent():GetData()

	-- Get the button that called the menu
	local button = args.button

	-- Get the args for the button
	args = button:GetData()

	-- Get the text of the selected dropdownmenu button
	local val = control:GetText()

	-- Update the button text for the caller button
	button:SetText(val)

	-- Hide the dropdownmenu immediately
	control:GetParent():Show(false, true)

	-- Update the settings.
	if args.category == "all" then
		for k, v in pairs(self.db.profile.categories) do
			self.db.profile.categories[k][args.value] = val
		end

		self:InitializeOptions()
	else
		self.db.profile.categories[args.category][args.value] = val
	end

	-- Update all the ui options.
	self:UpdateOptions()
end


function Perspective:CategoryItem_OnReturn(handler, control)
	local args = control:GetData()

	local val = control:GetText()

	if args.number then
		if not tonumber(val) then
			val = self:GetOptionValue(nil, args.value, args.category)
		else
			val = tonumber(val)
		end
	else
		if args.value == "limitBy" then
			val = string.lower(val)
			if val ~= "nil" and
				val ~= "quest" and
				val ~= "challenge" and
				val ~= "category" then
				val = self:GetOptionValue(nil, args.value, args.category)
			end
		end
	end

	control:SetText(val)

	if val == "nil" then 
		val = nil 
	end

	self.db.profile.categories[args.category][args.value] = val	

	if args.category == "all" then
		for k, v in pairs(self.db.profile.categories) do
			self.db.profile.categories[k][args.value] = val
		end

		self:InitializeOptions()
	elseif args.value == "icon" then
		args.item:FindChild("HeaderIcon"):SetSprite(val)	
	end

	self:UpdateOptions()
end

function Perspective:CategoryItem_OnEscape(handler, control)
	local args = control:GetData()
	
	local val = self:GetOptionValue(nil, args.value, args.category)

	control:SetText(val)
end

function Perspective:CategoryItem_OnColorClick(handler, control, button)
	local data = control:GetData()

  	--GeminiColor:ShowColorPicker(self, "CategoryItem_OnColorSet", true, args.color, control)
  	ColorPicker.AdjustCColor(data.color, false, setColor, data)
end

function Perspective:CategoryItem_OnColorSet(color, ...)
	local control = arg[1]
	local args = control:GetData()

	control:SetBGColor(color)
	self.db.profile.categories[args.category][args.value] = color

	if args.category == "all" then
		for k, v in pairs(self.db.profile.categories) do
			v[args.value] = color
		end

		self:InitializeOptions()
	elseif args.value == "iconColor" then
		args.item:FindChild("HeaderIcon"):SetBGColor(color)
	end
		
	self:UpdateOptions()
end

---------------------------------------------------------------------------------------------------
-- Settings Events
---------------------------------------------------------------------------------------------------

function Perspective:SettingsTimer_OnChanged(handler, control, button)
	local args = control:GetData()

	local val = round(control:GetValue(), args.numDecimal)

	args.text:SetText(val .. " " .. args.unit)

	self.db.profile.settings[args.value] = val

	self[args.value]:Set(val / args.divBy, true, args.tickFunc, self)
end







function round(num, idp)

	if idp and idp > 0 then

		local mult = 10 ^ idp

		return math.floor(num * mult + 0.5) / mult

	end

	return math.floor(num + 0.5)

end