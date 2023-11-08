----------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- Para UnderAttack
local P1PosX = SCREEN_CENTER_X-159;
local P2PosX = SCREEN_CENTER_X+159;
local iNXModAdjust = 55;

function IsUnderAttackForPlayer( pn )
	local POpSt = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString('ModsLevel_Preferred');
	if ( string.find(POpSt,"UnderAttack") ~= nil ) then
		return true;
	end;
	return false;
end;

function IsNXForPlayer( pn )
	local POpSt = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString('ModsLevel_Preferred');
	if ( string.find(POpSt,"ModNX") ~= nil ) then
		return true;
	end;
	return false;
end;

function IsDropForPlayer( pn )
	local POpSt = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString('ModsLevel_Preferred');
	if ( string.find(POpSt,"Drop") ~= nil ) then
		return true;
	end;
	return false;
end;

function GetP1XPosition()
	local bUA = IsUnderAttackForPlayer(PLAYER_1);
	local bNX = IsNXForPlayer(PLAYER_1);
	
	if bUA then
		if bNX then
			return P2PosX-iNXModAdjust;
		else
			return P2PosX;
		end;
	end;
	
	if bNX then
		return P1PosX+iNXModAdjust;
	else
		return P1PosX;
	end;
end;

function GetP2XPosition()
	local bUA = IsUnderAttackForPlayer(PLAYER_2);
	local bNX = IsNXForPlayer(PLAYER_2);
	
	if bUA then
		if bNX then
			return P1PosX+iNXModAdjust;
		else
			return P1PosX;
		end;
	end;
	
	if bNX then
		return P2PosX-iNXModAdjust;
	else
		return P2PosX;
	end;
end;

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--///////////////////////////////////////////////////////////////
-- Usado en las esferas de nivel del SSM y Evaluation
-- Actor:Setea el nivel, traduciendo los números 99 y -1
function Actor:SetLevelText(pn)
	local cur_steps = GAMESTATE:GetCurrentSteps(pn);
	if cur_steps == nil then return; end;
	
	local meter = cur_steps:GetMeter();
	if meter==99 then self:settext('??'); return; end;
	if meter==-1 then self:settext('!!'); return; end;

	self:settext( string.format("%.2d",meter) );
end;

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--///////////////////////////////////////////////////////////////

-- Se utiliza en el default.lua del decorations del select music
function AddDots( score )
	if score >= 999999999 then
		return "999.999.999";
	end;
	
	if score >= 1000000 then
		local millonesimas = math.floor(score/1000000);
		local milesimas = math.floor(score/1000) - millonesimas*1000;
		local centesimas = score - milesimas*1000 - millonesimas*1000000;

		return string.format("%01d",millonesimas).."."..string.format("%03d",milesimas).."."..string.format("%03d",centesimas);
	elseif score < 1000000 and score >= 1000 then
		local milesimas = math.floor(score/1000);
		local centesimas = score - milesimas*1000;
		
		return string.format("%01d",milesimas).."."..string.format("%03d",centesimas);
	else
		return string.format("%01d",score);
	end;
end;

function GetHighScoresFrame( pn, appear_on_start )
local t = Def.ActorFrame {
	OnCommand=function(self)
		if appear_on_start then self:playcommand("StartSelectingSteps"); end;
		return;
	end;
	children = {
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/highscores_bg") )..{
			InitCommand=cmd(basezoom,.66;zoomx,0);
			ChangeStepsMessageCommand=cmd(stoptweening;zoomx,1);
			StartSelectingStepsMessageCommand=cmd(stoptweening;zoomx,0;linear,.2;zoomx,1);
			GoBackSelectingSongMessageCommand=cmd(stoptweening;zoomx,1;linear,.2;zoomx,0);
			OffCommand=cmd(stoptweening;zoomx,1;linear,.2;zoomx,0);
		};
		--personal hs
		LoadFont("_karnivore lite white")..{
			InitCommand=cmd(settext,"";horizalign,left;zoom,.62;x,-40;y,-14);
			RefreshTextCommand=function(self)
				local cur_song = GAMESTATE:GetCurrentSong();
				local cur_steps = GAMESTATE:GetCurrentSteps(pn);
				if GAMESTATE:HasProfile(pn) then
					local HSList = PROFILEMAN:GetProfile( pn ):GetHighScoreList(cur_song,cur_steps):GetHighScores();
					if (#HSList ~= 0) then
						local score = HSList[1]:GetScore();
						if score > 9999999999 then
							score = 9999999999;
						end;
						self:settext( AddDots(score) );
					else
						self:settext("")
					end;
				else
					self:settext("")
				end;
			end;
			ChangeStepsMessageCommand=function(self,params)
				if params.Player ~= pn then return; end;
				(cmd(stoptweening;playcommand,'RefreshText'))(self);
			end;
			StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.2;queuecommand,'RefreshText');
			GoBackSelectingSongMessageCommand=cmd(finishtweening;settext,"");
			OffCommand=cmd(stoptweening;visible,false);
		};
		--machine best name
		LoadFont("","_myriad pro 20px") .. {
			InitCommand=cmd(settext,"";horizalign,left;zoom,.62;x,-40;y,12);
			RefreshTextCommand=function(self)
				local cur_song = GAMESTATE:GetCurrentSong();
				local cur_steps = GAMESTATE:GetCurrentSteps( pn );
				local HSList = PROFILEMAN:GetMachineProfile():GetHighScoreList(cur_song,cur_steps):GetHighScores();
				if #HSList ~= 0 then
					self:settext( string.upper( HSList[1]:GetName() ));
				else
					self:settext("");
				end;
			end;
			ChangeStepsMessageCommand=function(self,params)
				if params.Player ~= pn then return; end;
				(cmd(stoptweening;playcommand,'RefreshText'))(self);
			end;
			StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.2;queuecommand,'RefreshText');
			GoBackSelectingSongMessageCommand=cmd(stoptweening;settext,"");
			OffCommand=cmd(stoptweening;visible,false);
		};
		--machine best hs
		LoadFont("_karnivore lite white")..{
			InitCommand=cmd(settext,"";horizalign,left;zoom,.62;x,-40;y,21);
			RefreshTextCommand=function(self)
				local cur_song = GAMESTATE:GetCurrentSong();
				local cur_steps = GAMESTATE:GetCurrentSteps(pn);
				local HSList = PROFILEMAN:GetMachineProfile():GetHighScoreList(cur_song,cur_steps):GetHighScores();
				if (#HSList ~= 0) then
					local score = HSList[1]:GetScore();
					if score > 9999999999 then
						score = 9999999999;
					end;
					self:settext( AddDots(score) );
				else
					self:settext("")
				end;
			end;
			ChangeStepsMessageCommand=function(self,params)
				if params.Player ~= pn then return; end;
				(cmd(stoptweening;playcommand,'RefreshText'))(self);
			end;
			StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.2;queuecommand,'RefreshText');
			GoBackSelectingSongMessageCommand=cmd(stoptweening;settext,"");
			OffCommand=cmd(stoptweening;visible,false);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/highscores_glow") )..{
			InitCommand=cmd(basezoom,.66;diffuse,0,1,1,1;blend,'BlendMode_Add');
			OnCommand=cmd(zoomx,0);
			StartSelectingStepsMessageCommand=cmd(stoptweening;horizalign,center;diffusealpha,0;zoomx,0;x,0;sleep,.2;linear,.1;zoomx,1;diffusealpha,.8;linear,.1;zoomx,0;diffusealpha,0;queuecommand,'Loop');
			LoopCommand=cmd(stoptweening;x,0;horizalign,center;zoomx,1;diffusealpha,0;linear,1;diffusealpha,.1;linear,1;diffusealpha,0;queuecommand,'Loop');
			ChangeStepsMessageCommand=function(self,params)
				if params.Player ~= pn then return; end;
				if params.Direction == -1 then
					(cmd(stoptweening;horizalign,left;diffusealpha,0;zoomx,0;x,-44;linear,.1;zoomx,1;diffusealpha,.8))(self);
					(cmd(horizalign,right;diffusealpha,.8;zoomx,1;x,44;linear,.1;zoomx,0;diffusealpha,0;queuecommand,'Loop'))(self);
				else
					(cmd(stoptweening;horizalign,right;diffusealpha,0;zoomx,0;x,44;linear,.1;zoomx,1;diffusealpha,.8))(self);
					(cmd(horizalign,left;diffusealpha,.8;zoomx,1;x,-44;linear,.1;zoomx,0;diffusealpha,0;queuecommand,'Loop'))(self);
				end;
			end;
			GoBackSelectingSongMessageCommand=cmd(stoptweening;zoomx,0;x,0);
			OffCommand=cmd(stoptweening;zoomx,0;x,0);
		};
	};
};
return t;
end;



-----------------------------------------------------------------------
-----------------------------------------------------------------------
--///////////////////////////////////////////////////////////////
-- Labels

local Labels = {
	["ANOTHER"] = 1,
	["PRO"] = 2,
	["TRAIN"] = 3,
	["QUEST"] = 4,
	["UCS"] = 5,
	["HIDDEN"] = 6,
	["INFINITY"] = 7,
	["JUMP"] = 8,
	["OUCS"] = 9,
	["NEW"] = 0
};

function GetLabelNumber( label )
	if label == "" then return 10; end;
	
	return Labels[label];
end;


--/////////////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Obtiene el color de la esfera, según el estilo y descripción del chart
function GetDiffNumberBall( cur_steps )
	if cur_steps == nil then return 0; end;
	style = cur_steps:GetStepsType();
	description = cur_steps:GetDescription();

	if style=='StepsType_Pump_Single' and string.find(description,"SP") then return(1);
	elseif style=='StepsType_Pump_Single' then return (0);
	elseif (style=='StepsType_Pump_Couple') then return (5);
	elseif (style=='StepsType_Pump_Double' and string.find(description,"DP")) or style=='StepsType_Pump_Routine' then return(3);
	elseif (style=='StepsType_Pump_Double' and string.find( string.upper(description),"HALFDOUBLE" ) ) or style=='StepsType_Pump_Halfdouble' then return (4);
	elseif style=='StepsType_Pump_Double' then return (2);
	end;
	
	return 0;
end;

-- Obtiene el digito indicado y lo escribe
function Actor:SetLevelTextByDigit( cur_steps, digit )
	if cur_steps == nil then return; end;
	local style = cur_steps:GetStepsType();
	local description = cur_steps:GetDescription();
	local row = 0;
	local column = 0;
	
	if style=='StepsType_Pump_Single' and string.find(description,"SP") then row = 4;
	elseif style=='StepsType_Pump_Single' then row = 0;
	elseif (style=='StepsType_Pump_Couple') then row = 5;
	elseif (style=='StepsType_Pump_Double' and string.find(description,"DP")) or style=='StepsType_Pump_Routine' then row = 5;
	elseif (style=='StepsType_Pump_Double' and string.find( string.upper(description),"HALFDOUBLE" ) ) or style=='StepsType_Pump_Halfdouble' then row = 1;
	elseif style=='StepsType_Pump_Double' then row = 1;
	end;
	
	local meter = cur_steps:GetMeter();
	
	
	
	if meter==99 then column = 10;
	elseif meter==99 then column = 11;
	else
		if meter>99 then meter = 99; end;
		if digit ==1 then
			column = math.floor( (meter/10) );
		elseif digit ==2 then
			column = meter - math.floor( (meter/10) )*10;
		end;
	end;
	self:setstate( column + row*12 );
end;

-- Obtiene la etiqueta superior para mostrar en la esfera
local function GetBallLabel( cur_steps )
	return GetLabelNumber( cur_steps:GetLabel() );
end;

-- Obtiene la etiqueta inferior para mostrar en la esfera
local function GetBallUnderLabel( cur_steps )
	local style = cur_steps:GetStepsType();
	local description = cur_steps:GetDescription();
	
	if (style=='StepsType_Pump_Double' and string.find( string.upper(description),"HALFDOUBLE" ) ) or style=='StepsType_Pump_Halfdouble' then return 0;
	elseif (style=='StepsType_Pump_Couple') then return 1;
	end;
	
	return 2; --empty
end;

-- Función para obtener la esfera de nivel
function GetBallLevel( pn, show_dir_arrows )
	local k = Def.ActorFrame {		
		InitCommand=cmd(basezoom,.67);
		ShowUpCommand=cmd(playcommand,"Update";playcommand,'ShowUpInternal');
		HideCommand=cmd(playcommand,'HideInternal');
		StepsChosenMessageCommand=function(self,params)
			if params.Player == pn then self:playcommand('StepsChosenInternal'); end;
		end;
		ChangeStepsMessageCommand=function(self,params)
			if params.Player ~= pn then return; end;
			self:playcommand('Update');
			self:playcommand('UpdateInternal',{Direction = params.Direction});
			end;
		UpdateCommand=function(self)
			local this = self:GetChildren();
			local cur_steps = GAMESTATE:GetCurrentSteps(pn);
			
			-- Actualizo color esfera de nivel
			(cmd(stoptweening;diffusealpha,1;setstate,GetDiffNumberBall(cur_steps)))( this.Bigballs );
			
			-- Actualizo digitos de nivel
			(cmd(stoptweening;diffusealpha,1;SetLevelTextByDigit,cur_steps,1))( this.LevelDigit1 );
			(cmd(stoptweening;diffusealpha,1;SetLevelTextByDigit,cur_steps,2))( this.LevelDigit2 );
			
			-- Actualizo etiquetas
			(cmd(stoptweening;diffusealpha,1;sleep,.03;setstate,GetBallLabel(cur_steps)))( this.Label );
			(cmd(stoptweening;diffusealpha,1;sleep,.03;setstate,GetBallUnderLabel(cur_steps)))( this.Underlabel );
		end;
		children = {
			-- Frame --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs frame.png") )..{
				InitCommand=cmd(pause);
				UpdateInternalCommand=cmd(stoptweening;diffusealpha,1);
			};
			
			-- Glow Spin --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs glow spin.png") )..{
				InitCommand=cmd(blend,'BlendMode_Add';diffuse,0,1,1,1);
				OffCommand=cmd(stoptweening;diffusealpha,0);
				ShowUpInternalCommand=cmd(stoptweening;diffusealpha,0;sleep,.2;queuecommand,'Spin');
				UpdateInternalCommand=cmd(stoptweening;queuecommand,'Spin');
				SpinCommand=cmd(stoptweening;diffusealpha,.8;rotationz,0;linear,.2;rotationz,360;diffusealpha,0);
			};
			
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs glow spin.png") )..{
				InitCommand=cmd(blend,'BlendMode_Add');
				OffCommand=cmd(stoptweening;diffusealpha,0);
				ShowUpInternalCommand=cmd(stoptweening;diffusealpha,0;sleep,.4;queuecommand,'Spin');
				HideInternalCommand=cmd(stoptweening;diffusealpha,0);
				SpinCommand=cmd(stoptweening;diffusealpha,.1;rotationz,0;linear,2;rotationz,360;queuecommand,'Spin');
			};
			
			-- Esfera del nivel --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs 4x2.png") )..{
				Name="Bigballs";
				InitCommand=cmd(pause);
			};
			
			-- Level (numeros) Digit 1 --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs numbers 12x6.png") )..{
				Name="LevelDigit1";
				InitCommand=cmd(y,2;pause;x,-22);
			};
			
			-- Level (numeros) Digit 2 --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs numbers 12x6.png") )..{
				Name="LevelDigit2";
				InitCommand=cmd(y,2;pause;x,22);
			};
			
			-- Big glow
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs bigglow.png") )..{
				InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0;visible,show_dir_arrows);
				OffCommand=cmd(stoptweening;diffusealpha,0;linear,.05;diffusealpha,.5;zoom,1;linear,.2;zoomx,1.5;diffusealpha,0);
			};
			
			-- Glow Side to side --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs glow sidetoside.png") )..{
				InitCommand=cmd(blend,'BlendMode_Add';diffuse,0,1,1,1);
				ShowUpInternalCommand=cmd(stoptweening;diffusealpha,0;zoom,1;horizalign,center;x,0;sleep,.2;diffusealpha,1;linear,.2;diffusealpha,0);
				HideInternalCommand=cmd(stoptweening;diffusealpha,0);
				OffCommand=cmd(stoptweening;diffusealpha,0);
				UpdateInternalCommand=function(self,params)
					if params.Direction == -1 then	--der
						(cmd(stoptweening;horizalign,left;diffusealpha,0;zoomx,0;x,-55;linear,.1;zoomx,1;diffusealpha,1))(self);
						(cmd(horizalign,right;diffusealpha,1;zoomx,1;x,55;linear,.1;zoomx,0;diffusealpha,0))(self);
					elseif params.Direction == 1 then	--izq
						(cmd(stoptweening;horizalign,right;diffusealpha,0;zoomx,0;x,55;linear,.1;zoomx,1;diffusealpha,1))(self);
						(cmd(horizalign,left;diffusealpha,1;zoomx,1;x,-55;linear,.1;zoomx,0;diffusealpha,0))(self);
					end;
				end;
			};
			
			-- Labels --
			LoadActor( THEME:GetPathG("","Common Resources/B_LABELS 1x11.png") )..{
				Name="Label";
				InitCommand=cmd(y,-58;pause;setstate,9);
				--OffCommand=cmd(stoptweening;diffusealpha,1;sleep,.2;linear,.05;diffusealpha,0);
			};
			
			-- Under labels --
			LoadActor( THEME:GetPathG("","Common Resources/B_UNDERLABELS 1x3.png") )..{
				Name="Underlabel";
				InitCommand=cmd(y,40;pause;setstate,2);
				--OffCommand=cmd(stoptweening;diffusealpha,1;sleep,.2;linear,.05;diffusealpha,0);
			};
			
			-- Right Arrow --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_BigBalls arrow.png") )..{
				InitCommand=cmd(x,70;zoom,1;rotationy,180;diffusealpha,0;visible,show_dir_arrows);
				UpdateInternalCommand=function(self,params)
					if params.Direction == 1 then	--der
						(cmd(finishtweening;zoom,1;x,80;linear,.05;x,90;sleep,.04;linear,.05;x,80;queuecommand,'Loop'))(self);
					elseif params.Direction == -1 then	--izq
						(cmd(finishtweening;zoom,1;x,80;sleep,.05;sleep,.04;sleep,.05;queuecommand,'Loop'))(self);
					end;
				end;
				StepsChosenInternalCommand=cmd(finishtweening;queuecommand,'Loop');
				LoopCommand=cmd(finishtweening;x,80;linear,1;x,85;linear,1;x,80;queuecommand,'Loop');
				ShowUpInternalCommand=cmd(stoptweening;x,80;diffusealpha,0;zoom,0;sleep,.2;linear,.1;diffusealpha,1;zoom,1.1;linear,.1;zoom,1;queuecommand,'Loop');
				HideInternalCommand=cmd(stoptweening;diffusealpha,1;zoom,1;x,80;linear,.1;zoom,1.1;linear,.1;zoom,0;diffusealpha,0);
				OffCommand=cmd(stoptweening;diffusealpha,1;zoom,1;x,80;linear,.2;zoom,0;diffusealpha,0);	
			};
			
			-- Left Arrow --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_BigBalls arrow.png") )..{
				InitCommand=cmd(x,-80;diffusealpha,0;visible,show_dir_arrows);
				UpdateInternalCommand=function(self,params)
					if params.Direction == -1 then	--der
						(cmd(finishtweening;x,-80;linear,.05;x,-90;sleep,.04;linear,.05;x,-80;queuecommand,'Loop'))(self);
					elseif params.Direction == 1 then	--izq
						(cmd(finishtweening;x,-80;sleep,.05;sleep,.04;sleep,.05;queuecommand,'Loop'))(self);
					end;
				end;
				StepsChosenInternalCommand=cmd(finishtweening;queuecommand,'Loop');
				LoopCommand=cmd(finishtweening;x,-80;linear,1;x,-85;linear,1;x,-80;queuecommand,'Loop');
				ShowUpInternalCommand=cmd(stoptweening;x,-80;diffusealpha,0;zoom,0;sleep,.2;linear,.1;diffusealpha,1;zoom,1.1;linear,.1;zoom,1;queuecommand,'Loop');
				HideInternalCommand=cmd(stoptweening;diffusealpha,1;zoom,1;x,-80;linear,.1;zoom,1.1;linear,.1;zoom,0;diffusealpha,0);
				OffCommand=cmd(stoptweening;diffusealpha,1;zoom,1;x,-80;linear,.2;zoom,0;diffusealpha,0);		
			};
			
			-- READY? --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/READY.png") )..{
				InitCommand=cmd(y,60;diffusealpha,0);
				StepsChosenInternalCommand=cmd(stoptweening;diffusealpha,1);
				UpdateInternalCommand=cmd(stoptweening;diffusealpha,0);
				ShowUpInternalCommand=cmd(stoptweening;diffusealpha,0);
				HideInternalCommand=cmd(stoptweening;diffusealpha,0);
				OffCommand=cmd(stoptweening;diffusealpha,0);		
			};
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/READY.png") )..{
				InitCommand=cmd(y,60;blend,'BlendMode_Add';diffusealpha,0);
				StepsChosenInternalCommand=cmd(stoptweening;diffusealpha,1;diffuseshift;effectcolor2,color("1,1,1,.3");effectcolor1,color("1,1,1,0");effectperiod,.2);
				UpdateInternalCommand=cmd(stoptweening;diffusealpha,0);
				ShowUpInternalCommand=cmd(stoptweening;diffusealpha,0);
				HideInternalCommand=cmd(stoptweening;diffusealpha,0);
				OffCommand=cmd(stoptweening;diffusealpha,0);		
			};
		};
	};

	return k;
end;

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////