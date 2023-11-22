local t = Def.ActorFrame {
	GoNextScreenMessageCommand=cmd(playcommand,'Off');
};

local init_pos = 133;
local delta = 23;

-- Tick sound
local times = 1;
t[#t+1] = LoadActor(THEME:GetPathS("","Sounds/Tick.mp3"))..{
	OnCommand=cmd(sleep,2;queuecommand,'Play');
	PlayCommand=function(self)
		--SOUND:PlayOnce(THEME:GetPathS("","Sounds/Tick.WAV"));
		self:play();
		times = times + 1;
		if( times < 24 ) then
			self:sleep(.074);
			self:queuecommand('Play');
		end;
	end;
	OffCommand=cmd(stoptweening);
}

t[#t+1] = LoadActor(THEME:GetPathS("","Sounds/HEART_PLUS.mp3"))..{
	OnCommand=cmd(sleep,1.8;queuecommand,'Play');
	PlayCommand=function(self)
		self:play();
	end;
	OffCommand=cmd(stoptweening);
}

-- Scores
if GAMESTATE:IsSideJoined(PLAYER_1) then
	local curstats = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1); 
	local perfects = curstats:GetTapNoteScores('TapNoteScore_W2') + curstats:GetTapNoteScores('TapNoteScore_CheckpointHit');
	local greats = curstats:GetTapNoteScores('TapNoteScore_W3');
	local goods = curstats:GetTapNoteScores('TapNoteScore_W4');
	local bads = curstats:GetTapNoteScores('TapNoteScore_W5');
	local misses = curstats:GetTapNoteScores('TapNoteScore_Miss') + curstats:GetTapNoteScores('TapNoteScore_CheckpointMiss');
	local maxcombo = curstats:MaxCombo();
	local stagebreak = curstats:GetReachedLifeZero();
	
	local notestotal = perfects + greats + goods + bads + misses;
	if notestotal <= 1 then notestotal = 1 end;
	local weightednotes = perfects + 0.6*greats + 0.2*goods + 0.1*bads;
	local pscore = math.floor(((weightednotes * 0.995 + maxcombo * 0.005) / notestotal) * 1000000 );
	if pscore < 0 then
		pscore = 0;
	elseif pscore > 1000000 then
		pscore = 1000000;
	end;
	
	local pgrade = "F";
	pgrade = (
		(pscore >= 995000 and "SSS+")	or 
		(pscore >= 990000 and "SSS")	or 
		(pscore >= 985000 and "SS+")	or
		(pscore >= 980000 and "SS")	or
		(pscore >= 975000 and "S+")	or
		(pscore >= 970000 and "S")	or 
		(pscore >= 960000 and "AAA+")	or 
		(pscore >= 950000 and "AAA")	or
		(pscore >= 925000 and "AA+")	or
		(pscore >= 900000 and "AA")	or
		(pscore >= 825000 and "A+")	or
		(pscore >= 750000 and "A")	or
		(pscore >= 650000 and "B")	or
		(pscore >= 550000 and "C")	or
		(pscore >= 450000 and "D") 	or
		"F"
	);
	local plate = "";
	plate = (
		(stagebreak and "")	or 
		(misses >= 21 and "Rough Game")	or 
		(misses >= 11 and "Fair Game")	or
		(misses >= 6 and "Talented Game")	or
		(misses >= 1 and "Marvelous Game")	or
		(bads >= 1 and "Superb Game")	or 
		(goods >= 1 and "Extreme Game")	or 
		(greats >= 1 and "Ultimate Game")	or
		"Perfect Game"
	);

	t[#t+1] = DrawRollingNumberP1( WideScale(66, 115), init_pos, 	perfects, 'HorizAlign_Left', 2 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( WideScale(66, 115), init_pos+delta, curstats:GetTapNoteScores('TapNoteScore_W3'), 'HorizAlign_Left', 2.08 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( WideScale(66, 115), init_pos+delta*2, curstats:GetTapNoteScores('TapNoteScore_W4'), 'HorizAlign_Left', 2.16 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( WideScale(66, 115), init_pos+delta*3, curstats:GetTapNoteScores('TapNoteScore_W5'), 'HorizAlign_Left', 2.24 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( WideScale(66, 115), init_pos+delta*4, misses, 'HorizAlign_Left', 2.32 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( WideScale(66, 115), init_pos+delta*5, curstats:MaxCombo(), 'HorizAlign_Left', 2.40 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP2( WideScale(66, 115), init_pos+delta*6, pscore, 'HorizAlign_Left', 2.48 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( WideScale(66, 115), init_pos+delta*7, curstats:GetScore(), 'HorizAlign_Left', 2.56 )..{InitCommand=cmd(zoom,.84);};
	--kcal
	local kcal = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetCaloriesBurned();
	t[#t+1] = DrawRollingNumberP1( WideScale(106, 155), init_pos+delta*8, math.floor( (kcal - math.floor(kcal))*1000 ), 'HorizAlign_Left', 2.64 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( WideScale(66, 115), init_pos+delta*8, math.floor( kcal ), 'HorizAlign_Left', 2.64 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = LoadFont("_karnivore lite white 20px")..{ InitCommand=cmd(settext,".";y,init_pos+delta*8;x,WideScale(101, 150);zoom,.84;diffusealpha,0;sleep,2.64;diffusealpha,1); };
	--p. grade
	t[#t+1] = LoadFont("hdkarnivore 24px")..{ InitCommand=cmd(settext,pgrade;y,init_pos+delta*6;x,WideScale(171, 220);zoom,.84;diffusealpha,0;sleep,4.2;diffusealpha,1); };
	--plate
	t[#t+1] = LoadFont("hdkarnivore 24px")..{ InitCommand=cmd(settext,plate;y,init_pos-delta;x,WideScale(171, 220);zoom,.84;diffusealpha,0;sleep,4.2;diffusealpha,1); };

end;

if GAMESTATE:IsSideJoined(PLAYER_2) then
	local curstats = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2); 
	local perfects = curstats:GetTapNoteScores('TapNoteScore_W2') + curstats:GetTapNoteScores('TapNoteScore_CheckpointHit');
	local greats = curstats:GetTapNoteScores('TapNoteScore_W3');
	local goods = curstats:GetTapNoteScores('TapNoteScore_W4');
	local bads = curstats:GetTapNoteScores('TapNoteScore_W5');
	local misses = curstats:GetTapNoteScores('TapNoteScore_Miss') + curstats:GetTapNoteScores('TapNoteScore_CheckpointMiss');
	local maxcombo = curstats:MaxCombo();
	local stagebreak = curstats:GetReachedLifeZero();
	
	local notestotal = perfects + greats + goods + bads + misses;
	if notestotal <= 1 then notestotal = 1 end;
	local weightednotes = perfects + 0.6*greats + 0.2*goods + 0.1*bads;
	local pscore = math.floor(((weightednotes * 0.995 + maxcombo * 0.005) / notestotal) * 1000000 );
	if pscore < 0 then
		pscore = 0;
	elseif pscore > 1000000 then
		pscore = 1000000;
	end;
	
	local pgrade = "(F)";
	pgrade = (
		(pscore >= 995000 and "SSS+")	or 
		(pscore >= 990000 and "SSS")	or 
		(pscore >= 985000 and "SS+")	or
		(pscore >= 980000 and "SS")	or
		(pscore >= 975000 and "S+")	or
		(pscore >= 970000 and "S")	or 
		(pscore >= 960000 and "AAA+")	or 
		(pscore >= 950000 and "AAA")	or
		(pscore >= 925000 and "AA+")	or
		(pscore >= 900000 and "AA")	or
		(pscore >= 825000 and "A+")	or
		(pscore >= 750000 and "A")	or
		(pscore >= 650000 and "B")	or
		(pscore >= 550000 and "C")	or
		(pscore >= 450000 and "D") 	or
		"F"
	);
	local plate = "";
	plate = (
		(stagebreak and "")	or 
		(misses >= 21 and "Rough Game")	or 
		(misses >= 11 and "Fair Game")	or
		(misses >= 6 and "Talented Game")	or
		(misses >= 1 and "Marvelous Game")	or
		(bads >= 1 and "Superb Game")	or 
		(goods >= 1 and "Extreme Game")	or 
		(greats >= 1 and "Ultimate Game")	or
		"Perfect Game"
	);
	
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(66, 115), init_pos, 	perfects, 'HorizAlign_Right', 2 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(66, 115), init_pos+delta, greats, 'HorizAlign_Right', 2.08 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(66, 115), init_pos+delta*2, goods, 'HorizAlign_Right', 2.16 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(66, 115), init_pos+delta*3, bads, 'HorizAlign_Right', 2.24 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(66, 115), init_pos+delta*4, misses, 'HorizAlign_Right', 2.32 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(66, 115), init_pos+delta*5, maxcombo, 'HorizAlign_Right', 2.40 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP2( SCREEN_RIGHT-WideScale(66, 115), init_pos+delta*6, pscore, 'HorizAlign_Right', 2.48 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(66, 115), init_pos+delta*7, curstats:GetScore(), 'HorizAlign_Right', 2.56 )..{InitCommand=cmd(zoom,.84);};
	--kcal
	local kcal = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetCaloriesBurned();
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(66, 115), init_pos+delta*8, math.floor( (kcal - math.floor(kcal))*1000 ), 'HorizAlign_Right', 2.64 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = DrawRollingNumberP1( SCREEN_RIGHT-WideScale(106, 155), init_pos+delta*8, math.floor( kcal ), 'HorizAlign_Right', 2.64 )..{InitCommand=cmd(zoom,.84);};
	t[#t+1] = LoadFont("_karnivore lite white 20px")..{ InitCommand=cmd(settext,".";y,init_pos+delta*8;x,SCREEN_RIGHT-WideScale(101, 150);zoom,.84;diffusealpha,0;sleep,2.64;diffusealpha,1); };
	--p. grade
	t[#t+1] = LoadFont("hdkarnivore 24px")..{ InitCommand=cmd(settext,pgrade;y,init_pos+delta*6;x,SCREEN_RIGHT-WideScale(171, 220);zoom,.84;diffusealpha,0;sleep,4.2;diffusealpha,1); };
	--plate
	t[#t+1] = LoadFont("hdkarnivore 24px")..{ InitCommand=cmd(settext,plate;y,init_pos-delta;x,SCREEN_RIGHT-WideScale(171, 220);zoom,.84;diffusealpha,0;sleep,4.2;diffusealpha,1); };

end;

return t;