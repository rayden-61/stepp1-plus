local Noteskin = {}

--bBlanks:
Noteskin.bBlanks = {
	--["element"] = true|false;
	["Hold Tail Active"] = true;
	["Hold Tail Active"] = true;
	["Roll Tail Inactive"] = true;
	["Roll Tail Inactive"] = true;
}
Noteskin.PartsToRotate = {
	--["elemenu"] = true|false;
	["Roll Head Active"] = false;
	["Roll Head Inactive"] = false;
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
	["Hold Body Inactive"] = "Hold Body Active";
	["Hold Bottomcap Inactive"] = "Hold Bottomcap Active";
	["Hold Tail Inactive"] = "Hold Tail Active";
	--
	["Roll Topcap Active"] = "Hold Topcap Active";
	["Roll Body Active"] = "Roll Body Active";
	["Roll Bottomcap Active"] = "Roll Bottomcap Active";
	["Roll Tail Active"] = "Hold Tail Active";
	--
	["Roll Topcap Inactive"] = "Hold Topcap Active";
	["Roll Body Inactive"] = "Roll Body Active";
	["Roll Bottomcap Inactive"] = "Roll Bottomcap Active";
	["Roll Tail Inactive"] = "Hold Tail Active";
}
-- explicit, n/w
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

--[[--------------------------------------------------------------------------
DONT EDIT THE FUNCTION, DON'T COPY AND PASTE THE WHOLE NOTESKIN.LUA
JUST MAKE A NEW ONE AND GRAB WHATEVER IS USEFUL FOR YOUR NOTESKIN.
phew~

See cmd-routine-p* noteskin.lua for a simple and clear example on
how to do this properly, notice how the rest of the noteskins just
have graphics and at least a metrics.ini with few things
--]]--------------------------------------------------------------------------
local function func()
	local sButton = Var "Button"
	local sElement = Var "Element"
	
	if Noteskin.bBlanks[sElement] then
		local t = Def.Actor {};
		if Var "SpriteOnly" then
			t = LoadActor( "_blank" );
		end
		return t
	end
	
	local sButtonToLoad = sButton
	
	local ElementToLoad = Noteskin.ElementRedirs[sElement]
	if not ElementToLoad then
		ElementToLoad = sElement
	end
	
	if sElement == "Explosion"
	or sElement == "Tap Mine"
	or sElement == "Receptor"
	or sElement == "Press"
	then
		sButtonToLoad = "UpLeft"
	end
	
	if ElementToLoad == "Tap Note" then
		sButtonToLoad = Noteskin.ButtonRedirs[sButton]
	end;
	
	local path = NOTESKIN:GetPath(sButtonToLoad,ElementToLoad)
	if ( string.find(sElement,"Hold") or string.find(sElement,"Roll") )
	and not ( string.find(sElement,"Head") or string.find(sElement,"Tail") )
	then
		path = NOTESKIN:GetPath(sButtonToLoad,ElementToLoad)
	end
	
	local t = LoadActor(path)
	if ElementToLoad == "Tap Note" then
		t.BaseRotationY=Noteskin.BaseRotY[sButton];
	end
	
	if sElement == "Tap Lift" then
		t.InitCommand=cmd(pulse;effectclock,"beat";effectmagnitude,1,0.75,0);
	end
	
	return t
end

Noteskin.Load = func
Noteskin.CommonLoad = func

return Noteskin