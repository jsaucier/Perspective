
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
			[""] = true,
			["Module"] = true,
			["Edit the module for this category."] = true,
			["Disable"] = true,
			["Disable this category."] = true,
			["Hide When In Combat"] = true,
			["Hide this category while in combat."] = true,
			["Hide When Occluded"] = true,
			["Hide this category whhen it is occluded."] = true,
			["Show Icon"] = true,
			["Show the icon for this category."] = true,
			["Show Namee"] = true,
			["Show the name for this category."] = true,
			["Show Distance"] = true,
			["Show the distance for this category."] = true,
			["Show Lines"] = true,
			["Show the line to this cateogry."] = true,
			["Show Line Outline"] = true,
			["Show the outline of the line to this category."] = true,
			["Show Lines Offscreen"] = true,
			["Show the line to this category even it is offscreen."] = true,
			["Color Font By Range Color"] = true,
			["Use the range color for the font color."] = true,
			["Color Icon By Range Color"] = true,
			["Use the range color for the icon color."] = true,
			["Color Line By Range Color"] = true,
			["Use the range color for the line color."] = true,
			["Display As"] = true,
			["Set a display name to be used instead of the unit's name."] = true,
			["Icon"] = true,
			["Set the icon to be displayed for this category."] = true,
			["Icon Height"] = true,
			["Set the icon height for this category."] = true,
			["Icon Width"] = true,
			["Set the icon width for this category."] = true,
			["Min Distance"] = true,
			["Set the minimium distance for which to show this category."] = true,
			["Max Distance"] = true,
			["Set the maximium distance for which to show this category."] = true,
			["Z Distance"] = true,
			["Set the maximium vertical distance for which to show this category."] = true,
			["Line Width"] = true,
			["Set the line width for the category."] = true,
			["Limit Icons"] = true,
			["Set the maximium limit of icons to be displayed on screen at once."] = true,
			["Limit Lines"] = true,
			["Set the maximium limit of lines to be displayed on screen at once."] = true,
			["Range Limit"] = true,
			["Set the range limit for this category.  This can be used to determine if your skills are in range of certain targets."] = true,
			["Font Color"] = true,
			["Set the font color for this category."] = true,
			["Icon Color"] = true,
			["Set the icon color for this category."] = true,
			["Line Color"] = true,
			["Set the line color for this category."] = true,
			["Range Color"] = true,
			["Set the range color for this category."] = true,
			["Back"] = true,
			["Back to the categories list view."] = true,
			["Delete"] = true,
			["Delete this category."] = true,
			["Default"] = true,
			["Reset this category to the default settings."] = true,
			["Default ALL"] = true,
			["Reset ALL addon settings back to the defaults."] = true,
			["Settings"] = true,
			["Categories"] = true,
			["All"] = true,
			["Set All"] = true,
			["Target"] = true,
			["Miscellaneous"] = true,
			["Player"] = true,
			["Group"] = true,
			["Guild"] = true,
			["Exile"] = true,
			["Dominion"] = true,
			["Friend"] = true,
			["Rival"] = true,
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
			["Tanxox"] = true,
			["Return Teleporter"] = true,
			["Gus Oakby"] = true,
			["Lilly Startaker"] = true,
			["Transportation Expert Conner"] = true,
			["Warrant Officer Burke"] = true,
			["Venyanna Skywind"] = true,
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
			["Ship to Northern Wastes"] = true,
			["Food Table"] = true,
			["Butcher Block"] = true,
			["Tanning Rack"] = true,
		}

		for k, v in pairs(locale) do
			locale[k] = k
		end
	end

	return locale
end