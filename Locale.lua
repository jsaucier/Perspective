
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
	local locale = {}

	-- Category Titles
	locale.Category_Set_All 						= "Set All"
	locale.Category_Custom_Unit 					= "Custom Unit"

	locale.Category_Misc_Target 					= "Target"
	locale.Category_Misc_Focus 						= "Focus"
	locale.Category_Misc_Lore 						= "Lore"
	locale.Category_Misc_Weapon_Subdue 				= "Weapon Subdue"

	locale.Category_Player_Group 					= "Group"
	locale.Category_Player_Raid 					= "Raid"
	locale.Category_Player_Guild 					= "Guild"
	locale.Category_Player_Exile 					= "Exile"
	locale.Category_Player_Dominion 				= "Dominion"
	locale.Category_Player_Friend 					= "Friend"
	locale.Category_Player_Rival					= "Rival"
	locale.Category_Player_Main_Tank 				= "Main Tank"
	locale.Category_Player_Main_Assist 				= "Main Assist"
	locale.Category_Player_Tank 					= "Tank"
	locale.Category_Player_Healer 					= "Healer"
	locale.Category_Player_DPS						= "DPS"

	locale.Category_NPC_Friendly_Normal 			= "Friendly Normal"
	locale.Category_NPC_Friendly_Prime 				= "Friendly Prime"
	locale.Category_NPC_Friendly_Elite 				= "Friendly Elite"
	locale.Category_NPC_Neutral_Normal				= "Neutral Normal"
	locale.Category_NPC_Neutral_Prime 				= "Neutral Prime"
	locale.Category_NPC_Neutral_Elite 				= "Neutral Elite"
	locale.Category_NPC_Hostile_Normal 				= "Hostile Normal"
	locale.Category_NPC_Hostile_Prime 				= "Hostile Prime"
	locale.Category_NPC_Hostile_Elite 				= "Hostile Elite"

	locale.Category_Quest_Objective 				= "Objective"
	locale.Category_Quest_Interactable 				= "Interactable"
	locale.Category_Quest_Start 					= "Start"
	locale.Category_Quest_TalkTo 					= "Talk To"
	locale.Category_Quest_Complete 					= "Complete"
	locale.Category_Quest_Location 					= "Quest Location"
	locale.Category_Event_Location 					= "Event Location"
	locale.Category_Quest_Loot 						= "Quest Loot"

	locale.Category_Challenge_Location 				= "Challenge Location"
	locale.Category_Challenge_Objective 			= "Objective"

	locale.Category_Harvest_Farmer 					= "Farmer"
	locale.Category_Harvest_Mining 					= "Mining"
	locale.Category_Harvest_Relic_Hunter 			= "Relic Hunter"
	locale.Category_Harvest_Survivalist 			= "Survivalist"
	locale.Category_Harvest_Food_Table 				= "Food Table"
	locale.Category_Harvest_Butcher_Block 			= "Butcher Block"
	locale.Category_Harvest_Tanning_Rack 			= "Tanning Rack"
	locale.Category_Harvest_Harvestable 			= "Harvestable"

	locale.Category_Travel_Taxi 					= "Taxi"
	locale.Category_Travel_Portal 					= "Portal"
	locale.Category_Travel_Bind_Point 				= "Bind Point"
	locale.Category_Travel_Dungeon 					= "Dungeon"
	locale.Category_Town_Commodities_Exchange 		= "Commodities Exchange"
	locale.Category_Town_Auction_House 				= "Auction House"
	locale.Category_Town_Mailbox 					= "Mailbox"
	locale.Category_Town_Vendor 					= "Vendor"
	locale.Category_Town_Crafting_Station 			= "Crafting Station"
	locale.Category_Town_Engraving_Station 			= "Engraving Station"
	locale.Category_Town_Tradeskill_Trainer 		= "Tradeskill Trainer"
	locale.Category_Town_Appearance_Modifier 		= "Dye"
	locale.Category_Town_Bank 						= "Bank"
	locale.Category_Town_Guild_Bank 				= "Guild Bank"
	locale.Category_Town_Guild_Registrar 			= "Guild Registrar"
	locale.Category_Town_City_Guard 				= "Guard"

	locale.Category_Path_Mission_Location 			= "Mission Location"
	locale.Category_Path_Scientist 					= "Scientist"
	locale.Category_Path_Scientist_Scans 			= "Scientist Scans"
	locale.Category_Path_Soldier 					= "Soldier"
	locale.Category_Path_Settler 					= "Settler"
	locale.Category_Path_Settler_Resources 			= "Settler Resources"
	locale.Category_Path_Explorer 					= "Explorer"

	locale.Category_WotW_Enemy_Champion 			= "Champions"
	locale.Category_WotW_Energy_Node 				= "Energy Node"
	locale.Category_WotW_Moodie_Totem 				= "Moodie Totem"
	locale.Category_WotW_Skeech_Totem 				= "Skeech Totem"

	locale.Category_Crimelords_Police 				= "Police"

	locale.Category_Malgrave_Water 					= "Water"
	locale.Category_Malgrave_Caravan_Member 		= "Caravan Member"
	locale.Category_Malgrave_Food 					= "Food"
	locale.Category_Malgrave_Feed 					= "Feed"
	locale.Category_Malgrave_Enemy 					= "Special Enemies"
	locale.Category_Malgrave_Cactus_Fruit 			= "Cactus Fruit"
	locale.Category_Malgrave_Medical_Grenade 		= "Medical Grenade"
	locale.Category_Malgrave_Bug_Bomb 				= "Bug Bomb"

	--Module titles
	locale.Module_All 								= "All"
	locale.Module_Misc 								= "Miscellaneous"
	locale.Module_Player 							= "Player"
	locale.Module_NPC 								= "NPC"
	locale.Module_Quest 							= "Quest"
	locale.Module_Challenge 						= "Challenge"
	locale.Module_Harvest 							= "Harvest"
	locale.Module_Misc								= "Miscellaneous"
	locale.Module_Travel 							= "Travel"
	locale.Module_Town 								= "Town"
	locale.Module_Path								= "Path"
	locale.Module_WotW 								= "War of the Wilds"
	locale.Module_Crimelords 						= "Crimelords of Whitevale"
	locale.Module_Malgrave 							= "The Malgrave Trail"
	locale.Module_Custom							= "Custom"

	locale.Unit_Custom								= "Custom"
	-- Unit names (do not translate as these come from the game client)
	locale.Unit_Food_Table 							= "Food Table"
	locale.Unit_Butcher_Block 						= "Butcher Block"
	locale.Unit_Tanning_Rack 						= "Tanning Rack"
	locale.Unit_Energy_Node 						= "Energy Node"
	locale.Unit_Moodie_Totem 						= "Moodie Totem"
	locale.Unit_Skeech_Totem 						= "Skeech Totem"
	locale.Unit_Caravan_Member						= "Caravan Member"
	locale.Unit_Cactus_Fruit 						= "Cactus Fruit"
	locale.Unit_Medical_Grenade 					= "Medical Grenade"
	locale.Unit_Bug_Bomb 							= "Bug Bomb"
	locale.Unit_Return_Teleporter 					= "Return Teleporter"
	locale.Unit_Bruxen 								= "Bruxen"						
	locale.Unit_Tanxox 								= "Tanxox"						
	locale.Unit_Gus_Oakby						 	= "Gus Oakby"					
	locale.Unit_Lilly_Startaker					 	= "Lilly Startaker"				
	locale.Unit_Transportation_Expert_Conner 		= "Transportation Expert Conner"	
	locale.Unit_Warrant_Officer_Burke 				= "Warrant Officer Burke"		
	locale.Unit_Venyanna_Skywind 					= "Venyanna Skywind"				
	locale.Unit_Captain_Karaka 						= "Captain Karaka"				
	locale.Unit_Captain_Cryzin 						= "Captain Cryzin"				
	locale.Unit_Captain_Petronia 					= "Captain Petronia"				
	locale.Unit_Captain_Visia 						= "Captain Visia"				
	locale.Unit_Captain_Zanaar 						= "Captain Zanaar"				
	locale.Unit_Servileia_Uticeia 					= "Servileia Uticeia"			
	locale.Unit_Maimbot_R4 							= "Maimbot R4"
	locale.Unit_Police_Patrolman 					= "Police Patrolman"				
	locale.Unit_Police_Constable 					= "Police Constable"				
	locale.Unit_Water 								= "Water"						
	locale.Unit_Water_Barrel 						= "Water Barrel"					
	locale.Unit_Invisible_Water_Dowsing_Unit 		= "Invisible Water Dowsing Unit"	
	locale.Unit_Cheese								= "Cheese"						
	locale.Unit_Chicken								= "Chicken"						
	locale.Unit_Roan_Steak							= "Roan Steak"					
	locale.Unit_Fruit								= "Fruit"						
	locale.Unit_Food_Crate							= "Food Crate"					
	locale.Unit_Large_Feed_Sack						= "Large Feed Sack"				
	locale.Unit_Feed_Sack 							= "Feed Sack"					
	locale.Unit_Hay_Bale 							= "Hay Bale"						
	locale.Unit_Roving_Chompacabra 					= "Roving Chompacabra"			
	locale.Unit_Dustback_Gnasher 					= "Dustback Gnasher"				
	locale.Unit_Dustback_Gnawer 					= "Dustback Gnawer"
	locale.Unit_Roan_Skull 							= "Roan Skull"
	locale.Unit_Walatiki_Totem_Dominion				= "Dominion Moodie Totem"
	locale.Unit_Walatiki_Totem_Exile				= "Exile Moodie Totem"
	locale.Unit_Walatiki_Mask 						= "Moodie Mask"
	locale.Unit_Walatiki_Mask_Dominion				= "Dominion Moodie Mask"
	locale.Unit_Walatiki_Mask_Exile					= "Exile Moodie Mask"
	locale.Unit_Datacube							= "DATACUBE"
	locale.Unit_Shipwrecked_Victim					= "Shipwrecked Victim"

	-- Buffs, dont change
	locale.Debuff_Moodie_Mask_Neutral				= "Neutral - Moodie Mask Carrier"
	locale.Debuff_Moodie_Mask_Dominion				= "Dominion Moodie Mask Carrier"
	locale.Debuff_Moodie_Mask_Exile					= "Exile Moodie Mask Carrier"

	-- Trade skill names (do not translate as these come from the game client)
	locale.Tradeskill_Farmer 						= "Farmer"
	locale.Tradeskill_Mining 						= "Mining"
	locale.Tradeskill_Relic_Hunter 					= "Relic Hunter"
	locale.Tradeskill_Survivalist 					= "Survivalist"

	-- Unit Display As Strings
	locale.Unit_Travel_Thayd 						= "Ship to Thayd"
	locale.Unit_Travel_Crimson_Badlands 			= "Ship to Crimson Badlands"
	locale.Unit_Travel_Grimvault 					= "Ship to Grimvault"
	locale.Unit_Travel_Farside 						= "Ship to Farside"
	locale.Unit_Travel_Whitevale 					= "Ship to Whitevale"
	locale.Unit_Travel_Northern_Wastes 				= "Ship to Northern Wastes"
	locale.Unit_Travel_Wilderrun 					= "Ship to Wilderrun"
	locale.Unit_Travel_Malgrave 					= "Ship to Malgrave"
	locale.Unit_Travel_Ilium 						= "Ship to Ilium"

	-- UI General Strings
	locale.UI_Options_Tooltip_Action				= "Press enter to save your value."

	-- UI Options Buttons
	locale.UI_Options_NewButton_Text 				= "New Category"
	locale.UI_Options_NewButton_Tooltip 			= "Create a new category."
	locale.UI_Options_DefaultButton_Text 			= "Default ALL"
	locale.UI_Options_DefaultButton_Tooltip 		= "Right click to reset ALL addon settings back to the defaults."
	locale.UI_Options_ExportButton_Text 			= "Export"
	locale.UI_Options_ExportButton_Tooltip 			= "Export your current settings."
	locale.UI_Options_ImportButton_Text 			= "Import"
	locale.UI_Options_ImportButton_Tooltip 			= "Import settings from another character."
	locale.UI_Options_CategoriesCheck_Text 			= "Categories"
	locale.UI_Options_SettingsCheck_Text 			= "Settings"

	-- UI Editor Check Buttons
	locale.UI_Editor_DisableCheck_Text 				= "Disable"
	locale.UI_Editor_DisableCheck_Tooltip 			= "Disable this category."
	locale.UI_Editor_CombatDisableCheck_Text 		= "Hide When In Combat"
	locale.UI_Editor_CombatDisableCheck_Tooltip 	= "Hide this category while in combat."
	locale.UI_Editor_OccludedDisableCheck_Text 		= "Hide When Occluded"
	locale.UI_Editor_OccludedDisableCheck_Tooltip 	= "Hide this category whhen it is occluded."
	locale.UI_Editor_ShowIconCheck_Text 			= "Show Icon"
	locale.UI_Editor_ShowIconCheck_Tooltip 			= "Show the icon for this category."
	locale.UI_Editor_ShowNameCheck_Text 			= "Show Name"
	locale.UI_Editor_ShowNameCheck_Tooltip 			= "Show the name for this category."
	locale.UI_Editor_ShowDistanceCheck_Text 		= "Show Distance"
	locale.UI_Editor_ShowDistanceCheck_Tooltip 		= "Show the distance for this category."
	locale.UI_Editor_ShowLinesCheck_Text 			= "Show Lines"
	locale.UI_Editor_ShowLinesCheck_Tooltip 		= "Show the line to this cateogry."
	locale.UI_Editor_ShowOutlineCheck_Text 			= "Show Line Outline"
	locale.UI_Editor_ShowOutlineCheck_Tooltip 		= "Show the outline of the line to this category."
	locale.UI_Editor_ShowOffScreenLineCheck_Text 	= "Show Lines Offscreen"
	locale.UI_Editor_ShowOffScreenLineCheck_Tooltip = "Show the line to this category even it is offscreen."
	locale.UI_Editor_RangeFontCheck_Text 			= "Color Font By Range Color"
	locale.UI_Editor_RangeFontCheck_Tooltip	 		= "Use the range color for the font color."
	locale.UI_Editor_RangeIconCheck_Text 			= "Color Icon By Range Color"
	locale.UI_Editor_RangeIconCheck_Tooltip 		= "Use the range color for the icon color."
	locale.UI_Editor_RangeLineCheck_Text 			= "Color Line By Range Color"
	locale.UI_Editor_RangeLineCheck_Tooltip 		= "Use the range color for the line color."

	-- UI Editor Textboxes
	locale.UI_Editor_ModuleText_Text				= "Module"
	locale.UI_Editor_ModuleText_Tooltip 			= "Edit the module for this category."
	locale.UI_Editor_DisplayText_Text				= "Display As"
	locale.UI_Editor_DisplayText_Tooltip 			= "Set a display name to be used instead of the unit's name."
	locale.UI_Editor_IconText_Text					= "Icon"
	locale.UI_Editor_IconText_Tooltip 				= "Set the icon to be displayed for this category."
	locale.UI_Editor_IconHeightText_Text			= "Icon Height"
	locale.UI_Editor_IconHeightText_Tooltip 		= "Set the icon height for this category."
	locale.UI_Editor_IconWidthText_Text				= "Icon Width"
	locale.UI_Editor_IconWidthText_Tooltip 			= "Set the icon width for this category."
	locale.UI_Editor_MinDistanceText_Text			= "Min Distance"
	locale.UI_Editor_MinDistanceText_Tooltip 		= "Set the minimium distance for which to show this category."
	locale.UI_Editor_MaxDistanceText_Text			= "Max Distance"
	locale.UI_Editor_MaxDistanceText_Tooltip 		= "Set the maximium distance for which to show this category."
	locale.UI_Editor_ZDistanceText_Text				= "Z Distance"
	locale.UI_Editor_ZDistanceText_Tooltip 			= "Set the maximium vertical distance for which to show this category."
	locale.UI_Editor_LineWidthText_Text				= "Line Width"
	locale.UI_Editor_LineWidthText_Tooltip 			= "Set the line width for the category."
	locale.UI_Editor_MaxIconsText_Text				= "Limit Icons"
	locale.UI_Editor_MaxIconsText_Tooltip 			= "Set the maximium limit of icons to be displayed on screen at once."
	locale.UI_Editor_MaxLinesText_Text				= "Limit Lines"
	locale.UI_Editor_MaxLinesText_Tooltip 			= "Set the maximium limit of lines to be displayed on screen at once."
	locale.UI_Editor_RangeLimitText_Text			= "Range Limit"
	locale.UI_Editor_RangeLimitText_Tooltip 		= "Set the range limit for this category.  This can be used to determine if your skills are in range of certain targets."

	-- UI Editor Color Buttons
	locale.UI_Editor_FontColor_Text					= "Font Color"
	locale.UI_Editor_FontColor_Tooltip 				= "Set the font color for this category."
	locale.UI_Editor_IconColor_Text					= "Icon Color"
	locale.UI_Editor_IconColor_Tooltip 				= "Set the icon color for this category."
	locale.UI_Editor_LineColor_Text					= "Line Color"
	locale.UI_Editor_LineColor_Tooltip 				= "Set the line color for this category."
	locale.UI_Editor_RangeColor_Text				= "Range Color"
	locale.UI_Editor_RangeColor_Tooltip 			= "Set the range color for this category."

	-- UI Editor Buttons
	locale.UI_Editor_BackButton_Text				= ""
	locale.UI_Editor_BackButton_Tooltip 			= "Back to the categories list view."
	locale.UI_Editor_DeleteButton_Text				= "Delete"
	locale.UI_Editor_DeleteButton_Tooltip 			= "Delete this category."
	locale.UI_Editor_DefaultButton_Text				= "Default"
	locale.UI_Editor_DefaultButton_Tooltip 			= "Reset this category to the default settings."

	-- UI Dialog Titles
	locale.UI_Dialog_Options						= "Perspective Options"
	locale.UI_Dialog_PTI_Header						= "Perspective Target Information"
	locale.UI_Dialog_Export_Header					= "Perspective Settings Export"
	locale.UI_Dialog_Import_Header					= "Perspective Settings Import"

	-- UI Dialog Buttons
	locale.UI_Dialog_PTI_Button_Text				= "Get Current Target"
	locale.UI_Dialog_Close_Button_Text				= "Close"
	
	-- UI Dialog Strings
	locale.UI_Dialog_PTI_Error						= "Please select a target first."

	-- UI Settings Page
	locale.UI_Settings_DisableCheck_Text			= "Disable Perspective"
	locale.UI_Settings_DisableCheck_Tooltip			= "Disabling Perspective turns it completely off but preserves all settings."
	locale.UI_Settings_DrawSlider_Text				= "Redraw Delay Time:"
	locale.UI_Settings_DrawSlider_Tooltip 			= "The amount of time between screen redraws."
	locale.UI_Settings_FastSlider_Text 				= "Update delay at close range"
	locale.UI_Settings_FastSlider_Tooltip			= "The amount of time between updates for units close to the player."
	locale.UI_Settings_SlowSlider_Text 				= "Update delay at long range"
	locale.UI_Settings_SlowSlider_Tooltip			= "The amount of time between updates for units far from the player."

	locale.UI_Settings_MaxUnitsText_Text 			= "Max Units"
	locale.UI_Settings_MaxUnitsText_Tooltip			= "The maximum limit of total icons to that are allowed to be drawn onscreen at once."
	locale.UI_Settings_OffsetCheck_Text	 			= "Offset lines from character"
	locale.UI_Settings_OffsetCheck_Tooltip	 		= "Offsets the lines so they do not overlay on top of your character."




	-- New Stuff as of 2014.7.7
	locale.Module_PVP								= "PVP"

	locale.Category_PVP_Friendly_Engineer			= "Friendly Engineer"
	locale.Category_PVP_Friendly_Warrior			= "Friendly Warrior"
	locale.Category_PVP_Friendly_Stalker			= "Friendly Stalker"
	locale.Category_PVP_Friendly_Medic				= "Friendly Medic"
	locale.Category_PVP_Friendly_Spellslinger		= "Friendly Spellslinger"
	locale.Category_PVP_Friendly_Esper				= "Friendly Esper"

	locale.Category_PVP_Hostile_Engineer			= "Hostile Engineer"
	locale.Category_PVP_Hostile_Warrior				= "Hostile Warrior"
	locale.Category_PVP_Hostile_Stalker				= "Hostile Stalker"
	locale.Category_PVP_Hostile_Medic				= "Hostile Medic"
	locale.Category_PVP_Hostile_Spellslinger		= "Hostile Spellslinger"
	locale.Category_PVP_Hostile_Esper				= "Hostile Esper"
	
	locale.Module_Walatiki							= "Walatiki Temple"

	locale.Category_Walatiki_Mask					= "Neutral Mask"
	locale.Category_Walatiki_Mask_Dominion			= "Dominion Mask"
	locale.Category_Walatiki_Mask_Exile				= "Exile Mask"
	locale.Category_Walatiki_Carrier_Friendly		= "Friendly Carrier"
	locale.Category_Walatiki_Carrier_Hostile		= "Hostile Carrier"
	locale.Category_Walatiki_Totem_Exile	 		= "Exile Totem"
	locale.Category_Walatiki_Totem_Dominion 		= "Dominion Totem"

	-- New Stuff as of 2014.7.8
	locale.Category_Quest_Spell						= "Spell Objective"



	local cancel = Apollo.GetString(1);

	if cancel == "Abbrechen" then 
		-- German

		-- Unit names (do not translate as these come from the game client)
		locale.Unit_Food_Table 						= "Esstisch"
		locale.Unit_Butcher_Block 					= "Metzgerblock"
		locale.Unit_Tanning_Rack 					= "Gerbeständer"
		locale.Unit_Energy_Node 					= "Energieknoten"
		locale.Unit_Moodie_Totem 					= "Moodietotem"
		locale.Unit_Skeech_Totem 					= "Skeechtotem"
		locale.Unit_Caravan_Member 					= "Karawanenmitglied"
		locale.Unit_Cactus_Fruit 					= "Kaktusfrucht"
		locale.Unit_Medical_Grenade 				= "Medizinische Granate"
		locale.Unit_Bug_Bomb 						= "Käferbombe"
		locale.Unit_Return_Teleporter 				= "Rückkehrteleporter"
		--locale.Unit_Bruxen 						= "Bruxen"
		--locale.Unit_Tanxox 						= "Tanxox"
		--locale.Unit_Gus_Oakby 					= "Gus Oakby"
		locale.Unit_Lilly_Startaker 				= "Lilly Sterngreifer"			
		locale.Unit_Transportation_Expert_Conner 	= "Transportexpertin Conner"	
		locale.Unit_Warrant_Officer_Burke 			= "Stabsfeldwebel Burke"	
		locale.Unit_Venyanna_Skywind 				= "Venyanna Himmelswind"
		locale.Unit_Maimbot_R4 						= "Verstümmlerbot R4"
		locale.Unit_Police_Patrolman 				= "Polizeistreife"				
		locale.Unit_Police_Constable 				= "Wachtmeisterin"				
		locale.Unit_Water 							= "Wasser"													
		locale.Unit_Water_Barrel 					= "Karawanenmitglied"					
		--locale.Unit_Invisible_Water_Dowsing_Unit 	= "Invisible Water Dowsing Unit"	
		locale.Unit_Cheese 							= "Käse"						
		locale.Unit_Chicken 						= "Huhn"						
		locale.Unit_Roan_Steak 						= "Roonsteak"					
		locale.Unit_Fruit 							= "Obst"						
		locale.Unit_Food_Crate						= "Lebensmittelkiste"					
		locale.Unit_Large_Feed_Sack 				= "Großer Futtersack"				
		locale.Unit_Feed_Sack 						= "Futtersack"					
		locale.Unit_Hay_Bale 						= "Heuballen"						
		locale.Unit_Roving_Chompacabra 				= "Umherziehender Chompacabra"			
		locale.Unit_Dustback_Gnasher				= "Staubrücken-Knirscher"				
		locale.Unit_Dustback_Gnawer					= "Staubrücken-Kauer"
		locale.Unit_Roan_Skull 						= "Roonschädel"
		locale.Unit_Walatiki_Totem_Dominion			= "Dominion-Moodietotem"
		locale.Unit_Walatiki_Totem_Exile			= "Verbannten-Moodie-Totem"
		locale.Unit_Walatiki_Mask 					= "Maske der Moodie"
		locale.Unit_Walatiki_Mask_Dominion			= "Dominion-Maske der Moodie"
		locale.Unit_Walatiki_Mask_Exile				= "Moodiemaske der Verbannten"
		locale.Unit_Datacube						= "DATENWÜRFEL:"
		locale.Unit_Shipwrecked_Victim				= "Schiffbrüchiger"

		-- Trade skill names (do not translate as these come from the game client)
		locale.Tradeskill_Farmer 					= "Bauer"
		locale.Tradeskill_Mining 					= "Bergbau"
		locale.Tradeskill_Relic_Hunter 				= "Reliktjäger"
		locale.Tradeskill_Survivalist 				= "Überlebenskünstler"

		-- Changes as of 2014.7.7
		locale.Module_Walatiki						= "Walatiki-Tempel"

		-- Not to be changed!


		-- Buffs, dont change
		locale.Debuff_Moodie_Mask_Neutral			= "Neutral – Moodiemaskenträger"
		locale.Debuff_Moodie_Mask_Dominion			= "Dominion-Moodiemasken-Träger"
		locale.Debuff_Moodie_Mask_Exile				= "Exile-Moodiemasken-Träger"


	elseif cancel == "Annuler" then 	

		--Module titles
		locale.Module_All 								= "Tout"
		locale.Module_Misc 								= "Variés"
		locale.Module_Player 							= "Joueurs"
		locale.Module_NPC 								= "NPC"
		locale.Module_Quest 							= "Quêtes"
		locale.Module_Challenge 						= "Défis"
		locale.Module_Harvest 							= "Harvest"
		locale.Module_Travel 							= "Transport & Téléporteurs"
		locale.Module_Town 								= "Villes"
		locale.Module_Path								= "Vocation"
		locale.Module_WotW 								= "War of the Wilds"
		locale.Module_Crimelords 						= "Crimelords of Whitevale"
		locale.Module_Malgrave 							= "The Malgrave Trail"
		locale.Module_Custom							= "Personnalisé"

		-- Category Titles
		locale.Category_Set_All 						= "Configurer Tout"
		locale.Category_Custom_Unit 					= "Unités personnalisées"

		locale.Category_Misc_Target 					= "Cible"
		locale.Category_Misc_Focus 						= "Focus"
		locale.Category_Misc_Lore 						= "Lore"
		locale.Category_Misc_Weapon_Subdue 				= "Arme échappée"

		locale.Category_Player_Group 					= "Groupe"
		locale.Category_Player_Raid 					= "Raid"
		locale.Category_Player_Guild 					= "Guilde"
		locale.Category_Player_Exile 					= "Exilés"
		locale.Category_Player_Dominion 				= "Dominion"
		locale.Category_Player_Friend 					= "Alliés"
		locale.Category_Player_Rival					= "Rivaux"
		locale.Category_Player_Main_Tank 				= "Tank principal"
		locale.Category_Player_Main_Assist 				= "Assistant principal"
		locale.Category_Player_Tank 					= "Tanks"
		locale.Category_Player_Healer 					= "Soigneurs"
		locale.Category_Player_DPS						= "DPS"

		locale.Category_NPC_Friendly_Normal 			= "Allié Normal"
		locale.Category_NPC_Friendly_Prime 				= "Allié Prime"
		locale.Category_NPC_Friendly_Elite 				= "Allié Élite"
		locale.Category_NPC_Neutral_Normal				= "Neutre Normal"
		locale.Category_NPC_Neutral_Prime 				= "Neutre Prime"
		locale.Category_NPC_Neutral_Elite 				= "Neutre Élite"
		locale.Category_NPC_Hostile_Normal 				= "Hostile Normal"
		locale.Category_NPC_Hostile_Prime 				= "Hostile Prime"
		locale.Category_NPC_Hostile_Elite 				= "Hostile Élite"

		locale.Category_Quest_Objective 				= "Objectif"
		locale.Category_Quest_Interactable 				= "Interactif"
		locale.Category_Quest_Start 					= "Début"
		locale.Category_Quest_TalkTo 					= "Parler à"
		locale.Category_Quest_Complete 					= "Compléter"
		locale.Category_Quest_Location 					= "Lieu de Quête"
		locale.Category_Event_Location 					= "Lieu d'Évenement"
		locale.Category_Quest_Loot 						= "Butin de Quête"

		locale.Category_Challenge_Location 				= "Lieu de Défi"
		locale.Category_Challenge_Objective 			= "Objectif"

		locale.Category_Harvest_Farmer 					= "Fermier"
		locale.Category_Harvest_Mining 					= "Mineur"
		locale.Category_Harvest_Relic_Hunter 			= "Chasseur de reliques"
		locale.Category_Harvest_Survivalist 			= "Adepte de la survie"
		locale.Category_Harvest_Food_Table 				= "Buffet"
		locale.Category_Harvest_Butcher_Block 			= "Bloc de boucher"
		locale.Category_Harvest_Tanning_Rack 			= "Atelier de tanneur"
		locale.Category_Harvest_Harvestable 			= "Recueillable"

		locale.Category_Travel_Taxi 					= "Taxi"
		locale.Category_Travel_Portal 					= "Téléporteur"
		locale.Category_Travel_Bind_Point 				= "Terminal de transmat"
		locale.Category_Travel_Dungeon 					= "Donjon"
		locale.Category_Town_Commodities_Exchange 		= "Brocanteur"
		locale.Category_Town_Auction_House 				= "Commissaire-priseur (Encanteur)"
		locale.Category_Town_Mailbox 					= "Boîte aux lettres"
		locale.Category_Town_Vendor 					= "Marchand"
		locale.Category_Town_Crafting_Station 			= "Station d'artisanat"
		locale.Category_Town_Engraving_Station 			= "Poste de gravure"
		locale.Category_Town_Tradeskill_Trainer 		= "Instructeur artisan"
		locale.Category_Town_Appearance_Modifier 		= "Expert coloriste"
		locale.Category_Town_Bank 						= "Banque"
		locale.Category_Town_Guild_Bank 				= "Banque de guilde"
		locale.Category_Town_Guild_Registrar 			= "Officier de guilde"
		locale.Category_Town_City_Guard 				= "Garde"

		locale.Category_Path_Mission_Location 			= "Lieu de mission"
		locale.Category_Path_Scientist 					= "Scientifique"
		locale.Category_Path_Scientist_Scans 			= "Analyse Scientifiques"
		locale.Category_Path_Soldier 					= "Soldat"
		locale.Category_Path_Settler 					= "Colon"
		locale.Category_Path_Settler_Resources 			= "Ressources coloniales"
		locale.Category_Path_Explorer 					= "Explorateur"

		locale.Category_WotW_Enemy_Champion 			= "Champions"
		locale.Category_WotW_Energy_Node 				= "Node d'énergie"
		locale.Category_WotW_Moodie_Totem 				= "Totem Moodie"
		locale.Category_WotW_Skeech_Totem 				= "Totem Skeech"

		locale.Category_Crimelords_Police 				= "Police"

		locale.Category_Malgrave_Water 					= "Eau"
		locale.Category_Malgrave_Caravan_Member 		= "Membre de caravane"
		locale.Category_Malgrave_Food 					= "Nourriture"
		locale.Category_Malgrave_Feed 					= "Feed"
		locale.Category_Malgrave_Enemy 					= "Enemis spéciaux"
		locale.Category_Malgrave_Cactus_Fruit 			= "Fruits de cactus"
		locale.Category_Malgrave_Medical_Grenade 		= "Grenade médicale"
		locale.Category_Malgrave_Bug_Bomb 				= "Bombe à insecte"

		-- Unit Display As Strings
		locale.Unit_Travel_Thayd 						= "Vaisseau pour Thayd"
		locale.Unit_Travel_Crimson_Badlands 			= "Vaisseau pour Terres maudites écarlates"
		locale.Unit_Travel_Grimvault 					= "Vaisseau pour Mornegeôle"
		locale.Unit_Travel_Farside 						= "Vaisseau pour Outre-horizon"
		locale.Unit_Travel_Whitevale 					= "Vaisseau pour Valblanc"
		locale.Unit_Travel_Northern_Wastes 				= "Vaisseau pour Septentrion Sauvage (?)"
		locale.Unit_Travel_Wilderrun 					= "Vaisseau pour Sombreflore"
		locale.Unit_Travel_Malgrave 					= "Vaisseau pour Maltombe"
		locale.Unit_Travel_Ilium 						= "Vaisseau pour Ilium"

		-- UI General Strings
		locale.UI_Options_Tooltip_Action				= "Appuyez sur ENTRÉE pour enregistrer la valeur."

		-- UI Options Buttons
		locale.UI_Options_NewButton_Text 				= "Nouvelle catégorie"
		locale.UI_Options_NewButton_Tooltip 			= "Crée une nouvelle catégorie."
		locale.UI_Options_DefaultButton_Text 			= "RÉINITIALISER"
		locale.UI_Options_DefaultButton_Tooltip 		= "Cliquez avec le bouton de droite pour réinitialiser TOUS les paramètres de Perspective à leurs valeurs par défaut."
		locale.UI_Options_ExportButton_Text 			= "Exporter"
		locale.UI_Options_ExportButton_Tooltip 			= "Exportez votre configuration actuelle."
		locale.UI_Options_ImportButton_Text 			= "Importer"
		locale.UI_Options_ImportButton_Tooltip 			= "Importer la configuration d'un autre personnage."
		locale.UI_Options_CategoriesCheck_Text 			= "Catégories"
		locale.UI_Options_SettingsCheck_Text 			= "Configuration"

		-- UI Editor Check Buttons
		locale.UI_Editor_DisableCheck_Text 				= "Désactiver"
		locale.UI_Editor_DisableCheck_Tooltip 			= "Désactiver cette catégorie."
		locale.UI_Editor_CombatDisableCheck_Text 		= "Cacher pendant le combat"
		locale.UI_Editor_CombatDisableCheck_Tooltip 	= "Cacher cette catégorie pendant le combat."
		locale.UI_Editor_OccludedDisableCheck_Text 		= "Cacher lorsqu'occulté"
		locale.UI_Editor_OccludedDisableCheck_Tooltip 	= "Cacher les objets de cette catégorie lorsqu'elle est occultée (ex: derrière une montagne)."
		locale.UI_Editor_ShowIconCheck_Text 			= "Afficher les icones"
		locale.UI_Editor_ShowIconCheck_Tooltip 			= "Afficher les icones pour les objets de cette catégorie."
		locale.UI_Editor_ShowNameCheck_Text 			= "Afficher les noms"
		locale.UI_Editor_ShowNameCheck_Tooltip 			= "Afficher les noms pour les objets de cette catégorie."
		locale.UI_Editor_ShowDistanceCheck_Text 		= "Afficher les distances"
		locale.UI_Editor_ShowDistanceCheck_Tooltip 		= "Afficher les distances pour les objets de cette catégorie."
		locale.UI_Editor_ShowLinesCheck_Text 			= "Afficher les lignes"
		locale.UI_Editor_ShowLinesCheck_Tooltip 		= "Afficher les lignes pour les objets de cette catégorie."
		locale.UI_Editor_ShowOutlineCheck_Text 			= "Afficher les contours de lignes"
		locale.UI_Editor_ShowOutlineCheck_Tooltip 		= "Afficher les contours de lignes pour cette catégorie."
		locale.UI_Editor_ShowOffScreenLineCheck_Text 	= "Afficher les lignes hors-écran"
		locale.UI_Editor_ShowOffScreenLineCheck_Tooltip = "Afficher les lignes qui mènent à une destination hors-écran."
		locale.UI_Editor_RangeFontCheck_Text 			= "Colorer le texte selon la distrance"
		locale.UI_Editor_RangeFontCheck_Tooltip	 		= "Colorer le texte selon la distrance."
		locale.UI_Editor_RangeIconCheck_Text 			= "Colorer l'icone selon la distance"
		locale.UI_Editor_RangeIconCheck_Tooltip 		= "Colorer l'icone selon la distance."
		locale.UI_Editor_RangeLineCheck_Text 			= "Colorer la ligne selon la distance"
		locale.UI_Editor_RangeLineCheck_Tooltip 		= "Colorer la ligne selon la distance."

		-- UI Editor Textboxes
		locale.UI_Editor_ModuleText_Text				= "Module"
		locale.UI_Editor_ModuleText_Tooltip 			= "Éditez le module de cette catégorie."
		locale.UI_Editor_DisplayText_Text				= "Renommer"
		locale.UI_Editor_DisplayText_Tooltip 			= "Afficher le nom suivant en lieu de nom d'unité."
		locale.UI_Editor_IconText_Text					= "Icone"
		locale.UI_Editor_IconText_Tooltip 				= "Choisissez l'icone à afficher pour les objets de cette catégorie."
		locale.UI_Editor_IconHeightText_Text			= "Hauteur d'icone"
		locale.UI_Editor_IconHeightText_Tooltip 		= "Détermine la hauteur des icones affichés pour les objets de cette catégorie."
		locale.UI_Editor_IconWidthText_Text				= "Largeur d'icone"
		locale.UI_Editor_IconWidthText_Tooltip 			= "Détermine la largeur des icones affichés pour les objets de cette catégorie."
		locale.UI_Editor_MinDistanceText_Text			= "Distance min"
		locale.UI_Editor_MinDistanceText_Tooltip 		= "Les objets en-deça de cette distance ne seront pas affichés."
		locale.UI_Editor_MaxDistanceText_Text			= "Distance max"
		locale.UI_Editor_MaxDistanceText_Tooltip 		= "Les objets au-delà de cette distance ne seront pas affichés."
		locale.UI_Editor_ZDistanceText_Text				= "Distance Z"
		locale.UI_Editor_ZDistanceText_Tooltip 			= "Les objets au-delà de cette distance sur l'axe Z (altitude) ne seront pas affichés."
		locale.UI_Editor_LineWidthText_Text				= "Largeur de ligne"
		locale.UI_Editor_LineWidthText_Tooltip 			= "Détermine la largeur des lignes qui seront dessignées."
		locale.UI_Editor_MaxIconsText_Text				= "Limite d'icones"
		locale.UI_Editor_MaxIconsText_Tooltip 			= "Nombre maximal d'icones à afficher pour cette catégorie."
		locale.UI_Editor_MaxLinesText_Text				= "Limite de lignes"
		locale.UI_Editor_MaxLinesText_Tooltip 			= "Nombre maximal de lignes à dessiner pour cette catégorie."
		locale.UI_Editor_RangeLimitText_Text			= "Distance max"
		locale.UI_Editor_RangeLimitText_Tooltip 		= "Détermine une distance maximale arbitraire, jusqu'à laquelle la couleur de distance sera utilisée."

		-- UI Editor Color Buttons
		locale.UI_Editor_FontColor_Text					= "Couleur du texte"
		locale.UI_Editor_FontColor_Tooltip 				= "Ajuster la couleur du texte pour les objets de cette catégorie."
		locale.UI_Editor_IconColor_Text					= "Couleur des icones"
		locale.UI_Editor_IconColor_Tooltip 				= "Ajuster la couleur des icones pour les objets de cette catégorie."
		locale.UI_Editor_LineColor_Text					= "Couleur des lignes"
		locale.UI_Editor_LineColor_Tooltip 				= "Ajuster la couleur des lignes pour les objets de cette catégorie."
		locale.UI_Editor_RangeColor_Text				= "Couleur de distance"
		locale.UI_Editor_RangeColor_Tooltip 			= "Ajuster la couleur de distance pour les objets de cette catégorie."

		-- UI Editor Buttons
		locale.UI_Editor_BackButton_Text				= ""
		locale.UI_Editor_BackButton_Tooltip 			= "Retour à liste des catégories."
		locale.UI_Editor_DeleteButton_Text				= "Effacer"
		locale.UI_Editor_DeleteButton_Tooltip 			= "Effacer cette catégorie."
		locale.UI_Editor_DefaultButton_Text				= "Défaut"
		locale.UI_Editor_DefaultButton_Tooltip 			= "Rénitialiser cette catégorie aux valeurs par défaut."

		-- UI Dialog Titles
		locale.UI_Dialog_Options						= "Perspective - Options"
		locale.UI_Dialog_PTI_Header						= "Perspective - Information sur la cible"
		locale.UI_Dialog_Export_Header					= "Perspective - Export de profil"
		locale.UI_Dialog_Import_Header					= "Perspective - Import de profil"

		-- UI Dialog Buttons
		locale.UI_Dialog_PTI_Button_Text				= "Obtenir la cible courante"
		locale.UI_Dialog_Close_Button_Text				= "Fermer"
		
		-- UI Dialog Strings
		locale.UI_Dialog_PTI_Error						= "Veuillez d'abord sélectionner une cible."

		-- UI Settings Page
		locale.UI_Settings_DisableCheck_Text			= "Désactiver Perspective"
		locale.UI_Settings_DisableCheck_Tooltip			= "Désactiver Perspective suspend les fonctionnalités mais préserve toutes les options de configuration."
		locale.UI_Settings_DrawSlider_Text				= "Délai minimal avant de redessiner"
		locale.UI_Settings_DrawSlider_Tooltip 			= "Controle le délai minimal avant que les lignes et icones soient redessinnées."
		locale.UI_Settings_FastSlider_Text 				= "Délai de mise à jour à courte portéee"
		locale.UI_Settings_FastSlider_Tooltip			= "Le délai entre les mises à jour aux unités qui sont près du joueur."
		locale.UI_Settings_SlowSlider_Text 				= "Délai de mise à jour à longue portée"
		locale.UI_Settings_SlowSlider_Tooltip			= "Le délai entre les mises à jour aux unités qui sont loin du joueur."
		locale.UI_Settings_MaxUnitsText_Text 			= "Max d'unités"
		locale.UI_Settings_MaxUnitsText_Tooltip			= "Le nombre maximum d'icones qui peuvent être dessinés en même temps à l'écran."
		locale.UI_Settings_OffsetCheck_Text	 			= "Offset lines from character"
		locale.UI_Settings_OffsetCheck_Tooltip			= "Offsets the lines so they do not overlay on top of your character."

--------------------------	
--------------------------	

		-- Unit names (do not translate as these come from the game client)
		locale.Unit_Food_Table 						= "Buffet"
		locale.Unit_Butcher_Block 					= "Bloc de boucher"
		locale.Unit_Tanning_Rack 					= "Atelier de tanneur"
		locale.Unit_Energy_Node 					= "Source d'énergie"
		locale.Unit_Moodie_Totem 					= "Totem moodie"
		locale.Unit_Skeech_Totem 					= "Totem skeech"
		locale.Unit_Caravan_Member					= "Membre de la caravane"
		locale.Unit_Cactus_Fruit 					= "Fruit de cactus"
		locale.Unit_Medical_Grenade 				= "Médi-grenade"
		locale.Unit_Bug_Bomb 						= "Bombe insecticide"
		locale.Unit_Return_Teleporter 				= "Téléporteur de retour"
		--locale.Unit_Bruxen 						= "Bruxen"						
		--locale.Unit_Tanxox 						= "Tanxox"						
		--locale.Unit_Gus_Oakby						= "Gus Oakby"					
		--locale.Unit_Lilly_Startaker					= "Lilly Startaker"				
		locale.Unit_Transportation_Expert_Conner 	= "Experte en transport Conner"	
		locale.Unit_Warrant_Officer_Burke 			= "Adjudant Burke"		
		locale.Unit_Venyanna_Skywind 				= "Venyanna Ailecéleste"				
		locale.Unit_Maimbot_R4 						= "Mutilatron R4"				
		locale.Unit_Police_Patrolman 				= "Policier en patrouille"				
		locale.Unit_Police_Constable 				= "Agent de police"				
		locale.Unit_Water 							= "Eau"						
		locale.Unit_Water_Barrel 					= "Baril d'eau"					
		--locale.Unit_Invisible_Water_Dowsing_Unit 	= "Invisible Water Dowsing Unit"	
		locale.Unit_Cheese							= "Fromage"						
		locale.Unit_Chicken							= "Poulet"						
		locale.Unit_Roan_Steak						= "Steak de Roan"					
		--locale.Unit_Fruit							= "Fruit"						
		locale.Unit_Food_Crate						= "Caisse de nourriture"					
		locale.Unit_Large_Feed_Sack					= "Grand sac de nourriture"				
		locale.Unit_Feed_Sack 						= "Sac de nourriture"					
		locale.Unit_Hay_Bale 						= "Botte de foin"						
		locale.Unit_Roving_Chompacabra 				= "Chompacabra en maraude"			
		locale.Unit_Dustback_Gnasher 				= "Croqueur ocredos"				
		locale.Unit_Dustback_Gnawer 				= "Rongeur ocredos"
		locale.Unit_Roan_Skull 						= "Crâne de Roan"
		locale.Unit_Walatiki_Totem_Dominion			= "Totem moodie du Dominion"
		locale.Unit_Walatiki_Totem_Exile			= "Totem moodie des Exilés"
		locale.Unit_Walatiki_Mask 					= "Masque moodie"
		locale.Unit_Walatiki_Mask_Dominion			= "Masque moodie du Dominion"
		locale.Unit_Walatiki_Mask_Exile				= "Masque moodie Exilé"
		locale.Unit_Datacube						= "INFOCUBE"
		locale.Unit_Shipwrecked_Victim				= "Victime naufragée"

		-- Trade skill names (do not translate as these come from the game client)
		locale.Tradeskill_Farmer 					= "Agriculture"
		locale.Tradeskill_Mining 					= "Mineur"
		locale.Tradeskill_Relic_Hunter 				= "Chasseur de reliques"
		locale.Tradeskill_Survivalist 				= "Adepte de la survie"

		-- Buffs, dont change
		locale.Debuff_Moodie_Mask_Neutral			= "Neutre - Porteur de masque moodie"
		locale.Debuff_Moodie_Mask_Dominion			= "Porteur de masque moodie du Dominion"
		locale.Debuff_Moodie_Mask_Exile				= "Porteur de masque moodie Exilé"

		
		-- Changes as of 2014.7.7
		--locale.Module_PVP							= "PVP"

		--locale.Category_PVP_Friendly_Engineer		= "Friendly Engineer"
		--locale.Category_PVP_Friendly_Warrior		= "Friendly Warrior"
		--locale.Category_PVP_Friendly_Stalker		= "Friendly Stalker"
		--locale.Category_PVP_Friendly_Medic			= "Friendly Medic"
		--locale.Category_PVP_Friendly_Spellslinger	= "Friendly Spellslinger"
		--locale.Category_PVP_Friendly_Esper			= "Friendly Esper"

		--locale.Category_PVP_Hostile_Engineer		= "Hostile Engineer"
		--locale.Category_PVP_Hostile_Warrior			= "Hostile Warrior"
		--locale.Category_PVP_Hostile_Stalker			= "Hostile Stalker"
		--locale.Category_PVP_Hostile_Medic			= "Hostile Medic"
		--locale.Category_PVP_Hostile_Spellslinger	= "Hostile Spellslinger"
		--locale.Category_PVP_Hostile_Esper			= "Hostile Esper"
		
		locale.Module_Walatiki						= "Temple de Walatiki"

		--locale.Category_Walatiki_Mask				= "Neutral Mask"
		--locale.Category_Walatiki_Mask_Dominion		= "Dominion Mask"
		--locale.Category_Walatiki_Mask_Exile			= "Exile Mask"
		--locale.Category_Walatiki_Carrier_Friendly	= "Friendly Carrier"
		--locale.Category_Walatiki_Carrier_Hostile	= "Hostile Carrier"
		--locale.Category_Walatiki_Totem_Exile	 	= "Exile Totem"
		--locale.Category_Walatiki_Totem_Dominion 	= "Dominion Totem"

		-- New Stuff as of 2014.7.8
		--locale.Category_Quest_Spell				= "Spell Objective"

	end

	return locale
end