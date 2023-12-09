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


--/////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- P. SCORE FUNCTIONS --


function CalcPScore(perfects, greats, goods, bads, misses, maxcombo)
	local notestotal = perfects + greats + goods + bads + misses;
	if notestotal <= 1 then notestotal = 1 end;
	local weightednotes = perfects + 0.6*greats + 0.2*goods + 0.1*bads;
	local pscore = math.floor(((weightednotes * 0.995 + maxcombo * 0.005) / notestotal) * 1000000 );
	if pscore < 0 then
		pscore = 0;
	elseif pscore > 1000000 then
		pscore = 1000000;
	end
	return pscore;
end

--

function CalcPGrade(pscore)
	local pgrade = (
			(pscore >= 995000 and "SSS+")	or 
			(pscore >= 990000 and "SSS")	or 
			(pscore >= 985000 and "SS+")	or
			(pscore >= 980000 and "SS")		or
			(pscore >= 975000 and "S+")		or
			(pscore >= 970000 and "S")		or 
			(pscore >= 960000 and "AAA+")	or 
			(pscore >= 950000 and "AAA")	or
			(pscore >= 925000 and "AA+")	or
			(pscore >= 900000 and "AA")		or
			(pscore >= 825000 and "A+")		or
			(pscore >= 750000 and "A")		or
			(pscore >= 650000 and "B")		or
			(pscore >= 550000 and "C")		or
			(pscore >= 450000 and "D") 		or
			"F"
			);
	return pgrade;
end

--

function CalcPlate(greats,goods,bads,misses)
	local plate = (
		(misses >= 21 and "Rough Game")		or 
		(misses >= 11 and "Fair Game")		or
		(misses >= 6 and "Talented Game")	or
		(misses >= 1 and "Marvelous Game")	or
		(bads >= 1 and "Superb Game")		or 
		(goods >= 1 and "Extreme Game")		or 
		(greats >= 1 and "Ultimate Game")	or
		"Perfect Game"
		);
	return plate;
end;

--

function CalcPlateInitials(greats,goods,bads,misses)
	local plate = (
		(misses >= 21 and "RG")		or 
		(misses >= 11 and "FG")		or
		(misses >= 6 and "TG")		or
		(misses >= 1 and "MG")		or
		(bads >= 1 and "SG")		or 
		(goods >= 1 and "EG")		or 
		(greats >= 1 and "UG")		or
		"PG"
		);
	return plate;
end;

--

function ColorPGrade(pgrade)
	local PGradeColor = "";
	if pgrade == "AAA" or pgrade == "AAA+" then
		PGradeColor =  "#FFFFFF"; -- silver color (actually white)
	elseif string.find(pgrade, "A") then
		PGradeColor = "0.803,0.498,0.196,1"; -- bronze color
	elseif pgrade == "SSS" or pgrade == "SSS+" then
		PGradeColor = "#A5FDFD"; -- platinum color
	elseif string.find(pgrade, "S") then
		PGradeColor = "#FEE108"; -- gold color
	else
		PGradeColor = "0.596,0.596,0.592,1"; -- dark color (broken grades)
	end;
	return PGradeColor;
end;

--

function ColorPlate(plate)
	local PlateColor = "";
	if plate == "RG" or plate == "Rough Game" then
		PlateColor = "0.803,0.498,0.196,1";
	elseif plate == "FG" or plate == "Fair Game" then
		PlateColor = "0.803,0.498,0.196,1";
	elseif plate == "TG" or plate == "Talented Game"then
		PlateColor = "#FFFFFF";
	elseif plate ==	"MG" or plate == "Marvelous Game" then
		PlateColor = "#FFFFFF";
	elseif plate == "SG" or plate == "Superb Game" then
		PlateColor = "#FEE108";
	elseif plate == "EG" or plate == "Extreme Game" then
		PlateColor = "#FEE108";
	elseif plate == "UG" or plate == "Ultimate Game" then
		PlateColor = "#A5FDFD";
	elseif plate == "PG" or plate == "Perfect Game" then
		PlateColor = "#A5FDFD";
	else
		PlateColor = "#989897";
	end;
	return PlateColor;
end;


-----------------------------------------------------------------------
	

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////


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
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/highscores_total_label.png") )..{
			InitCommand=cmd(y,-38;basezoom,.66;zoomx,0);
			ChangeStepsMessageCommand=cmd(stoptweening;zoomx,1);
			StartSelectingStepsMessageCommand=cmd(stoptweening;zoomx,0;linear,.2;zoomx,1);
			GoBackSelectingSongMessageCommand=cmd(stoptweening;zoomx,1;linear,.2;zoomx,0);
			OffCommand=cmd(stoptweening;zoomx,1;linear,.2;zoomx,0);
		};
		--personal hs
		LoadFont("_karnivore lite white")..{
			InitCommand=cmd(settext,"";horizalign,left;zoom,.62;x,-40;y,-14;maxwidth,85);
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
			InitCommand=cmd(settext,"";horizalign,left;zoom,.62;x,-40;y,21;maxwidth,85);
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


--P.Score Frame
function GetPHighScoresFrame( pn, appear_on_start )
	local PersonalBestIndex = 1; 
	local PersonalBestPScore = 0;
	local MachineBestIndex = 1;
	local MachineBestPScore = 0;
	local MachineBestName = "";
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
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/highscores_pscore_label.png") )..{
				InitCommand=cmd(y,-38;basezoom,.66;zoomx,0);
				ChangeStepsMessageCommand=cmd(stoptweening;zoomx,1);
				StartSelectingStepsMessageCommand=cmd(stoptweening;zoomx,0;linear,.2;zoomx,1);
				GoBackSelectingSongMessageCommand=cmd(stoptweening;zoomx,1;linear,.2;zoomx,0);
				OffCommand=cmd(stoptweening;zoomx,1;linear,.2;zoomx,0);
			};

			--personal hs
			LoadFont("_karnivore lite white")..{
				InitCommand=cmd(settext,"";horizalign,left;zoom,.62;x,-40;y,-14;maxwidth,80);
				RefreshTextCommand=function(self)
					local cur_song = GAMESTATE:GetCurrentSong();
					local cur_steps = GAMESTATE:GetCurrentSteps(pn);
					PersonalBestIndex = 1;
					PersonalBestPScore = 0;
					if GAMESTATE:HasProfile(pn) then
						local HSList = PROFILEMAN:GetProfile( pn ):GetHighScoreList(cur_song,cur_steps):GetHighScores();
						if (#HSList ~= 0) then
							local perfects = 0;
							local greats = 0;
							local goods = 0;
							local bads = 0;
							local misses = 0;
							local maxcombo = 0;
							local pscore = 0;
							for i = 1,#HSList do
								perfects = HSList[i]:GetTapNoteScore('TapNoteScore_W2') + HSList[i]:GetTapNoteScore('TapNoteScore_CheckpointHit');
								greats = HSList[i]:GetTapNoteScore('TapNoteScore_W3');
								goods = HSList[i]:GetTapNoteScore('TapNoteScore_W4');
								bads = HSList[i]:GetTapNoteScore('TapNoteScore_W5');
								misses = HSList[i]:GetTapNoteScore('TapNoteScore_Miss') + HSList[i]:GetTapNoteScore('TapNoteScore_CheckpointMiss');		
								maxcombo = HSList[i]:GetMaxCombo();
								pscore = CalcPScore(perfects, greats, goods, bads, misses, maxcombo);
								if pscore >= PersonalBestPScore then
									PersonalBestIndex = i;
									PersonalBestPScore = pscore;
								end;
							end;
							self:settext( AddDots(PersonalBestPScore) );
						else
							self:settext("");
						end;
					else
						self:settext("");
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

			--Personal Best P.Grade
			LoadFont("pbhdkarnivore 24px")..{
				InitCommand=cmd(settext,"";horizalign,right;zoom,.32;x,43;y,-12);
				RefreshTextCommand=function(self)
					local cur_song = GAMESTATE:GetCurrentSong();
					local cur_steps = GAMESTATE:GetCurrentSteps(pn);
					if GAMESTATE:HasProfile(pn) then
						local HSList = PROFILEMAN:GetProfile( pn ):GetHighScoreList(cur_song,cur_steps):GetHighScores();
						if (#HSList ~= 0) then
								local pgrade = CalcPGrade(PersonalBestPScore);
								local pgradecolor = ColorPGrade(pgrade);
								self:settext( pgrade );
								self:diffuse(color(pgradecolor))
						else
							self:settext("");
						end;
					else
						self:settext("");
					end;
				end;
				ChangeStepsMessageCommand=function(self,params)
					if params.Player ~= pn then return; end;
					(cmd(stoptweening;sleep,.01;queuecommand,'RefreshText'))(self);
				end;
				StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.2;queuecommand,'RefreshText');
				GoBackSelectingSongMessageCommand=cmd(finishtweening;settext,"");
				OffCommand=cmd(stoptweening;visible,false);
			};

			--Personal Best Plate
			LoadFont("_karnivore lite white")..{
				InitCommand=cmd(settext,"";horizalign,right;zoom,.36;x,43;y,-23);
				RefreshTextCommand=function(self)
					local cur_song = GAMESTATE:GetCurrentSong();
					local cur_steps = GAMESTATE:GetCurrentSteps(pn);
					if GAMESTATE:HasProfile(pn) then
						local HSList = PROFILEMAN:GetProfile( pn ):GetHighScoreList(cur_song,cur_steps):GetHighScores();
						if (#HSList ~= 0) then
							local greats = HSList[PersonalBestIndex]:GetTapNoteScore('TapNoteScore_W3');
							local goods = HSList[PersonalBestIndex]:GetTapNoteScore('TapNoteScore_W4');
							local bads = HSList[PersonalBestIndex]:GetTapNoteScore('TapNoteScore_W5');
							local misses = HSList[PersonalBestIndex]:GetTapNoteScore('TapNoteScore_Miss') + HSList[PersonalBestIndex]:GetTapNoteScore('TapNoteScore_CheckpointMiss');		
							local plate = CalcPlateInitials(greats,goods,bads,misses);
							local platecolor = ColorPlate(plate);
							self:settext( plate );
							self:diffusecolor(color(platecolor));
						else
							self:settext("");
						end;
					else
						self:settext("");
					end;
				end;
				ChangeStepsMessageCommand=function(self,params)
					if params.Player ~= pn then return; end;
					(cmd(stoptweening;sleep,.01;queuecommand,'RefreshText'))(self);
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
					local pscore = 0;
					MachineBestIndex = 1;
					MachineBestPScore = 0;
					MachineBestName = "";
					if (#HSList ~= 0) then
						local perfects = 0;
						local greats = 0;
						local goods = 0;
						local bads = 0;
						local misses = 0;		
						local maxcombo = 0;
						local pscore = 0;
						for i = 1,#HSList do
							perfects = HSList[i]:GetTapNoteScore('TapNoteScore_W2') + HSList[i]:GetTapNoteScore('TapNoteScore_CheckpointHit');
							greats = HSList[i]:GetTapNoteScore('TapNoteScore_W3');
							goods = HSList[i]:GetTapNoteScore('TapNoteScore_W4');
							bads = HSList[i]:GetTapNoteScore('TapNoteScore_W5');
							misses = HSList[i]:GetTapNoteScore('TapNoteScore_Miss') + HSList[i]:GetTapNoteScore('TapNoteScore_CheckpointMiss');		
							maxcombo = HSList[i]:GetMaxCombo();
							pscore = CalcPScore(perfects, greats,goods,bads,misses,maxcombo);
							if pscore >= MachineBestPScore then
								MachineBestIndex = i;
								MachineBestPScore = pscore;
								MachineBestName = HSList[i]:GetName();
							end;
						end;
						self:settext( string.upper(MachineBestName) );
					else
						self:settext("")
					end;
				end;
				ChangeStepsMessageCommand=function(self,params)
					if params.Player ~= pn then return; end;
					(cmd(stoptweening;playcommand,'RefreshText'))(self);
				end;
				StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.20;queuecommand,'RefreshText');
				GoBackSelectingSongMessageCommand=cmd(stoptweening;settext,"");
				OffCommand=cmd(stoptweening;visible,false);
			};

			--machine best hs
			LoadFont("_karnivore lite white")..{
				InitCommand=cmd(settext,"";horizalign,left;zoom,.62;x,-40;y,21;maxwidth,80);
				RefreshTextCommand=function(self)
					local cur_song = GAMESTATE:GetCurrentSong();
					local cur_steps = GAMESTATE:GetCurrentSteps(pn);
					local HSList = PROFILEMAN:GetMachineProfile():GetHighScoreList(cur_song,cur_steps):GetHighScores();
					if (#HSList ~= 0) then
						self:settext( AddDots(MachineBestPScore) );
					else
						self:settext("")
					end;
				end;
				ChangeStepsMessageCommand=function(self,params)
					if params.Player ~= pn then return; end;
					(cmd(stoptweening;sleep,.01;queuecommand,'RefreshText'))(self);
				end;
				StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.21;queuecommand,'RefreshText');
				GoBackSelectingSongMessageCommand=cmd(stoptweening;settext,"");
				OffCommand=cmd(stoptweening;visible,false);
			};

			--machine best hs p.grade
			LoadFont("pbhdkarnivore 24px")..{
				InitCommand=cmd(settext,"";horizalign,right;zoom,.32;x,43;y,22);
				RefreshTextCommand=function(self)
					local cur_song = GAMESTATE:GetCurrentSong();
					local cur_steps = GAMESTATE:GetCurrentSteps(pn);
					local HSList = PROFILEMAN:GetMachineProfile():GetHighScoreList(cur_song,cur_steps):GetHighScores();
					if (#HSList ~= 0) then
						local pgrade = "";
						pgrade = CalcPGrade(MachineBestPScore);
						local pgradecolor = ColorPGrade(pgrade);
						self:settext( pgrade );
						self:diffuse(color(pgradecolor));
					else
						self:settext("")
					end;
				end;
				ChangeStepsMessageCommand=function(self,params)
					if params.Player ~= pn then return; end;
					(cmd(stoptweening;sleep,.01;queuecommand,'RefreshText'))(self);
				end;
				StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.21;queuecommand,'RefreshText');
				GoBackSelectingSongMessageCommand=cmd(stoptweening;settext,"");
				OffCommand=cmd(stoptweening;visible,false);
			};

			--machine best hs plate
			LoadFont("_karnivore lite white")..{
				InitCommand=cmd(settext,"";horizalign,right;zoom,.36;x,43;y,12);
				RefreshTextCommand=function(self)
					local cur_song = GAMESTATE:GetCurrentSong();
					local cur_steps = GAMESTATE:GetCurrentSteps(pn);
					local HSList = PROFILEMAN:GetMachineProfile():GetHighScoreList(cur_song,cur_steps):GetHighScores();
					if (#HSList ~= 0) then
						greats = HSList[MachineBestIndex]:GetTapNoteScore('TapNoteScore_W3');
						goods = HSList[MachineBestIndex]:GetTapNoteScore('TapNoteScore_W4');
						bads = HSList[MachineBestIndex]:GetTapNoteScore('TapNoteScore_W5');
						misses = HSList[MachineBestIndex]:GetTapNoteScore('TapNoteScore_Miss') + HSList[PersonalBestIndex]:GetTapNoteScore('TapNoteScore_CheckpointMiss');		
						plate = CalcPlateInitials(greats,goods,bads,misses);
						local platecolor = ColorPlate(plate);
						self:settext( plate );
						self:diffuse(color(platecolor));
					else
						self:settext("")
					end;
				end;
				ChangeStepsMessageCommand=function(self,params)
					if params.Player ~= pn then return; end;
					(cmd(stoptweening;sleep,.01;queuecommand,'RefreshText'))(self);
				end;
				StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.21;queuecommand,'RefreshText');
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
-- Obtiene el color de la esfera, seg�n el estilo y descripci�n del chart
function GetDiffNumberBall( cur_steps )
	if cur_steps == nil then return 0; end;
	local style = cur_steps:GetStepsType();
	local description = cur_steps:GetDescription();
	local meter = cur_steps:GetMeter();

	if style=='StepsType_Pump_Single' and string.find(description,"SP") then return(1);
	elseif style=='StepsType_Pump_Single' then return (0);
	elseif style=='StepsType_Pump_Routine' or (description ~= "RANDOMSONGS" and style=='StepsType_Pump_Double' and ((meter == (99 or 50)) or string.find(string.upper(description),"COOP") or string.find(string.upper(description),"CO-OP") or string.find(string.upper(description),"ROUTINE") ) ) then return (5);
	elseif ( style=='StepsType_Pump_Double' and string.find( string.upper(description),"DP" ) ) or style=='StepsType_Pump_Couple' then return(3);
	elseif (style=='StepsType_Pump_Double' and string.find( string.upper(description),"HALFDOUBLE" ) ) or style=='StepsType_Pump_Halfdouble' then return (4);
	elseif style=='StepsType_Pump_Double' then return (2);
	end;
	
	return 0;
end;

-- Get simplified ball color
function GetSimpleDiffNumberBall( cur_steps )
	if cur_steps == nil then return 0; end;
	local style = cur_steps:GetStepsType();
	local description = cur_steps:GetDescription();
	local meter = cur_steps:GetMeter();

	if style=='StepsType_Pump_Single' and string.find(description,"SP") then return(2);
	elseif style=='StepsType_Pump_Single' then return (0);
	elseif style=='StepsType_Pump_Routine' or (style=='StepsType_Pump_Double' and ((meter == (99 or 50)) or string.find(string.upper(description),"COOP") or string.find(string.upper(description),"CO-OP") or string.find(string.upper(description),"ROUTINE") ) ) then return (6);
	elseif ( style=='StepsType_Pump_Double' and string.find( string.upper(description),"DP" ) ) or style=='StepsType_Pump_Couple' then return(3);
	elseif (style=='StepsType_Pump_Double' and string.find( string.upper(description),"HALFDOUBLE" ) ) or style=='StepsType_Pump_Halfdouble' then return (5);
	elseif style=='StepsType_Pump_Double' then return (1);
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
	local meter = cur_steps:GetMeter();
	local chartname = cur_steps:GetChartName();
	local chartcredits = cur_steps:GetAuthorCredit();
	
	if meter>99 then meter = 99; end;
	if meter == 99 then
		column = 10;
	else
		if digit ==1 then
			column = math.floor( (meter/10) );
		elseif digit ==2 then
			column = meter - math.floor( (meter/10) )*10;
		end;
	end;

	if style=='StepsType_Pump_Single' and string.find(description,"SP") then row = 4;
	elseif style=='StepsType_Pump_Single' then row = 0;
	elseif style=='StepsType_Pump_Routine' or (not (string.find(description, "RANDOMSONGS")) and style=='StepsType_Pump_Double' and ((meter == (99 or 50)) or string.find(string.upper(description),"COOP") or string.find(string.upper(description),"CO-OP") or string.find(string.upper(description),"ROUTINE") ) ) then
		row = 6;
		if digit == 1 then 
			column = 12;
		elseif digit == 2 then
			column = 10;
			if string.find(string.upper(description), "2P") or string.find(string.upper(chartname), "2P") or string.find(string.upper(chartcredits), "2 PLAYERS")  or string.find(string.upper(description), "2 P") or string.find(string.upper(chartname), "2 P") or string.find(string.upper(description), "TWO P") or string.find(string.upper(chartname), "TWO P") then column = 2
			elseif string.find(string.upper(description), "3P") or string.find(string.upper(chartname), "3P") or string.find(string.upper(chartcredits), "3 PLAYERS")  or string.find(string.upper(description), "3 P") or string.find(string.upper(chartname), "3 P") or string.find(string.upper(description), "THREE P") or string.find(string.upper(chartname), "THREE P") then column = 3
			elseif string.find(string.upper(description), "4P") or string.find(string.upper(chartname), "4P") or string.find(string.upper(chartcredits), "4 PLAYERS")  or string.find(string.upper(description), "4 P") or string.find(string.upper(chartname), "4 P") or string.find(string.upper(description), "FOUR P") or string.find(string.upper(chartname), "FOUR P") then column = 4
			elseif string.find(string.upper(description), "5P") or string.find(string.upper(chartname), "5P") or string.find(string.upper(chartcredits), "5 PLAYERS")  or string.find(string.upper(description), "5 P") or string.find(string.upper(chartname), "5 P") or string.find(string.upper(description), "FIVE P") or string.find(string.upper(chartname), "FIVE P") then column = 5
			elseif string.find(string.upper(description), "6P") or string.find(string.upper(chartname), "6P") or string.find(string.upper(chartcredits), "6 PLAYERS")  or string.find(string.upper(description), "6 P") or string.find(string.upper(chartname), "6 P") or string.find(string.upper(description), "SIX P") or string.find(string.upper(chartname), "SIX P") then column = 6
			elseif string.find(string.upper(description), "7P") or string.find(string.upper(chartname), "7P") or string.find(string.upper(chartcredits), "7 PLAYERS")  or string.find(string.upper(description), "7 P") or string.find(string.upper(chartname), "7 P") or string.find(string.upper(description), "SEVEN P") or string.find(string.upper(chartname), "SEVEN P") then column = 7
			elseif string.find(string.upper(description), "8P") or string.find(string.upper(chartname), "8P") or string.find(string.upper(chartcredits), "8 PLAYERS")  or string.find(string.upper(description), "8 P") or string.find(string.upper(chartname), "8 P") or string.find(string.upper(description), "EIGHT P") or string.find(string.upper(chartname), "EIGHT P") then column = 8
			elseif string.find(string.upper(description), "9P") or string.find(string.upper(chartname), "9P") or string.find(string.upper(chartcredits), "9 PLAYERS")  or string.find(string.upper(description), "9 P") or string.find(string.upper(chartname), "9 P") or string.find(string.upper(description), "NINE P") or string.find(string.upper(chartname), "NINE P") then column = 9
			elseif string.find(string.upper(description), "1P") or string.find(string.upper(chartname), "1P") or string.find(string.upper(chartcredits), "1 PLAYER")  or string.find(string.upper(description), "1 P") or string.find(string.upper(chartname), "1 P") or string.find(string.upper(description), "ONE P") or string.find(string.upper(chartname), "ONE P") then column = 1
			end;
		end;
	elseif ( style=='StepsType_Pump_Double' and string.find( string.upper(description),"DP" ) ) or style=='StepsType_Pump_Couple' then row = 5;
	elseif (style=='StepsType_Pump_Double' and string.find( string.upper(description),"HALFDOUBLE" ) ) or style=='StepsType_Pump_Halfdouble' then row = 1;
	elseif style=='StepsType_Pump_Double' then row = 1;
	end
	self:setstate( column + row*13 );
end;

-- Obtiene la etiqueta superior para mostrar en la esfera
local function GetBallLabel( cur_steps )
	return GetLabelNumber( cur_steps:GetLabel() );
end;

-- Obtiene la etiqueta inferior para mostrar en la esfera
--local function GetBallUnderLabel( cur_steps )
--	local style = cur_steps:GetStepsType();
--	local description = cur_steps:GetDescription();
--	
--	if (style=='StepsType_Pump_Double' and string.find( string.upper(description),"HALFDOUBLE" ) ) or style=='StepsType_Pump_Halfdouble' then return 0;
--	elseif (style=='StepsType_Pump_Couple') then return 1;
--	end;
--	
--	return 2; --empty
--end;

-- Funci�n para obtener la esfera de nivel
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
--			(cmd(stoptweening;diffusealpha,1;sleep,.03;setstate,GetBallUnderLabel(cur_steps)))( this.Underlabel );
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
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs numbers 13x7.png") )..{
				Name="LevelDigit1";
				InitCommand=cmd(y,2;pause;x,-22);
			};
			
			-- Level (numeros) Digit 2 --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs numbers 13x7.png") )..{
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
--			LoadActor( THEME:GetPathG("","Common Resources/B_UNDERLABELS 1x3.png") )..{
--				Name="Underlabel";
--				InitCommand=cmd(visible,show_labels;y,40;pause;setstate,2);
				--OffCommand=cmd(stoptweening;diffusealpha,1;sleep,.2;linear,.05;diffusealpha,0);
--			};
			
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


-- Simplified Ball
function GetSimpleBallLevel( pn )
	local l = Def.ActorFrame {		
		InitCommand=cmd(basezoom,.67);
		ShowUpCommand=cmd(playcommand,"Update";playcommand,'ShowUpInternal');
		HideCommand=cmd(playcommand,'HideInternal');
		UpdateCommand=function(self)
			local this = self:GetChildren();
			local cur_steps = GAMESTATE:GetCurrentSteps(pn);
			
			-- Actualizo color esfera de nivel
			(cmd(stoptweening;diffusealpha,1;setstate,GetSimpleDiffNumberBall(cur_steps);basezoom,2))( this.Bigballs );
			
			-- Actualizo digitos de nivel
			(cmd(stoptweening;diffusealpha,1;SetLevelTextByDigit,cur_steps,1))( this.LevelDigit1 );
			(cmd(stoptweening;diffusealpha,1;SetLevelTextByDigit,cur_steps,2))( this.LevelDigit2 );
			
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
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/fullbar balls 7x1.png") )..{
				Name="Bigballs";
				InitCommand=cmd(pause);
			};
			
			-- Level (numeros) Digit 1 --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs numbers 13x7.png") )..{
				Name="LevelDigit1";
				InitCommand=cmd(y,2;pause;x,-22);
			};
			
			-- Level (numeros) Digit 2 --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs numbers 13x7.png") )..{
				Name="LevelDigit2";
				InitCommand=cmd(y,2;pause;x,22);
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
		};
	};

	return l;
end;

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////