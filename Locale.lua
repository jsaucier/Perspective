
require "Apollo"

local PerspectiveLocale = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:NewAddon("PerspectiveLocale", false)

function PerspectiveLocale:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self 

	return o
end

function PerspectiveLocale:OnInitialize()
	self.locale = self:LoadLocalization()
end

function PerspectiveLocale:OnEnable()
	if Apollo.GetAddon("Rover") then
		SendVarToRover("PerspectiveLocale", self)
	end
end

function PerspectiveLocale:LoadLocalization()
	local cancel = Apollo.GetString(1);
	local locale = {}

	if cancel == "Abbrechen" then 		-- German
		locale = {}
	elseif cancel == "Annuler" then 	-- French
		locale = {}
	else 								-- English
		locale = {
			["All"] = true,
			["Set All"] = true,
			["Target"] = true,
			["Miscellaneous"] = true,
			["Player"] = true,
			["Group"] = true,
			["Guild"] = true,
			["NPC"] = true,
			["Friendly Normal"] = true,
			["Friendly Prime"] = true,
			["Friendly Elite"] = true,
			["Neutral Normal"] = true,
			["Neutral Prime"] = true,
			["Neutral Elite"] = true,
			["Hostile Normal"] = true,
			["Hostile Prime"] = true,
			["Hostile Elite"] = true,
			["Quest"] = true,
			["Objective"] = true,
			["Start"] = true,
			["Talk To"] = true,
			["Complete"] = true,
			["Quest Location"] = true,
			["Event Location"] = true,
			["Challenge"] = true,
			["Challenge Location"] = true,
			["Harvest"] = true,
			["Farmer"] = true,
			["Miner"] = true,
			["Relic Hunter"] = true,
			["Survivalist"] = true,
			["Travel"] = true,
			["Flight Path"] = true,
			["Portal"] = true,
			["Bind Point"] = true,
			["Town"] = true,
			["Commodities Exchange"] = true,
			["Auction House"] = true,
			["Mailbox"] = true,
			["Vendor"] = true,
			["Crafting Station"] = true,
			["Tradeskill Trainer"] = true,
			["Appearance Modifier"] = true,
			["Bank"] = true,
			["Dungeon"] = true,
			["Lore"] = true,
			["Path"] = true,
			["Mission Location"] = true,
			["Scientist"] = true,
			["Scientist Scans"] = true,
			["Soldier"] = true,
			["Settler"] = true,
			["Settler Resources"] = true,
			["Explorer"] = true,
			["Loot"] = true,
			["Weapon Subdue"] = true,
			["Miscellaneous"] = true,
			["War of the Wilds"] = true,
			["Enemy Champion"]		 = true,	
			["Energy Node"] = true,
			["Moodie Totem"] = true,
			["Skeech Totem"] = true,
			["Crimelords of Whitevale"] = true,
			["Police"] = true,
			["Bruxen"] = true,
			["Return Teleporter"] = true,
			["Gus Oakby"] = true,
			["Lilly Startaker"] = true,
			["Transportation Expert Conner"] = true,
			["Warrant Officer Burke"] = true,
			["Empirius"] = true,
			["Sagittaurus"] = true,
			["Lectro"] = true,
			["Krule"] = true,
			["Zappo"] = true,
			["Ignacio"] = true,
			["Police Patrolman"] = true,
			["Police Constable"] = true,
			["Ship to Thayd"] = true,
			["Ship to Crimson Badlands"] = true,
			["Ship to Grimvault"] = true,
			["Ship to Farside"] = true,
			["Ship to Whitevale"] = true,
		}

		for k, v in pairs(locale) do
			locale[k] = k
		end
	end

	return locale
end