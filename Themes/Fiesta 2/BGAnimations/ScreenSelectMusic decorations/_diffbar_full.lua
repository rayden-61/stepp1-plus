--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local aSteps = {};
local numSteps;

local iChartsToShow = 13;
local bIsExtensiveList = false;
local zoom_factor = 0.66;

--[[
if PREFSMAN:GetPreference("ExtendedStepsList") then
	iChartsToShow = 14;
end;]]--

local curLimInferior = 1;
local curLimSuperior = iChartsToShow;

local t = Def.ActorFrame {
	InitCommand=cmd(draworder,99;zoom,zoom_factor);
	PlayableStepsChangedMessageCommand=function(self)
		if GAMESTATE:IsBasicMode() then return; end;
		aSteps = nil;
		aSteps = SCREENMAN:GetTopScreen():GetPlayableSteps();
		numSteps = #aSteps;
		
		----
		curLimInferior = 1;
		curLimSuperior = iChartsToShow;
		----
		
		if( numSteps > iChartsToShow ) then
			bIsExtensiveList = true;
		else
			bIsExtensiveList = false;
		end;
		---
		
		self:playcommand('UpDate');
	end;
	ChangeStepsMessageCommand=function(self,params)  --solo ocurre en SelectStepsState
		if GAMESTATE:IsBasicMode() then return; end;
		
		----
		if( bIsExtensiveList ) then -- posiblemente se pase a la siguiente hoja de pasos
				local limInf = 1;
				local limSup = iChartsToShow;
				local pos = SCREENMAN:GetTopScreen():GetSelection(params.Player)+1;
				
				local bAnyChange = false;
				
				if pos > curLimInferior or pos < curLimSuperior then
					bAnyChange = true;
				end;
				
				while (limInf>pos) or (limSup<pos)  do
					bAnyChange = true;
					limInf = limInf + iChartsToShow;
					limSup = limSup + iChartsToShow;
				end;
				
				if bAnyChange then
					if limInf == curLimInferior and limSup == curLimSuperior then
						bAnyChange = false;
					else
						curLimInferior = limInf;
						curLimSuperior = limSup;
					end;
				end;
				
				if bAnyChange then				
					local tempSteps = {};
					tempSteps = SCREENMAN:GetTopScreen():GetPlayableSteps();
					aSteps = nil;
					aSteps = {};
					for j=1,iChartsToShow do
						aSteps[j] = tempSteps[j+limInf-1];
					end;
					
					numSteps = #aSteps;
					self:playcommand('UpDate');
				end;
		end;
		
		self:playcommand('UpDateCursor',{Player = params.Player});
	end;
	--OffCommand=cmd(playcommand,'FadeOut');
}

--////////////////////////////////////////////////////////
-- Regresa un número según el estilo de los pasos "i"
local function GetDiffNum(i)
	--No regresa ningun step
	if i > numSteps then return 4; end;
	
	style = aSteps[i]:GetStepsType();
	description = aSteps[i]:GetDescription();

	--Clasificacion de pasos x estilo, single, double, couple o halfdouble
	--TODO: "StepsType_Pump_Couple"
	
	if style=='StepsType_Pump_Single' and string.find( description,"SP" ) then return 2;
	elseif style=='StepsType_Pump_Single' then return 0;
	elseif style=='StepsType_Pump_Couple' then return 3;
	elseif ( style=='StepsType_Pump_Double' and string.find( description,"DP" ) ) or style=='StepsType_Pump_Routine'  then return 3;
	elseif style=='StepsType_Pump_Double' or style=='StepsType_Pump_Halfdouble' then return 1;
	end;
	
	return 4;
end;

--////////////////////////////////////////////////////////
-- ActorFunction: Setea el meter, i=indice
function Actor:SetMeterValue(i,style)
	if i > numSteps then self:settext(""); return; end;

	if GetDiffNum(i) ~= style then
		self:settext("");
		return;
	end;
	
	local num = aSteps[i]:GetMeter();
	if num > 99 then self:settext("99"); return; end;
	if num == 99 then self:settext("??"); return; end;
	if num == -1 then self:settext("!!"); return; end;
	
	self:settext( string.format("%.2d",num) );
end;


--////////////////////////////////////////////////////////
local function GetSmallBallLabel( i )
	if i > numSteps then return GetLabelNumber(""); end;	--empty
	return GetLabelNumber( aSteps[i]:GetLabel() );
end;

local function GetUnderBallLabel( i )
	if i > numSteps then return 2; end;	--empty
	local cur_step = aSteps[i];

	local style = cur_step:GetStepsType();
	local description = cur_step:GetDescription();
	
	if ( style=='StepsType_Pump_Double' and string.find( string.upper(description),"HALFDOUBLE" ) ) or style=='StepsType_Pump_Halfdouble' then
		return 0;
	elseif ( style=='StepsType_Pump_Couple' ) then
		return 1
	end;
	
	return 2;
end;

--////////////////////////////////////////////////////////
--Regresa el indice que esta activo.
local function GetActiveIndex(pn)
	if not GAMESTATE:IsSideJoined(pn) then return nil; end;
	
	local selection = SCREENMAN:GetTopScreen():GetSelection(pn)+1;
	local index = selection;
	
	while index > iChartsToShow do
		index = index - iChartsToShow;
	end;
	
	return index;
end;

--[[
function IsNewStepByGroupCondition()
	local cur_song = GAMESTATE:GetCurrentSong();
	if not getenv("IsNewFor"..cur_song:GetGroupName().."Group") then
		return false;
	end;
	return true;
end;
]]--

local GradeLetters = { 
	["Grade_Tier01"] = "SSS", 
	["Grade_Tier02"] = "X", 
	["Grade_Tier03"] = "G", 
	["Grade_Tier04"] = "A", 
	["Grade_Tier05"] = "B", 
	["Grade_Tier06"] = "C", 
	["Grade_Tier07"] = "D", 
	["Grade_Tier08"] = "F" 
}

local function GetPersonalGrade(pn, i)
	if GAMESTATE:IsSideJoined(pn) and GAMESTATE:HasProfile(pn) and aSteps[i] then
		local HighScores = PROFILEMAN:GetProfile(pn):GetHighScoreList(GAMESTATE:GetCurrentSong(), aSteps[i]):GetHighScores()
		if #HighScores ~= 0 then
			local GradeTier = HighScores[1]:GetGrade()
			local Grade = (GradeTier == "Grade_Failed" and "F" or GradeLetters[GradeTier])
			if Grade == "G" and HighScores[1]:GetTapNoteScore('TapNoteScore_W5') > 0 then
				return "S"
			else
				return Grade
			end
		else
			return nil
		end
	else
		return nil
	end
end

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


--BackDiffList
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/fullbar_black") );

--[[
for i=1,iChartsToShow do
	t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/ball.png") )..{
		OnCommand=cmd(x,-378+(i-1)*63);
	};
end]]

local Xpos = {}
for i=1,iChartsToShow do
	Xpos[i] = -377.8+(i-1)*63;
end

for i=1,iChartsToShow do

	--	Glowing Ring --
	t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/glow_ring") ) .. {
		InitCommand=cmd(x,Xpos[i];blend,'BlendMode_Add';diffusealpha,.2;playcommand,'Spin');
		SpinCommand=cmd(stoptweening;rotationz,0;linear,2;rotationz,-359;queuecommand,'Spin');
	}
	
	--	Dots Glow --
	t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/dots_glow") ) .. {
		InitCommand=cmd(x,Xpos[i];blend,'BlendMode_Add';playcommand,'Loop');
		LoopCommand=cmd(stoptweening;y,-20;diffusealpha,0;linear,.5;y,0;diffusealpha,.2;linear,.5;y,20;diffusealpha,0;sleep,.5;queuecommand,'Loop');
	}
	
	--	DifficultyBalls --
	t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/fullbar balls 5x1.png") )..{
		InitCommand=cmd(x,Xpos[i];pause);
		UpDateCommand=cmd( setstate,GetDiffNum(i);visible,GetDiffNum(i)~=4 );
	}
	
	-- Meters --
	t[#t+1] = LoadFont("N_SINGLE_N") .. {
		InitCommand=cmd(x,Xpos[i]+1;y,-1.1);
		StartSelectingStepsMessageCommand=cmd(x,Xpos[i]+1;linear,.3;y,0);
		GoBackSelectingSongMessageCommand=cmd(x,Xpos[i]+1;linear,.3;y,-1.1);
		UpDateCommand=cmd( SetMeterValue,i,0 );
	};
	
	t[#t+1] = LoadFont("N_SINGLE_P") .. {
		InitCommand=cmd(x,Xpos[i]+1;y,-1.1);
		StartSelectingStepsMessageCommand=cmd(x,Xpos[i]+1;linear,.3;y,0);
		GoBackSelectingSongMessageCommand=cmd(x,Xpos[i]+1;linear,.3;y,-1.1);
		UpDateCommand=cmd( SetMeterValue,i,2 );
	};
	
	t[#t+1] = LoadFont("N_DOUBLE_N") .. {
		InitCommand=cmd(x,Xpos[i]+1;y,-1.1);
		StartSelectingStepsMessageCommand=cmd(x,Xpos[i]+1;linear,.3;y,0);
		GoBackSelectingSongMessageCommand=cmd(x,Xpos[i]+1;linear,.3;y,-1.1);
		UpDateCommand=cmd( SetMeterValue,i,1 );
	};
	
	t[#t+1] = LoadFont("N_DOUBLE_P") .. {
		InitCommand=cmd(x,Xpos[i]+1;y,-1.1);
		StartSelectingStepsMessageCommand=cmd(x,Xpos[i]+1;linear,.3;y,0);
		GoBackSelectingSongMessageCommand=cmd(x,Xpos[i]+1;linear,.3;y,-1.1);
		UpDateCommand=cmd( SetMeterValue,i,3 );
	};
	
	-- Top Rank
	t[#t+1] = Def.Sprite {
		Name="RankP1";
		Texture=THEME:GetPathG("", "RecordGrades/R_F (doubleres).png");
		InitCommand=cmd(x,Xpos[i];y,-30;zoom,0.65);
		UpDateCommand=function(self)
			local Grade = GetPersonalGrade(PLAYER_1, i)
			if Grade ~= nil then
				self:Load(THEME:GetPathG("", "RecordGrades/R_" .. Grade .. " (doubleres).png"))
			else
				self:Load(nil)
			end
		end;
	};
	
	-- Bottom Rank
	t[#t+1] = Def.Sprite {
		Name="RankP2";
		Texture=THEME:GetPathG("", "RecordGrades/R_F (doubleres).png");
		InitCommand=cmd(x,Xpos[i];y,29;zoom,0.65);
		UpDateCommand=function(self)
			local Grade = GetPersonalGrade(PLAYER_2, i)
			if Grade ~= nil then
				self:Load(THEME:GetPathG("", "RecordGrades/R_" .. Grade .. " (doubleres).png"))
			else
				self:Load(nil)
			end
		end;
	};
	
	-- Labels --
	t[#t+1] = LoadActor( THEME:GetPathG("","Common Resources/B_LABELS 1x11.png") ) .. {
		InitCommand=cmd(x,Xpos[i];pause;y,-22;zoom,.55);
		StartSelectingStepsMessageCommand=cmd(x,Xpos[i];linear,.3;y,-21);
		GoBackSelectingSongMessageCommand=cmd(x,Xpos[i];linear,.3;y,-22);
		UpDateCommand=cmd( setstate,GetSmallBallLabel(i) );
	};
	
	-- Under Labels --
	t[#t+1] = LoadActor( THEME:GetPathG("","Common Resources/B_UNDERLABELS 1x3") ).. {
		InitCommand=cmd(x,Xpos[i];pause;y,19;zoom,.5);
		UpDateCommand=cmd( setstate,GetUnderBallLabel(i) );
	};
	
end;

-- Pink arrows ------------------------------------------------
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/fullbar_arrow") )..{
	InitCommand=function(self)
		(cmd(x,425;blend,'BlendMode_Add';zoom,.7;bounce;effectmagnitude,5,0,0;effectperiod,1))(self);
	end;
	UpDateCommand=function(self)
		if bIsExtensiveList then self:visible(true); else self:visible(false); end;
	end;
}

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/fullbar_arrow") )..{
	InitCommand=function(self)
		(cmd(x,-425;rotationz,180;blend,'BlendMode_Add';zoom,.7;bounce;effectmagnitude,-5,0,0;effectperiod,1))(self);
	end;
	UpDateCommand=function(self)
		if bIsExtensiveList then self:visible(true); else self:visible(false); end;
	end;
}

------------------------------------------------
-- Cursor Function --
local function GetCursorFor(pn)
if GAMESTATE:IsSideJoined(pn) or ( not GAMESTATE:IsSideJoined(pn) and GAMESTATE:IsBasicMode() ) then
	local a = Def.ActorFrame {
		InitCommand=function(self)
			if not GAMESTATE:IsSideJoined(pn) then
				self:visible(false);
			end;
		end;
		PlayerJoinedMessageCommand=function(self,params)
			if params.Player == pn then
				self:visible(true);
			end;
		end;
	};
	--
	a[#a+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/fullbar_"..pn.."_cursor") )..{
		InitCommand=cmd(y,-1);
		OnCommand=cmd(stoptweening;diffusealpha,0);
		StartSelectingStepsMessageCommand=function(self)
			if not GAMESTATE:IsSideJoined(pn) then return; end;
			(cmd(stoptweening;x,Xpos[GetActiveIndex(pn)];diffusealpha,0;zoom,1;sleep,.25;linear,.05;diffusealpha,1;queuecommand,'Loop'))(self);
		end;
		UpDateCursorCommand=function(self,params)
			if params.Player ~= pn then return; end;
			(cmd(stoptweening;diffusealpha,1;x,Xpos[GetActiveIndex(pn)];queuecommand,'Loop'))(self);
		end;
		LoopCommand=cmd(stoptweening;zoom,1;diffusealpha,1;linear,.4;zoom,1.1;diffusealpha,.6;linear,.4;zoom,1;diffusealpha,1;queuecommand,'Loop');
		GoBackSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0);
		OffCommand=cmd(stoptweening;diffusealpha,0);

	};
	--
	a[#a+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/fulllevel_"..pn.."_text") )..{
		InitCommand=function(self)
			if pn == PLAYER_1 then
				self:y(-34);	
			else
				self:y(34);
			end;
		end;
		OnCommand=cmd(stoptweening;diffusealpha,0);
		StartSelectingStepsMessageCommand=function(self)
			if not GAMESTATE:IsSideJoined(pn) then return; end;
			(cmd(stoptweening;x,Xpos[GetActiveIndex(pn)];diffusealpha,0;zoom,1;sleep,.25;linear,.05;diffusealpha,1;queuecommand,'Loop'))(self);
		end;
		UpDateCursorCommand=function(self,params)
			if params.Player ~= pn then return; end;
			(cmd(stoptweening;diffusealpha,1;x,Xpos[GetActiveIndex(pn)];queuecommand,'Loop'))(self);
		end;
		LoopCommand=cmd(stoptweening;diffusealpha,1;zoom,1;linear,.4;zoom,1.1;diffusealpha,.6;linear,.4;zoom,1;diffusealpha,1;queuecommand,'Loop');
		GoBackSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0);
		OffCommand=cmd(stoptweening;diffusealpha,0);

	};
	return a;
else 
	return nil;
end;
end;

t[#t+1] = GetCursorFor(PLAYER_1);
t[#t+1] = GetCursorFor(PLAYER_2);


return t;