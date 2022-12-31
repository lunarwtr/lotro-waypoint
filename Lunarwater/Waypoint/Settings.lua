
import "Lunarwater.Waypoint";


SettingsClass = class();

function SettingsClass:Constructor()
	self:LoadSettings();
end

function SettingsClass:SetSettings(settings)
	self.settings = settings;
end

function SettingsClass:GetSettings()
	return self.settings;
end

function SettingsClass:GetSetting(key)
	return self.settings[key];
end

function SettingsClass:PutSetting(key, value)
	self.settings[key] = value;
end

function SettingsClass:LoadSettings()
	local settings = Lunarwater.Waypoint.PluginData.Load( Turbine.DataScope.Account , "WaypointSettings")
	if settings == nil then
		self.settings = { 
			WindowPos = {  
				["left"] = tostring((Turbine.UI.Display.GetWidth() / 2) - 75.5),
				["top"] =  tostring((Turbine.UI.Display.GetHeight() / 2) - 150)
			}
		};
	else
		self.settings = settings;
	end
end

function SettingsClass:SaveSettings()
	Lunarwater.Waypoint.PluginData.Save(Turbine.DataScope.Account, "WaypointSettings", self.settings );
end


Settings = SettingsClass();