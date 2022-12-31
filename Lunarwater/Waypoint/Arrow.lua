--[[
   Copyright 2011 Kelly Riley (lunarwater)

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
]]
import "Turbine";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Lunarwater.Waypoint";

local locale = "en";
if Turbine.Shell.IsCommand("hilfe") then
  locale = "de";
elseif Turbine.Shell.IsCommand("aide") then
  locale = "fr";
end

Arrow = class( Turbine.UI.Window );
function Arrow:Constructor()
    Turbine.UI.Window.Constructor( self );
	
   	local invisible = Turbine.UI.Color(0,0,0,0);
    self:SetSize(75,75);
    self:SetVisible( false );
    self:SetMouseVisible(false);
    self:SetBackColor(invisible);
    
    local aliascommand = '/loc';
    if locale == 'de' then 
    	aliascommand = '/pos' 
    elseif locale == 'fr' then
    	aliascommand = '/emp' 
    end;
    local sc = Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, '' );
    sc:SetData(aliascommand);
	local quick = Turbine.UI.Lotro.Quickslot();
	quick:SetParent(self);
    quick:SetSize( 18, 18 );
 	quick:SetAllowDrop(false);    
    local offset = (self:GetWidth() - quick:GetWidth()) / 2;
    quick:SetPosition(offset,offset);
    quick:SetShortcut(sc);
    quick:SetVisible(true);    
	self.quick = quick;
	
	self.quick.alias=aliascommand;
	self.quick.DragDrop=function()
		local sc = Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, '' );
		sc:SetData(self.quick.alias);
		self.quick:SetShortcut(sc);
	end	
    	
    local arrow = Turbine.UI.Control();
    arrow:SetParent(self);
    arrow:SetPosition(0,0);
    arrow:SetSize(75,75);
    arrow:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
    arrow:SetBackground("Lunarwater/Waypoint/arrowunknown.tga");
    arrow:SetMouseVisible(false);
    self.arrow = arrow;

end

function Arrow:ShowFinished()
	self.arrow:SetBackground("Lunarwater/Waypoint/arrowfinish.tga");
end
function Arrow:ShowArrow()
	self.arrow:SetBackground("Lunarwater/Waypoint/arrow.tga");
end
function Arrow:ShowRefresh()
	self.arrow:SetBackground("Lunarwater/Waypoint/arrowrefresh.tga");
end

function Arrow:ShowUnknown()
	self.arrow:SetBackground("Lunarwater/Waypoint/arrowunknown.tga");
end
