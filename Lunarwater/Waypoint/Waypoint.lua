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

local LOC_MESSAGES = { 
	'r(%d+) lx(%d+%.?%d*) ly(%d+%.?%d*) i%d+ ox(%d+%.?%d*) oy(%d+%.?%d*) oz(%d+%.?%d*) h(%d+%.?%d*)',
	'r(%d+) lx(%d+%.?%d*) ly(%d+%.?%d*) i%d+ cInside ox(.-%d+%.?%d*) oy(.-%d+%.?%d*) oz(.-%d+%.?%d*) h(%d+%.?%d*)',
	'r(%d+) lx(%d+%.?%d*) ly(%d+%.?%d*) i%d+ ox(%d+%.?%d*) oy(%d+%.?%d*) oz(%d+%.?%d*)',
	'r(%d+) lx(%d+%.?%d*) ly(%d+%.?%d*) i%d+ cInside ox(.-%d+%.?%d*) oy(.-%d+%.?%d*) oz(.-%d+%.?%d*)',
	-- not likely to match last --
	'r(%d+) lx(%d+%.?%d*) ly(%d+%.?%d*) ox(.-%d+%.?%d*) oy(.-%d+%.?%d*) oz(.-%d+%.?%d*) h(%d+%.?%d*)',
	'r(%d+) lx(%d+%.?%d*) ly(%d+%.?%d*) cInside ox(.-%d+%.?%d*) oy(.-%d+%.?%d*) oz(.-%d+%.?%d*) h(%d+%.?%d*)',
	'r(%d+) lx(%d+%.?%d*) ly(%d+%.?%d*) ox(.-%d+%.?%d*) oy(.-%d+%.?%d*) oz(.-%d+%.?%d*)',
	'r(%d+) lx(%d+%.?%d*) ly(%d+%.?%d*) cInside ox(.-%d+%.?%d*) oy(.-%d+%.?%d*) oz(.-%d+%.?%d*)'
};


if (tonumber("1,000")==1) then
	function tonum(val)
		if val~=nil then
			return tonumber((string.gsub(val,"%.",",")))        
	    end
        return nil;
	end
else
	function tonum(val)
		if val~=nil then
			return tonumber((string.gsub(val,",",".")))        
	    end
        return nil;
	end    
end

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

Waypoint = class( Turbine.UI.Window );
function Waypoint:Constructor()
    Turbine.UI.Window.Constructor( self );
	local invisible = Turbine.UI.Color(0,0,0,0);
	local pos = Lunarwater.Waypoint.Settings:GetSetting('WindowPos');
	self:SetPosition( pos.left , pos.top );
    self:SetSize(150,150);
    self:SetOpacity( 1 );
    self:SetBackColor(invisible);
    self:SetMouseVisible(false);
	self:SetZOrder(150);
	
    local arrow = Lunarwater.Waypoint.Arrow();
    local offset = math.floor(self:GetWidth() / 4);
    arrow:SetPosition(self:GetLeft() + offset,self:GetTop() + offset);
	arrow:SetZOrder(self:GetZOrder() + 1);
	arrow.ShortcutMoved = function(left, top)
		self:SetPosition(left - offset, top - offset);
	end
	
	local color = Turbine.UI.Color(1,.9,.5);
 	local messageLabel = Turbine.UI.Label();
 	messageLabel:SetParent(self);
 	messageLabel:SetSize(self:GetWidth(),15);
 	messageLabel:SetPosition(0,self:GetHeight() - 50);
 	messageLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
 	messageLabel:SetForeColor(color);
	messageLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
    messageLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	messageLabel:SetMouseVisible(false);
	messageLabel:SetText('Target needed');
	
 	local rangeLabel = Turbine.UI.Label();
 	rangeLabel:SetParent(self);
 	rangeLabel:SetSize(self:GetWidth(),15);
 	rangeLabel:SetPosition(0,messageLabel:GetTop() + rangeLabel:GetHeight());
 	rangeLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
 	rangeLabel:SetForeColor(color);
	rangeLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
    rangeLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
 	rangeLabel:SetMouseVisible(false);
	
 	self.arrow = arrow;
 	self.messageLabel = messageLabel;
 	self.rangeLabel = rangeLabel;
	
 	local mover = Turbine.UI.Control();
	mover:SetParent(self);
    mover:SetBlendMode( Turbine.UI.BlendMode.None );
    mover:SetBackground("Lunarwater/Waypoint/move.tga");		
	mover:SetSize(15,15);
	mover:SetPosition(45,45);
	mover:SetZOrder(arrow:GetZOrder() + 1);	
	mover:SetMouseVisible(true);
	mover.MouseEnter = function()
	    mover:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	end
	mover.MouseLeave = function()
    	mover:SetBlendMode( Turbine.UI.BlendMode.None );
	end	
  	
    mover.MouseDown = function( sender, args )
        if(args.Button == Turbine.UI.MouseButton.Left) then
            sender.dragStartX = args.X;
            sender.dragStartY = args.Y;
            sender.dragging = true;
            sender.dragged = false;
        end
    end
    mover.MouseUp = function( sender, args )
        if(args.Button == Turbine.UI.MouseButton.Left) then
            if (sender.dragging) then
                sender.dragging = false;
                Lunarwater.Waypoint.Settings:PutSetting('WindowPos', {  ["left"] = (self:GetLeft()), ["top"] =  (self:GetTop())});
                Lunarwater.Waypoint.Settings:SaveSettings();
            end
        end
    end
    mover.MouseMove = function(sender,args)
        if ( sender.dragging ) then
            local left, top = self:GetPosition();
            local aleft, atop = self.arrow:GetPosition();
            self:SetPosition( left + ( args.X - sender.dragStartX ), top + args.Y - sender.dragStartY );
            self.arrow:SetPosition( aleft + ( args.X - sender.dragStartX ), atop + args.Y - sender.dragStartY );
            
            sender.dragged = true;
        end
    end	

 	local closer = Turbine.UI.Control();
	closer:SetParent(self);
    closer:SetBlendMode( Turbine.UI.BlendMode.None );
    closer:SetBackground("Lunarwater/Waypoint/close.tga");		
	closer:SetSize(15,15);
	closer:SetPosition(85,45);
	closer:SetZOrder(arrow:GetZOrder() + 1);	
	closer:SetMouseVisible(true);
	closer.MouseEnter = function()
	    closer:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	end
	closer.MouseLeave = function()
    	closer:SetBlendMode( Turbine.UI.BlendMode.None );
	end	
	closer.MouseUp = function( sender, args )
        if(args.Button == Turbine.UI.MouseButton.Left) then
            self:SetVisible(false);
        end
    end

    self:SetVisible( false );
	
    self:SetWantsKeyEvents( true );
    self.KeyDown = function( sender, args )
        if ( args.Action == 268435635 ) then
        	if self:IsVisible() then
				Turbine.UI.Window.SetVisible(self, false);
				self.arrow:SetVisible(false); 
        	else
        		if self.currentCoor ~= nil then 
					self:SetVisible(true); 
					self:UpdateArrow();
				end
        	end
        end
	end
    Turbine.Chat.Received=function(sender, args)
       --Turbine.Shell.WriteLine('channel ' .. tostring(args.ChatType) .. ":" .. args.Message);
       if args.ChatType == 4 and self:IsVisible() then
	       local loc = self:ParseChatLocation(args.Message);
	       if loc ~= nil then
	       	   local coor = self:ConvertToPlayer(loc);
	       	   self.currentLoc = loc;
	       	   self.currentCoor = coor;
			   self:UpdateArrow();	       	   
	       end
       end
    end

end

function Waypoint:Reset()
	self.currentCoor = nil;
	self.currentLoc = nil;
	self.arrow:ShowUnknown();
	self.arrow:SetRotation( { x = 0, y = 0, z = 0 } );		
	self.messageLabel:SetText('Target needed');
	self.rangeLabel:SetText("");
	self:SetWantsUpdates(false);	
end

function Waypoint:Update( sender, args )
    local newOpacity;

    local now = Turbine.Engine.GetGameTime();
    local delta = now - self.refreshStartTime;

	if delta > 5 then
		self.arrow:ShowRefresh();
    	self:SetWantsUpdates( false );
    end;
end

function Waypoint:SetVisible( state )
	Turbine.UI.Window.SetVisible(self, state);
	self.arrow:SetVisible(state);
	if not state then
		self:Reset();
	end
end

function Waypoint:SetTargetCoordinate( coor )
	self.targetCoor = coor;
	self.currentCoor = nil;
	self.currentLoc = nil;
	self.arrow:ShowRefresh();
	self.arrow:SetRotation( { x = 0, y = 0, z = 0 } );		
	self.messageLabel:SetText(self:CoordinateToString(coor));
	self.rangeLabel:SetText("");
	self:SetVisible(true);
	self:SetWantsUpdates(false);
end

function Waypoint:CoordinateToString( coor )
   	
   	local yd = 'N';
   	if coor.y < 0 then yd = 'S' end;
   	local xd = 'E';
   	if coor.x < 0 then xd = 'W' end;
   	
   	if locale == 'de' and xd == 'E' then
   		xd = 'O';
   	end;
   	
   	return math.abs(coor.y) .. yd  .. ', ' .. math.abs(coor.x) .. xd;
end

function Waypoint:UpdateArrow()
	if self.targetCoor ~= nil and self.currentCoor ~= nil then
		-- local angle = math.atan2(self.currentCoor.y - self.targetCoor.y, self.currentCoor.x - self.targetCoor.x) * 270 / math.pi
		local x1 = round(self.currentCoor.x, 1); local x2 = round(self.targetCoor.x, 1);
		local y1 = round(self.currentCoor.y, 1); local y2 = round(self.targetCoor.y, 1);
		
		if x1 == x2 and y1 == y2 then
			self.rangeLabel:SetText("Arrived @ " .. self:CoordinateToString(self.targetCoor));	
			self.arrow:ShowFinished();
			self.arrow:SetRotation( { x = 0, y = 0, z = 0 } );
			self:SetWantsUpdates( false );	
		else
			-- turn on refresh timer
			self.refreshStartTime = Turbine.Engine.GetGameTime();
			self:SetWantsUpdates( true );
			
			local angle;
			if x2 == x1 then
				if y2 < y1 then angle = 180 else angle = 360 end
			elseif y1 == y2 then
				if x2 < x1 then angle = 270 else angle = 90 end
			elseif x2 < x1 and y2 < y1 then
				-- bottom left
				angle = 270 - math.deg(math.atan((y1 - y2)/(x1 - x2)));
			elseif x2 < x1 and y2 > y1 then
				-- top left
				angle = 270 + math.deg(math.atan((y2 - y1)/(x1 - x2)));
			elseif x2 > x1 and y2 < y1 then
				-- bottom right
				angle = 90 + math.deg(math.atan((y1 - y2)/(x2 - x1)));
			elseif x2 > x1 and y2 > y1 then
				-- top right
				angle = 90 - math.deg(math.atan((y2 - y1)/(x2 - x1)));
			end
			
			local arrowAngle = 0;
			if self.currentLoc.h > angle then 
				arrowAngle = math.floor(self.currentLoc.h - angle); 
			else
				arrowAngle = math.floor(360 - (angle - self.currentLoc.h)); 
			end
			-- Turbine.Shell.WriteLine('from ' .. self:CoordinateToString(self.currentCoor) .. ' to ' .. self:CoordinateToString(self.targetCoor).. ' => ' ..tostring(angle) .. ' | ' .. tostring(arrowAngle));
			
			local distance = math.sqrt( ( self.currentCoor.x - self.targetCoor.x )^2 + ( self.currentCoor.y - self.targetCoor.y )^2 ) * 202.2171;
			if distance > 30 then
				self.rangeLabel:SetText('~' .. tostring(round(distance,1)) .. 'm away');
			else
				self.rangeLabel:SetText('within 30m');
			end	
	
			self.arrow:ShowArrow();
			self.arrow:SetRotation( { x = 0, y = 0, z = arrowAngle } );
		end
	end
end

function Waypoint:ParseCoordinate( message )
	local y, yd = message:match "(%d+%.?%d*)([NSns])";
	local x, xd = message:match "(%d+%.?%d*)([EWOewo])";
	if y ~= nil and x ~= nil then
		x = tonum(x);
		y = tonum(y);
		if xd == 'W' or xd == 'w' or (locale == 'de' and ( xd == 'o' or xd == 'O' )) then
			x = - x;
		end
		if yd == 'S' or yd == 's' then
			y = - y;
		end
		--Turbine.Shell.WriteLine('x: ' .. x .. ' y: ' .. y);
		return { x = x, y = y }
	end
end

function Waypoint:ParseChatLocation( message )
	local matchprefix = 'You are on .+ server %d* at ';
	if locale == 'de' then
		matchprefix = 'Ihr seid auf dem Server .+ in ';		
	elseif locale == 'fr' then
		matchprefix = 'Vous vous trouvez sur .+ serveur %d*, à ';
	end
	for i, suffix in ipairs(LOC_MESSAGES) do
		local matchstring = matchprefix .. suffix; 
		local r, lx, ly, ox, oy, oz, h = message:match(matchstring);
		if r ~= nil then
			if h == nil then h = 0 end;
			return { r = tonum(r), lx = tonum(lx), ly = tonum(ly), ox = tonum(ox), oy = tonum(oy), oz = tonum(oz), h = tonum(h) };
		end
	end
end

function Waypoint:ConvertToPlayer( dev_coordinate )
	-- You are at: r1 lx904 ly975 ox18.49 oy142.90 oz418.52 h140.6
 	-- You are at: r1 lx1046 ly1147 ox129.00 oy75.72 oz417.78 h358.6 
    -- You are at: r1 lx959 ly921 ox153.80 oy36.75 oz381.56 h199.7
	local x = (( math.floor( dev_coordinate.lx / 8 ) * 160 + dev_coordinate.ox ) - 29360) / 200;
	local y = (( math.floor( dev_coordinate.ly / 8 ) * 160 + dev_coordinate.oy ) - 24880) / 200;

	return { x = round(x,3), y = round(y,3) };
	
end

function Waypoint:ProcessCommandArguments( arg )
	
	if arg == 'hide' then
		self:SetVisible(false);
	elseif arg == 'show' then
		self:SetVisible(true);
	elseif arg == 'help' then
		Turbine.Shell.WriteLine(self:GetHelp(true));
	else 
		local target, coord_text = arg:match "(target) (.*)";
		if target ~= nil then
			local coor = self:ParseCoordinate(coord_text);
			if coor ~= nil then
				self:SetTargetCoordinate(coor);
			end
		else
			Turbine.Shell.WriteLine(self:GetHelp(true));
		end
	end
	
	
end


function Waypoint:GetHelp(tagged)

	if tagged then
		return "<rgb=#008080>Waypoint</rgb> " .. Plugins.Waypoint:GetVersion() .. " by <rgb=#FF80FF>Lunarwater</rgb>\n" ..
			 "    <rgb=#008080>/way help</rgb> : shows Waypoint help \n" ..
			 "    <rgb=#008080>/way show</rgb> : shows Waypoint \n" ..
			 "    <rgb=#008080>/way hide</rgb> : hides Waypoint \n" ..
			 "    <rgb=#008080>/way target <coordinate></rgb> : target a coordinate for waypoint\n" ..
			 "        (i.e. /way target 21.4S 45W)\n\n";
	else
		return "Waypoint " .. Plugins.Waypoint:GetVersion() .. " by Lunarwater\n" ..
			 "    /way help : shows Waypoint help \n" ..
			 "    /way show : shows Waypoint \n" ..
			 "    /way hide : hides Waypoint \n" ..
			 "    /way target <coordinate> : target a coordinate for waypoint\n" ..
			 "        (i.e. /way target 21.4S 45W)\n\n";
	end 
end
