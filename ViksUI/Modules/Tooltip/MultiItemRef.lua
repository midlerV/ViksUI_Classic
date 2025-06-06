local T, C, L = unpack(ViksUI)
if C.tooltip.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Multi ItemRefTooltip
----------------------------------------------------------------------------------------
local tips = {[1] = _G["ItemRefTooltip"]}
local types = {item = true, enchant = true, spell = true, quest = true, unit = true, talent = true, achievement = true, glyph = true, instancelock = true, currency = true}
local shown

local CreateTip = function(link)
	for _, v in ipairs(tips) do
		for _, tip in ipairs(tips) do
			if tip:IsShown() and tip.link == link then
				tip.link = nil
				HideUIPanel(tip)
				return
			end
		end
		if not v:IsShown() then
			v.link = link
			return v
		end
	end

	local num = #tips + 1
	local tip = CreateFrame("GameTooltip", "ItemRefTooltip"..num, UIParent, "GameTooltipTemplate")
	if num == 2 then
		tip:SetPoint("LEFT", ItemRefTooltip, "RIGHT", 3, 0)
	else
		tip:SetPoint("LEFT", "ItemRefTooltip"..num - 1, "RIGHT", 3, 0)
	end
	tip:SetSize(128, 64)
	tip:EnableMouse(true)
	tip:SetMovable(true)
	tip:SetClampedToScreen(true)
	tip:RegisterForDrag("LeftButton")
	tip:SetScript("OnDragStart", function(self) self:StartMoving() end)
	tip:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

	tip.NineSlice:SetAlpha(0)
	local bg = CreateFrame("Frame", nil, tip)
	bg:SetPoint("TOPLEFT")
	bg:SetPoint("BOTTOMRIGHT")
	bg:SetFrameLevel(tip:GetFrameLevel() - 1)
	bg:SetTemplate("Transparent")

	local close = CreateFrame("Button", "ItemRefTooltip"..num.."CloseButton", tip)
	close:SetScript("OnClick", function() HideUIPanel(tip) end)
	T.SkinCloseButton(close)

	table.insert(UISpecialFrames, tip:GetName())

	tip.link = link
	tips[num] = tip

	return tip
end

local ShowTip = function(tip, link)
	ShowUIPanel(tip)
	if not tip:IsShown() then
		tip:SetOwner(UIParent, "ANCHOR_PRESERVE")
	end
	shown = true
	tip:SetHyperlink(link)
	shown = nil
end

local SetHyperlink = _G.ItemRefTooltip.SetHyperlink
function _G.ItemRefTooltip:SetHyperlink(link, ...)
	local handled = strsplit(":", link)
	if not InCombatLockdown() and not IsModifiedClick() and handled and types[handled] and not shown then
		local tip = CreateTip(link)
		if tip then
			ShowTip(tip, link)
		end
		return
	end

	SetHyperlink(self, link, ...)
end