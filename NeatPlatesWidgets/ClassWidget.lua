---------------
-- Class Widget
---------------
local classWidgetPath = "Interface\\Addons\\NeatPlatesWidgets\\ClassWidget\\"
local classWidgetCustomPath = "Interface\\NeatPlatesTextures\\ClassWidget\\"
local classIcon = {}
--local ScaleOptions = {x = 1, y = 1, offset = {x = 0, y = 0}}

function VerifyTextures()
		local classes = {"WARRIOR","PALADIN","HUNTER","ROGUE","PRIEST","DEATHKNIGHT","SHAMAN","MAGE","WARLOCK","MONK","DRUID","DEMONHUNTER"}
		for i,class in pairs(classes) do
			if not classIcon[class] then
				local f = CreateFrame('frame')
		    local tx = f:CreateTexture()
		    tx:SetPoint('BOTTOMLEFT', WorldFrame, -200, -200) -- The texture has to be "visible", but not necessarily on-screen (you can also set its alpha to 0)
		    tx:SetAlpha(0)
		    f:SetAllPoints(tx)
		    f:SetScript('OnSizeChanged', function(self, width, height)
		        local size = format('%.0f%.0f', width, height) -- The floating point numbers need to be rounded or checked like "width < 8.1 and width > 7.9"
		        if size == '11' then
		            classIcon[class] = classWidgetPath..class
		        else
		            classIcon[class] = classWidgetCustomPath..class
		        end
		    end)
		    tx:SetTexture(classWidgetCustomPath..class)
		    tx:SetSize(0,0) -- Size must be set after every SetTexture
		  end
		end
end

local function UpdateClassWidget(self, unit, showFriendly)
	local class, icon

	if unit then
		if showFriendly and unit.reaction == "FRIENDLY" and unit.type == "PLAYER" then
			class = unit.class
		elseif unit.type == "PLAYER" then class = unit.class end

		if class then
			self.Icon:SetTexture(classIcon[class])
			self:Show()
		else self:Hide() end
	end

end

local function UpdateWidgetConfig(frame)
	local width = frame:GetParent()._width or 24;
	local height = frame:GetParent()._height or 24;
	frame:SetWidth(width); frame:SetHeight(height)

	frame.Icon = frame:CreateTexture(nil, "ARTWORK")
	frame.Icon:SetAllPoints(frame)

	--frame.Icon:SetPoint("CENTER", frame, "CENTER", ScaleOptions.offset.x, ScaleOptions.offset.y)
end

local function CreateClassWidget(parent)

	local frame = CreateFrame("Frame", nil, parent)
	
	UpdateWidgetConfig(frame)

	frame:Hide()
	frame.Update = UpdateClassWidget
	frame.UpdateConfig = UpdateWidgetConfig
	return frame
end

--local function SetClassWidgetOptions(LocalVars)
--	ScaleOptions = LocalVars.ClassIconScaleOptions

--	NeatPlates:ForceUpdate()
--end

local ClassWidgetWatcher = CreateFrame("Frame")
ClassWidgetWatcher:SetScript("OnEvent", VerifyTextures)
ClassWidgetWatcher:RegisterEvent("PLAYER_ENTERING_WORLD")

NeatPlatesWidgets.CreateClassWidget = CreateClassWidget
--NeatPlatesWidgets.SetClassWidgetOptions = SetClassWidgetOptions