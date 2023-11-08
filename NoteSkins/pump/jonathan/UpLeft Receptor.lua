local t = Def.ActorFrame {};

	if Var "Button" == "Center" and GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetStepsType() ~= "StepsType_Pump_Halfdouble" then 

		t[#t+1] = NOTESKIN:LoadActor("Center", "Outline")..{
			Name="Outline Full";
		};
	
	end;
	
	if Var "Button" == "DownLeft" and GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetStepsType() == "StepsType_Pump_Halfdouble" then 

		t[#t+1] = NOTESKIN:LoadActor("DownLeft", "Outline")..{
		InitCommand=cmd(x,-25);
			Name="Outline Full";
		};
	
	end;
	
	
	
t[#t+1] = NOTESKIN:LoadActor(Var "Button", "Ready Receptor")..{
		Name="Base";
		Frames = { { Frame = 0 } };
		OnCommand=cmd(animate,false);
		
	};

t[#t+1] = NOTESKIN:LoadActor(Var "Button", "Ready Receptor")..{
		Name="Base";
		Frames = { { Frame = 1 } };
		InitCommand=cmd(animate,false;blend,Blend.Add);
		OnCommand=cmd(diffuseshift;effectcolor1,1,1,1,0;effectcolor2,1,1,1,1;effecttiming,0,0,1,0;effectclock,"bgm");
	};
	
	


t[#t+1] = NOTESKIN:LoadActor(Var "Button", "Hit")..{
		Name="Glow";
		Frames = { { Frame = 1 } };
		InitCommand=cmd(diffusealpha,0);
		PressCommand=cmd(stoptweening;diffusealpha,1;zoom,0.95;linear,0.25;zoom,1.1;diffusealpha,0);
	};
	


return t