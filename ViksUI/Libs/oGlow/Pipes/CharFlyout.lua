if oGlow:IsClassic() then return end
local hook
local _E

local getID = function(loc)
	local player, bank, bags, voidStorage, slot, bag = EquipmentManager_UnpackLocation(loc)
	if not player and not bank and not bags and not voidStorage then return end

	if not bags then
		return GetInventoryItemLink("player", slot)
	else
		return C_Container.GetContainerItemLink(bag, slot)
	end
end

local pipe = function(self)
	local location, id = self.location
	if location and location < EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION then
		id = getID(location)
	end

	return oGlow:CallFilters("char-flyout", self, _E and id)
end

local update = function(self)
	local buttons = EquipmentFlyoutFrame.buttons
	for _, button in next, buttons do
		pipe(button)
	end
end

local enable = function(self)
	_E = true

	if not hook then
		hook = function(...)
			if _E then return pipe(...) end
		end

		hooksecurefunc("EquipmentFlyout_DisplayButton", hook)
	end
end

local disable = function(self)
	_E = nil
end

oGlow:RegisterPipe("char-flyout", enable, disable, update, "Character equipment flyout frame")