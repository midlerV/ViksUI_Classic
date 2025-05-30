local T, C, L = unpack(ViksUI)

----------------------------------------------------------------------------------------
--	Prevent users config errors
----------------------------------------------------------------------------------------
if C.actionbar.rightbars > 3 then
	C.actionbar.rightbars = 3
end

if C.actionbar.bottombars > 3 then
	C.actionbar.bottombars = 3
end

if C.actionbar.split_bars == true then
	C.actionbar.bottombars = 3
end

if T.Classic and C.actionbar.bottombars == 3 and C.actionbar.rightbars == 3 then
	C.actionbar.bottombars = 3
	C.actionbar.rightbars = 2
end

if C.actionbar.bottombars < 1 then
	C.actionbar.bottombars = 1
end

if C.actionbar.editor then
	C.actionbar.bottombars_mouseover = false
	C.actionbar.rightbars_mouseover = false
	C.actionbar.toggle_mode = false
end

----------------------------------------------------------------------------------------
--	Auto-overwrite script config is X addon is found
----------------------------------------------------------------------------------------
if IsAddOnLoaded("Stuf") or IsAddOnLoaded("PitBull4") or IsAddOnLoaded("ShadowedUnitFrames") or IsAddOnLoaded("LunaUnitFrames") then
	C.unitframe.enable = false
end

if C.unitframe.Autohide then
	if IsAddOnLoaded("Grid") or IsAddOnLoaded("Grid2") or IsAddOnLoaded("HealBot") or IsAddOnLoaded("VuhDo") or IsAddOnLoaded("Cell") or IsAddOnLoaded("Aptechka") then
		C.unitframe.ShowRaid = false
	end
end

if IsAddOnLoaded("TidyPlates") or IsAddOnLoaded("nPlates") or IsAddOnLoaded("Kui_Nameplates") or IsAddOnLoaded("rNamePlates") or IsAddOnLoaded("EKplates") or IsAddOnLoaded("bdNameplates") or IsAddOnLoaded("Plater") or IsAddOnLoaded("Nameplates") or IsAddOnLoaded("NeatPlates") then
	C.nameplate.enable = false
end

if IsAddOnLoaded("Dominos") or IsAddOnLoaded("Bartender4") or IsAddOnLoaded("RazerNaga") then
	C.actionbar.enable = false
	C.actionbar.toggle_mode = false
end

if IsAddOnLoaded("Mapster") then
	C.minimap.fog_of_war = false
end

if IsAddOnLoaded("Prat-3.0") or IsAddOnLoaded("Chatter") or IsAddOnLoaded("BasicChatMods") or IsAddOnLoaded("Glass") then
	C.chat.enable = false
end

if IsAddOnLoaded("Quartz") or IsAddOnLoaded("AzCastBar") then
	C.unitframe.unit_castbar = false
	C.unitframe.plugins_swing = false
	C.unitframe.plugins_gcd = false
end

if IsAddOnLoaded("Afflicted3") or IsAddOnLoaded("InterruptBar") then
	C.enemycooldown.enable = false
end

if IsAddOnLoaded("TipTac") or IsAddOnLoaded("FreebTip") or IsAddOnLoaded("bTooltip") or IsAddOnLoaded("PhanxTooltip") or IsAddOnLoaded("Icetip") then
	C.tooltip.enable = false
end

if IsAddOnLoaded("Gladius") or IsAddOnLoaded("GladiusEx") or IsAddOnLoaded("Gladdy") then
	C.unitframe.show_arena = false
end

if IsAddOnLoaded("Omen") or IsAddOnLoaded("rThreat") or IsAddOnLoaded("ClassicThreatMeter") or IsAddOnLoaded("ThreatClassic2") then
	C.threat.enable = false
end

if IsAddOnLoaded("DBM-SpellTimers") then
	C.raidcooldown.enable = false
end

if IsAddOnLoaded("AdiBags") or IsAddOnLoaded("ArkInventory") or IsAddOnLoaded("cargBags_Nivaya") or IsAddOnLoaded("cargBags") or IsAddOnLoaded("Bagnon") or IsAddOnLoaded("Combuctor") or IsAddOnLoaded("TBag") or IsAddOnLoaded("BaudBag") or IsAddOnLoaded("Baganator") then
	C.bag.enable = false
end

if IsAddOnLoaded("MikScrollingBattleText") or IsAddOnLoaded("Parrot") or IsAddOnLoaded("xCT") or IsAddOnLoaded("sct") then
	C.combattext.enable = false
end

if IsAddOnLoaded("Doom_CooldownPulse") then
	C.pulsecooldown.enable = false
end

if IsAddOnLoaded("GnomishVendorShrinker") or IsAddOnLoaded("AlreadyKnown") then
	C.trade.already_known = false
end

if IsAddOnLoaded("Clique") or IsAddOnLoaded("sBinder") then
	C.misc.click_cast = false
end

if IsAddOnLoaded("RaidSlackCheck") then
	C.announcements.flask_food = false
	C.announcements.feasts = false
end

if IsAddOnLoaded("PhoenixStyle") then
	C.announcements.toys = false
end

if IsAddOnLoaded("Overachiever") then
	C.tooltip.achievements = false
end

if IsAddOnLoaded("ChatSounds") then
	C.chat.whisp_sound = false
end

if IsAddOnLoaded("Aurora") then
	C.skins.blizzard_frames = false
end

if IsAddOnLoaded("BigWigs") or IsAddOnLoaded("DBM-Core") then
	C.automation.auto_role = false
end

if IsAddOnLoaded("QuickQuest") then
	C.quest.accept_quest = false
end

----------------------------------------------------------------------------------------
--	Load external profile settings
----------------------------------------------------------------------------------------
if T.PostDisable then
	T.PostDisable()
end