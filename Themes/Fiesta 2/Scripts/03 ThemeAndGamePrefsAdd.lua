--[[function GetInitBasicGroup()
	local sNames=SONGMAN:GetSongGroupNames();
	local foundit = false;
	
	for i=1,(#sNames) do
		if sNames[i] == "BasicModeGroup" then
			foundit = true;
		end;
	end;
	
	if foundit then
		return "BasicModeGroup";
	else
		return sNames[1];
	end;
end;


function GetInitFullGroup()
	local sNames=SONGMAN:GetSongGroupNames();
	local foundit = false;
	
	for i=1,(#sNames) do
		if sNames[i] == "Examples" then
			foundit = true;
		end;
	end;
	
	if foundit then
		return "Examples";
	else
		return sNames[1];
	end;
end;
]]--

function GamePrefBasicModeGroup()
	local sNames=SONGMAN:GetSongGroupNames();
	local t = {
		Name = "GamePrefBasicModeGroup";
		LayoutType = "ShowOneInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = sNames;
		LoadSelections = function(self, list, pn)
			if (ReadGamePrefFromFile("BasicModeGroup") ~= nil) then
				local group = GetGamePref("BasicModeGroup");
				local gottrue = false;
				for i=1,(#sNames) do
					if (sNames[i]==group) then
						list[i]=true;
						gottrue=true;
					else
						list[i]=false;
					end;
				end;
				if not gottrue then
					WriteGamePrefToFile("BasicModeGroup",GetInitBasicGroup());	-- setea el primer grupo
					list[1] = true;
				end;
			else
				WriteGamePrefToFile("BasicModeGroup",GetInitBasicGroup());	-- setea el primer grupo
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			local val = sNames[1];	--default
			for i=1,#list do
				if list[i] then
					val = sNames[i];
				end;
			end;
			WriteGamePrefToFile("BasicModeGroup",val);
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" } );
			THEME:ReloadMetrics();
		end;
	};
	setmetatable( t, t );
	return t;
end;

function GamePrefFullModeGroup()
	local sNames=SONGMAN:GetSongGroupNames();
	local t = {
		Name = "GamePrefFullModeGroup";
		LayoutType = "ShowOneInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = sNames;
		LoadSelections = function(self, list, pn)
			if (ReadGamePrefFromFile("FullModeGroup") ~= nil) then
				local group = GetGamePref("FullModeGroup");
				local gottrue = false;
				for i=1,(#sNames) do
					if (sNames[i]==group) then
						list[i]=true;
						gottrue=true;
					else
						list[i]=false;
					end;
				end;
				if not gottrue then
					WriteGamePrefToFile("FullModeGroup",GetInitFullGroup());	-- setea el primer grupo
					list[1] = true;
				end;
			else
				WriteGamePrefToFile("FullModeGroup",GetInitFullGroup());	-- setea el primer grupo
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			local val = sNames[1];	--default
			for i=1,#sNames do
				if list[i] then
					val = sNames[i];
				end;
			end;
			WriteGamePrefToFile("FullModeGroup",val);
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" } );
			THEME:ReloadMetrics();
		end;
	};
	setmetatable( t, t );
	return t;
end

function GamePrefDemonstrationGroup()
	local sNames=SONGMAN:GetSongGroupNames();
	local t = {
		Name = "GamePrefDemonstrationGroup";
		LayoutType = "ShowOneInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = sNames;
		LoadSelections = function(self, list, pn)
			if (ReadGamePrefFromFile("DemonstrationGroup") ~= nil) then
				local group = GetGamePref("DemonstrationGroup");
				local gottrue = false;
				for i=1,(#sNames) do
					if (sNames[i]==group) then
						list[i]=true;
						gottrue=true;
					else
						list[i]=false;
					end;
				end;
				if not gottrue then
					WriteGamePrefToFile("DemonstrationGroup",sNames[1]);	-- setea el primer grupo
					list[1] = true;
				end;
			else
				WriteGamePrefToFile("DemonstrationGroup",sNames[1]);	-- setea el primer grupo
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			local val = sNames[1];	--default
			for i=1,#sNames do
				if list[i] then
					val = sNames[i];
				end;
			end;
			WriteGamePrefToFile("DemonstrationGroup",val);
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" } );
			THEME:ReloadMetrics();
		end;
	};
	setmetatable( t, t );
	return t;
end

function GamePrefCWColor()
	local t = {
		Name = "GamePrefCWColor";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = {"Blue","Orange"};
		LoadSelections = function(self, list, pn)
			local color = PREFSMAN:GetPreference("CWColor");
			--if ReadGamePrefFromFile("CWColor") ~= nil then
				if color == "Blue" then
					list[1] = true;
				elseif color == "Orange" then
					list[2] = true;
				else
					list[1] = true;	-- default
				end;
			--else
			--	WriteGamePrefToFile("CWColor","Blue");
			--	list[1] = true;
			--end;
		end;
		SaveSelections = function(self, list, pn)
			local val = "";
			if list[1] then
				val = "Blue";
			elseif list[2] then
				val = "Orange";
			else
				val = "Blue";
			end;
			--WriteGamePrefToFile("CWColor",val);
			PREFSMAN:SetPreference("CWColor",val);
			PREFSMAN:SavePreferences();
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" } );
			THEME:ReloadMetrics();
		end;
	};
	setmetatable( t, t );
	return t;
end

function GameSSMTimer()
	local t = {
		Name = "GameSSMTimer";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = {"30","60","90"};
		LoadSelections = function(self, list, pn)
			if ReadGamePrefFromFile("SSMTimer") ~= nil then
				if GetGamePref("SSMTimer") == "31" then
					list[1] = true;
				elseif GetGamePref("SSMTimer") == "61" then
					list[2] = true;
				elseif GetGamePref("SSMTimer") == "91" then
					list[3] = true;
				else
					list[1] = true;	-- default
				end;
			else
				WriteGamePrefToFile("SSMTimer","31");
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			local val = "";
			if list[1] then
				val = "31";
			elseif list[2] then
				val = "61";
			elseif list[3] then
				val = "91";
			else
				val = "31";
			end;
			WriteGamePrefToFile("SSMTimer",val);
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" } );
			THEME:ReloadMetrics();
		end;
	};
	setmetatable( t, t );
	return t;
end

function UseBasicModeForLocalProfile()
	local t = {
		Name = "UseBasicModeForLocalProfile";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = {"Yes","No"};
		LoadSelections = function(self, list, pn)
			if ReadGamePrefFromFile("UseBasicModeForLocalProfile") ~= nil then
				if GetGamePref("UseBasicModeForLocalProfile") == "Yes" then
					list[1] = true;
				elseif GetGamePref("UseBasicModeForLocalProfile") == "No" then
					list[2] = true;
				else
					list[1] = true;	-- default
				end;
			else
				WriteGamePrefToFile("UseBasicModeForLocalProfile","Yes");
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			local val = "";
			if list[1] then
				val = "Yes";
			elseif list[2] then
				val = "No";
			else
				val = "Yes";
			end;
			WriteGamePrefToFile("UseBasicModeForLocalProfile",val);
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" } );
			THEME:ReloadMetrics();
		end;
	};
	setmetatable( t, t );
	return t;
end

function ExtendedStepsList()
	local t = {
		Name = "ExtendedStepsList";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = {"Normal","Extended"};
		LoadSelections = function(self, list, pn)
			if ReadGamePrefFromFile("ExtendedStepsList") ~= nil then
				if GetGamePref("ExtendedStepsList") == "Normal" then
					list[1] = true;
				elseif GetGamePref("ExtendedStepsList") == "Extended" then
					list[2] = true;
				else
					list[1] = true;	-- default
				end;
			else
				WriteGamePrefToFile("ExtendedStepsList","Normal");
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			local val = "";
			if list[1] then
				val = "Normal";
			elseif list[2] then
				val = "Extended";
			else
				val = "Extended";
			end;
			WriteGamePrefToFile("ExtendedStepsList",val);
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" } );
			THEME:ReloadMetrics();
		end;
	};
	setmetatable( t, t );
	return t;
end

function InputDebounceTime()
	local t = {
		Name = "InputDebounceTime";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = {"0","0.01","0.02","0.03","0.04","0.05"};
		LoadSelections = function(self, list, pn)
			local value = math.ceil(tonumber(PREFSMAN:GetPreference("InputDebounceTime")) * 100);
			if value == 0 then
				list[1] = true;
			elseif value == 1 then
				list[2] = true;
			elseif value == 2 then
				list[3] = true;
			elseif value == 3 then
				list[4] = true;
			elseif value == 4 then
				list[5] = true;
			elseif value == 5 then
				list[6] = true;
			else
				list[1] = true;	-- default
			end;
		end;
		SaveSelections = function(self, list, pn)
			local val = "";
			if list[1] then
				val = "0";
			elseif list[2] then
				val = "0.01";
			elseif list[3] then
				val = "0.02";
			elseif list[4] then
				val = "0.03";
			elseif list[5] then
				val = "0.04";
			elseif list[6] then
				val = "0.05";
			else
				val = "0";
			end;
			PREFSMAN:SetPreference("InputDebounceTime",val);
			PREFSMAN:SavePreferences();
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" } );
			--THEME:ReloadMetrics();
		end;
	};
	setmetatable( t, t );
	return t;
end