require "Window"
require "GameLib"
require "Apollo"
require "Quest"
require "QuestLib"

local GeminiAddon = Apollo.GetPackage("Gemini:Addon-1.1").tPackage

local Perspective = GeminiAddon:NewAddon("Perspective", false, {})

local Options

local L = {}

local activationStates = {
	{ state = "QuestReward", 			category = "questReward" },
	{ state = "QuestNewMain", 			category = "questNew" },
	{ state = "QuestNew", 				category = "questNew" },
	{ state = "QuestNewRepeatable", 	category = "questNew" },
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
	{ state = "EngravingStation", 		category = "engravingStation" },
	{ state = "GuildRegistrar",			category = "guildRegistrar"},
	{ state = "CityDirections",			category = "cityDirections"},
	{ state = "Dye", 					category = "dye" },
	{ state = "Bank", 					category = "bank" },
	{ state = "GuildBank", 				category = "guildBank" },
	{ state = "Dungeon", 				category = "dungeon" },
}

-- Lookup tables to save ourselves a lot of work and fake an oval dead zone around character
local DeadzoneAnglesLookup = {
	{ Deg = -90, Rad = -1.5707963267949, NextRad = -1.48352986419518, Length = 250, WideLength = 250, DeltaRad = 0.0872664625997164, DeltaLength = -5, DeltaWideLength = -3 }, 
	{ Deg = -85, Rad = -1.48352986419518, NextRad = -1.39626340159546, Length = 245, WideLength = 247, DeltaRad = 0.0872664625997166, DeltaLength = -13, DeltaWideLength = -2 }, 
	{ Deg = -80, Rad = -1.39626340159546, NextRad = -1.30899693899575, Length = 232, WideLength = 245, DeltaRad = 0.0872664625997164, DeltaLength = -17, DeltaWideLength = -6 }, 
	{ Deg = -75, Rad = -1.30899693899575, NextRad = -1.13446401379631, Length = 215, WideLength = 239, DeltaRad = 0.174532925199433, DeltaLength = -45, DeltaWideLength = -17 }, 
	{ Deg = -65, Rad = -1.13446401379631, NextRad = -0.959931088596881, Length = 170, WideLength = 222, DeltaRad = 0.174532925199433, DeltaLength = -35, DeltaWideLength = -22 }, 
	{ Deg = -55, Rad = -0.959931088596881, NextRad = -0.785398163397448, Length = 135, WideLength = 200, DeltaRad = 0.174532925199433, DeltaLength = -30, DeltaWideLength = -26 }, 
	{ Deg = -45, Rad = -0.785398163397448, NextRad = -0.523598775598299, Length = 105, WideLength = 174, DeltaRad = 0.261799387799149, DeltaLength = -30, DeltaWideLength = -39 }, 
	{ Deg = -30, Rad = -0.523598775598299, NextRad = 0, Length = 75, WideLength = 135, DeltaRad = 0.523598775598299, DeltaLength = -30, DeltaWideLength = -62 }, 
	{ Deg = 0, Rad = 0, NextRad = 0.785398163397448, Length = 45, WideLength = 73, DeltaRad = 0.785398163397448, DeltaLength = -10, DeltaWideLength = -40 }, 
	{ Deg = 45, Rad = 0.785398163397448, NextRad = 1.5707963267949, Length = 35, WideLength = 33, DeltaRad = 0.785398163397448, DeltaLength = 0, DeltaWideLength = -6 }, 
	{ Deg = 90, Rad = 1.5707963267949, NextRad = 2.35619449019234, Length = 35, WideLength = 27, DeltaRad = 0.785398163397448, DeltaLength = 0, DeltaWideLength = 0 }
}
local DeadzoneRaceLookup = {
	[1] = { Race = "Exile Human", Scale = 1.1, Wide = 0 }, 
	[3] = { Race = "Granok", Scale = 1.0, Wide = 1 }, 
	[4] = { Race = "Aurin", Scale = 0.9, Wide = 0 }, 
	[13] = { Race = "Chua", Scale = 0.70, Wide = 0 }, 
	[16] = { Race = "Mordesh", Scale = 1.05, Wide = 0 }
}

local unitTypes = {}

function Perspective:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 

    return o
end

local tick = 0
local elapsed = 0

function Perspective:OnInitialize()
	-- Load our localization
	L = GeminiAddon:GetAddon("PerspectiveLocale"):LoadLocalization()

	Options = GeminiAddon:GetAddon("PerspectiveOptions")

	Apollo.LoadSprites("PerspectiveSprites.xml")

	local xmlDoc = XmlDoc.CreateFromFile("Perspective.xml")

	self.Overlay = Apollo.LoadForm(xmlDoc, "Overlay", "InWorldHudStratum", self)
	self.Overlay:Show(true, true)

	-- Table of all units we know about.
	self.units 		= {
		all 		= {},
		prioritized	= {},
		categorized	= {},
		queue 		= {} }

	-- Table of the sorted units, used to sort and draw by distance
	self.sorted 	= {
		prioritized	= {},
		categorized	= {} }
	
	-- Table of the current active challenges
	self.challenges = {}

	-- Table of our update timers
	self.timers 	= {
		draw 		= { elapsed = 0, divisor = 1000, 	func = "OnTimerDraw" },
		fast 		= { elapsed = 0, divisor = 1000, 	func = "OnTimerFast" },
		slow 		= { elapsed = 0, divisor = 1,		func = "OnTimerSlow" },
		queue 		= { elapsed = 0, divisor = 1000,	func = "OnTimerQueue", time = 10 } }

	for index, state in pairs(activationStates) do
		unitTypes[state.state] = true
	end

	-- Path marker windows
	self.markers = {}
	self.markersInitialized = false
	
	self.inRaid = false

	-- Register our addon events	
	Apollo.RegisterEventHandler("UnitCreated", 							"OnUnitCreated", self)
	Apollo.RegisterEventHandler("UnitDestroyed", 						"OnUnitDestroyed", self)
	Apollo.RegisterEventHandler("ChangeWorld", 							"OnWorldChanged", self)	
	Apollo.RegisterEventHandler("QuestInit", 							"OnQuestInit", self)
	Apollo.RegisterEventHandler("QuestObjectiveUpdated", 				"OnQuestObjectiveUpdated", self)
	Apollo.RegisterEventHandler("QuestStateChanged", 					"OnQuestStateChanged", self)
	Apollo.RegisterEventHandler("QuestTrackedChanged", 					"OnQuestTrackedChanged", self)	
	Apollo.RegisterEventHandler("ChallengeActivate",	 				"OnChallengeActivated", self) 
	Apollo.RegisterEventHandler("ChallengeAbandon", 					"OnChallengeRemoved", self)
	Apollo.RegisterEventHandler("ChallengeCompleted", 					"OnChallengeRemoved", self)
	Apollo.RegisterEventHandler("ChallengeFailArea", 					"OnChallengeRemoved", self)
	Apollo.RegisterEventHandler("ChallengeFailTime", 					"OnChallengeRemoved", self)
	Apollo.RegisterEventHandler("ChallengeFailGeneric",	 				"OnChallengeRemoved", self)
	Apollo.RegisterEventHandler("PlayerPathMissionActivate", 			"OnPlayerPathMissionActivate", self)
	Apollo.RegisterEventHandler("PlayerPathMissionAdvanced", 			"OnPlayerPathMissionAdvanced", self)
	Apollo.RegisterEventHandler("PlayerPathMissionComplete",	 		"OnPlayerPathMissionComplete", self)
	Apollo.RegisterEventHandler("PlayerPathMissionDeactivate", 			"OnPlayerPathMissionDeactivate", self)
	Apollo.RegisterEventHandler("PlayerPathMissionUnlocked", 			"OnPlayerPathMissionUnlocked", self)
	Apollo.RegisterEventHandler("PlayerPathMissionUpdate", 				"OnPlayerPathMissionUpdate", self)
	Apollo.RegisterEventHandler("TargetUnitChanged",					"OnTargetUnitChanged", self)
	Apollo.RegisterEventHandler("AlternateTargetUnitChanged",			"OnAlternateTargetUnitChanged", self)
	Apollo.RegisterEventHandler("PublicEventStart", 					"OnPublicEventUpdate", self)
	Apollo.RegisterEventHandler("PublicEventObjectiveUpdate", 			"OnPublicEventUpdate", self)	
	Apollo.RegisterEventHandler("PublicEventLocationAdded", 			"OnPublicEventUpdate", self)
	Apollo.RegisterEventHandler("PublicEventLocationRemoved", 			"OnPublicEventUpdate", self)
	Apollo.RegisterEventHandler("PublicEventObjectiveLocationAdded", 	"OnPublicEventUpdate", self)
	Apollo.RegisterEventHandler("PublicEventObjectiveLocationRemoved", 	"OnPublicEventUpdate", self)
	Apollo.RegisterEventHandler("PublicEventCleared", 					"OnPublicEventEnd", self)
	Apollo.RegisterEventHandler("PublicEventEnd", 						"OnPublicEventEnd", self)
	Apollo.RegisterEventHandler("PublicEventLeave",						"OnPublicEventEnd", self)
	Apollo.RegisterEventHandler("UnitActivationTypeChanged", 			"OnUnitActivationTypeChanged", self)
	Apollo.RegisterEventHandler("UnitNameChanged",						"OnUnitNameChanged", self)
	Apollo.RegisterEventHandler("UnitGroupChanged",						"OnUnitGroupChanged", self)
	Apollo.RegisterEventHandler("Group_MemberFlagsChanged",				"OnGroup_MemberFlagsChanged", self)
	Apollo.RegisterEventHandler("Group_Left",							"OnGroup_Left", self)
	Apollo.RegisterEventHandler("Group_Join",							"OnGroup_Updated", self)
	Apollo.RegisterEventHandler("Group_Updated",						"OnGroup_Updated", self)
	Apollo.RegisterEventHandler("ChatZoneChange",						"OnChatZoneChange", self)
end

function Perspective:OnEnable()
	-- Make sure the addon isn't disabled before starting.
	if not Options.db.profile[Options.profile].settings.disabled then
		-- Start the timers
		Perspective:Start()
	end

	self.loaded = true

	if Apollo.GetAddon("Rover") then
		SendVarToRover("Perspective", self)
	end
end

function Perspective:Start()
	self.offsetLines = Options.db.profile[Options.profile].settings.offsetLines
	
	-- Check to see if we are in a raid
	self.inRaid = GroupLib.InRaid()

	-- Remove the event handler for next frame, again as a precaution
	Apollo.RemoveEventHandler("NextFrame", self)

	if not Options.db.profile[Options.profile].settings.disabled then
		if self.loaded then
			-- Recreate all the units
			for id, unit in pairs(self.units.all) do
				self:OnUnitCreated(unit)
			end
		end
		
		-- Load the timers
		self:SetTimers()
	end

	self:UpdateZoneSpellEffects()

	Apollo.RegisterEventHandler("NextFrame", "OnNextFrame", self)
end

function Perspective:Stop()
	-- Disable all timers
	for name, timer in pairs(self.timers) do
		timer.enabled = nil
		timer.elapsed = 0
	end

	self.units.prioritized = {}
	self.units.categorized = {}

	self.buffs = nil
	self.debuffs = nil

	self.markers = {}
	self.markersInitialized = false

	-- Destroy all our pixies
	self.Overlay:DestroyAllPixies()
end

function Perspective:SetTimers()
	for name, timer in pairs(self.timers) do
		timer.elapsed = 0
		timer.time = Options.db.profile[Options.profile].settings[name] / timer.divisor
		timer.enabled = true
	end
end

function Perspective:GetUnitById(id)
	local unit = GameLib.GetUnitById(id)

	return unit
end

function Perspective:GetUnitInfo(unit)
	if self.units.prioritized[unit:GetId()] then
		return self.units.prioritized[unit:GetId()]
	elseif self.units.categorized[unit:GetId()] then
		return self.units.categorized[unit:GetId()]
	else
		return { id = unit:GetId() }
	end
end

function Perspective:DestroyUnitInfo(unit)
	if unit and unit:IsValid() then
		self.units.prioritized[unit:GetId()] = nil
		self.units.categorized[unit:GetId()] = nil
	end
end

function Perspective:OnNextFrame()
	if not Options.db.profile[Options.profile].settings.disabled then 
		self:UpdateTimers()
	end
end

function Perspective:UpdateTimers()
	-- Get the amount of time since last update
	elapsed = (os.clock() - tick)

	for name, timer in pairs(self.timers) do
		-- Only update the timer if it's enabled.
		if timer.enabled then
			-- Update the elapsed time for the timer.
			timer.elapsed = timer.elapsed + elapsed

			-- Check if its time to fire our timer
			if timer.elapsed >= timer.time then
				-- Make sure our func exists before attempting to fire it
				if self[timer.func] and type(self[timer.func] == "function") then
					-- Fire the timers func
					self[timer.func](self, elapsed)
				end
				-- Reset the timers elapsed time
				timer.elapsed = 0
			end
		end
	end

	-- Save the last tick.
	tick = os.clock()
end

function Perspective:OnTimerQueue(elapsed)
	if table.getn(self.units.queue) > 0 then
		local count = 1
		-- Iterrate backwards so we can remove them from the table as we go
		for i = table.getn(self.units.queue), 1, -1 do
			local update = self.units.queue[i]

			if update.recategorize then
				-- Update the rewards for this unit.
				local canHaveReward = self:UpdateRewards(update.ui, update.unit)

				self:UpdateUnitCategory(update.ui, update.unit)
			else
				-- Update the rewards for this unit.
				local canHaveReward = self:UpdateRewards(update.ui, update.unit)

				if canHaveReward then
					-- If this is a new quest or challenge, first make sure the
					-- unit has the quest/challenge
					if new and update.ui[update.table][update.id] then
						-- Recategorize the unit.
						self:UpdateUnitCategory(update.ui, update.unit)
					elseif not new then
						-- Recategorize the unit.
						self:UpdateUnitCategory(update.ui, update.unit)
					end
				end
			end

			table.remove(self.units.queue, i)

			count = count + 1

			-- Limit to only twenty at a time.
			if count >= 5 then
				break
			end
		end
	end
end


function Perspective:AddPixie(ui, pPos, pixies, items, lines)
	local unit = self:GetUnitById(ui.id)

	if unit then -- check for pvp visiblity?then				
		local isOccluded = unit:IsOccluded()

		if isOccluded and unit:IsPvpFlagged() and unit:GetDispositionTo(GameLib.GetPlayerUnit()) == 0 then
			-- pvp hostile player, this will cause errors on drawing because we only know its last 
			-- known location cause the line to go crazy off the screen
			return
		end

		if not ui.disabled and 
			ui.inRange and
			not (ui.disableInCombat and GameLib.GetPlayerUnit():IsInCombat()) and
			table.getn(pixies) < Options.db.profile[Options.profile].settings.max
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
						if showItem and (items[ui.limitBy][id] or 0) >= ui.max then
							showItem = false
						end

						-- Determine if our line is within limit.
						if showLine and (lines[ui.limitBy][id] or 0) >= ui.maxLines then
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

function Perspective:GetLineOffsetFromCenter (yDist, vectorLength)
	-- Avoid divide by 0
	if (vectorLength == 0) then return 0 end

	-- Get angle in radians: arcsin of opposite(yDist) / hypothenuse(vectorLength)
	local angle = math.asin(yDist / vectorLength)

	local Wide = 0
	if (self.PlayerRaceId ~= nil) then 
		local deadzoneRaceEntry = DeadzoneRaceLookup[self.PlayerRaceId]
		if (deadzoneRaceEntry ~= nil) then Wide = deadzoneRaceEntry.Wide end
	end

	for index, item in pairs(DeadzoneAnglesLookup) do
		if (angle >= item.Rad and angle < item.NextRad) then
			local DeltaRatio = (angle - item.Rad) / item.DeltaRad
			local Offset
			if (Wide == 1) then
				Offset = item.WideLength + (item.DeltaWideLength * DeltaRatio)
			else
				Offset = item.Length + (item.DeltaLength * DeltaRatio)
			end
			-- Print (	"a:" .. angle .. ", " .. " | item.Rad: " .. item.Rad .. " | item.Length: " .. item.Length .. " | dRatio: " .. DeltaRatio .. " | Offset: " .. Offset)
			return Offset
		end
	end

	return 0
end


function Perspective:DrawPixie(ui, unit, uPos, pPos, showItem, showLine, dottedLine, deadzone)

	-- Draw the line first, if it needs to be drawn
	if showLine then
		-- Get the unit's position and vector
		local pos = unit:GetPosition()
		local vec = Vector3.New(pos.x, pos.y, pos.z)

		-- Get the screen position of the unit by it's vector
        local lPos = GameLib.WorldLocToScreenPoint(vec)

        local xOffset = 0
        local yOffset = 0

        local drawLine = 1

        if self.offsetLines then
	        -- Get the length of the vector
			local xDist = lPos.x - pPos.nX
			local yDist = lPos.y - pPos.nY
			local vectorLength = math.sqrt(xDist * xDist + yDist * yDist)

			-- Get line distance offset based on angle, scale for camera position 
			local lineOffsetFromCenter = self:GetLineOffsetFromCenter(yDist, vectorLength)
			if (deadzone ~= nil) then lineOffsetFromCenter = lineOffsetFromCenter * deadzone.scale end
			-- Print (	"O:" .. math.floor(pPos.nX) .. ", " .. math.floor(pPos.nY) .. " | T: " .. math.floor(lPos.x) .. "," .. math.floor(lPos.y) .. " | D: " .. math.floor(xDist) .. "," .. math.floor(yDist) .. " | VL: " .. math.floor(vectorLength) )
			-- Print (	"DZ.nameplateY: " .. math.floor(deadzone.nameplateY) .. ", DZ.feetY: " .. math.floor(deadzone.feetY) .. ", Height: " .. math.floor(deadzone.feetY - deadzone.nameplateY) .. ", DZ.scale : " .. deadzone.scale )

			-- Add: Deadzone size scale from config (a float multiplier that changes lineOffsetFromCenter)
			-- TODO 

			-- Don't draw "outside-in" lines or if the result will be less than 10 pixels long
			if (lineOffsetFromCenter + 25 < vectorLength) then 
				-- Get the ratio of the line distance from the center of the screen to the vector length
				local lengthRatio = lineOffsetFromCenter / vectorLength

				-- Get the x and y offsets for the line starting point
				xOffset = lengthRatio * xDist
				yOffset = lengthRatio * yDist
			else
				drawLine = 0
			end
		end

		if drawLine == 1 then 

			local pixieLocPoints = { 0, 0, 0, 0 }

			if dottedLine == true then 
				-- Draw Dots, then! 
				-- First dumb approach, and it seems to work OK:  
				-- 		draw dot at start, 
				--		then one extra dot at ~half (configurable) remaining distance (maybe with a max jump length)
				--		until 20 pixels remain on either X or Y axis (really do NOT want to spam SQRT)

				local drawX = pPos.nX + xOffset
				local drawY = pPos.nY + yOffset
				local targetX = lPos.x
				local targetY = lPos.y
				local deltaX, deltaY, deltaRatio
				-- move that to some global place with change notification and account for render scale
				local maxDelta = Apollo.GetDisplaySize().nWidth / 6 

				while 1 do
					-- Draw Dot 
		 			self.Overlay:AddPixie( {
		 					strSprite = "PerspectiveSprites:small-circle", cr = ui.cLineColor, 
		 					loc = { fPoints = pixieLocPoints, nOffsets = { drawX - 5, drawY - 5, drawX + 5, drawY + 5 } }
		 				} )
		 			-- Move half remaioning distance
		 			deltaX = (targetX - drawX)
		 			deltaY = (targetY - drawY)

		 			if ( deltaX >= -20 and deltaX <= 20 and deltaY >= -20 and deltaY <= 20 ) then break end 

		 			if ( math.abs(deltaX) > maxDelta ) then 
		 				deltaRatio = maxDelta / math.abs(deltaX)
		 				deltaX = deltaX * deltaRatio
		 				deltaY = deltaY * deltaRatio
		 			end
		 			if ( math.abs(deltaY) > maxDelta ) then 
		 				deltaRatio = maxDelta / math.abs(deltaY)
		 				deltaX = deltaX * deltaRatio
		 				deltaY = deltaY * deltaRatio
		 			end

		 			drawX = drawX + deltaX * 0.5
		 			drawY = drawY + deltaY * 0.5

				end

				-- Add option to show final dot? 
				self.Overlay:AddPixie( {
						strSprite = "PerspectiveSprites:small-circle", cr = ui.cLineColor, 
						loc = { fPoints = pixieLocPoints, nOffsets = { targetX - 5, targetY - 5, targetX + 5, targetY + 5 } }
					} )
			else
				-- Draw lines!
				-- Draw the background line to give the outline if required
				if ui.showLineOutline then
					local lineAlpha = string.sub(ui.cLineColor, 1, 2)

					self.Overlay:AddPixie({
						bLine = true,
						fWidth = ui.lineWidth + 2,
						cr = lineAlpha .. "000000",
						loc = {
							fPoints = pixieLocPoints,
							nOffsets = { lPos.x, lPos.y, pPos.nX + xOffset, pPos.nY + yOffset }
						}
					})
				end

				-- Draw the actual line to the unit's vector
				self.Overlay:AddPixie({
					bLine = true,
					fWidth = ui.lineWidth,
					cr = ui.cLineColor,
					loc = {
						fPoints = pixieLocPoints,
						nOffsets = { lPos.x, lPos.y, pPos.nX + xOffset, pPos.nY + yOffset }
					}
				})
			end

		end

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
				text = ui.display or ui.name or ""
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


function Perspective:OnTimerDraw()
	-- Perspective is disabled
	if Options.db.profile[Options.profile].settings.disabled then return end

	-- This list will contain all the pixies we we'll need to draw.
	local pixies = {}

	-- Save player unit & Race Id
	if (self.Player == nil) then 
		local p = GameLib.GetPlayerUnit()
		if (p:IsValid()) then 
			self.Player = GameLib.GetPlayerUnit() 
		end
	end
	if (self.PlayerRaceId == nil) then 
		if (self.Player ~= nil) then 
			self.PlayerRaceId = self.Player:GetRaceId()

		end
	end

	-- Get the player's current screen position
	-- local pPos = GameLib.GetUnitScreenPosition(GameLib.GetPlayerUnit())
	local pPos = GameLib.GetUnitScreenPosition(self.Player)

	-- We want to make sure we can get the unit's screen position	
	if pPos then

		-- The limits tables
		local items = {	unit = {}, category = {}, quest = {}, challenge = {} }
		local lines = {	unit = {}, category = {}, quest = {}, challenge = {} }

		-- Check our prioritized units first, they are the closest to our player
		for index, ui in pairs(self.sorted.prioritized) do
			self:AddPixie(ui, pPos, pixies, items, lines)
		end

		-- Finally check our categorized units.
		for index, ui in pairs(self.sorted.categorized) do
			self:AddPixie(ui, pPos, pixies, items, lines)			
		end

		-- Destroy all our pixies
		self.Overlay:DestroyAllPixies()

		-- Finally, lets draw some pixies!

		-- Draw the markers, they are most likely going to be the farthest pixies from the player
		-- so we want them "behind" our other units.
		self:MarkersDraw()

		-- Drawing pixies want to measure a deadzone. This will be based on character size onscreen
		-- (i.e. camera distance/angle). Get the proper information 
		local deadzone = nil
		
		if (self.Player ~= nil) then
			deadzone = {
				["nameplateY"] = self.Player:GetOverheadAnchor().y, 
				["feetY"] = pPos.nY, 
				["raceScale"] = 1.0, 
				["scale"] = nil
			}
			if (self.PlayerRaceId ~= nil) then 
				local deadzoneRaceEntry = DeadzoneRaceLookup[self.PlayerRaceId]
				if (deadzoneRaceEntry ~= nil) then 
					deadzone.raceScale = deadzoneRaceEntry.Scale 
				end
			end
			deadzone.scale = (deadzone.feetY - deadzone.nameplateY) / 300 * deadzone.raceScale
		end

		-- Now, for the pixies, we'll draw them in reverse, because the lists were sorted by
		-- distance, closest to farthest.  This will ensure the farthest are drawn first and 
		-- "behind" our closer pixies.
		for i = #pixies, 1, -1 do
			-- Get our next pixie
			pixie = pixies[i]

			-- Drw the pixie
			self:DrawPixie(
				pixie.ui, 
				pixie.unit,
				pixie.uPos, 
				pixie.pPos, 
				pixie.showItem, 
				pixie.showLine, 
				deadzone)
		end

	end
end

-- Updates all the units we know about as well as loading options if its needed.
-- Categorizes and prioritizes our units.
function Perspective:OnTimerSlow()
	-- Perspective is disabled
	if Options.db.profile[Options.profile].settings.disabled then return end

	local player = GameLib.GetPlayerUnit()

	if player then
		local pos = player:GetPosition()
	
		if pos then
			-- Get the player's current vector from position.
			local vector = Vector3.New(pos.x, pos.y, pos.z)

			self.sorted.categorized = {}

			-- Update the categorized units.
			for id, ui in pairs(self.units.categorized) do
				if ui then
					local unit = GameLib.GetUnitById(id)
				
					if unit and	self:UpdateUnit(ui, unit) then
						table.insert(self.sorted.categorized, ui)
					end
				end
			end

			table.sort(self.sorted.categorized, function(a, b) return (a.distance or 0) < (b.distance or 0) end)
			
			if self.markersInitialized then
				self:MarkersUpdate(vector)
			else
				self:MarkersInit()
			end

		end

		-- Check for new spell effects, this is gonna suck :(
		for id, unit in pairs(self.units.all) do
			-- Limit buffs to players for now
			if unit:IsValid() and unit:GetType() == "Player" then
				local ui = self:GetUnitInfo(unit)

				local category = self:UpdateSpellEffects(ui, unit)

				if category and category ~= ui.category then
					-- Need to recategorize this unit
					table.insert(self.units.queue, { ui = ui, unit = unit, recategorize = true })
				end
			end
		end
	end
end

-- Updates our prioritized (close) units faster than the farther ones.
-- We'll keep this as light weight as possible, only updating the distance and relevant info.
function Perspective:OnTimerFast(forced)
	-- Perspective is disabled
	if Options.db.profile[Options.profile].settings.disabled then return end

	local player = GameLib.GetPlayerUnit()

	if player then
		local pos = player:GetPosition()
	
		if pos then
			-- Get the player's current vector from position.
			local vector = Vector3.New(pos.x, pos.y, pos.z)

			self.sorted.prioritized = {}

			-- Update the prioritized units.
			for id, ui in pairs(self.units.prioritized) do
				if ui then
					local unit = GameLib.GetUnitById(id)
				
					if unit and	self:UpdateUnit(ui, unit) then
						table.insert(self.sorted.prioritized, ui)
					end
				end
			end

			-- Sort the units by distance.
			table.sort(self.sorted.prioritized, function(a, b) return (a.distance or 0) < (b.distance or 0) end)
		end
	end
end

function Perspective:UpdateUnitCategory(ui, unit)
	-- Reset the ui category
	ui.category = nil

	if unit and unit:IsValid() then
		-- Get the unit name
		ui.name = unit:GetName()

		-- Determines if the unit is busy
		if not self:IsUnitBusy(unit) then
			-- Targetted unit
			if unit == GameLib.GetTargetUnit() and
				not Options.db.profile[Options.profile].categories.target.disabled then
				ui.category = "target"
			elseif self.focus and unit == self.focus and
				not Options.db.profile[Options.profile].categories.focus.disabled then
				ui.category = "focus"
			elseif Options.db.profile[Options.profile].categories[ui.name] and
				not Options.db.profile[Options.profile].categories[ui.name].disabled then
				-- This is a custom category, it has priority over all other category types except
				-- target and focus.
				ui.category = ui.name
			elseif Options.db.profile[Options.profile].names[ui.name] then
				ui.category = Options.db.profile[Options.profile].names[ui.name].category
				ui.named = ui.name
			else
				-- Updates the activation state for the unit and determines if it is busy, if it is
				-- busy then we do not care for this unit at this time.
				self:UpdateActivationState(ui, unit)
			end
		
			-- Only continue looking for a category if it has not be found by now, unless its a 
			-- scientist item, then we'll further check the rewards to see if its an active scan
			-- mission target, it will then be reclassified as such.
			if not ui.category or ui.category == "scientist" then
				-- Determines if any rewards for this unit exist, such as quest objectvies, 
				-- challenge objectives or scientist scan target.
				if ui.hasQuest and 
					not Options:GetOptionValue(nil, "disabled", "questObjective") then 
					if ui.hasActivation then
						ui.category = "questInteractable"
					else
						ui.category = "questObjective"
					end
				elseif ui.hasChallenge and 
					not Options:GetOptionValue(nil, "disabled", "challenge") then 
					ui.category = "challenge"
				elseif ui.hasScan and 
					not Options:GetOptionValue(nil, "disabled", "scientistScans") then 
					ui.category = "scientistScans"
				end

				if not ui.category then
					-- Attempt to categorize the unit by type.
					local type = unit:GetType()

					if type == "Player" then
						self:UpdatePlayer(ui, unit)
					elseif type == "NonPlayer" then
						self:UpdateNonPlayer(ui, unit)
					elseif type == "Harvest" then
						self:UpdateHarvest(ui, unit)
					elseif type == "Pickup" then
						self:UpdatePickup(ui, unit)
					elseif unit:GetLoot() then
						self:UpdateLoot(ui, unit)
					end
				end
			end

			-- If a category has still not been found for the unit, then determine its disposition
			-- and difficulty and categorize it as such.
			if not ui.category and unit:GetType() == "NonPlayer" and not unit:IsDead() then
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

				if not Options.db.profile[Options.profile].categories[npcType].disabled then
					ui.category = npcType
				end	
			end

			if unit:IsDead() then
				-- Clear dead npc quest / challenge objectives and harvests, but not scientist scans
				if unit:GetType() == "Harvest" or
					ui.category == "questObjective" or
					ui.category == "challenge" then
					ui.category = nil
				end
			end
		end
	end

	-- Finally determine that our category has been successfully set
	if ui.category then
		-- Update the unit's information.
		self:UpdateUnitInfo(ui, unit)
	else
		-- Destroy the unit
		self:DestroyUnitInfo(unit)
	end
end

-- This gets called when the unit category is updated
function Perspective:UpdateUnitInfo(ui, unit)
	if ui.category then
		-- Set the unit info name
		ui.name = unit:GetName()

		-- Load the options for this unit.
		self:UpdateOptions(ui)

		-- Unit is not disabled and we have our options loaded for it, 
		-- lets finish updating its information.
		if not ui.disabled then
			if ui.limitBy and ui.limitBy ~= "none" then	
				if 	   ui.limitBy == "name"			then ui.limitId = { ui.name }
				elseif ui.limitBy == "category" 	then ui.limitId = { ui.category }
				elseif ui.limitBy == "quest" 		then ui.limitId = ui.quests
				elseif ui.limitBy == "challenge"	then ui.limitId = ui.challenges
				end
			else
				ui.limitId = nil
			end
			
			-- Update the unit, this will sort it into the correct table
			self:UpdateUnit(ui, unit)
		end
	end
end

function Perspective:UpdateOptions(ui, full)
	local function updateOptions(ui)
		if ui.category then
			-- Loads the options for the ui
			for k, v in pairs(Options.db.profile[Options.profile].categories.default) do
				ui[k] = Options:GetOptionValue(ui, k)
			end

			-- Determines if this is a named unit with a set display as value.
			ui.display = ui.named  and Options.db.profile[Options.profile].names[ui.name].display or ui.display

			-- Lets the adodn know we've loaded this ui.
			ui.loaded = true	
		else
			ui.loaded = false
		end				
	end
	
	if ui then
		-- Update only the specific unit information
		updateOptions(ui)
	else
		-- Updating all options
		if full then
			-- Now we can recategorize all units we know about
			for id, unit in pairs(self.units.all) do
				-- Get the ui or create a new one (in this case mostly creating)
				local ui = self:GetUnitInfo(unit)

				-- Update the rewards for the unit
				self:UpdateRewards(ui, unit)

				-- Categorize the unit
				self:UpdateUnitCategory(ui, unit)
			end
		else
			for _, tbl in pairs({ "prioritized", "categorized" }) do
				for id, ui in pairs(self.units[tbl]) do
					-- Get the ui
					local unit = GameLib.GetUnitById(ui.id)

					if unit then
						updateOptions(ui)
					end
				end
			end			
		end

		-- Causes immediate updates
		self:OnTimerSlow()
		self:OnTimerFast()
	end
end

function Perspective:UpdateSpellEffects(ui, unit)
	local tables = { 
		{ name = "debuffs", ar = "arHarmful" },
		{ name = "buffs", ar = "arBeneficial" } }

	for index, tbl in pairs(tables) do
		if self[tbl.name] then
			for index, effect in pairs(unit:GetBuffs()[tbl.ar]) do
				-- Spell effect name
				local name = effect.splEffect:GetName()

				local eff = self[tbl.name][name]

				if eff then
					local disposition = ""

					if eff.disposition then
						disposition = (unit:GetDispositionTo(GameLib.GetPlayerUnit()) == 2) and "Friendly" or "Hostile"
					end

					-- Return the category for this spell effect.
					return self[tbl.name][name].category .. disposition
				end
			end
		end
	end

	return nil
end

function Perspective:UpdateZoneSpellEffects()
	if not GameLib.GetCurrentZoneMap() then return end

	local zoneId = GameLib.GetCurrentZoneMap().id

	-- Update our valid buffs and debuffs for the zone
	local tables = { "buffs", "debuffs" }

	for index, tbl in pairs(tables) do
		-- Empty the table.
		self[tbl] = {}

		-- Determines if we found a buff or not.
		local active = false

		-- Make sure the category is enabled.
		for name, options in pairs(Options.db.profile[Options.profile][tbl]) do
			-- Zone id makes the buff's listed zone id.
			if options.zone == zoneId then
				-- Now determine if the category for the buff is enabled, otherwise no need to track it
				local isEnabled = false

				-- Check if this is a disposition based category
				if options.disposition == true then
					-- Check to make sure at least either the Hostile or Friendly category is enabled.
					if not Options.db.profile[Options.profile].categories[options.category .. "Hostile"].disabled or
						not Options.db.profile[Options.profile].categories[options.category .. "Friendly"].disabled then
						isEnabled = true
					end
				else
					-- Make sure the category is enabled.
					if not Options.db.profile[Options.profile].categories[options.category].disabled then
						isEnabled = true
					end
				end

				if isEnabled == true then
					-- Valid buff we need to be checking for.
					self[tbl][name] = { category = options.category, disposition = options.disposition }
				
					-- Active table.
					active = true
				end
			end
		end

		if not active then
			self[tbl] = nil
		end
	end
end

-- Updates the unit to and calculates its current distance from the player.
function Perspective:UpdateUnit(ui, unit)
	local player = GameLib.GetPlayerUnit()

	if player then
		local position = player:GetPosition()

		if position then
			if unit then
				-- Check if we need to recategorize
				if unit:IsDead() then -- Clear dead units
					-- Clear dead npc quest / challenge objectives, but not scientist scans as
					-- well as harvest
					if unit:GetType() == "Player" or 
						unit:GetType() == "Harvest" or
						ui.category == "questObjective" or
						ui.category == "challenge" then
						-- Queue the unit to be recategorized.
						table.insert(self.units.queue, { ui = ui, unit = unit, recategorize = true })
						return
					end
				end

				if ui.loaded then
					-- Find the index of the ui if its not passed in.
					if tbl and not index then
						for i, u in pairs(self[tbl]) do
							if u.id == ui.id then
								index = i
								break
							end
						end
					end

					-- Update the players position and vector
					local pPos = position
					local pVec = Vector3.New(pPos.x, pPos.y, pPos.z)

					-- Update the units position and vector
					local uPos = unit:GetPosition()
					ui.vector = Vector3.New(uPos.x, uPos.y, uPos.z)

					-- Calculate z axis (really y axis) distance
					local zVec = Vector3.New(pPos.x, uPos.y, pPos.z)
					local zDistance = (pVec - zVec):Length()

					if pPos and uPos then
						-- Get the distance from the player.
						ui.distance = (pVec - ui.vector):Length()
						
						-- Get the scale size based on distance.
						ui.scale = math.min(1 / (ui.distance / 100), 1)
						
						-- Determine if the unit is in range of display.
						ui.inRange = (ui.distance >= ui.minDistance and 
									  ui.distance <= ui.maxDistance and 
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

						-- Prioritize or categorize based on distance.
						if ui.distance <= ui.rangeLimit + 20 then
							self.units.prioritized[ui.id] = ui
							self.units.categorized[ui.id] = nil
						else
							self.units.categorized[ui.id] = ui
							self.units.prioritized[ui.id] = nil
						end

						return true
					end
				end
			else
				return nil
			end
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
			if not marker.disabled and
				marks < marker.max and
				uPos.z > 0 and
				region.distance and 
				region.inRange then

				if marker.showIcon then
					self.Overlay:AddPixie({
						strSprite = marker.icon,
						cr = marker.iconColor,
						loc = {
							fPoints = { 0, 0, 0, 0 },
							nOffsets = {
								uPos.x - (marker.iconWidth / 2), 
								uPos.y - (marker.iconHeight / 2), 
								uPos.x + (marker.iconWidth / 2),
								uPos.y + (marker.iconHeight / 2) } } })
				end

				if marker.showName or marker.showDistance then
					local text = ""

					if marker.showName then
						text = marker.display or marker.name or ""
					end

					text = marker.showDistance and text .. " (" .. math.ceil(region.distance) .. "m)" or text

					self.Overlay:AddPixie({
						strText = text,
						strFont = marker.font,
						crText = marker.fontColor,
						loc = {
							fPoints = { 0, 0, 0, 0 },
							nOffsets = {
								uPos.x - (marker.iconWidth), 
								uPos.y + (marker.iconHeight / 2), 
								uPos.x + (marker.iconWidth),
								uPos.y + (100) } },
						flagsText = {
							DT_CENTER = true,
							DT_WORDBREAK = true	} })
				end

				if marker.showIcon or 
					marker.showName or 
					marker.showDistance then
					marks = marks + 1
				end
			end
		end
	end
end

function Perspective:MarkersInit()
	local _, __

	-- Set the markers as no longer initialized
	self.markersInitialized = false

	-- Destroy any current makers
	self.markers = {}

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

	local challenges = ChallengesLib.GetActiveChallengeList()

	if challenges then
		for _, challenge in pairs(challenges) do
			self:MarkerChallengeUpdate(challenge)
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

function Perspective:MarkerChallengeUpdate(challenge, remove)
	local id = "challenge" .. challenge:GetId()

	if challenge:IsActivated() and not remove then
		self.markers[id] = {
			name = challenge:GetName(),
			type = "challenge",
			regions = {} }

		-- Update the marker options
		self:MarkerUpdateOptions(self.markers[id], "challengeLocation")

		for index, region in pairs(challenge:GetMapRegions()) do
			self.markers[id].regions[index] = {
				vector = Vector3.New(region.tIndicator.x, region.tIndicator.y, region.tIndicator.z)
			}
			self:MarkerUpdate(self.markers[id])
		end
	else
		self.markers[id] = nil
	end
end

function Perspective:MarkerEventUpdate(event)
	local id = "event" .. event:GetName()

	if event:IsActive() and table.getn(event:GetObjectives()) > 0 then
		self.markers[id] = {
			name = event:GetName(),
			type = "event",
			regions = {} }

			-- Update the marker options
			self:MarkerUpdateOptions(self.markers[id], "eventLocation")

		for index, objective in pairs(event:GetObjectives()) do
			for index, region in pairs(objective:GetMapRegions()) do
				self.markers[id].regions[index] = {
					vector = Vector3.New(region.tIndicator.x, region.tIndicator.y, region.tIndicator.z)
				}
				self:MarkerUpdate(self.markers[id])
			end
		end
	end
end

function Perspective:MarkerPathUpdate(mission, deactivated)
	local id = "path" .. mission:GetId()

	if not mission:IsComplete() and not deactivated then
		if table.getn(mission:GetMapRegions()) > 0 or table.getn(mission:GetMapLocations()) > 0 then
			self.markers[id] = {
				name = mission:GetName(),
				mission = mission,
				type = "path",
				regions = {} }

			-- Update the marker options
			self:MarkerUpdateOptions(self.markers[id], "pathLocation")

			for index, region in pairs(mission:GetMapRegions()) do
				table.insert(self.markers[id].regions, {
					vector = Vector3.New(region.tIndicator.x, region.tIndicator.y, region.tIndicator.z)
				})
				self:MarkerUpdate(self.markers[id])
			end
			for index, loc in pairs(mission:GetMapLocations()) do
				table.insert(self.markers[id].regions, {
					vector = Vector3.New(loc.x, loc.y, loc.z)
				})
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
		  		regions = {} }

			-- Update the marker options
			self:MarkerUpdateOptions(self.markers[id], "questLocation")

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

function Perspective:MarkerUpdateOptions(marker, category)
	local options = { 
		"disabled", 
		"showIcon",
		"showName",
		"showDistance",
		"icon", 
		"iconColor",
		"iconWidth",
		"iconHeight",
		"maxDistance",
		"minDistance",
		"font",
		"fontColor",
		"max",
		"limitBy" }

	for _, option in pairs(options) do
		marker[option] = Options:GetOptionValue(nil, option, category)
	end
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
		for index, region in pairs(marker.regions) do
			-- Get the distance to the marker
			region.distance = math.ceil((vector - region.vector):Length())
				
			-- Determine if the player is in the region
			region.inRange = (region.distance >= marker.minDistance and
							region.distance <= marker.maxDistance)
		end

		table.sort(marker.regions, function(a, b) return (a.distance or 0) < (b.distance or 0) end)
	end
end

---------------------------------------------------------------------------------------------------
-- Addon Event Functions
---------------------------------------------------------------------------------------------------

function Perspective:OnUnitCreated(unit)
	local type = unit:GetType()

	self.units.all[unit:GetId()] = unit

	-- Get the categorized ui if it exists.
	local ui = self:GetUnitInfo(unit)

	-- Get the rewards for this unit
	self:UpdateRewards(ui, unit)

	-- Attempt to categorize the unit
	self:UpdateUnitCategory(ui, unit)
end

function Perspective:OnUnitDestroyed(unit)
	self.units.all[unit:GetId()] = nils

	self:DestroyUnitInfo(unit)
end

function Perspective:OnTargetUnitChanged(unit)
	-- Ensure we have the target unit enabled.
	if not Options.db.profile[Options.profile].categories.target.disabled then
		-- Attempt to locate and update our current target unit
		for _, tbl in pairs({ "prioritized", "categorized" }) do
			for id, ui in pairs(self.units[tbl]) do
				if ui.category == "target" then
					-- Recategorize our current target.
					self:UpdateUnitCategory(ui, GameLib.GetUnitById(id))
					break
				end
			end
		end

		-- Ensure we actually have a target and didn't just untarget our current target.
		if unit and unit ~= GameLib.GetPlayerUnit() then
			-- Get the ui for our current target, or create a new one.
			local ui = self:GetUnitInfo(unit)

			-- Categorize the target unit.
			self:UpdateUnitCategory(ui, unit)
		end
	end	
end

function Perspective:OnAlternateTargetUnitChanged(unit)
	-- Save the focus target.
	self.focus = unit

	-- Ensure we have the focus unit enabled.
	if not Options.db.profile[Options.profile].categories.focus.disabled then
		-- Attempt to locate and update our current focus unit
		for _, tbl in pairs({ "prioritized", "categorized" }) do
			for id, ui in pairs(self.units[tbl]) do
				if ui.category == "focus" then
					-- Recategorize our current target.
					self:UpdateUnitCategory(ui, GameLib.GetUnitById(id))
					break
				end
			end
		end

		-- Ensure we actually have a target and didn't just untarget our current target.
		if unit then
			-- Get the ui for our current target, or create a new one.
			local ui = self:GetUnitInfo(unit)

			-- Categorize the target unit.
			self:UpdateUnitCategory(ui, unit)
		end
	end	
end

function Perspective:OnWorldChanged()
	if self.loaded then
		self:MarkersInit()
	end

	self.Player = nil

	-- Update buffs / debuffs table
	self:UpdateZoneSpellEffects()
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

function Perspective:OnQuestObjectiveUpdated(quest, state)
	if self.loaded then
		-- Update our quest location markers
		self:MarkerQuestUpdate(quest)

		-- Update the quest units based on the quest
		self:UpdateQuestUnits(quest, state)
	end
end

-- Event fired when quests are abandoned, accepted, accomplished, etc..
function Perspective:OnQuestStateChanged(quest, state)
	if self.loaded then
		-- Update our quest location markers
		self:MarkerQuestUpdate(quest)
	
		-- Update the quest units based on the quest
		self:UpdateQuestUnits(quest, state)
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

function Perspective:OnUnitActivationTypeChanged(unit)
	-- Get the unit info or create a new one
	local ui = self:GetUnitInfo(unit)

	self:UpdateUnitCategory(ui, unit)
end

function Perspective:OnUnitNameChanged(unit)
	local ui = self:GetUnitInfo(unit)

	self:UpdateUnitCategory(ui, unit)
end

function Perspective:OnUnitGroupChanged(unit)
	if not Options.db.profile[Options.profile].categories.group.disabled then
		local ui = self:GetUnitInfo(unit)

		-- Recategorize the player.
		self:UpdateUnitCategory(ui, unit)
	end
end

function Perspective:OnGroup_MemberFlagsChanged(index, arg2, flags)
	local unit = GroupLib.GetUnitForGroupMember(index)

	if unit and unit:IsValid() then
		local ui = self:GetUnitInfo(unit)
		
		-- Recategorize the player.
		self:UpdateUnitCategory(ui, unit)
	end
end

function Perspective:OnGroup_Left()
	if self.inRaid then
		-- Player is no longer in a raid
		self.inRaid = false

		-- Recategorize the units using the queue.
		self:RecategorizeAllUnits(true)
	end
end

function Perspective:OnGroup_Updated()
	if GroupLib.InRaid() and not self.inRaid then
		-- Player is now in raid.
		self.inRaid = true

		-- Recategorize the units using the queue.
		self:RecategorizeAllUnits(true)
	end
end

function Perspective:OnChatZoneChange()
	-- We have moved to a different zone
	self:OnWorldChanged()
end

function Perspective:OnChallengeActivated(challenge)
	self.challenges[challenge:GetId()] = true
	self:MarkerChallengeUpdate(challenge)

	self:UpdateChallengeUnits(challenge, true)
end

function Perspective:OnChallengeRemoved(challenge)
	local id

	if type(challenge) == "number" then
		id = challenge
		challenge = ChallengesLib:GetActiveChallengeList()[challenge]
	elseif type(challenge) == "userdata" and challenge:GetId() then
		id = challenge:GetId()
	end

	if id then
		self.challenges[id] = nil
		self:MarkerChallengeUpdate(challenge, true)
		self:UpdateChallengeUnits(challenge, false)
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

function Perspective:RecategorizeAllUnits(queue)
	-- User left or joined a group, update all units
	for id, unit in pairs(self.units.all) do
		-- Make sure the unit is still valid and has a quest reward for the quest.
		if unit:IsValid() then
			-- Get the ui for the unit or create a new one.
			local ui = self:GetUnitInfo(unit)

			if queue then
				table.insert(self.units.queue, { 
					ui = ui, 
					unit = unit, 
					recategorize = true })
			else
				self:UpdateUnitCategory(ui, unit)
			end
		end
	end
end

function Perspective:UpdateQuestUnits(quest, state)
	if state == Quest.QuestState_Accepted then
		-- Update all known units that have the new quest.
		for id, unit in pairs(self.units.all) do
			-- Make sure the unit is still valid and has a quest reward for the quest.
			if unit:IsValid() then
				-- Get the ui for the unit or create a new one.
				local ui = self:GetUnitInfo(unit)

				table.insert(self.units.queue, { 
					ui = ui, 
					unit = unit, 
					table = "quests", 
					new = true,
					id = quest:GetId() })
			end
		end
	else
		-- Quest abandoned, accomplished, etc.. something we already know about, 
		-- therefore we only need to search our currently categorized units and
		-- update them.
		for _, tbl in pairs({ "prioritized", "categorized" }) do
			for id, ui in pairs(self.units[tbl]) do
				if ui.hasQuest and ui.quests[quest:GetId()] then
					local unit = GameLib.GetUnitById(id)

					table.insert(self.units.queue, { 
						ui = ui, 
						unit = unit, 
						table = "quests", 
						id = quest:GetId() })
				end
			end
		end
	end
end

function Perspective:UpdateChallengeUnits(challenge, active)
	if active then
		-- Update all known units that have the new quest.
		for id, unit in pairs(self.units.all) do
			-- Make sure the unit is still valid and has a challenge reward for the challenge.
			if unit:IsValid() and 				-- Valid 
				unit:GetType() ~= "Player" and	-- Non Player
				not unit:IsDead() then			-- Non Dead 
				-- Get the ui for the unit.
				local ui = self:GetUnitInfo(unit)

				table.insert(self.units.queue, { 
					ui = ui, 
					unit = unit, 
					table = "challenges", 
					new = true,
					id = challenge:GetId() })
			end
		end
	else
		-- Challenge is no longer active, just update the units that had the challenge.
		for _, tbl in pairs({ "prioritized", "categorized" }) do
			for id, ui in pairs(self.units[tbl]) do
				if ui.hasChallenge and ui.challenges[challenge:GetId()] then
					local unit = GameLib.GetUnitById(id)

					if unit then
						table.insert(self.units.queue, { 
							ui = ui, 
							unit = unit, 
							table = "challenges", 
							id = challenge:GetId() })
					end
				end
			end
		end
	end
end

function Perspective:GetClass(unit)
	local classId = unit:GetClassId()

	for class, cId in pairs(GameLib.CodeEnumClass) do
		if classId == cId then
			return class
		end
	end
end

function Perspective:GetRaidType(unit)
	for i = 1, GroupLib.GetMemberCount(), 1 do
		if unit == GroupLib.GetUnitForGroupMember(i) then
			local member = GroupLib.GetGroupMember(i)

			if member.bIsOnline then
				if member.bMainTank and 
					not Options.db.profile[Options.profile].categories.mainTank.disabled then
					return "mainTank"
				elseif	member.bMainAssist and
					not Options.db.profile[Options.profile].categories.mainAssist.disabled then
					return "mainAssist"
				elseif member.bTank and 
					not Options.db.profile[Options.profile].categories.tank.disabled then
					return "tank"
				elseif member.bHealer and 
					not Options.db.profile[Options.profile].categories.healer.disabled then
					return "healer"
				elseif	member.bDPS and
					not Options.db.profile[Options.profile].categories.dps.disabled then
					return "dps"
				elseif GroupLib.InRaid() then
					return "raid"
				else
					return nil
				end
			end
		end
	end

	return nil
end

function Perspective:UpdatePlayer(ui, unit)

	local player = GameLib.GetPlayerUnit()
	
	-- We don't care about ourselves, or invalid units
	if unit:IsThePlayer() or not unit:IsValid() or unit:IsDead() then return end

	-- Check debuffs, then buffs
	ui.category = self:UpdateSpellEffects(ui, unit)
	
	if not ui.category then
		if unit:IsPvpFlagged() then
			local category = "friendlyPvp"

			if unit:GetDispositionTo(self.Player) == 0 then
				category = "hostilePvp"
			end

			ui.category = category .. self:GetClass(unit)
		-- Check to see if the unit is in our group
		elseif unit:IsInYourGroup() then
			local raidType = self:GetRaidType(unit)

			if raidType then
				ui.category  = raidType
			elseif not Options.db.profile[Options.profile].categories.group.disabled then
				ui.category = "group"
			end
		-- Check to see if the unit is in our guild
		elseif 	player and player:GetGuildName() and 
				unit:GetGuildName() == player:GetGuildName() and
				not Options.db.profile[Options.profile].categories.guild.disabled then
			ui.category = "guild"
		elseif unit:IsFriend() or unit:IsAccountFriend() and
			not Options.db.profile[Options.profile].categories.friend.disabled then
			ui.category = "friend"
		elseif unit:IsRival() and
			not Options.db.profile[Options.profile].categories.rival.disabled then
			ui.category = "rival"
		elseif unit:GetFaction() == 167 and
			not Options.db.profile[Options.profile].categories.exile.disabled then
			ui.category = "exile"
		elseif unit:GetFaction() == 166 and
			not Options.db.profile[Options.profile].categories.dominion.disabled then
			ui.category = "dominion"
		end
	end
end

function Perspective:UpdateNonPlayer(ui, unit)
	local id = GameLib.GetCurrentWorldId()

	-- War of the Wilds
	if id == 1393 then
		if (unit:GetFaction() == 170 or unit:GetFaction() == 900) and unit:GetName() ~= L.Unit_Maimbot_R4 then
			ui.category = "wotwChampion"
		end
	end	
end

function Perspective:UpdateHarvest(ui, unit)
	local skill = unit:GetHarvestRequiredTradeskillName()
	local category
	
	if not unit:IsDead() then
		if skill == L.Tradeskill_Farmer then
			category = "farmer"
		elseif skill == L.Tradeskill_Mining then
			category = "miner"
		elseif skill == L.Tradeskill_Relic_Hunter then
			category = "relichunter"
		elseif skill == L.Tradeskill_Survivalist then
			category = "survivalist" 
		end
		
		if category and not Options.db.profile[Options.profile].categories[category].disabled then
			ui.category = category
		end
	end
end

function Perspective:UpdatePickup(ui, unit)
	if string.find(unit:GetName(), GameLib.GetPlayerUnit():GetName()) and
		not Options.db.profile[Options.profile].categories.subdue.disabled then
		ui.category = "subdue"
	end
end

function Perspective:UpdateLoot(ui, unit)
	local loot = unit:GetLoot()

	if loot and 
		loot.eLootItemType and 
		loot.eLootItemType == 6 and
		not Options.db.profile[Options.profile].categories.questLoot.disabled then
		category = "questLoot"
	end
end

function Perspective:IsUnitBusy(unit)
	local state = unit:GetActivationState()

	if state.Busy and state.Busy.bIsActive then 
		return true 
	else
		return false
	end
end

function Perspective:UpdateActivationState(ui, unit)
	if not unit:IsValid() then return false end

	local state = unit:GetActivationState()

	-- The unit is busy, nothing to do here
	if state.Busy and state.Busy.bIsActive then return end

	local category

	for _, __ in pairs(state) do
		if not ui.hasActivation then
			-- This is an interactive object.
			ui.hasActivation = true
			break;
		end
	end

	for k, v in pairs(activationStates) do
		if state[v.state] and 
			state[v.state].bIsActive and
			not Options.db.profile[Options.profile].categories[v.category].disabled then

			category = v.category

			if v.state == "Datacube" and 
				PlayerPathLib:GetPlayerPathType() == PlayerPathLib.PlayerPathType_Scientist and 
				string.find(unit:GetName(), "DATACUBE:") then
				category = "scientistScans"
			end	

			break
		end
	end

	if not category then
		-- Get the player's path type
		if  PlayerPathLib:GetPlayerPathType() == PlayerPathLib.PlayerPathType_Soldier then
			path = "solider"
		elseif PlayerPathLib:GetPlayerPathType() == PlayerPathLib.PlayerPathType_Settler then
			path = "settler"
		elseif PlayerPathLib:GetPlayerPathType() == PlayerPathLib.PlayerPathType_Scientist then
			path = "scientist"
		elseif PlayerPathLib:GetPlayerPathType() == PlayerPathLib.PlayerPathType_Explorer then
			path = "explorer"
		end

		if state.Collect and 
			state.Collect.bUsePlayerPath and 
			state.Collect.bCanInteract and
			state.Collect.bIsActive then

			if path == "settler" then
				category = "settlerResources"
			else
				category = path
			end

		elseif state.Interact and 
			state.Interact.bUsePlayerPath and 
			state.Interact.bCanInteract and
			state.Interact.bIsActive then
			category = path
		end
	end

	ui.category = category
end

function Perspective:UpdateRewards(ui, unit)
	-- Determines if this unit is a valid quest target
	-- This is used to target specific units for specific quests.
	local function isValidQuestUnit(unit, questId, act)
		-- Default all as valid.
		local isValid = true

		if unit:GetMouseOverType() == "Simple" then
			if unit:GetType() == "NonPlayer" then
				-- Landing Site (Northern Wastes)
				if questId == 7085 and not act.Interact then
					isValid = false
				end
			elseif unit:GetType() == "Simple" or unit:GetType() == "SimpleCollidable" then
				-- ANALYSIS: Crystal Healing (Northern Wastes)
				if questId == 7086 and not act.ScientistRawScannable then
					isValid = false
				-- The Ravenous Grove
				elseif questId == 6762 and not act.Interact then
					isValid = false
				end
			end
		elseif unit:GetType() == "NonPlayer" then
			if unit:IsDead() then
				isValid = false
			end
		end

		return isValid
	end

	local function isValidChallengeUnit(unit, challengeId)
		-- Default all as valid.
		local isValid = true

		if unit:GetType() == "NonPlayer" then
			if unit:IsDead() then
				isValid = false
			end
		end

		return isValid
	end

	local uType = unit:GetType()

	-- Make sure the unit will actually have a reward.
	if type == "Player" or
		type == "Harvest" or
		type == "Pickup" or
		type == "InstancePortal" or
		unit:GetLoot() or
		not unit:IsValid() then
		return false
	end

	-- Track the quests, challenges, and scans for the unit info.
	ui.hasQuest = false
	ui.hasChallenge = false
	ui.hasScan = false
	ui.quests = {}
	ui.challenges = {}

	-- Gets the rewards (quest, challenge, scans) for the unit.
	local ri = unit:GetRewardInfo()
	local i = 0

	if ri and type(ri) == "table" then
		-- Gets the activation state for the unit.
		local act = unit:GetActivationState()

		for i = 1, #ri do
			local type = ri[i].strType
			
			if type == "Quest" then				
				-- Get the quest id
				local questId = ri[i].idQuest

				if isValidQuestUnit(unit, questId, act) then
					-- Add the quest id to the ui quest list
					ui.quests[questId] = true

					ui.hasQuest = true
				end
			elseif type == "Challenge" then
				-- Get the challenge id
				local challengeId = ri[i].idChallenge

				-- Make sure we are actively on the challenge
				if self.challenges[challengeId] and
					isValidChallengeUnit(unit, challengeId) then
					-- Add the challenge id to the ui challenge list
					ui.challenges[challengeId] = true

					ui.hasChallenge = true
				end
			elseif type == "Scientist" and 
				ri[i].pmMission and
				not ri[i].pmMission:IsComplete() then
				-- Scan mission objective.
				ui.hasScan = true
			end
		end
	end

	-- No rewards, lets check for fixes.
	if i == 0 then
		-- Challenge fixes by name.
		if Options.db.profile[Options.profile].challengeUnits[unit:GetName()] then
			local challengeId = Options.db.profile[Options.profile].challengeUnits[unit:GetName()].challenge

			if self.challenges[challengeId] and isValidChallengeUnit(unit, challengeId) then
				ui.hasChallenge = true
				ui.challenges[challengeId] = true
			end
		end
	end

	return true
end