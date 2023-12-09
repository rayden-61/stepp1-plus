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
		LoadActor( THEME:GetPathG("","ScreenSystemLayer/heart") )..{
			Name = "heart";
			InitCommand=cmd(x,26;y,7);
		};
		LoadFont("","_myriad pro 20px") .. {
			Name = "TimePlayed";
			InitCommand=cmd(horizalign,left;y,7;x,-70);
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
			(cmd(stoptweening;y,SCREEN_HEIGHT+20;linear,.2;y,SCREEN_HEIGHT-15))(self);
		end;
	end;
	ScreenChangedMessageCommand=function(self)
		local screen = SCREENMAN:GetTopScreen():GetName();
		if screen == "ScreenEvaluationNormal" then
			local heart = self:GetChild("heart");
			(cmd(stoptweening;diffusealpha,0;zoom,4;sleep,1.8;linear,.2;zoom,1;diffusealpha,1;sleep,0;diffusealpha,1;linear,.1;zoom,1.2;linear,.4;zoom,1;diffusealpha,0))(heart);
		else
			local heart = self:GetChild("heart");
			heart:finishtweening();
			heart:diffusealpha(0);
		end;
		(cmd(stoptweening;ShowPlayerName,1))(self);
		end;
	HideProfileChangesMessageCommand=function(self,params)
		if params.pn=='PlayerNumber_P1' then
			local name = self:GetChild("Name");
			name:settext("GUEST P1");
			self:y(SCREEN_HEIGHT-15);
		end;
	end;
	LocalProfileChangeMessageCommand=function(self,params)	--cambio la profile del jugador
		if params.pn=='PlayerNumber_P1' then
			local name = self:GetChild("Name");
			name:settext( string.upper(string.sub(params.name,1,8)) ); --corta el nombre hasta 8 letras
			self:y(SCREEN_HEIGHT-15);
		end;
	end;
	PlayerUnjoinedMessageCommand=function(self,params)
		if params.Player ~= 'PlayerNumber_P1' then return; end;
		local name = self:GetChild("Name");
		name:settext("");
		self:y(SCREEN_HEIGHT+20);
	end;
};


-- Player 2 Name
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
			(cmd(stoptweening;y,SCREEN_HEIGHT+20;linear,.2;y,SCREEN_HEIGHT-15))(self);
		end;
	end;
	ScreenChangedMessageCommand=function(self)
		local screen = SCREENMAN:GetTopScreen():GetName();
		if screen == "ScreenEvaluationNormal" then
			local heart = self:GetChild("heart");
			(cmd(stoptweening;diffusealpha,0;zoom,4;sleep,1.8;linear,.2;zoom,1;diffusealpha,1;sleep,0;diffusealpha,1;linear,.1;zoom,1.2;linear,.4;zoom,1;diffusealpha,0))(heart);
		else
			local heart = self:GetChild("heart");
			heart:finishtweening();
			heart:diffusealpha(0);
		end;
		(cmd(stoptweening;ShowPlayerName,2))(self);
		end;
	HideProfileChangesMessageCommand=function(self,params)
		if params.pn=='PlayerNumber_P2' then
			local name = self:GetChild("Name");
			name:settext("GUEST P2");
			self:y(SCREEN_HEIGHT-15);
		end;
	end;
	LocalProfileChangeMessageCommand=function(self,params)	--cambio la profile del jugador
		if params.pn=='PlayerNumber_P2' then
			local name = self:GetChild("Name");	
			name:settext( string.upper(string.sub(params.name,1,8)) ); --corta el nombre hasta 8 letras
			self:y(SCREEN_HEIGHT-15);
		end;
	end;
	PlayerUnjoinedMessageCommand=function(self,params)
		if params.Player ~= 'PlayerNumber_P2' then return; end;
		local name = self:GetChild("Name");
		name:settext("");
		self:y(SCREEN_HEIGHT+20);
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
