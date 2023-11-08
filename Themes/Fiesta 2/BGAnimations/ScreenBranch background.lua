local t = Def.ActorFrame{}

local rmin = 0;
local rmax = 6;

local num = math.random(rmin,rmax);

if num == 6 then
	num = tostring(num).."_"..GetLanguageText();
end;

return Def.ActorFrame {
	children = {
		LoadActor( THEME:GetPathG("","ScreenBranch/WP"..num..".png") )..{
			InitCommand=cmd(scale_or_crop_background);
		};
	}
}

