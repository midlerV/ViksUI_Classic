local T, C, L = unpack(ViksUI)
if C.tooltip.enable ~= true or C.tooltip.mount ~= true then return end

----------------------------------------------------------------------------------------
--	Show source of mount
----------------------------------------------------------------------------------------
local MountCache = {}
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
	for _, mountID in ipairs(C_MountJournal.GetMountIDs()) do
		MountCache[select(2, C_MountJournal.GetMountInfoByID(mountID))] = mountID
	end
end)

local function MountSourceTooltip(self, ...)
	if not UnitIsPlayer(...) or UnitIsUnit(..., "player") then return end
	local id

	if T.Classic then
		id = select(10, UnitAura(...))
	else
		local aura = C_UnitAuras.GetAuraDataByAuraInstanceID(...)
		id = aura and aura.spellId
	end

	if id and MountCache[id] then
		local text = NOT_COLLECTED
		local r, g, b = 1, 0, 0
		local collected = select(11, C_MountJournal.GetMountInfoByID(MountCache[id]))

		if collected then
			text = COLLECTED
			r, g, b = 0, 1, 0
		end

		self:AddLine(" ")
		self:AddLine(text, r, g, b)

		local sourceText = select(3, C_MountJournal.GetMountInfoExtraByID(MountCache[id]))
		self:AddLine(sourceText, 1, 1, 1)
		self:AddLine(" ")
		self:Show()
	end
end

if T.Classic then
	hooksecurefunc(GameTooltip, "SetUnitAura", MountSourceTooltip)
else
	hooksecurefunc(GameTooltip, "SetUnitBuffByAuraInstanceID", MountSourceTooltip)
end