
require "Apollo"

local PerspectiveLocale = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:NewAddon("PerspectiveLocale", true)

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
			["Ship to Crimson Isles"] = true,
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