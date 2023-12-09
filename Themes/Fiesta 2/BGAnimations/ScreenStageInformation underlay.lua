local t = Def.ActorFrame {}

t[#t+1] = LoadActor(GetBackgroundPath()) .. {
	InitCommand=cmd(show_background_properly)
}

if GAMESTATE:IsSideJoined(PLAYER_1) then
	t[#t+1] = Def.Sprite {
		Texture=THEME:GetPathG("", "ScreenStageInformation/StepArtistP1"),
		InitCommand=function(self)
			self:xy(58, SCREEN_BOTTOM-21)
			self:zoom(0.6)
		end
	}
	
	t[#t+1] = Def.BitmapText {
		Font="_myriad pro 20px",
		InitCommand=function(self)
			self:xy(18.5, SCREEN_BOTTOM-18)
			self:zoom(0.6)
			self:horizalign(left)
			self:wrapwidthpixels(130)
			self:vertspacing(-8)
			self:maxheight(30)
			self:maxwidth(130)
		end,
		OnCommand=function(self)
			if GAMESTATE:GetCurrentSteps(PLAYER_1):GetAuthorCredit() ~= "" then
				self:settext(GAMESTATE:GetCurrentSteps(PLAYER_1):GetAuthorCredit())
			else
				self:settext("Unknown")
			end
		end
	}

	t[#t+1] = GetBallLevel( PLAYER_1, false )..{ 
		InitCommand=cmd(basezoom,.57;x,cx-275;playcommand,"ShowUp";y,SCREEN_BOTTOM-40;pause;); 
	};

end

if GAMESTATE:IsSideJoined(PLAYER_2) then
	t[#t+1] = Def.Sprite {
		Texture=THEME:GetPathG("", "ScreenStageInformation/StepArtistP2"),
		InitCommand=function(self)
			self:xy(SCREEN_RIGHT-58, SCREEN_BOTTOM-21)
			self:zoom(0.6)
		end
	}
	
	t[#t+1] = Def.BitmapText {
		Font="_myriad pro 20px",
		InitCommand=function(self)
			self:xy(SCREEN_RIGHT-18.5, SCREEN_BOTTOM-18)
			self:zoom(0.6)
			self:horizalign(right)
			self:wrapwidthpixels(130)
			self:vertspacing(-8)
			self:maxheight(30)
			self:maxwidth(130)
		end,
		OnCommand=function(self)
			if GAMESTATE:GetCurrentSteps(PLAYER_2):GetAuthorCredit() ~= "" then
				self:settext(GAMESTATE:GetCurrentSteps(PLAYER_2):GetAuthorCredit())
			else
				self:settext("Unknown")
			end
		end
	}

	t[#t+1] = GetBallLevel( PLAYER_2, false )..{ 
		InitCommand=cmd(basezoom,.57;x,cx+275;playcommand,"ShowUp";y,SCREEN_BOTTOM-40;pause;); 
	};
end

return t


