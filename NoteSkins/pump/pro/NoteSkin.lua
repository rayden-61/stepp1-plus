local Noteskin = {}

Noteskin.bBlanks = {
	--["element"] = true|false;
	["Hold Tail Active"] = true;
	["Roll Tail Active"] = true;
	["Roll Tail Inactive"] = true;
	["Roll Tail Inactive"] = true;
}

Noteskin.ElementRedirs = {
	--["element"] = "redirected_element";
	["Hold Head Active"] = "Tap Note";
	["Hold Head Inactive"] = "Tap Note";
	["Roll Head Active"] = "Tap Note";
	["Roll Head Inactive"] = "Tap Note";
	["Tap Fake"] = "Tap Note";
	["Tap Lift"] = "Tap Note";
	--
	["Hold Topcap Inactive"] = "Hold Topcap Active";
	--["Hold Body Inactive"] = "Hold Body Active";
	--["Hold Bottomcap Inactive"] = "Hold Bottomcap Active";
	--["Hold Tail Inactive"] = "Hold Tail Active";
	--
	["Roll Topcap Active"] = "Hold Topcap Active";
	--["Roll Body Active"] = "Roll Body Active";
	--["Roll Bottomcap Active"] = "Hold Bottomcap Active";
	--["Roll Tail Active"] = "Hold Tail Active";
	--
	["Roll Topcap Inactive"] = "Hold Topcap Active";
	--["Roll Body Inactive"] = "Roll Body Active";
	--["Roll Bottomcap Inactive"] = "Hold Bottomcap Active";
	--["Roll Tail Inactive"] = "Hold Tail Active";
}

Noteskin.PartsToRotate = {
	--["elemenu"] = true|false;
	["Roll Head Active"] = false;
	["Roll Head Inactive"] = false;
}

Noteskin.PartsToRedir = {
	["Roll Head Active"] = false;
	["Roll Head Inactive"] = false;
}

Noteskin.ButtonRedirs = {
	Center = "Center";
	UpLeft = "UpLeft";
	UpRight = "UpLeft";
	DownLeft = "DownLeft";
	DownRight = "DownLeft";
}

Noteskin.BaseRotY = {
	Center = 0;
	UpLeft = 0;
	UpRight = 180;
	DownLeft = 0;
	DownRight = 180;
}

local function func()
	local sButton = Var "Button"
	local sElement = Var "Element"
	
	-- blanks
	if Noteskin.bBlanks[sElement] or (sElement == "Receptor" and sButton ~= "Center") then
		local t = Def.Actor {};
		if Var "SpriteOnly" then
			t = LoadActor( "/NoteSkins/pump/default/_blank" );
		end
		return t
	end
	
	-- redir
	local ElementToLoad = Noteskin.ElementRedirs[sElement]
	if not ElementToLoad then
		ElementToLoad = sElement
	end
	
	-- Elements button
	--if sElement == "Explosion" or sElement == "Tap Mine" or sElement == "Tap Lift" then 
	if sElement == "Tap Mine" or sElement == "Tap Lift" then 
		sButton = "UpLeft"
	end
	
	-- Path solve
	local bRedir = Noteskin.PartsToRedir[ElementToLoad];
	if bRedir == nil then bRedir = true end
	
	local path = "";
	
	if bRedir then
		path = NOTESKIN:GetPath(Noteskin.ButtonRedirs[sButton],ElementToLoad)
	else
		path = NOTESKIN:GetPath(sButton,ElementToLoad)
	end
	
	if ( string.find(sElement,"Hold") or string.find(sElement,"Roll") or sElement == "Explosion" ) and not ( string.find(sElement,"Head") or string.find(sElement,"Tail") ) then
		path = NOTESKIN:GetPath(sButton,ElementToLoad)
	end
	
	local t = LoadActor(path)
	local bRotate = Noteskin.PartsToRotate[ElementToLoad]
	if bRotate == nil then bRotate = true end	--rotate by default
	if bRotate and sElement ~= "Explosion" then
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