local T, C, L = unpack(ViksUI)
if C.actionbar.enable ~= true then return end

----------------------------------------------------------------------------------------
--	MultiBarBottomLeft(by Tukz)
----------------------------------------------------------------------------------------
local bar = CreateFrame("Frame", "Bar2Holder", ActionBarAnchor)
if C.actionbar.editor then
	local NumRow = ceil(C.actionbar.bar2_num / C.actionbar.bar2_row)
	bar:SetWidth((C.actionbar.bar2_size * C.actionbar.bar2_row) + (C.actionbar.button_space * (C.actionbar.bar2_row - 1)))
	bar:SetHeight((C.actionbar.bar2_size * NumRow) + (C.actionbar.button_space * (NumRow - 1)))
	bar:SetPoint("BOTTOMLEFT", Bar1Holder, "TOPLEFT", 0, C.actionbar.button_space)
else
	bar:SetAllPoints(ActionBarAnchor)
end
MultiBarBottomLeft:SetParent(bar)

bar:RegisterEvent("PLAYER_ENTERING_WORLD")
bar:SetScript("OnEvent", function(self, event)
	if not T.Classic then
		Settings.SetValue("PROXY_SHOW_ACTIONBAR_2", true)
	end
	local NumPerRows = C.actionbar.bar2_row
	local NextRowButtonAnchor = _G["MultiBarBottomLeftButton1"]
	for i = 1, 12 do
		local b = _G["MultiBarBottomLeftButton"..i]
		local b2 = _G["MultiBarBottomLeftButton"..i-1]
		b:ClearAllPoints()
		if C.actionbar.editor then
			if i <= C.actionbar.bar2_num then
				if i == 1 then
					b:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
				elseif i == NumPerRows + 1 then
					b:SetPoint("TOPLEFT", NextRowButtonAnchor, "BOTTOMLEFT", 0, -C.actionbar.button_space)

					NumPerRows = NumPerRows + C.actionbar.bar2_row
					NextRowButtonAnchor = _G["MultiBarBottomLeftButton"..i]
				else
					b:SetPoint("LEFT", b2, "RIGHT", T.Scale(C.actionbar.button_space), 0)
				end
			else
				b:SetPoint("TOP", UIParent, "TOP", 0, 200)
			end
		else
			if i == 1 then
				b:SetPoint("BOTTOM", ActionButton1, "TOP", 0, C.actionbar.button_space)
			else
				b:SetPoint("LEFT", b2, "RIGHT", T.Scale(C.actionbar.button_space), 0)
			end
		end
	end
end)

-- Hide bar
if C.actionbar.bottombars == 1 then
	bar:Hide()
end

if C.actionbar.bottombars_mouseover then
	for i = 1, 12 do
		local b = _G["MultiBarBottomLeftButton"..i]
		b:SetAlpha(0)
		b:HookScript("OnEnter", function() BottomBarMouseOver(1) end)
		b:HookScript("OnLeave", function() if not HoverBind.enabled then BottomBarMouseOver(0) end end)
	end
end

if C.actionbar.editor and C.actionbar.bar2_mouseover then
	for i = 1, 12 do
		local b = _G["MultiBarBottomLeftButton"..i]
		b:SetAlpha(0)
		b:HookScript("OnEnter", function() Bar2MouseOver(1) end)
		b:HookScript("OnLeave", function() if not HoverBind.enabled then Bar2MouseOver(0) end end)
	end

	bar:SetScript("OnEnter", function() Bar2MouseOver(1) end)
	bar:SetScript("OnLeave", function() if not HoverBind.enabled then Bar2MouseOver(0) end end)
end