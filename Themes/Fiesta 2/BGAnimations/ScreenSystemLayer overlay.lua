local t = Def.ActorFrame {}

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Revisa en los metrics de la screen si se deben o no mostrar los creditos
function ShowCredits()
	local screen = SCREENMAN:GetTopScreen();
	local bShow = true;
	if screen then
		local sClass = screen:GetName();
		bShow = THEME:GetMetric( sClass, "ShowCreditDisplay" );
	end
	return( bShow );
end;

function Actor:ShowIfCreditsAreInScreen()
	if ShowCredits() then self:visible( true ); else self:visible( false ); end;
end;
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSystemLayer/STEPP1") )..{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_HEIGHT-14;zoom,.8);
	ScreenChangedMessageCommand=cmd(ShowIfCreditsAreInScreen);
};

--[[
t[#t+1] = LoadActor(THEME:GetPathG("","Messages/back.png"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+90;diffusealpha,1;zoom,.7;visible,false);
		ScreenChangedMessageCommand=function(self)
			local screen = SCREENMAN:GetTopScreen():GetName();
			if screen == "ScreenSelectMusic" then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
};

t[#t+1] = LoadActor(THEME:GetPathG("","Messages/back_glow.png"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+90;diffusealpha,1;zoom,.7;blend,"BlendMode_Add";visible,false);
		OnCommand=cmd(diffusealpha,.2);
		ScreenChangedMessageCommand=function(self)
			local screen = SCREENMAN:GetTopScreen():GetName();
			if screen == "ScreenSelectMusic" then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
};
	
t[#t+1] = LoadActor(THEME:GetPathG("","Messages/goback_"..GetLanguageText()..".png"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+90;diffusealpha,1;zoom,.7;visible,false);
		OnCommand=cmd(zoom,.47);
		ScreenChangedMessageCommand=function(self)
			local screen = SCREENMAN:GetTopScreen():GetName();
			if screen == "ScreenSelectMusic" then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
};
--]]
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Pantallas en las que no se muestra el nombre de los jugadores.
local Screens = {
	("ScreenInit"),("ScreenLogo"),("ScreenBranch"),("ScreenTitleMenu"),("ScreenOptionsService"),("ScreenGameOver"),("ScreenNextStage"),("ScreenStageBreak"),("ScreenStageInformation"),("ScreenDelay"),("ScreenDemonstration"),("ScreenUSBProfileSave"),("ScreenWarning"),("ScreenWaiting"), ("ScreenGameplayNormal"), ("ScreenGameplay"),("ScreenPrevGameplayDelay"),("ScreenAfterGameplayDelay")
};

--actor para mostrar o no el nombre del jugador
function Actor:ShowPlayerName(pn)
	local screen = SCREENMAN:GetTopScreen():GetName();
	local show = true;
	for i=1,#Screens do
		if Screens[i] == screen then show = false; end;
	end;
	
	--if not show then
	self:visible( show );
	
	-- Se resetea la posicion en x, ademas de mostrar los nombres.
	if screen == "ScreenSelectProfile" then
		self:y(SCREEN_HEIGHT+20);
	end;
end;

--frame que define el background y font para el nombre
local function PlayerName( Player )
	local t = Def.ActorFrame {
		LoadActor( THEME:GetPathG("","ScreenSystemLayer/PlayerName background "..Player) )..{
			Name = "Back1";
		};
		LoadFont("","_myriad pro 20px") .. {
			Name = "Name";
			InitCommand=cmd(horizalign,left;y,-8;x,-70);
		};
		LoadFont("","_myriad pro 20px") .. {
			Name = "SessionDataText";
			InitCommand=cmd(horizalign,left;y,7;x,-70;zoom,.54;diffuse,color("#00FFFF"));
		};
		LoadActor(THEME:GetPathS("","Sounds/Voice")) .. {
			Name = "StageBreakSound";
			OnCommand=cmd(playcommand,'Play');
			PlayCommand=function(self)
				self:play();
			end;
		};
	};
	return t;
end;

function GetDigit( number, digit )
	local d1 = math.floor(number/10);
	local d2 = number - math.floor(number/10)*10;
	
	if digit == 1 then
		return ( d1+d1*10 );
	elseif digit == 2 then
		return ( d2+d1*10 );
	end;
	
	return 1;
end;

local SessionDataTable = {};
local P1CurrentProfile="";
local P1CurrentSongTimeS=0;
local P1CurrentSongTimeD=0;
local P1CurrentLevelTimeS=0;
local P1CurrentLevelTimeD=0;
-- Player 1 Name
t[#t+1] = PlayerName( PLAYER_1 )..{
	InitCommand=function(self)
		if IsHD() then
			self:x(SCREEN_CENTER_X-270);
		else
			self:x(SCREEN_CENTER_X-170);
		end;
	(cmd(y,SCREEN_HEIGHT+20;basezoom,.66))(self);
	end;
	PlayerStartedSelectProfileMessageCommand=function( self, params )
		local la = SCREENMAN:GetTopScreen():GetName();
		if (params.Player == PLAYER_1) then
			local name = self:GetChild("Name");
			name:settext("GUEST P1");
			P1CurrentProfile = "GUEST P1";
			local SessionDataText = self:GetChild("SessionDataText");
			if SessionDataTable[P1CurrentProfile] ~= nil then
				local formattedtimeP1 = FormatTimeLong(SessionDataTable[P1CurrentProfile]["PlaytimeS"]+SessionDataTable[P1CurrentProfile]["PlaytimeD"]);
				local SingleLevelNum = 0;
				local SingleLevelString = "S00";
				if SessionDataTable[P1CurrentProfile]["PlaytimeS"] ~= 0 then
					SingleLevelNum = math.floor(SessionDataTable[P1CurrentProfile]["LeveltimeS"]/SessionDataTable[P1CurrentProfile]["PlaytimeS"]);
					if SingleLevelNum > 9 then SingleLevelString = "S"..SingleLevelNum else SingleLevelString = "S0"..SingleLevelNum end;
				end;
				local DoubleLevelNum = 0;
				local DoubleLevelString = "D00";
				if SessionDataTable[P1CurrentProfile]["PlaytimeD"] ~= 0 then
					DoubleLevelNum = math.floor(SessionDataTable[P1CurrentProfile]["LeveltimeD"]/SessionDataTable[P1CurrentProfile]["PlaytimeD"]);
					if DoubleLevelNum > 9 then DoubleLevelString = "D"..DoubleLevelNum else DoubleLevelString = "D0"..DoubleLevelNum end;
				end;
				SessionDataText:settext("Lv. "..SingleLevelString.." / "..DoubleLevelString.."   ♫"..SessionDataTable[P1CurrentProfile]["SongsPlayed"].." ("..formattedtimeP1..")".."   Kcal: "..math.floor(SessionDataTable[P1CurrentProfile]["Kcals"]));
			else
				SessionDataText:settext("");
			end;
			(cmd(stoptweening;y,SCREEN_HEIGHT+20;linear,.2;y,SCREEN_HEIGHT-15))(self);
		end;
	end;
	ScreenChangedMessageCommand=function(self)
		local screen = SCREENMAN:GetTopScreen():GetName();
		if SessionDataTable[P1CurrentProfile] ~= nil then
			if screen == "ScreenEvaluationNormal" then
				SessionDataTable[P1CurrentProfile]["Kcals"] = SessionDataTable[P1CurrentProfile]["Kcals"] + STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetCaloriesBurned()*0.50;
				if SessionDataTable[P1CurrentProfile]["Kcals"] > 9999 then SessionDataTable[P1CurrentProfile]["Kcals"] = 9999 end;
				SessionDataTable[P1CurrentProfile]["SongsPlayed"] = SessionDataTable[P1CurrentProfile]["SongsPlayed"] + 1;
				if SessionDataTable[P1CurrentProfile]["SongsPlayed"] > 99 then SessionDataTable[P1CurrentProfile]["SongsPlayed"] = 99 end;
			elseif screen == "ScreenStageBreak" then
				self:GetChild("StageBreakSound"):play();
			end;
			SessionDataTable[P1CurrentProfile]["PlaytimeS"] = SessionDataTable[P1CurrentProfile]["PlaytimeS"] + P1CurrentSongTimeS;
			SessionDataTable[P1CurrentProfile]["PlaytimeD"] = SessionDataTable[P1CurrentProfile]["PlaytimeD"] + P1CurrentSongTimeD;
			SessionDataTable[P1CurrentProfile]["LeveltimeS"] = SessionDataTable[P1CurrentProfile]["LeveltimeS"] + P1CurrentLevelTimeS;
			SessionDataTable[P1CurrentProfile]["LeveltimeD"] = SessionDataTable[P1CurrentProfile]["LeveltimeD"] + P1CurrentLevelTimeD;
		else
			SessionDataTable[P1CurrentProfile] = {};
			SessionDataTable[P1CurrentProfile]["PlaytimeS"] = 0;
			SessionDataTable[P1CurrentProfile]["PlaytimeD"] = 0;
			SessionDataTable[P1CurrentProfile]["Kcals"] = 0;
			SessionDataTable[P1CurrentProfile]["SongsPlayed"] = 0;
			SessionDataTable[P1CurrentProfile]["LeveltimeS"] = 0;
			SessionDataTable[P1CurrentProfile]["LeveltimeD"] = 0;
		end;
		P1CurrentSongTimeS = 0;
		P1CurrentSongTimeD = 0;
		P1CurrentLevelTimeS = 0;
		P1CurrentLevelTimeD = 0;
		local SessionDataText = self:GetChild("SessionDataText");
		local formattedtimeP1 = FormatTimeLong(SessionDataTable[P1CurrentProfile]["PlaytimeS"]+SessionDataTable[P1CurrentProfile]["PlaytimeD"]);
		local SingleLevelNum = 0;
		local SingleLevelString = "S00";
		if SessionDataTable[P1CurrentProfile]["PlaytimeS"] ~= 0 then
			SingleLevelNum = math.floor(SessionDataTable[P1CurrentProfile]["LeveltimeS"]/SessionDataTable[P1CurrentProfile]["PlaytimeS"]);
			if SingleLevelNum > 9 then SingleLevelString = "S"..SingleLevelNum else SingleLevelString = "S0"..SingleLevelNum end;
		end;
		local DoubleLevelNum = 0;
		local DoubleLevelString = "D00";
		if SessionDataTable[P1CurrentProfile]["PlaytimeD"] ~= 0 then
			DoubleLevelNum = math.floor(SessionDataTable[P1CurrentProfile]["LeveltimeD"]/SessionDataTable[P1CurrentProfile]["PlaytimeD"]);
			if DoubleLevelNum > 9 then DoubleLevelString = "D"..DoubleLevelNum else DoubleLevelString = "D0"..DoubleLevelNum end;
		end;
		SessionDataText:settext("Lv. "..SingleLevelString.." / "..DoubleLevelString.."   ♫"..SessionDataTable[P1CurrentProfile]["SongsPlayed"].." ("..formattedtimeP1..")".."   Kcal: "..math.floor(SessionDataTable[P1CurrentProfile]["Kcals"]));
		(cmd(stoptweening;ShowPlayerName,1))(self);
		end;
	HideProfileChangesMessageCommand=function(self,params)
		if params.pn=='PlayerNumber_P1' then
			local name = self:GetChild("Name");
			name:settext("GUEST P1");
			P1CurrentProfile = "GUEST P1";
			local SessionDataText = self:GetChild("SessionDataText");
			if SessionDataTable[P1CurrentProfile] ~= nil then
				local formattedtimeP1 = FormatTimeLong(SessionDataTable[P1CurrentProfile]["PlaytimeS"]+SessionDataTable[P1CurrentProfile]["PlaytimeD"]);
				local SingleLevelNum = 0;
				local SingleLevelString = "S00";
				if SessionDataTable[P1CurrentProfile]["PlaytimeS"] ~= 0 then
					SingleLevelNum = math.floor(SessionDataTable[P1CurrentProfile]["LeveltimeS"]/SessionDataTable[P1CurrentProfile]["PlaytimeS"]);
					if SingleLevelNum > 9 then SingleLevelString = "S"..SingleLevelNum else SingleLevelString = "S0"..SingleLevelNum end;
				end;
				local DoubleLevelNum = 0;
				local DoubleLevelString = "D00";
				if SessionDataTable[P1CurrentProfile]["PlaytimeD"] ~= 0 then
					DoubleLevelNum = math.floor(SessionDataTable[P1CurrentProfile]["LeveltimeD"]/SessionDataTable[P1CurrentProfile]["PlaytimeD"]);
					if DoubleLevelNum > 9 then DoubleLevelString = "D"..DoubleLevelNum else DoubleLevelString = "D0"..DoubleLevelNum end;
				end;
				SessionDataText:settext("Lv. "..SingleLevelString.." / "..DoubleLevelString.."   ♫"..SessionDataTable[P1CurrentProfile]["SongsPlayed"].." ("..formattedtimeP1..")   ".."~Lv. "..SingleLevelString.." / "..DoubleLevelString.."   Kcal: "..math.floor(SessionDataTable[P1CurrentProfile]["Kcals"]));
			else
				SessionDataText:settext("");
			end;
			self:y(SCREEN_HEIGHT-15);
		end;
	end;
	LocalProfileChangeMessageCommand=function(self,params)	--cambio la profile del jugador
		if params.pn=='PlayerNumber_P1' then
			local name = self:GetChild("Name");
			name:settext( string.upper(string.sub(params.name,1,8)) ); --corta el nombre hasta 8 letras
			P1CurrentProfile = params.name;
			local SessionDataText = self:GetChild("SessionDataText");
			if SessionDataTable[P1CurrentProfile] ~= nil then
				local formattedtimeP1 = FormatTimeLong(SessionDataTable[P1CurrentProfile]["PlaytimeS"]+SessionDataTable[P1CurrentProfile]["PlaytimeD"]);
				local SingleLevelNum = 0;
				local SingleLevelString = "S00";
				if SessionDataTable[P1CurrentProfile]["PlaytimeS"] ~= 0 then
					SingleLevelNum = math.floor(SessionDataTable[P1CurrentProfile]["LeveltimeS"]/SessionDataTable[P1CurrentProfile]["PlaytimeS"]);
					if SingleLevelNum > 9 then SingleLevelString = "S"..SingleLevelNum else SingleLevelString = "S0"..SingleLevelNum end;
				end;
				local DoubleLevelNum = 0;
				local DoubleLevelString = "D00";
				if SessionDataTable[P1CurrentProfile]["PlaytimeD"] ~= 0 then
					DoubleLevelNum = math.floor(SessionDataTable[P1CurrentProfile]["LeveltimeD"]/SessionDataTable[P1CurrentProfile]["PlaytimeD"]);
					if DoubleLevelNum > 9 then DoubleLevelString = "D"..DoubleLevelNum else DoubleLevelString = "D0"..DoubleLevelNum end;
				end;
				SessionDataText:settext("Lv. "..SingleLevelString.." / "..DoubleLevelString.."   ♫"..SessionDataTable[P1CurrentProfile]["SongsPlayed"].." ("..formattedtimeP1..")".."   Kcal: "..math.floor(SessionDataTable[P1CurrentProfile]["Kcals"]));
			else
				SessionDataText:settext("");
			end;
			self:y(SCREEN_HEIGHT-15);
		end;
	end;
	PlayerUnjoinedMessageCommand=function(self,params)
		if params.Player ~= 'PlayerNumber_P1' then return; end;
		local name = self:GetChild("Name");
		name:settext("");
		P1CurrentProfile = "";
		local SessionDataText = self:GetChild("SessionDataText");
		SessionDataText:settext("");
		self:y(SCREEN_HEIGHT+20);
	end;
	JudgmentMessageCommand=function(self,param)
		if GAMESTATE:IsSideJoined(PLAYER_1) then
			local P1CurrentSongTime = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetAliveSeconds();
			local style = GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType();
			local meter = GAMESTATE:GetCurrentSteps(PLAYER_1):GetMeter();
			if style == 'StepsType_Pump_Single' or style == 'StepsType_Pump_Routine' then
				P1CurrentLevelTimeS = P1CurrentSongTime * meter;
				P1CurrentLevelTimeD = 0;
				P1CurrentSongTimeS = P1CurrentSongTime;
				P1CurrentSongTimeD = 0;
			else
				if meter == 99 then meter = 15 end; --co-op charts will be treated as level 15 as to not inflate average level absurdly.
				P1CurrentLevelTimeS = 0;
				P1CurrentLevelTimeD = P1CurrentSongTime * meter;
				P1CurrentSongTimeS = 0;
				P1CurrentSongTimeD = P1CurrentSongTime;
			end;
		end;
	end;
};


-- Player 2 Name
local P2CurrentProfile="";
local P2CurrentSongTimeS=0;
local P2CurrentSongTimeD=0;
local P2CurrentLevelTimeS=0;
local P2CurrentLevelTimeD=0;
t[#t+1] = PlayerName( PLAYER_2 )..{
	InitCommand=function(self)
		if IsHD() then
			self:x(SCREEN_CENTER_X+270);
		else
			self:x(SCREEN_CENTER_X+170);
		end;
	(cmd(y,SCREEN_HEIGHT+20;basezoom,.66))(self);
	end;
	PlayerStartedSelectProfileMessageCommand=function( self, params )
		if (params.Player == PLAYER_2) then
			local name = self:GetChild("Name");
			name:settext("GUEST P2");
			P2CurrentProfile = "GUEST P2";
			local SessionDataText = self:GetChild("SessionDataText");
			if SessionDataTable[P2CurrentProfile] ~= nil then
				local formattedtimeP2 = FormatTimeLong(SessionDataTable[P2CurrentProfile]["PlaytimeS"]+SessionDataTable[P2CurrentProfile]["PlaytimeD"]);
				local SingleLevelNum = 0;
				local SingleLevelString = "S00";
				if SessionDataTable[P2CurrentProfile]["PlaytimeS"] ~= 0 then
					SingleLevelNum = math.floor(SessionDataTable[P2CurrentProfile]["LeveltimeS"]/SessionDataTable[P2CurrentProfile]["PlaytimeS"]);
					if SingleLevelNum > 9 then SingleLevelString = "S"..SingleLevelNum else SingleLevelString = "S0"..SingleLevelNum end;
				end;
				local DoubleLevelNum = 0;
				local DoubleLevelString = "D00";
				if SessionDataTable[P2CurrentProfile]["PlaytimeD"] ~= 0 then
					DoubleLevelNum = math.floor(SessionDataTable[P2CurrentProfile]["LeveltimeD"]/SessionDataTable[P2CurrentProfile]["PlaytimeD"]);
					if DoubleLevelNum > 9 then DoubleLevelString = "D"..DoubleLevelNum else DoubleLevelString = "D0"..DoubleLevelNum end;
				end;
				SessionDataText:settext("Lv. "..SingleLevelString.." / "..DoubleLevelString.."   ♫"..SessionDataTable[P2CurrentProfile]["SongsPlayed"].." ("..formattedtimeP2..")".."   Kcal: "..math.floor(SessionDataTable[P2CurrentProfile]["Kcals"]));
			else
				SessionDataText:settext("");
			end;
			(cmd(stoptweening;y,SCREEN_HEIGHT+20;linear,.2;y,SCREEN_HEIGHT-15))(self);
		end;
	end;
	ScreenChangedMessageCommand=function(self)
		local screen = SCREENMAN:GetTopScreen():GetName();
		if SessionDataTable[P2CurrentProfile] ~= nil then
			if screen == "ScreenEvaluationNormal" then
				SessionDataTable[P2CurrentProfile]["Kcals"] = SessionDataTable[P2CurrentProfile]["Kcals"] + STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetCaloriesBurned()*0.50;
				if SessionDataTable[P2CurrentProfile]["Kcals"] > 9999 then SessionDataTable[P2CurrentProfile]["Kcals"] = 9999 end;
				SessionDataTable[P2CurrentProfile]["SongsPlayed"] = SessionDataTable[P2CurrentProfile]["SongsPlayed"] + 1;
				if SessionDataTable[P2CurrentProfile]["SongsPlayed"] > 99 then SessionDataTable[P2CurrentProfile]["SongsPlayed"] = 99 end;
			elseif screen == "ScreenStageBreak" then

			end;
			SessionDataTable[P2CurrentProfile]["PlaytimeS"] = SessionDataTable[P2CurrentProfile]["PlaytimeS"] + P2CurrentSongTimeS;
			SessionDataTable[P2CurrentProfile]["PlaytimeD"] = SessionDataTable[P2CurrentProfile]["PlaytimeD"] + P2CurrentSongTimeD;
			SessionDataTable[P2CurrentProfile]["LeveltimeS"] = SessionDataTable[P2CurrentProfile]["LeveltimeS"] + P2CurrentLevelTimeS;
			SessionDataTable[P2CurrentProfile]["LeveltimeD"] = SessionDataTable[P2CurrentProfile]["LeveltimeD"] + P2CurrentLevelTimeD;
		else
			SessionDataTable[P2CurrentProfile] = {};
			SessionDataTable[P2CurrentProfile]["PlaytimeS"] = 0;
			SessionDataTable[P2CurrentProfile]["PlaytimeD"] = 0;
			SessionDataTable[P2CurrentProfile]["Kcals"] = 0;
			SessionDataTable[P2CurrentProfile]["SongsPlayed"] = 0;
			SessionDataTable[P2CurrentProfile]["LeveltimeS"] = 0;
			SessionDataTable[P2CurrentProfile]["LeveltimeD"] = 0;
		end;
		P2CurrentSongTimeS=0;
		P2CurrentSongTimeD=0;
		P2CurrentLevelTimeS=0;
		P2CurrentLevelTimeD=0;
		local SessionDataText = self:GetChild("SessionDataText");
		local formattedtimeP2 = FormatTimeLong(SessionDataTable[P2CurrentProfile]["PlaytimeS"]+SessionDataTable[P2CurrentProfile]["PlaytimeD"]);
		local SingleLevelNum = 0;
		local SingleLevelString = "S00";
		if SessionDataTable[P2CurrentProfile]["PlaytimeS"] ~= 0 then
			SingleLevelNum = math.floor(SessionDataTable[P2CurrentProfile]["LeveltimeS"]/SessionDataTable[P2CurrentProfile]["PlaytimeS"]);
			if SingleLevelNum > 9 then SingleLevelString = "S"..SingleLevelNum else SingleLevelString = "S0"..SingleLevelNum end;
		end;
		local DoubleLevelNum = 0;
		local DoubleLevelString = "D00";
		if SessionDataTable[P2CurrentProfile]["PlaytimeD"] ~= 0 then
			DoubleLevelNum = math.floor(SessionDataTable[P2CurrentProfile]["LeveltimeD"]/SessionDataTable[P2CurrentProfile]["PlaytimeD"]);
			if DoubleLevelNum > 9 then DoubleLevelString = "D"..DoubleLevelNum else DoubleLevelString = "D0"..DoubleLevelNum end;
		end;
		SessionDataText:settext("Lv. "..SingleLevelString.." / "..DoubleLevelString.."   ♫"..SessionDataTable[P2CurrentProfile]["SongsPlayed"].." ("..formattedtimeP2..")".."   Kcal: "..math.floor(SessionDataTable[P2CurrentProfile]["Kcals"]));
		(cmd(stoptweening;ShowPlayerName,2))(self);
		end;
	HideProfileChangesMessageCommand=function(self,params)
		if params.pn=='PlayerNumber_P2' then
			local name = self:GetChild("Name");
			name:settext("GUEST P2");
			P2CurrentProfile = "GUEST P2";
			local SessionDataText = self:GetChild("SessionDataText");
			if SessionDataTable[P2CurrentProfile] ~= nil then
				local formattedtimeP2 = FormatTimeLong(SessionDataTable[P2CurrentProfile]["PlaytimeS"]+SessionDataTable[P2CurrentProfile]["PlaytimeD"]);
				local SingleLevelNum = 0;
				local SingleLevelString = "S00";
				if SessionDataTable[P2CurrentProfile]["PlaytimeS"] ~= 0 then
					SingleLevelNum = math.floor(SessionDataTable[P2CurrentProfile]["LeveltimeS"]/SessionDataTable[P2CurrentProfile]["PlaytimeS"]);
					if SingleLevelNum > 9 then SingleLevelString = "S"..SingleLevelNum else SingleLevelString = "S0"..SingleLevelNum end;
				end;
				local DoubleLevelNum = 0;
				local DoubleLevelString = "D00";
				if SessionDataTable[P2CurrentProfile]["PlaytimeD"] ~= 0 then
					DoubleLevelNum = math.floor(SessionDataTable[P2CurrentProfile]["LeveltimeD"]/SessionDataTable[P2CurrentProfile]["PlaytimeD"]);
					if DoubleLevelNum > 9 then DoubleLevelString = "D"..DoubleLevelNum else DoubleLevelString = "D0"..DoubleLevelNum end;
				end;
				SessionDataText:settext("Lv. "..SingleLevelString.." / "..DoubleLevelString.."   ♫"..SessionDataTable[P2CurrentProfile]["SongsPlayed"].." ("..formattedtimeP2..")".."   Kcal: "..math.floor(SessionDataTable[P2CurrentProfile]["Kcals"]));
					else
				SessionDataText:settext("");
			end;
			self:y(SCREEN_HEIGHT-15);
		end;
	end;
	LocalProfileChangeMessageCommand=function(self,params)	--cambio la profile del jugador
		if params.pn=='PlayerNumber_P2' then
			local name = self:GetChild("Name");	
			name:settext( string.upper(string.sub(params.name,1,8)) ); --corta el nombre hasta 8 letras
			P2CurrentProfile = params.name;
			local SessionDataText = self:GetChild("SessionDataText");
			if SessionDataTable[P2CurrentProfile] ~= nil then
				local formattedtimeP2 = FormatTimeLong(SessionDataTable[P2CurrentProfile]["PlaytimeS"]+SessionDataTable[P2CurrentProfile]["PlaytimeD"]);
				local SingleLevelNum = 0;
				local SingleLevelString = "S00";
				if SessionDataTable[P2CurrentProfile]["PlaytimeS"] ~= 0 then
					SingleLevelNum = math.floor(SessionDataTable[P2CurrentProfile]["LeveltimeS"]/SessionDataTable[P2CurrentProfile]["PlaytimeS"]);
					if SingleLevelNum > 9 then SingleLevelString = "S"..SingleLevelNum else SingleLevelString = "S0"..SingleLevelNum end;
				end;
				local DoubleLevelNum = 0;
				local DoubleLevelString = "D00";
				if SessionDataTable[P2CurrentProfile]["PlaytimeD"] ~= 0 then
					DoubleLevelNum = math.floor(SessionDataTable[P2CurrentProfile]["LeveltimeD"]/SessionDataTable[P2CurrentProfile]["PlaytimeD"]);
					if DoubleLevelNum > 9 then DoubleLevelString = "D"..DoubleLevelNum else DoubleLevelString = "D0"..DoubleLevelNum end;
				end;
				SessionDataText:settext("Lv. "..SingleLevelString.." / "..DoubleLevelString.."   ♫"..SessionDataTable[P2CurrentProfile]["SongsPlayed"].." ("..formattedtimeP2..")".."   Kcal: "..math.floor(SessionDataTable[P2CurrentProfile]["Kcals"]));
			else
				SessionDataText:settext("");
			end;
			self:y(SCREEN_HEIGHT-15);
		end;
	end;
	PlayerUnjoinedMessageCommand=function(self,params)
		if params.Player ~= 'PlayerNumber_P2' then return; end;
		local name = self:GetChild("Name");
		name:settext("");
		P2CurrentProfile = "";
		local SessionDataText = self:GetChild("SessionDataText");
		SessionDataText:settext("");
		self:y(SCREEN_HEIGHT+20);
	end;
	JudgmentMessageCommand=function(self,param)
		if GAMESTATE:IsSideJoined(PLAYER_2) then 
			local P2CurrentSongTime = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetAliveSeconds();
			local style = GAMESTATE:GetCurrentSteps(PLAYER_2):GetStepsType();
			local meter = GAMESTATE:GetCurrentSteps(PLAYER_2):GetMeter();
			if style == 'StepsType_Pump_Single' or style == 'StepsType_Pump_Routine' then
				P2CurrentLevelTimeS = P2CurrentSongTime * meter;
				P2CurrentLevelTimeD = 0;
				P2CurrentSongTimeS = P2CurrentSongTime;
				P2CurrentSongTimeD = 0;
			else
				if meter == 99 then meter = 15 end; --co-op charts will be treated as level 15 as to not inflate average level absurdly.
				P2CurrentLevelTimeS = 0;
				P2CurrentLevelTimeD = P2CurrentSongTime * meter;
				P2CurrentSongTimeS = 0;
				P2CurrentSongTimeD = P2CurrentSongTime;
			end;
		end;
	end;
};

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TopScreen Text- Mensajes del sistema
t[#t+1] = Def.ActorFrame {
	Def.Quad {
		InitCommand=cmd(zoomtowidth,SCREEN_WIDTH;zoomtoheight,30;horizalign,left;vertalign,top;y,SCREEN_TOP;diffuse,color("0,0,0,0"));
		OnCommand=cmd(finishtweening;diffusealpha,0.85;);
		OffCommand=cmd(sleep,3;linear,0.5;diffusealpha,0;);
	};
	LoadFont("Common","Normal") .. {
		Name="Text";
		InitCommand=cmd(maxwidth,750;horizalign,left;vertalign,top;y,SCREEN_TOP+10;x,SCREEN_LEFT+10;shadowlength,1;diffusealpha,0;);
		OnCommand=cmd(finishtweening;diffusealpha,1;zoom,0.5);
		OffCommand=cmd(sleep,3;linear,0.5;diffusealpha,0;);
	};
	SystemMessageMessageCommand = function(self, params)
		self:GetChild("Text"):settext( params.Message );
		self:playcommand( "On" );
		if params.NoAnimate then
			self:finishtweening();
		end
		self:playcommand( "Off" );
	end;
	HideSystemMessageMessageCommand = cmd(finishtweening);
};


return t;
