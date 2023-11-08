local Color1 = color(Var "Color1");
local stretchBG = PREFSMAN:GetPreference("StretchBackgrounds")
local ratio = PREFSMAN:GetPreference("DisplayAspectRatio")

local t = Def.ActorFrame {
	LoadActor(Var "File1") .. {
		OnCommand=function(self)
			self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
			
			if stretchBG then
				self:SetSize(SCREEN_WIDTH,SCREEN_HEIGHT)
			else
				if (ratio > 1.5) then
					self:scaletofit(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
				else
					self:scale_or_crop_background();
				end;
			end

			self:diffuse(Color1)
			self:effectclock("music")
			self:loop(false)
			
		end;
		GainFocusCommand=cmd(play);
		LoseFocusCommand=cmd(pause);
	};
};

return t;
