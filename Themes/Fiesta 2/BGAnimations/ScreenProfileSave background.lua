local t = Def.ActorFrame {};

local num = tostring(6).."_"..GetLanguageText();
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenBranch/WP"..num..".png") )..{
	InitCommand=cmd(scale_or_crop_background);
};

t[#t+1] = LoadFont("Common","Normal") .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-50;settext,"Saving players profiles";zoom,.6);--horizalign,'HorizAlign_Left';
	OnCommand=cmd(diffusealpha,0;linear,.2;diffusealpha,1;sleep,1.6;linear,.2;diffusealpha,0;);
}

return t;
