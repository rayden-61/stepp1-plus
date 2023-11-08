local Noteskin = {}

Noteskin.bBlanks = {
	--["element"] = true|false;
	["Hold Topcap Active"] 	= true;
	["Hold Topcap Inactive"] = true;
	["Roll Topcap Active"] = true;
	["Roll Topcap Inactive"] = true;
	--
	["Hold Tail Active"] = true;
	["Hold Tail Inactive"] = true;
	["Roll Tail Active"] = true;
	["Roll Tail Inactive"] = true;
}

Noteskin.ElementRedirs = {
	--["element"] = "redirected_element";
	["Tap Fake"] = "Tap Note";
	["Tap Lift"] = "Tap Note";
	--
	["Hold Head Active"] = "Tap Note";
	["Hold Head Inactive"] = "Tap Note";
	["Roll Head Active"] = "Roll Head Active";
	["Roll Head Inactive"] = "Roll Head Active";
	--
	["Hold Body Inactive"] = "Hold Body Active";
	["Roll Body Inactive"] = "Hold Body Active";
	["Roll Body Active"] = "Hold Body Active";
	--
	["Hold Bottomcap Inactive"] = "Hold Bottomcap Active";
	["Roll Bottomcap Inactive"] = "Hold Bottomcap Active";
	["Roll Bottomcap Active"] = "Hold Bottomcap Active";
}

Noteskin.PartsToNotRotate = {
	["Roll Head Active"] = true;
	["Roll Head Inactive"] = true;
	["Hold Body Active"] = true;
	["Hold Bottomcap Active"] = true;
	["Explosion"] = true;
}

Noteskin.ElementsToNotButtonRedir = {
	["Roll Head Active"] = true;
	["Roll Head Inactive"] = true;
	["Hold Body Active"] = true;
	["Hold Bottomcap Active"] = true;
	["Explosion"] = true;
}

Noteskin.ButtonRedirs = {
	Center = "Center";
	UpLeft = "UpLeft";
	UpRight = "UpRight";
	DownLeft = "DownLeft";
	DownRight = "DownRight";
}

Noteskin.BaseRotY = {
	Center = 0;
	UpLeft = 0;
	UpRight = 0;
	DownLeft = 0;
	DownRight = 0;
}

local function func()
	local sButton = Var "Button"
	local sElement = Var "Element"
	local bSpriteOnly = Var "SpriteOnly"
	
	-- blanks
	if Noteskin.bBlanks[sElement] then
		local t = Def.Actor {};
		if bSpriteOnly then
			t = LoadActor( "/NoteSkins/pump/default/_blank" );
		end
		return t
	end
	
	-- Element Redir
	local ElementToLoad = Noteskin.ElementRedirs[sElement]
	if not ElementToLoad then
		ElementToLoad = sElement
	end
	
	-- Mines button exception 
	if sElement == "Tap Mine" then 
		sButton = "UpLeft"
	end
	
	-- Path solve
	local path = "";

	if Noteskin.ElementsToNotButtonRedir[ElementToLoad] then
		path = NOTESKIN:GetPath(sButton,ElementToLoad)
	else
		path = NOTESKIN:GetPath(Noteskin.ButtonRedirs[sButton],ElementToLoad)
	end
	
	local t = LoadActor(path)
	if not Noteskin.PartsToNotRotate[ElementToLoad] then
		t.BaseRotationY=Noteskin.BaseRotY[sButton]
	end
	
	-- Lift with bounce
	if sElement == "Tap Lift" then
		t.InitCommand=cmd(pulse;effectclock,"beat";effectmagnitude,1,0.75,0);
	end
	
	return t
end

Noteskin.Load = func
Noteskin.CommonLoad = func

return Noteskin