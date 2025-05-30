local T, C, L = unpack(ViksUI)
if C.unitframe.enable ~= true or T.class ~= "MAGE" then return end

local _, ns = ...
local oUF = ns.oUF

if(oUF:IsClassic()) then return end

local SPELL_POWER_ARCANE_CHARGES = Enum.PowerType.ArcaneCharges or 16

local function Update(self, _, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= "ARCANE_CHARGES")) then return end

	local element = self.ArcaneCharge

	if(element.PreUpdate) then
		element:PreUpdate(unit)
	end

	local cur = UnitPower("player", SPELL_POWER_ARCANE_CHARGES)
	local max = UnitPowerMax("player", SPELL_POWER_ARCANE_CHARGES)

	for i = 1, max do
		if(i <= cur) then
			element[i]:SetAlpha(1)
		else
			element[i]:SetAlpha(0.2)
		end
	end

	if(element.PostUpdate) then
		return element:PostUpdate(cur)
	end
end

local function Path(self, ...)
	return (self.ArcaneCharge.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit, "ARCANE_CHARGES")
end

local function Visibility(self)
	local element = self.ArcaneCharge
	local spec = GetSpecialization()

	if spec == SPEC_MAGE_ARCANE then
		element:Show()
		-- if self.Debuffs then self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 19) end  --Not changing as its on own anchor
	else
		element:Hide()
		-- if self.Debuffs then self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 5) end  --Not changing as its on own anchor
	end
end

local function Enable(self)
	local element = self.ArcaneCharge
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_POWER_UPDATE", Path)

		element.handler = CreateFrame("Frame", nil, element)
		element.handler:RegisterEvent("PLAYER_TALENT_UPDATE")
		element.handler:RegisterEvent("PLAYER_ENTERING_WORLD")
		element.handler:SetScript("OnEvent", function() Visibility(self) end)

		return true
	end
end

local function Disable(self)
	local element = self.ArcaneCharge
	if(element) then
		self:UnregisterEvent("UNIT_POWER_UPDATE", Path)
		element.handler:UnregisterEvent("PLAYER_TALENT_UPDATE")
		element.handler:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end

oUF:AddElement("ArcaneCharge", Path, Enable, Disable)