import "Turbine"
import "Turbine.UI"
import "Turbine.UI.Lotro"
import "Lunarwater.Waypoint"

Options = class(Turbine.UI.Control)

function Options:Constructor()
    Turbine.UI.Control.Constructor(self)

    local fontColor = Turbine.UI.Color(1,.9,.5);
    local fontFace = Turbine.UI.Lotro.Font.Verdana14;
    local headerFontFace = Turbine.UI.Lotro.Font.VerdanaBold16;
    local backColor = Turbine.UI.Color(0.1, 0.1, 0.1);
    self:SetBackColor(backColor);
    self:SetSize(350, 600);

    local y = 10

    -- Stale post seconds input (remains at top)
    local distanceLabel = Turbine.UI.Label()
    distanceLabel:SetParent(self)
    distanceLabel:SetFont(fontFace)
    distanceLabel:SetText(STRING.COMPLETION_DISTANCE_LABEL)
    distanceLabel:SetPosition(10, y)
    distanceLabel:SetSize(200, 30)

    self.distanceInput = Turbine.UI.Lotro.TextBox()
    self.distanceInput:SetParent(self)
    self.distanceInput:SetFont(fontFace);
    self.distanceInput:SetForeColor(fontColor);
    self.distanceInput:SetText(tostring(Lunarwater.Waypoint.Settings:GetSetting('Distance') or DEFAULT_COMPLETION_DISTANCE))
    self.distanceInput:SetPosition(220, y)
    self.distanceInput:SetSize(40, 20)
    self.suppressDistanceChange = false
    local defaultDistance = Lunarwater.Waypoint.Settings:GetSetting('Distance') or DEFAULT_COMPLETION_DISTANCE
    self.distanceInput:SetText(tostring(defaultDistance))
    -- Horizontal scrollbar for distance
    self.distanceScrollbar = Turbine.UI.Lotro.ScrollBar()
    self.distanceScrollbar:SetParent(self)
    self.distanceScrollbar:SetOrientation(Turbine.UI.Orientation.Horizontal)
    self.distanceScrollbar:SetMinimum(0)
    self.distanceScrollbar:SetMaximum(100)
    self.distanceScrollbar:SetBackColor(Turbine.UI.Color.Black)
    self.distanceScrollbar:SetValue(defaultDistance)
    self.distanceScrollbar:SetPosition(265, y + 5)
    self.distanceScrollbar:SetSize(100, 10)
    self.suppressScrollbarChange = false
    self.distanceInput.TextChanged = function(sender, args)
        if self.suppressDistanceChange then return end
        local v = tonumber(self.distanceInput:GetText())
        if not v or v < 0 or v > 100 then
            self.suppressDistanceChange = true
            self.distanceInput:SetText(tostring(defaultDistance))
            self.suppressDistanceChange = false
            return
        end
        Lunarwater.Waypoint.Settings:PutSetting('Distance', v)
        Lunarwater.Waypoint.Settings:SaveSettings();
        -- Sync scrollbar
        self.suppressScrollbarChange = true
        self.distanceScrollbar:SetValue(v)
        self.suppressScrollbarChange = false
    end
    self.distanceScrollbar.ValueChanged = function(sender, args)
        if self.suppressScrollbarChange then return end
        local v = self.distanceScrollbar:GetValue()
        self.suppressDistanceChange = true
        self.distanceInput:SetText(tostring(v))
        self.suppressDistanceChange = false
        Lunarwater.Waypoint.Settings:PutSetting('Distance', v)
        Lunarwater.Waypoint.Settings:SaveSettings();
    end

end
