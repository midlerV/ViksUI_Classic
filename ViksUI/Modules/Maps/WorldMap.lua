local T, C, L = unpack(ViksUI)

----------------------------------------------------------------------------------------
--	Font replacement
----------------------------------------------------------------------------------------
MapQuestInfoRewardsFrame.XPFrame.Name:SetFont(C.media.normal_font, 13, "")

----------------------------------------------------------------------------------------
--	Change position
----------------------------------------------------------------------------------------
hooksecurefunc(WorldMapFrame, "SynchronizeDisplayState", function()
	if CharacterFrame:IsShown() or SpellBookFrame:IsShown() or (PlayerTalentFrame and PlayerTalentFrame:IsShown()) or (ChannelFrame and ChannelFrame:IsShown()) or PVEFrame:IsShown() or (MacroFrame and MacroFrame:IsShown()) or (GarrisonLandingPage and GarrisonLandingPage:IsShown()) then return end
	if not WorldMapFrame:IsMaximized() then
		WorldMapFrame:ClearAllPoints()
		WorldMapFrame:SetPoint(unpack(C.position.map))
	end
end)
WorldMapFrame:SetClampedToScreen(true)

----------------------------------------------------------------------------------------
--	Count of quests
----------------------------------------------------------------------------------------
local maxQuest = T.Vanilla and 20 or T.Classic and 25 or 35
local numQuest = CreateFrame("Frame", nil, QuestMapFrame)
numQuest.text = numQuest:CreateFontString(nil, "ARTWORK", "GameFontNormal")
if C.skins.blizzard_frames then
	numQuest.text:SetPoint("TOP", QuestMapFrame, "TOP", 0, -21)
else
	numQuest.text:SetPoint("TOP", QuestMapFrame, "TOP", 0, -17)
end
numQuest.text:SetJustifyH("LEFT")
numQuest.text:SetText(select(2, C_QuestLog.GetNumQuestLogEntries()).."/"..maxQuest)

----------------------------------------------------------------------------------------
--	Creating coordinate
----------------------------------------------------------------------------------------
local coords = CreateFrame("Frame", "CoordsFrame", WorldMapFrame)
coords:SetFrameLevel(WorldMapFrame.BorderFrame:GetFrameLevel() + 2)
coords:SetFrameStrata(WorldMapFrame.BorderFrame:GetFrameStrata())

coords.PlayerText = coords:CreateFontString(nil, "ARTWORK", "GameFontNormal")
coords.PlayerText:SetPoint("BOTTOMLEFT", WorldMapFrame.ScrollContainer, "BOTTOM", -40, 20)
coords.PlayerText:SetJustifyH("LEFT")
coords.PlayerText:SetText(UnitName("player")..": 0,0")

coords.MouseText = coords:CreateFontString(nil, "ARTWORK", "GameFontNormal")
coords.MouseText:SetJustifyH("LEFT")
coords.MouseText:SetPoint("BOTTOMLEFT", coords.PlayerText, "TOPLEFT", 0, 5)
coords.MouseText:SetText(L_MAP_CURSOR..": 0,0")

local mapRects, tempVec2D = {}, CreateVector2D(0, 0)
local function GetPlayerMapPos(mapID)
	tempVec2D.x, tempVec2D.y = UnitPosition("player")
	if not tempVec2D.x then return end

	local mapRect = mapRects[mapID]
	if not mapRect then
		local _, pos1 = C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(0, 0))
		local _, pos2 = C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(1, 1))
		if not pos1 or not pos2 then return end
		mapRect = {pos1, pos2}
		mapRect[2]:Subtract(mapRect[1])
		mapRects[mapID] = mapRect
	end
	tempVec2D:Subtract(mapRect[1])

	return (tempVec2D.y/mapRect[2].y), (tempVec2D.x/mapRect[2].x)
end

local int = 0
WorldMapFrame:HookScript("OnUpdate", function()
	int = int + 1
	if int >= 3 then
		local unitMap = C_Map.GetBestMapForUnit("player")
		local x, y = 0, 0

		if unitMap then
			x, y = GetPlayerMapPos(unitMap)
		end

		if x and y and x >= 0 and y >= 0 then
			coords.PlayerText:SetFormattedText("%s: %.0f,%.0f", T.name, x * 100, y * 100)
		else
			coords.PlayerText:SetText(UnitName("player")..": ".."|cffff0000"..L_MAP_BOUNDS.."|r")
		end

		if WorldMapFrame.ScrollContainer:IsMouseOver() then
			local mouseX, mouseY = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()
			if mouseX and mouseY and mouseX >= 0 and mouseY >= 0 then
				coords.MouseText:SetFormattedText("%s %.0f,%.0f", L_MAP_CURSOR, mouseX * 100, mouseY * 100)
			else
				coords.MouseText:SetText(L_MAP_CURSOR.."|cffff0000"..L_MAP_BOUNDS.."|r")
			end
		else
			coords.MouseText:SetText(L_MAP_CURSOR.."|cffff0000"..L_MAP_BOUNDS.."|r")
		end

		numQuest.text:SetText(select(2, C_QuestLog.GetNumQuestLogEntries()).."/"..maxQuest)

		int = 0
	end
end)

coords:RegisterEvent("PLAYER_ENTERING_WORLD")
coords:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	if ViksUISettingsPerChar and ViksUISettingsPerChar.Coords ~= true then
		coords:SetAlpha(0)
	end
end)

----------------------------------------------------------------------------------------
--	Added options to map tracking button
----------------------------------------------------------------------------------------
hooksecurefunc(WorldMapFrame.overlayFrames[2], "InitializeDropDown", function(self)
	UIDropDownMenu_AddSeparator()
	local info = UIDropDownMenu_CreateInfo()

	info.isTitle = true
	info.notCheckable = true
	info.text = "ViksUI"

	UIDropDownMenu_AddButton(info)
	info.text = nil

	info.isTitle = nil
	info.disabled = nil
	info.notCheckable = nil
	info.isNotRadio = true
	info.keepShownOnClick = true

	info.text = L_MAP_COORDS
	info.checked = function()
		return ViksUISettingsPerChar.Coords == true
	end

	info.func = function()
		if ViksUISettingsPerChar.Coords == true then
			ViksUISettingsPerChar.Coords = false
			coords:SetAlpha(0)
		else
			ViksUISettingsPerChar.Coords = true
			coords:SetAlpha(1)
		end
	end
	UIDropDownMenu_AddButton(info)

	if C.minimap.fog_of_war == true then
		info.text = L_MAP_FOG
		info.checked = function()
			return ViksUISettingsPerChar.FogOfWar == true
		end

		info.func = function()
			if ViksUISettingsPerChar.FogOfWar == true then
				ViksUISettingsPerChar.FogOfWar = false
				for i = 1, #T.overlayTextures do
					T.overlayTextures[i]:Hide()
				end
			else
				ViksUISettingsPerChar.FogOfWar = true
				for i = 1, #T.overlayTextures do
					T.overlayTextures[i]:Show()
				end
			end
		end
		UIDropDownMenu_AddButton(info)
	end
end)