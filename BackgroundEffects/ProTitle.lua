local Color1 = color(Var "Color1");


local t = Def.ActorFrame {
	LoadActor(Var "File1") .. {
		OnCommand=function(self)
			self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)			
self:scale_or_crop_background()

			self:diffuse(Color1)
			self:effectclock("music")
			self:loop(false)
			
		end;
		GainFocusCommand=cmd(play);
		LoseFocusCommand=cmd(pause);
	};
};





return t;
