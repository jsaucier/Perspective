require "Window"
require "GameLib"
require "Apollo"

local Perspective = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:NewAddon("Perspective", true)

local defaults = {
	profile = {
		settings = { 
			max = 10,
			redrawTime = 0.01,
			updateTime = 1.00,
		},
		categories = {
			default = {
				order = 0,
				disabled = false,
				disableInCombat = false,
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
				maxDistance = 99999,
				showDistance = true,
				showIcon = true,
				showName = true,
				showLineOutline = true,
				showLines = true,
				showLinesOffscreen = true,
			},
			all = {
				header = "Set All"
			},
			group = {
				header = "Group",
				fontColor = "ff97a9ff",
				lineColor = "ff97a9ff",
				icon = "IconSprites:Icon_Windows32_UI_CRB_InterfaceMenu_Character",
				showLines = false,
				maxLines = 4,
				maxIcons = 4,
			},
			guild = {
				header = "Guild",
				fontColor = "ff00ff00",
				lineColor = "ff00ff00",
				icon = "IconSprites:Icon_Windows32_UI_CRB_InterfaceMenu_GroupFinder",
				showLines = false,
			},
			hostile = {
				header = "Hostile NPCs",
				fontColor = "ffff0000",
				lineColor = "ffff0000",
				iconColor = "ffff0000",
				icon = "PerspectiveSprites:Circle",
				showLines = false,
				showName = false,
				showDistance = false,
				max = 10,
				iconHeight = 8,
				iconWidth = 8
			},	
			questObjective = {
				header = "Quest - Objective",
				icon = "PerspectiveSprites:QuestObjective",
				max = 3,
				limitBy = "quest",
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
				lineColor = "ffff8000",
			},
			questReward = {
				header = "Quest - Complete",
				icon = "IconSprites:Icon_MapNode_Map_Checkmark",
				lineColor = "ff00ff00",
			},			
			challenge = {
				header = "Challenge Objective",
				icon = "PerspectiveSprites:ChallengeObjective",
				lineColor = "ffff0000",
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
				fontColor = "ff00ffff",
				icon = "IconSprites:Icon_MapNode_Map_Taxi",
				showLines = false,
			},
			instancePortal = {
				header = "Instance Portal",
				fontColor = "ff00ffff",
				icon = "IconSprites:Icon_MapNode_Map_Portal",
				showLines = false,
			},
			bindPoint = {
				header = "Bind Point",
				fontColor = "ff00ffff",
				icon = "IconSprites:Icon_MapNode_Map_Gate",
				showLines = false,
			},
			marketplace = {
				header = "Town - Commodities Exchange",
				fontColor = "ff00ffff",
				icon = "IconSprites:Icon_MapNode_Map_CommoditiesExchange",
				showLines = false,
			},
			auctionHouse = {
				header = "Town - Auction House",
				fontColor = "ff00ffff",
				icon = "IconSprites:Icon_MapNode_Map_AuctionHouse",
				showLines = false,
			},
			mailBox = {
				header = "Town - Mailbox",
				fontColor = "ff00ffff",
				icon = "IconSprites:Icon_MapNode_Map_Mailbox",
				showLines = false,
			},
			vendor = {
				header = "Town - Vendor",
				fontColor = "ff00ffff",
				icon = "IconSprites:Icon_MapNode_Map_Vendor",
				showLines = false,
			},
			craftingStation = {
				header = "Town - Crafting Station",
				fontColor = "ff00ffff",
				icon = "IconSprites:Icon_MapNode_Map_Tradeskill",
				showLines = false,
			},
			tradeskillTrainer = {
				header = "Town - Tradeskill Trainer",
				fontColor = "ff00ffff",
				icon = "IconSprites:Icon_MapNode_Map_Trainer",
				showLines = false,
			},
			dye = {
				header = "Town - Appearance Modifier",
				fontColor = "ff00ffff",
				icon = "IconSprites:Icon_MapNode_Map_DyeSpecialist",
				showLines = false,
			},
			bank = {
				header = "Town - Bank",
				fontColor = "ff00ffff",
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
				header = "Path - Scientist Mission Scans",
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
			["Bruxen"] = {
				header = "Crimson Badlands - Thayd Portal",
				display = "Ship to Thayd",
				fontColor = "ff00ffff",
				icon = "IconSprites:Icon_MapNode_Map_Portal",
				showLines = false,
			},
			["Gus Oakby"] = {
				header = "Thayd - Crimson Badlands Portal",
				display = "Ship to Crimson Badlands",
				fontColor = "ff00ffff",
				icon = "IconSprites:Icon_MapNode_Map_Portal",
				showLines = false,
			},
			["Lilly Startaker"] = {
				header = "Thayd - Grimvault Portal",
				display = "Ship to Grimvault",
				fontColor = "ff00ffff",
				icon = "IconSprites:Icon_MapNode_Map_Portal",
				showLines = false,
			},
			["Transportation Expert Conner"] = {
				header = "Thayd - Farside Portal",
				display = "Ship to Farside",
				fontColor = "ff00ffff",
				icon = "IconSprites:Icon_MapNode_Map_Portal",
				showLines = false,
			},
			["Warrant Officer Burke"] = {
				header = "Thayd - Whitevale Portal",
				display = "Ship to Whitevale",
				fontColor = "ff00ffff",
				icon = "IconSprites:Icon_MapNode_Map_Portal",
				showLines = false,
			}
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
				maxPer = 10,
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

g_blah = nil

function Perspective:OnInitialize()
	Apollo.LoadSprites("PerspectiveSprites.xml")

	self.db = Apollo.GetPackage("Gemini:DB-1.0").tPackage:New(self, defaults)
	
	self.xmlDoc = XmlDoc.CreateFromFile("Perspective.xml")

    self.Options = Apollo.LoadForm(self.xmlDoc, "Options", nil, self)
    self.Categories = self.Options:FindChild("Categories")

    self.NewCategory = Apollo.LoadForm(self.xmlDoc, "NewCategory", self.Options, self)

	self.Overlay = Apollo.LoadForm(self.xmlDoc, "Overlay", "InWorldHudStratum", self)
	self.Overlay:Show(true)
					
	-- Register the slash command	
	Apollo.RegisterSlashCommand("perspective", "OnShowOptions", self)

	GeminiColor = Apollo.GetPackage("GeminiColor").tPackage
	
	-- Table containing every unit we currently are aware of
	self.units = {}
	-- Track our categorized units
	self.categorized = {}
	
	self.challenges = {}

	-- Path marker windows
	self.markers = {}
	self.markersInitialized = false
	
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

	self:UpdatePlayerPosition()
	
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
	--Apollo.RegisterEventHandler("ChallengeUpdated", 				"OnChallengeUpdated", self)

	Apollo.RegisterEventHandler("PlayerPathMissionActivate", 		"OnPlayerPathMissionActivate", self)
	Apollo.RegisterEventHandler("PlayerPathMissionAdvanced", 		"OnPlayerPathMissionAdvanced", self)
	Apollo.RegisterEventHandler("PlayerPathMissionComplete", 		"OnPlayerPathMissionComplete", self)
	Apollo.RegisterEventHandler("PlayerPathMissionDeactivate", 		"OnPlayerPathMissionDeactivate", self)
	Apollo.RegisterEventHandler("PlayerPathMissionUnlocked", 		"OnPlayerPathMissionUnlocked", self)
	Apollo.RegisterEventHandler("PlayerPathMissionUpdate", 			"OnPlayerPathMissionUpdate", self)
	
	Apollo.RegisterEventHandler("InterfaceMenuListHasLoaded", 		"OnInterfaceMenuListHasLoaded", self)
	Apollo.RegisterEventHandler("InterfaceMenuClicked", 			"OnInterfaceMenuClicked", self)
end

function Perspective:OnConfigure()
end

function Perspective:OnRestore(type, savedData)
end

function Perspective:OnSave(type)
end

function Perspective:OnEnable()


	redrawTimer = ApolloTimer.Create(self.db.profile.settings.redrawTime, true, "OnRedrawTimerTicked", self)
	updateTimer = ApolloTimer.Create(self.db.profile.settings.updateTime, true, "OnUpdateTimerTicked", self)

	if Apollo.GetAddon("Rover") then
		SendVarToRover("Perspective", self)
	end


	self:InitializeOptions()
end

function Perspective:UpdatePlayerPosition()
	-- Get the player postion
	self.player = GameLib:GetPlayerUnit()

	if self.player then
		self.position = self.player:GetPosition()

		if self.position then
			-- Vector of the player's position
			self.vector = Vector3.New(self.position.x, self.position.y, self.position.z)
		else
			return false
		end
	else
		return false
	end

	return true
end

function Perspective:OnRedrawTimerTicked()
	self.Overlay:DestroyAllPixies()
	
	local pPos = GameLib.GetUnitScreenPosition(GameLib:GetPlayerUnit())

	if not pPos then return	end

	local items = {	unit = {}, category = {}, quest = {}, challenge = {} }
	local lines = {	unit = {}, category = {}, quest = {}, challenge = {} }

	-- Pixes to draw in reverse so closest are on top
	local pixies = {}

	for index, ui in pairs(self.categorized) do
		if GameLib.GetUnitById(ui.id) and 
			not ui.disabled and 
			table.getn(pixies) < self.db.profile.settings.max then

			-- Update the units position
			local uPos = GameLib.GetUnitScreenPosition(ui.unit)
		
			if uPos then
				local showItem = true
				local showLine = true

				if not ui.inRange or (GameLib:GetPlayerUnit():IsInCombat() and ui.disableInCombat) then
					showItem = false
					showLine = false
				else
					if not ui.showLines or (not uPos.bOnScreen and not ui.showLinesOffscreen) then
						showLine = false
					end
					if not ui.canShow or not uPos.bOnScreen then
						showItem = false
					end
				end

				if ui.limitBy and (showItem or showLine) then
					for i, id in pairs(ui.limitId) do
						items[ui.limitBy][id] = items[ui.limitBy][id] or 0
						lines[ui.limitBy][id] = lines[ui.limitBy][id] or 0

						if (items[ui.limitBy][id] or 0) >= ui.max then
							showItem = false
						end

						if (lines[ui.limitBy][id] or 0) >= ui.maxLines then
							showLine = false
						end
					end
				end

				if showItem or showLine then
					table.insert(pixies, { ui = ui, uPos = uPos, pPos = pPos, showItem = showItem, showLine = showLine })
					
					if ui.limitBy then
						for i, id in pairs(ui.limitId) do
							if showItem then
								items[ui.limitBy][id] = (items[ui.limitBy][id] or 0) + 1
							end

							if showLine then
								lines[ui.limitBy][id] = (lines[ui.limitBy][id] or 0) + 1
							end
						end
					end
				end
			end
		end
	end


	for id, marker in pairs(self.markers) do
		local marks = 0
		local icon = self.db.profile.markers.quest.icon

		if marker.type == "path" then
			icon = self.db.profile.markers.path[self.path .. "Icon"]
		end

		for index, region in pairs(marker.regions) do
			-- Get the screen position of the unit by it's vector
			local uPos = GameLib.WorldLocToScreenPoint(region.vector)

			-- Make sure the point is onscreen and in front of us.
			if marks < self.db.profile.markers[marker.type].maxPer and
				uPos.z > 0 and
				not region.inArea then
				self.Overlay:AddPixie({
					strSprite = icon,
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
					strText = marker.name .. " (" .. region.distance .. "m)",
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

	for i = #pixies, 1, -1 do
		pixie = pixies[i]
		self:DrawPixie(pixie.ui, pixie.uPos, pixie.pPos, pixie.showItem, pixie.showLine)
	end


end

function Perspective:OnUpdateTimerTicked()

	-- Get the player postion
	local updated = self:UpdatePlayerPosition()

	if updated then
		-- Empty our categorized units
		self.categorized = {} 
		
		-- Units we are not interested in keeping track of
		local remove = {}

		-- Update all the known units
		for index, ui in pairs(self.units) do
			if GameLib.GetUnitById(ui.id) then
				local keep = self:UpdateUnit(ui, index)

				if not keep then
					-- this seems to keep  losing units
					--table.insert(remove, index)
				elseif ui.category then
					table.insert(self.categorized, ui)
				end
			else
				table.insert(remove, index)		
			end
		end
		
		if self.markersInitialized then
			self:MarkersUpdate()
		else
			self:MarkersInit()
		end
		
		table.sort(self.categorized, function(a, b) return a.distance < b.distance end)

		for k, v in pairs(remove) do
			table.remove(self.units, v)
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
	
	-- Set the markers as having been initialized
	self.markersInitialized = true
end

function Perspective:MarkersUpdate()
	local _, __
	
	-- Update all the episode markers
	for _, marker in pairs(self.markers) do
		self:MarkerUpdate(marker)
	end
end

function Perspective:MarkerPathUpdate(mission)
	local id = "path" .. mission:GetId()

	if mission:IsStarted() and not mission:IsComplete() then
		if table.getn(mission:GetMapRegions()) > 0 then
			self.markers[id] = {
				name = mission:GetName(),
				type = "path",
				regions = {},
				mission = mission
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
		  		regions = {}
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

function Perspective:MarkerUpdate(marker)
	local updated = self:UpdatePlayerPosition()

	if updated then
		local inArea = false

		if marker.type == "path" and marker.mission:IsInArea() then
			inArea = true
		end

		for index, region in pairs(marker.regions) do
			-- Get the distance to the marker
			region.distance = math.ceil((self.vector - region.vector):Length())
				
			-- Determine if the player is in the region
			if marker.type == "quest" then
				-- No direct call that I can find to determine if the player is
				-- in the area, so make it anywhere closer than 100m
				region.inArea = (region.distance <= self.db.profile.markers.quest.inAreaRange)
			elseif marker.type == "path" then
				region.inArea = inArea
			end
		end

		table.sort(marker.regions, function(a, b) return a.distance < b.distance end)
	end
end

function Perspective:UpdateOptions(ui)
	local function updateOptions(ui)
		for k, v in pairs(self.db.defaults.profile.categories.default) do
			ui[k] = self:GetOptionValue(ui, k)
		end

		if ui.showName or ui.showDistance or ui.showIcon then
			ui.canShow = true
		end

		ui.display = self:GetOptionValue(ui, "display")
		
		ui.loaded = true
	end
	
	if ui then
		-- Update only the specific unit information
		updateOptions(ui)
	else	
		-- Update all the unit informations
		for i, ui in pairs(self.units) do
			updateOptions(ui)
		end
	end
end

function Perspective:UpdateUnit(ui,index)
	-- Get the unit's position
	local pos = ui.unit:GetPosition()
	local name = ui.unit:GetName()

	if  pos and 						-- make sure we know the units position
		--name ~= "" and 				-- we want to make sure the unit has a name
		not ui.disabled then			-- check to make sure the unit isnt disabled

		local category = ui.category

		ui.category = nil				-- reset the category as it might have changed

		local state = {}

		-- Determine if this is a hostile mob
		if ui.unit:GetDispositionTo(GameLib:GetPlayerUnit())  == 0  and
			not self.db.profile.categories.hostile.disabled then
			ui.category = "hostile"
			state.track = true
		end

		if self.db.profile.categories[name] then
			ui.category = name
			state.track = true
		end

		local track, busy = self:UpdateActivation(ui)

		state.track = state.track or track
		state.busy = state.busy or busy

		if not state.busy then
			

			--if not ui.category or ui.category == "scientist" then
				local type = ui.unit:GetType()
				local rewards = self:GetRewardInfo(ui)

				if type == "Player" then
					self:UpdatePlayer(ui)
					state.track = true
				elseif type == "NonPlayer" then
					self:UpdateNonPlayer(ui, rewards)
					state.track = true
				elseif type == "Simple" or type == "SimpleCollidable" then
					self:UpdateSimple(ui, rewards)
					state.track = true
				elseif type == "Collectible" then
					self:UpdateCollectible(ui,rewards)
					state.track = true
				elseif type == "Harvest" then
					self:UpdateHarvest(ui)
					state.track = true
				else
					state.track = state.track
				end
			--end
		end

		if not state.track then
			return false
		end

		if ui.category then
			if not ui.loaded or ui.category ~= category then
				self:UpdateOptions(ui)
			end

			if ui.limitBy then	
				if 	   ui.limitBy == "name"			then ui.limitId = { ui.unit:GetName() }
				elseif ui.limitBy == "category" 	then ui.limitId = { ui.category }
				elseif ui.limitBy == "quest" 		then ui.limitId = ui.quest
				elseif ui.limitBy == "challenge"	then ui.limitId = ui.challenge
				end
			end

			-- Get the vector for the unit
			ui.vector = Vector3.New(pos.x, pos.y, pos.z)
			-- Get the distance from the player
			ui.distance = (self.vector - ui.vector):Length()
			-- Get the scale size based on distance
			ui.scale = math.min(1 / (ui.distance / 100), 1)
			-- Determine if the unit is in range of display		
			ui.inRange = (ui.distance > ui.minDistance and 
						  ui.distance < ui.maxDistance)
						  
			ui.scaledWidth = ui.iconWidth * math.max(ui.scale, .5)
			ui.scaledHeight = ui.iconHeight * math.max(ui.scale, .5)
		else 
			ui = { id = ui.id, unit = ui.unit }
		end
	else
		ui = { id = ui.id, unit = ui.unit }
	end

	return true
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
	Event_FireGenericEvent("InterfaceMenuList_NewAddOn", "Perspective", {"InterfaceMenuClicked", "", ""})
end

function Perspective:OnInterfaceMenuClicked()
	self.Options:Show(not self.Options:IsShown())
end

function Perspective:DrawPixie(ui, uPos, pPos, showItem, showLine)
	if showLine then
		local pos = ui.unit:GetPosition()
		local vec = Vector3.New(pos.x, pos.y, pos.z)
		-- Get the screen position of the unit by it's vector
		uLinePos = GameLib.WorldLocToScreenPoint(vec)

		-- Background line to give the outline
		if ui.showLineOutline then
			self.Overlay:AddPixie({
				strText = nil,
				strFont = nil,
				bLine = true,
				fWidth = ui.lineWidth + 2,
				cr = "ff000000",
				loc = {
					fPoints = {0,0,0,0},
					nOffsets = {
						uLinePos.x, 
						uLinePos.y, 
						pPos.nX, 
						pPos.nY
					}
				}
			})
		end

		self.Overlay:AddPixie({
			bLine = true,
			fWidth = ui.lineWidth + 0,
			cr = ui.lineColor,
			loc = {
				fPoints = {0,0,0,0},
				nOffsets = {
					uLinePos.x, 
					uLinePos.y, 
					pPos.nX, 
					pPos.nY
				}
			}
		})
	end

	if showItem then
		if ui.showIcon then
			self.Overlay:AddPixie({
				strText = nil,
				strFont = nil,
				bLine = false,
				strSprite = ui.icon,
				cr = ui.iconColor,
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
		
		if ui.showName or ui.showDistance then
			local text

			if ui.showName then
				text = ui.display or ui.unit:GetName()
			end

			text = (ui.showDistance and ui.distance >= 10) and text .. " (" .. math.ceil(ui.distance) .. "m)" or text
			
			self.Overlay:AddPixie({
				strText = text, --ui.unit:GetName(),
				strFont = ui.font,
				bLine = false,
				crText = ui.fontColor,
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

function Perspective:GetUnitInfo(unit)
	for i, v in pairs(self.units) do
		if v.id == unit:GetId() then
			return v
		end
	end
	
	return nil
end

---------------------------------------------------------------------------------------------------
-- Addon Event Functions
---------------------------------------------------------------------------------------------------

function Perspective:OnUnitCreated(unit)
	if not self:GetUnitInfo(unit) then
		local ui = { 
			id = unit:GetId(),
			unit = unit,
		}

		table.insert(self.units, ui)
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

function Perspective:OnWorldChanged()
	self:MarkersInit()
end

function Perspective:OnQuestInit()
	self:MarkersInit()
end

function Perspective:OnQuestTrackedChanged(quest)
	self:MarkerQuestUpdate(quest)
end

function Perspective:OnQuestObjectiveUpdated(quest)
	self:MarkerQuestUpdate(quest)
end

function Perspective:OnQuestStateChanged(quest)
	self:MarkerQuestUpdate(quest)
end

function Perspective:OnPlayerPathMissionActivate(mission)
	self:MarkerPathUpdate(mission)
end

function Perspective:OnPlayerPathMissionAdvanced(mission)
	self:MarkerPathUpdate(mission)
end

function Perspective:OnPlayerPathMissionComplete(mission)
	self:MarkerPathUpdate(mission)
end

function Perspective:OnPlayerPathMissionDeactivate(mission)
	self:MarkerPathUpdate(mission)
end

function Perspective:OnPlayerPathMissionUnlocked(mission)
	self:MarkerPathUpdate(mission)
end

function Perspective:OnPlayerPathMissionUpdate(mission)
	self:MarkerPathUpdate(mission)
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




function Perspective:UpdatePlayer(ui)
	local player = GameLib:GetPlayerUnit()
	
	-- We don't care about ourselves
	if ui.unit:IsThePlayer() then return end
	
	-- Check to see if the unit is in our group
	if 	ui.unit:IsInYourGroup() and 
		not self.db.profile.categories.group.disabled then
		ui.category = "group"			
	-- Check to see if the unit is in our guild
	elseif 	player and player:GetGuildName() and 
			ui.unit:GetGuildName() == player:GetGuildName() and
			not self.db.profile.categories.guild.disabled then
		ui.category = "guild"
	end
end

function Perspective:UpdateNonPlayer(ui, rewards)
	if 	rewards then
		-- Quest target mob
		if 	rewards.quest and not ui.unit:IsDead() and
			not self.db.profile.categories.questObjective.disabled then
			ui.category = "questObjective"
			ui.quest = rewards.quest
		-- Challenge target mob
		elseif rewards.challenge and not ui.unit:IsDead() and
			not self.db.profile.categories.challenge.disabled then
			ui.category = "challenge"
			ui.challenge = rewards.challenge
		elseif rewards.path and 
			not self.db.profile.categories[rewards.path].disabled then
			ui.category = rewards.path
		end
	end	
end

function Perspective:UpdateSimple(ui, rewards)
	local state = ui.unit:GetActivationState()

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

function Perspective:UpdateCollectible(ui, rewards)
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

function Perspective:UpdateHarvest(ui)
	local skill = ui.unit:GetHarvestRequiredTradeskillName()
	local category
	
	if not ui.unit:IsDead() then
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

function Perspective:UpdateActivation(ui)
	local state = ui.unit:GetActivationState()

	local states = {
		QuestReward = "questReward",
		QuestNewMain = "questNew",
		QuestNew = "questNew",
		QuestNewRepeatable = "questNew",
		TalkTo = "questTalkTo",
		FlightPath = "flightPath",
		InstancePortal = "instancePortal",
		BindPoint = "bindPoint",
		CommodityMarketplace = "marketplace",
		ItemAuctionhouse = "auctionHouse",
		Mail = "mailBox",
		TradeskillTrainer = "tradeskillTrainer",
		Vendor = "vendor",
		CraftingStation = "craftingStation",
		Dye = "dye",
		Bank = "bank",
		GuildBank = "bank",
		Dungeon = "dungeon",
		Datacube = "lore",
		ExplorerInterest = "explorer",
		ExplorerActivate = "explorer",
		ExplorerDoor = "explorer",
		SettlerActivate = "settler",
		SoldierActivate = "solider",
		SoldierKill = "solider",
		ScientistScannable = "scientist",
		ScientistActivate = "scientist"
	}

	local track, busy = false, false
	
	if state.Busy and
		state.Busy.bIsActive then
		busy = true
	end

	for k, v in pairs(states) do
		if state[k] and 
			state[k].bIsActive and
			not self.db.profile.categories[v].disabled then
			ui.category = v
			if v == "lore" and 
				self.path == "scientist" and 
				string.find(ui.unit:GetName(), "DATACUBE:") then
				ui.category = "scientistScans"
			end			
			track = true
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
			track = true
		elseif state.Interact and 
			state.Interact.bUsePlayerPath and 
			state.Interact.bCanInteract and
			state.Interact.bIsActive then
			ui.category = self.path
			track = true
		end
	end

	return track, busy
	--[[elseif self.ChkTable["Event"] and GameLib.GetWorldDifficulty() > 0 then
		if (tActivation.PublicEventTarget and tActivation.PublicEventTarget.bIsActive) or
		   (tActivation.PublicEventKill and tActivation.PublicEventKill.bIsActive) or
		   (tActivation["Public Event"] and tActivation["Public Event"].bIsActive) then		
			if unit:GetDispositionTo(self.playerUnit) > 1 then
				return "QuestSimple"
			else
				return "Quest"
			end
		end]]

	--return { track = false }
end

function Perspective:GetRewardInfo(ui)
	local rewardInfo = ui.unit:GetRewardInfo()
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
	self.Options:Show(true)
end

function Perspective:OnShowOptions()
	self.Options:Show(true)
end

function Perspective:OnCloseButton()
	self.Options:Show(false)
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

		-- Setup the event handlers for the newcategory window
		local ok = self.NewCategory:FindChild("OKButton")
		local cancel = self.NewCategory:FindChild("CancelButton")

		ok:AddEventHandler("ButtonSignal", 			"OnNewCategory_OKClicked")
		cancel:AddEventHandler("ButtonSignal",		"OnNewCategory_CancelClicked")

		self.Options:FindChild("CategoriesButton"):SetCheck(true)

		self.optionsInitialized = true
	end

	local default

	-- Add the whitelist items to the categories
	--[[for name, value in pairs(self.db.profile.whitelist) do
		if self.db.profile.categories[name] then
			--self.db.profile.categories[name].header = "Unit Name - " .. name
			--self.db.profile.categories[name].whitelist = true
		else
			self.db.profile.categories[name] = {
				header = "Unit Name - " .. name,
				whitelist = true,
			}
		end
	end]]

	-- Initialize the categories
	for k, v in pairs(self.db.profile.categories) do
		v = v or self.db.defaults.profile.categories[k]
		if k ~= "default" then
			local categoryItem = self.Categories:FindChild("CategoryItem" .. v.header)

			self:CategoryItem_Init(k, v.header, v.whitelist, categoryItem)
		end
	end

	-- Check to make sure all our items still exist
	for i, item in pairs(self.Categories:GetChildren()) do
		local category = item:GetData().category

		if not self.db.profile.categories[category] then
			item:Destroy()
		end
	end

	self:CategoryItems_Arrange()
end

function Perspective:CategoryItem_Init(category, header, whitelist, item)
	local init = false

	if not item then
		item = Apollo.LoadForm(self.xmlDoc, "CategoryItem", self.Categories, self)

		item:SetName("CategoryItem" .. header)

		local title 	= item:FindChild("HeaderButton")
		local check 	= item:FindChild("HeaderCheck")
		local default 	= item:FindChild("DefaultButton")
		local delete 	= item:FindChild("DeleteButton")

		title:SetText(header)
		title:AddEventHandler("ButtonSignal",		"OnCategoryItem_HeaderClicked")
		
		check:AddEventHandler("ButtonCheck", 		"OnCategoryItem_HeaderChecked")
		check:AddEventHandler("ButtonUncheck", 		"OnCategoryItem_HeaderChecked")

		delete:AddEventHandler("ButtonSignal", 		"OnCategoryItem_DeleteClicked")
		default:AddEventHandler("ButtonSignal", 	"OnCategoryItem_DefaultClicked")

		if whitelist then
			delete:Show(true, true)
		end

		if header == "Set All" then
			item:SetData({ category = category, header = header, whitelist = whitelist, expanded = true })
			check:SetCheck(true)
		else
			item:SetData({ category = category, header = header, whitelist = whitelist, expanded = false })
		end

		init = true
	end

	self:CategoryItem_InitCheckOption(item, "Disable", 				category, "disabled",				init)
	self:CategoryItem_InitCheckOption(item, "CombatDisable", 		category, "disableInCombat",		init)
	self:CategoryItem_InitCheckOption(item, "ShowIcon", 			category, "showIcon",				init)
	self:CategoryItem_InitCheckOption(item, "ShowName", 			category, "showName",				init)
	self:CategoryItem_InitCheckOption(item, "ShowDistance", 		category, "showDistance",			init)
	self:CategoryItem_InitCheckOption(item, "ShowLines", 			category, "showLines",				init)
	self:CategoryItem_InitCheckOption(item, "ShowOutline", 			category, "showLineOutline",		init)
	self:CategoryItem_InitCheckOption(item, "ShowOffScreenLine", 	category, "showLinesOffscreen",		init)

	self:CategoryItem_InitTextOption(item, "Font", 					category, "font", 			false,	init)
	self:CategoryItem_InitTextOption(item, "Icon", 					category, "icon", 			false,	init)
	self:CategoryItem_InitTextOption(item, "IconHeight", 			category, "iconHeight", 	true,	init)
	self:CategoryItem_InitTextOption(item, "IconWidth", 			category, "iconWidth", 		true, 	init)
	self:CategoryItem_InitTextOption(item, "MaxIcons", 				category, "max", 			true,	init)
	self:CategoryItem_InitTextOption(item, "MaxLines", 				category, "maxLines", 		true,	init)
	self:CategoryItem_InitTextOption(item, "LineWidth", 			category, "lineWidth", 		true,	init)
	self:CategoryItem_InitTextOption(item, "LimitBy", 				category, "limitBy", 		false,	init)
	self:CategoryItem_InitTextOption(item, "MinDistance", 			category, "minDistance", 	true,	init)
	self:CategoryItem_InitTextOption(item, "MaxDistance", 			category, "maxDistance", 	true,	init)
	self:CategoryItem_InitTextOption(item, "Display", 				category, "display", 		false,	init)

	self:CategoryItem_InitColorOption(item, "FontColor",			category, "fontColor",				init)
	self:CategoryItem_InitColorOption(item, "IconColor", 			category, "iconColor",				init)
	self:CategoryItem_InitColorOption(item, "LineColor", 			category, "lineColor",				init)

	self:CategoryItem_Toggle(item)

	return item
end


function Perspective:CategoryItem_InitCheckOption(item, control, category, value, init)
	control = item:FindChild(control .. "Check")
	
	control:SetData({ item = item, category = category, value = value })

	local val = self:GetOptionValue(nil, value, category)

	control:SetCheck(val)

	if init then
		control:AddEventHandler("ButtonCheck", 		"CategoryItem_OnChecked")
		control:AddEventHandler("ButtonUncheck", 	"CategoryItem_OnChecked")
	end
end

function Perspective:CategoryItem_InitTextOption(item, control, category, value, number, init)
	control = item:FindChild(control .. "Text")

	control:SetData({ item = item, category = category, value = value, number = number })

	local val = self:GetOptionValue(nil,  value, category)

	control:SetText(val or "")

	if init then
		control:AddEventHandler("EditBoxReturn", 	"CategoryItem_OnReturn")
		control:AddEventHandler("EditBoxTab", 		"CategoryItem_OnReturn")
		control:AddEventHandler("EditBoxEscape", 	"CategoryItem_OnEscape")
	end
end

function Perspective:CategoryItem_InitColorOption(item, control, category, value, init)
	control = item:FindChild(control .. "Button")

	local color = self:GetOptionValue(nil, value, category)

	control:SetBGColor(color)
	control:SetData({ item = item, category = category, value = value, color = color })

	if init then
		control:AddEventHandler("ButtonSignal", "CategoryItem_OnColorClick")
	end
end

function Perspective:CategoryItems_Arrange()
	local sort = function (a, b) 
		local a = a:GetData().header
		local b = b:GetData().header

		a = a == "Set All" and " " or a
		b = b == "Set All" and " " or b

		return a < b
	end

	self.Categories:ArrangeChildrenVert(1, sort)
end

function Perspective:CategoryItem_Toggle(item)
	local data = item:GetData()

	if data.expanded then
		item:SetAnchorOffsets(0, 5, 0, 331)
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
	self.NewCategory:Show(true)
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

	self.NewCategory:Show(false)
end

function Perspective:OnNewCategory_CancelClicked(handler, control, button)
	self.NewCategory:Show(false)
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
	local item = control:GetParent():GetParent():GetParent()
	local data = item:GetData()

	self.db.profile.categories[data.category] = nil

	item:Destroy()

	self:CategoryItems_Arrange()
end

function Perspective:CategoryItem_OnChecked(handler, control, button)
	local args = control:GetData()
	
	local val = control:IsChecked()

	if args.category == "all" then
		for k, v in pairs(self.db.profile.categories) do
			self.db.profile.categories[k][args.value] = val
		end

		self:InitializeOptions()
	else
		self.db.profile.categories[args.category][args.value] = val	
	end

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

	if args.category == "all" then
		for k, v in pairs(self.db.profile.categories) do
			self.db.profile.categories[k][args.value] = val
		end

		self:InitializeOptions()
	else
		self.db.profile.categories[args.category][args.value] = val	
	end

	self:UpdateOptions()
end

function Perspective:CategoryItem_OnEscape(handler, control)
	local args = control:GetData()
	
	local val = self:GetOptionValue(nil, args.value, args.category)

	control:SetText(val)
end

function Perspective:CategoryItem_OnColorClick(window, control, button)
	local args = control:GetData()

  	GeminiColor:ShowColorPicker(self, "CategoryItem_OnColorSet", true, args.color, control, args)
end

function Perspective:CategoryItem_OnColorSet(color, ...)
	local control = arg[1]
	local args = arg[2]

	control:SetBGColor(color)
	self.db.profile.categories[args.category][args.value] = color

	if args.category == "all" then
		for k, v in pairs(self.db.profile.categories) do
			self.db.profile.categories[k][args.value] = color
		end

		self:InitializeOptions()
	end

	self:UpdateOptions()
end