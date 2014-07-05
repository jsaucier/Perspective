
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
	local locale = {
		[""] = true,
		["Please select a target first."] = true,
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
		["Show Name"] = true,
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
		["Focus"] = true,
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
		["Captain Karaka"] = true,
		["Captain Mazonia"] = true,
		["Captain Pallas"] = true,
		["Captain Cryzin"] = true,
		["Captain Petronia"] = true,
		["Captain Visia"] = true,
		["Captain Zanaar"] = true,
		["Servileia Uticeia"] = true,
		["Ship to Thayd"] = true,
		["Ship to Crimson Badlands"] = true,
		["Ship to Grimvault"] = true,
		["Ship to Farside"] = true,
		["Ship to Whitevale"] = true,
		["Ship to Northern Wastes"] = true,
		["Ship to Wilderrun"] = true,
		["Ship to Malgrave"] = true,
		["Ship to Ilium"] = true,
		["Food Table"] = true,
		["Butcher Block"] = true,
		["Tanning Rack"] = true,
		["The Malgrave Trail"] = true,
		["Water"] = true,
		["Caravan Member"] = true,
		["Food"] = true,
		["Feed"] = true,
		["Enemy"] = true,
		["Chompacabras"] = true,
		["Dustback Gnawer"] = true,
		["Dustback Gnasher"] = true,
		["Roving Chompacabra"] = true,
		["Water Barrel"] = true,
		["Invisible Water Dowsing Unit"] = true,
		["Cheese"] = true,
		["Chicken"] = true,
		["Roan Steak"] = true,
		["Fruit"] = true,
		["Food Crate"] = true,
		["Large Feed Sack"] = true,
		["Feed Sack"] = true,
		["Medical Grenade"] = true,
		["Bug Bomb"] = true,
		["Cactus Fruit"] = true,
		["Hay Bale"] = true,
		["Main Tank"] = true,
		["Main Assist"] = true,
		["Tank"] = true,
		["Healer"] = true,
		["DPS"] = true,
		["Unknown"] = true,
	}

	local cancel = Apollo.GetString(1);

	if cancel == "Abbrechen" then 		
		-- German
		locale["Energy Node"] = "Energieknoten"
		locale["Moodie Totem"] = "Moodietotem"
		locale["Skeech Totem"] = "Skeechtotem"
		locale["Crimelords of Whitevale"] = "Unterweltbosse von Weißtal"
		locale["Return Teleporter"] = "Rückkehrteleporter"
		locale["Lilly Startaker"] = "Lilly Sterngreifer"
		locale["Transportation Expert Conner"] = "Transportexpertin Conner"
		locale["Warrant Officer Burke"] = "Stabsfeldwebel Burke"
		locale["Venyanna Skywind"] = "Venyanna Himmelswind"
		locale["Police Patrolman"] = "Polizeistreife"
		locale["Police Constable"] = "Wachtmeisterin"
		locale["Butcher Block"] = "Metzgerblock"
		locale["Tanning Rack"] = "Gerbeständer"
		locale["Food Table"] = "Esstisch"
		locale["The Malgrave Trail"] = "Der Jochgrab-Pfad"
		locale["Water"] = "Wasser"
		locale["Caravan Member"] = "Karawanenmitglied"
		locale["Feed"] = "Futter"
		locale["Dustback Gnawer"] = "Staubrücken-Kauer"
		locale["Dustback Gnasher"] = "Staubrücken-Knirscher"
		locale["Roving Chompacabra"] = "Umherziehender Chompacabra"
		locale["Water Barrel"] = "Wasserfass"
		locale["Cheese"] = "Käse"
		locale["Chicken"] = "Huhn"
		locale["Roan Steak"] = "Roonsteak"
		locale["Fruit"] = "Obst"
		locale["Food Crate"] = "Lebensmittelkiste"
		locale["Large Feed Sack"] = "Großer Futtersack"
		locale["Feed Sack"] = "Futtersack"
		locale["Medical Grenade"] = "Medizinische Granate"
		locale["Bug Bomb"] = "Käferbombe"
		locale["Cactus Fruit"] = "Kaktusfrucht"
		locale["Hay Bale"] = "Heuballen"
	elseif cancel == "Annuler" then 	
		-- French
		locale[""] = ""
		locale["Energy Node"] = "Terminal d'énergie"
		locale["Moodie Totem"] = "Totem moodie"
		locale["Skeech Totem"] = "Totem skeech"
		locale["Crimelords of Whitevale"] = "Les Barons du crime de Valblanc"
		locale["Return Teleporter"] = "Téléporteur de retour"
		locale["Transportation Expert Conner"] = "Experte en transport Conner"
		locale["Warrant Officer Burke"] = "Adjudant Burke"
		locale["Venyanna Skywind"] = "Venyanna Ailecéleste"
		locale["Police Patrolman"] = "Policier en patrouille"
		locale["Police Constable"] = "Agent de police"
		locale["Butcher Block"] = "Bloc de boucher"
		locale["Tanning Rack"] = "Atelier de tanneur"
		locale["Food Table"] = "Buffet"
		locale["The Malgrave Trail"] = "La Piste de Maltombe"
		locale["Water"] = "Eau"
		locale["Caravan Member"] = "Membre de la caravane"
		locale["Feed"] = "Nourriture"
		locale["Dustback Gnawer"] = "Rongeur ocredos"
		locale["Dustback Gnasher"] = "Croqueur ocredos"
		locale["Roving Chompacabra"] = "Chompacabra en maraude"
		locale["Water Barrel"] = "Baril d'eau"
		locale["Cheese"] = "Fromage"
		locale["Chicken"] = "Poulet"
		locale["Roan Steak"] = "Steak de Roan"
		locale["Fruit"] = "Fruit"
		locale["Food Crate"] = "Caisse de nourriture"
		locale["Large Feed Sack"] = "Grand sac de nourriture"
		locale["Feed Sack"] = "Sac de nourriture"
		locale["Medical Grenade"] = "Médi-grenade"
		locale["Bug Bomb"] = "Bombe insecticide"
		locale["Cactus Fruit"] = "Fruit de cactus"
		locale["Hay Bale"] = "Botte de foin"
	end

	for k, v in pairs(locale) do
		locale[k] = v == true and k or v
	end

	return locale
end