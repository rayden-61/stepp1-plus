local Noteskin = ... or {}

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
	["Roll Topcap Active"] = "Roll Topcap Active";
	["Roll Body Active"] = "Roll Body Active";
	["Roll Bottomcap Active"] = "Roll Bottomcap Active";
	["Roll Tail Active"] = "Roll Tail Active";
	--
	["Roll Topcap Inactive"] = "Roll Topcap Active";
	["Roll Body Inactive"] = "Roll Body Active";
	["Roll Bottomcap Inactive"] = "Roll Bottomcap Active";
	["Roll Tail Inactive"] = "Roll Tail Active";
}

Noteskin.BaseRotX = {
	Center = 0;
	UpLeft = 0;
	UpRight = 0;
	DownLeft = 0;
	DownRight = 0;
}
Noteskin.BaseRotY = {
	Center = 0;
	UpLeft = 0;
	UpRight = 0;
	DownLeft = 0;
	DownRight = 0;
}
Noteskin.BaseRotZ = {
	Center = 0;
	UpLeft = 0;
	UpRight = 0;
	DownLeft = 0;
	DownRight = 0;
}

return Noteskin