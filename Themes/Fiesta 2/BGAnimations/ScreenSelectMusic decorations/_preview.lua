local t = Def.ActorFrame {}

-- Frame
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/preview_frame") )..{
	InitCommand=cmd(blend,'BlendMode_Add';basezoom,.66);
	OnCommand=cmd(stoptweening;visible,false);
	NextSongMessageCommand=cmd(stoptweening;visible,true;diffusealpha,0;zoomx,0;x,-180;linear,.1;diffusealpha,1;x,0;zoomx,1;linear,.1;diffusealpha,0;x,180);
	PreviousSongMessageCommand=cmd(stoptweening;visible,true;diffusealpha,0;zoomx,0;x,180;linear,.1;diffusealpha,1;x,0;zoomx,1;linear,.1;diffusealpha,0;x,-180);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;visible,false);
	StartSelectingSongMessageCommand=cmd(stoptweening;visible,false);
	StartSelectingStepsMessageCommand=cmd(stoptweening;visible,false);
	OffCommand=cmd(stoptweening;visible,false);
}

-- Frame
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/songprev_frame") )..{
	InitCommand=cmd(blend,'BlendMode_Add';zoom,.66,draworder,-1);
	OnCommand=cmd(stoptweening;sleep,.74;queuecommand,'Loop');
	LoopCommand=cmd(stoptweening;diffusealpha,0;zoomx,.6;linear,.8;zoomx,.5;diffusealpha,.5;linear,.8;zoomx,.6;diffusealpha,0;queuecommand,'Loop');
	CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.74;queuecommand,'Loop');
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,0);
	StartSelectingSongMessageCommand=cmd(stoptweening;sleep,.74;queuecommand,'Loop');
	GoBackSelectingSongMessageCommand=cmd(stoptweening;playcommand,'Loop');
	StepsChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
	StartSelectingStepsMessageCommand=cmd(stoptweening;diffusealpha,0);
	StepsPreselectedCancelledMessageCommand=cmd(stoptweening;playcommand,'Loop');
	OffCommand=cmd(stoptweening;visible,false);
}

-- Frame
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/preview_frame") )..{
	InitCommand=cmd(blend,'BlendMode_Add';zoom,.66;draworder,1);
	OnCommand=cmd(stoptweening;diffusealpha,0);
	LoopCommand=cmd(stoptweening;diffusealpha,0;zoomx,.6;linear,.8;zoomx,.5;diffusealpha,.5;linear,.8;zoomx,.6;diffusealpha,0;queuecommand,'Loop');
	CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,0);
	StartSelectingStepsMessageCommand=cmd(stoptweening;queuecommand,'Loop');
	GoBackSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0);
	StepsChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
	StepsPreselectedCancelledMessageCommand=cmd(stoptweening;playcommand,'Loop');
	OffCommand=cmd(stoptweening;visible,false);
}

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
local nPlayersJoined = GAMESTATE:GetNumSidesJoined();

if nPlayersJoined == 1 then
	--GREEN QUEST SHADOW
	local g = Def.ActorFrame {
		InitCommand=cmd(y,-10);
		OnCommand=cmd(visible,false);
		StartSelectingStepsMessageCommand=cmd(stoptweening;visible,false;sleep,.2;queuecommand,'ChangeSteps');
		GoBackSelectingSongMessageCommand=cmd(stoptweening;visible,false);
		OffCommand=cmd(stoptweening;visible,false);
		ChangeStepsMessageCommand=function(self)
			self:stoptweening();
			if nPlayersJoined > 1 then
				self:visible(false);
				return;
			end;
			if #(GAMESTATE:GetCurrentSteps( GAMESTATE:GetMasterPlayerNumber() ):GetChartName()) ~= 0 then
				local label = GAMESTATE:GetCurrentSteps( GAMESTATE:GetMasterPlayerNumber() ):GetLabel();
				if(label == "QUEST" or label == "HIDDEN" or GAMESTATE:GetCurrentSteps( GAMESTATE:GetMasterPlayerNumber() ):ShowInfoBar()) then
					self:visible(true);
				else
					self:visible(false);
				end;
			else
				self:visible(false);
			end;
		end;
	};
		
	g[#g+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/preview_shadow_one_player") )..{
		InitCommand=cmd(basezoom,.675)
	};
	
	g[#g+1] = LoadFont("_myriad pro 20px")..{
		OnCommand=cmd(stoptweening;shadowlength,0;zoom,.8;maxwidth,300);
		ChangeStepsMessageCommand=cmd(playcommand,'UpdateText');
		StartSelectingStepsMessageCommand=cmd(playcommand,'UpdateText');
		UpdateTextCommand=function(self)
			local text = GAMESTATE:GetCurrentSteps( GAMESTATE:GetMasterPlayerNumber() ):GetChartName();
			if string.len(text) >= 70 then
				text = string.sub(text,1,68);
				text = text .. "...";
			end;
			self:settext( text );
		end;
	};
	
	t[#t+1] = g;
	
elseif nPlayersJoined == 2 then	
	local h = Def.ActorFrame {
		InitCommand=cmd(y,-10);
		OnCommand=cmd(visible,false);
		StartSelectingStepsMessageCommand=cmd(stoptweening;visible,false;sleep,.2;queuecommand,'ChangeSteps');
		GoBackSelectingSongMessageCommand=cmd(stoptweening;visible,false);
		OffCommand=cmd(stoptweening;visible,false);
		ChangeStepsMessageCommand=function(self)
			self:stoptweening();
			if nPlayersJoined < 2 then
				self:visible(false);
				return;
			end;
			
			local label_p1 = GAMESTATE:GetCurrentSteps( PLAYER_1 ):GetLabel();
			local label_p2 = GAMESTATE:GetCurrentSteps( PLAYER_2 ):GetLabel();
			
			if (GAMESTATE:GetCurrentSteps( PLAYER_1 ):GetChartName() ~= "" and (label_p1 == "QUEST" or label_p1 == "HIDDEN" or GAMESTATE:GetCurrentSteps( PLAYER_1 ):ShowInfoBar())) or (GAMESTATE:GetCurrentSteps( PLAYER_2 ):GetChartName() ~= "" and (label_p2 == "QUEST" or label_p2 == "HIDDEN" or GAMESTATE:GetCurrentSteps( PLAYER_2 ):ShowInfoBar()))then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
		PlayerJoinedMessageCommand=function(self)
			nPlayersJoined = GAMESTATE:GetNumSidesJoined();
		end;
	}
	
	h[#h+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/preview_shadow_two_players") )..{
		InitCommand=cmd(basezoom,.675)
	};
	
	--TEXT FOR PLAYER 1
	h[#h+1] = LoadFont("_myriad pro 20px")..{
		OnCommand=cmd(stoptweening;y,-35;shadowlength,0;zoom,.8;maxwidth,360);
		ChangeStepsMessageCommand=cmd(stoptweening;playcommand,'UpdateText');
		StartSelectingStepsMessageCommand=cmd(stoptweening;playcommand,'UpdateText');
		UpdateTextCommand=function(self)
			if not GAMESTATE:IsSideJoined( PLAYER_1 ) then
				return;
			end;
			local text = GAMESTATE:GetCurrentSteps( PLAYER_1 ):GetChartName();
			if string.len(text) >= 70 then
				text = string.sub(text,1,67);
				text = text .. "...";
			end;
			self:settext( text );
		end;
	};
	
	--TEXT FOR PLAYER 2
	h[#h+1] = LoadFont("_myriad pro 20px")..{
		OnCommand=cmd(stoptweening;y,35;shadowlength,0;zoom,.8;maxwidth,360);
		ChangeStepsMessageCommand=cmd(stoptweening;playcommand,'UpdateText');
		StartSelectingStepsMessageCommand=cmd(stoptweening;playcommand,'UpdateText');
		UpdateTextCommand=function(self)
			if not GAMESTATE:IsSideJoined( PLAYER_2 ) then
				return;
			end;
			local text = GAMESTATE:GetCurrentSteps( PLAYER_2 ):GetChartName();
			if string.len(text) >= 70 then
				text = string.sub(text,1,67);
				text = text .. "...";
			end;
			self:settext( text );
		end;
	};
	
	t[#t+1] =h;
end;

-- Contador
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/_counter_bg") )..{
	InitCommand=cmd(y,-78;zoom,0.67);
}

--t[#t+1] = LoadFont("_karnivore lite Bold white")..{
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(y,-80);
	CurrentSongChangedMessageCommand=function(self)
		local index = SCREENMAN:GetTopScreen():GetWheelCurrentIndex()+1;
		local numitems = SCREENMAN:GetTopScreen():GetWheelNumItems();
		
		local total_d3 = self:GetChild("TOTAL_D3");
		local total_d2 = self:GetChild("TOTAL_D2");
		local total_d1 = self:GetChild("TOTAL_D1");
		local curindex_d3 = self:GetChild("CURINDEX_D3");
		local curindex_d2 = self:GetChild("CURINDEX_D2");
		local curindex_d1 = self:GetChild("CURINDEX_D1");
		
		if numitems < 999 then
			local total_centenas = math.floor(numitems/100)*100;
			local total_decenas = math.floor((numitems - total_centenas)/10)*10;
			local total_unidad = math.floor(numitems - total_centenas - total_decenas);
			
			total_d3:setstate( math.floor(total_centenas/100) );
			total_d2:setstate( math.floor(total_decenas/10) );
			total_d1:setstate( math.floor(total_unidad) );
		else
			total_d3:setstate( 9 );
			total_d2:setstate( 9 );
			total_d1:setstate( 9 );
		end;
		
		if index < 999 then
			local curindex_centenas = math.floor(index/100)*100;
			local curindex_decenas = math.floor((index - curindex_centenas)/10)*10;
			local curindex_unidad = math.floor(index - curindex_centenas - curindex_decenas);
			
			curindex_d3:setstate( math.floor(curindex_centenas/100) );
			curindex_d2:setstate( math.floor(curindex_decenas/10) );
			curindex_d1:setstate( math.floor(curindex_unidad) );
		else
			curindex_d3:setstate( 9 );
			curindex_d2:setstate( 9 );
			curindex_d1:setstate( 9 );
		end;
	end;
	children = {
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_counter_bg") )..{
			InitCommand=cmd(y,1;basezoom,0.67);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/SongIndexNumber 10x1") )..{
			Name="TOTAL_D3";
			InitCommand=cmd(pause;x,10;basezoom,.66;setstate,2);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/SongIndexNumber 10x1") )..{
			Name="TOTAL_D2";
			InitCommand=cmd(pause;x,18;basezoom,.66);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/SongIndexNumber 10x1") )..{
			Name="TOTAL_D1";
			InitCommand=cmd(pause;x,26;basezoom,.66);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/SongIndexNumber 10x1") )..{
			Name="CURINDEX_D3";
			InitCommand=cmd(pause;x,-26;basezoom,.66);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/SongIndexNumber 10x1") )..{
			Name="CURINDEX_D2";
			InitCommand=cmd(pause;x,-18;basezoom,.66);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/SongIndexNumber 10x1") )..{
			Name="CURINDEX_D1";
			InitCommand=cmd(pause;x,-10;basezoom,.66);
		};
	};
}

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/_song_info_bg") )..{
	InitCommand=cmd(y,73;zoom,0.67);
}

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/_side_to_left") )..{
	InitCommand=cmd(blend,'BlendMode_Add';basezoom,0.67;horizalign,right;x,-148);
	StartSelectingStepsMessageCommand=cmd(stoptweening;sleep,.15;x,-155;diffusealpha,0;zoom,0;linear,.0;zoom,1;x,-148;diffusealpha,1;queuecommand,'Loop');
	GoBackSelectingSongMessageCommand=cmd(stoptweening;x,-148;diffusealpha,1;zoom,1;linear,.0;zoom,0;x,-155;diffusealpha,0);
	OffCommand=cmd(stoptweening;x,-148;diffusealpha,1;zoom,1;linear,.2;zoom,0;x,-155;diffusealpha,0);
	OnCommand=cmd(diffusealpha,0;zoom,0);
	LoopCommand=cmd(stoptweening;diffusealpha,1;linear,.5;diffusealpha,.5;linear,.5;diffusealpha,1;queuecommand,'Loop');
	FastLoopCommand=cmd(stoptweening;diffusealpha,1;linear,.1;diffusealpha,.5;linear,.1;diffusealpha,1;queuecommand,'FastLoop');
	StepsChosenMessageCommand=cmd(stoptweening;queuecommand,'FastLoop');
	StepsPreselectedCancelledMessageCommand=cmd(stoptweening;playcommand,'Loop');
}

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/_side_to_left") )..{
	InitCommand=cmd(blend,'BlendMode_Add';basezoom,0.67;horizalign,right;x,148;rotationy,180);
	StartSelectingStepsMessageCommand=cmd(stoptweening;sleep,.15;x,155;diffusealpha,0;zoom,0;linear,.0;zoom,1;x,148;diffusealpha,1;queuecommand,'Loop');
	GoBackSelectingSongMessageCommand=cmd(stoptweening;x,148;diffusealpha,1;zoom,1;linear,.0;zoom,0;x,155;diffusealpha,0);
	OffCommand=cmd(stoptweening;x,148;diffusealpha,1;zoom,1;linear,.2;zoom,0;x,155;diffusealpha,0);
	OnCommand=cmd(diffusealpha,0;zoom,0);
	LoopCommand=cmd(stoptweening;diffusealpha,1;linear,.5;diffusealpha,.5;linear,.5;diffusealpha,1;queuecommand,'Loop');
	FastLoopCommand=cmd(stoptweening;diffusealpha,1;linear,.1;diffusealpha,.5;linear,.1;diffusealpha,1;queuecommand,'FastLoop');
	StepsChosenMessageCommand=cmd(stoptweening;queuecommand,'FastLoop');
	StepsPreselectedCancelledMessageCommand=cmd(stoptweening;playcommand,'Loop');
}

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/_arrow_to_left") )..{
	InitCommand=cmd(blend,'BlendMode_Add';zoom,0.67;x,-182;y,-1);
	OnCommand=cmd(finishtweening;x,-160;y,50;zoom,0;linear,.3;x,-182;y,-1;zoom,.67;queuecommand,'Loop');
	LoopCommand=cmd(finishtweening;diffusealpha,1;linear,.5;diffusealpha,.5;linear,.5;diffusealpha,1;queuecommand,'Loop');
	PreviousSongMessageCommand=cmd(finishtweening;diffusealpha,1;x,-182;linear,.15;x,-202;linear,.15;x,-182;queuecommand,'Loop');
	NextSongMessageCommand=cmd(finishtweening;diffusealpha,1;sleep,.3;queuecommand,'Loop');
	StartSelectingStepsMessageCommand=cmd(finishtweening;x,-182;zoom,0.67;linear,.15;x,-160;zoom,0;queuecommand,'Loop');
	GoBackSelectingSongMessageCommand=cmd(finishtweening;sleep,.15;x,-160;zoom,0;linear,.15;x,-182;zoom,0.67;queuecommand,'Loop');
	GoBackSelectingGroupMessageCommand=cmd(finishtweening;x,-182;zoom,0.67;linear,.15;x,-160;zoom,0;queuecommand,'Loop');
	StartSelectingSongMessageCommand=cmd(finishtweening;sleep,.3;x,-160;zoom,0;linear,.15;x,-182;zoom,.67;queuecommand,'Loop');
}

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/_arrow_to_left") )..{
	InitCommand=cmd(blend,'BlendMode_Add';rotationz,180;zoom,0.67;x,182;y,-1);
	OnCommand=cmd(finishtweening;x,160;y,50;zoom,0;linear,.3;x,182;y,-1;zoom,.67;queuecommand,'Loop');
	LoopCommand=cmd(finishtweening;diffusealpha,1;linear,.5;diffusealpha,.5;linear,.5;diffusealpha,1;queuecommand,'Loop');
	NextSongMessageCommand=cmd(finishtweening;diffusealpha,1;x,182;linear,.15;x,202;linear,.15;x,182;queuecommand,'Loop');
	PreviousSongMessageCommand=cmd(finishtweening;diffusealpha,1;sleep,.3;queuecommand,'Loop');
	StartSelectingStepsMessageCommand=cmd(finishtweening;x,182;zoom,0.67;linear,.15;x,160;zoom,0;queuecommand,'Loop');
	GoBackSelectingSongMessageCommand=cmd(finishtweening;sleep,.15;x,160;zoom,0;linear,.15;x,182;zoom,0.67;queuecommand,'Loop');
	GoBackSelectingGroupMessageCommand=cmd(finishtweening;x,182;zoom,0.67;linear,.15;x,160;zoom,0;queuecommand,'Loop');
	StartSelectingSongMessageCommand=cmd(finishtweening;sleep,.3;x,160;zoom,0;linear,.15;x,182;zoom,.67;queuecommand,'Loop');
}

t[#t+1] = Def.ActorFrame {
	GoBackSelectingGroupMessageCommand=cmd(finishtweening;diffusealpha,0);
	StartSelectingSongMessageCommand=cmd(finishtweening;diffusealpha,0;sleep,.54;diffusealpha,1);
	OffCommand=cmd(stoptweening;visible,false);
	children = {
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_cursor_line") )..{
			InitCommand=cmd(zoom,0.67;y,95);
			OnCommand=cmd(stoptweening;y,145;sleep,.1;linear,.2;y,95);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_cursor_ball") )..{
			InitCommand=cmd(zoom,0.67;y,95;x,-155);
			OnCommand=cmd(stoptweening;y,145;sleep,.1;linear,.2;y,95);
			UpdateCommand=function(self)
				local cur_index = SCREENMAN:GetTopScreen():GetWheelCurrentIndex();
				local total = SCREENMAN:GetTopScreen():GetWheelNumItems();
				self:stoptweening();
				self:x( -155 + 310*(cur_index/total) );
			end;
			CurrentSongChangedMessageCommand=cmd(playcommand,'Update');
		};
	};
}

-- Frame
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/preview_frame") )..{
	InitCommand=cmd(blend,'BlendMode_Add';zoom,.66);
	OnCommand=cmd(stoptweening;diffusealpha,0);
	FastLoopCommand=cmd(stoptweening;diffusealpha,0;zoomx,1;linear,.1;zoomx,.5;diffusealpha,1;linear,.1;zoomx,1;diffusealpha,0;queuecommand,'FastLoop');
	StepsChosenMessageCommand=cmd(stoptweening;playcommand,'FastLoop');
	StepsPreselectedCancelledMessageCommand=cmd(stoptweening;diffusealpha,0);
	GoBackSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0);
	OffCommand=cmd(stoptweening;visible,false);
}

--t[#t+1] = LoadFont("_jnr_font")..{
--[[
t[#t+1] = LoadFont("_myriad pro 20px")..{
	OnCommand=cmd(stoptweening;horizalign,left;y,66;x,-148;zoom,.6;shadowlength,0;maxwidth,500;playcommand,'CurrentSongChanged');
	--PreviewChangedMessageCommand=cmd(stoptweening;visible,false);
	CurrentSongChangedMessageCommand=function(self)
		self:stoptweening();
	
		local group = SCREENMAN:GetTopScreen():GetCurrentGroup();
		if( group == "SO_RANDOM" ) then
			self:settext( "???" );
			return;
		end;
	
		if not GAMESTATE:GetCurrentSong() then
			self:visible(false);
			return;
		end;
		
		self:visible(true);
		self:settext( GAMESTATE:GetCurrentSong():GetDisplayMainTitle() );
	end;
	OffCommand=cmd(stoptweening;visible,false);
}

--t[#t+1] = LoadFont("_jnr_font")..{

t[#t+1] = LoadFont("_myriad pro 20px")..{
	OnCommand=cmd(stoptweening;horizalign,left;y,79;x,-148;zoom,.6;shadowlength,0;diffuse,0,1,1,1;maxwidth,230;playcommand,'CurrentSongChanged');
	--PreviewChangedMessageCommand=cmd(stoptweening;visible,false);
	CurrentSongChangedMessageCommand=function(self)
		self:stoptweening();
		
		if not GAMESTATE:GetCurrentSong() then
			self:visible(false);
			return;
		end;
		
		self:visible(true);
		self:settext( GAMESTATE:GetCurrentSong():GetDisplayArtist() );
	end;
	OffCommand=cmd(stoptweening;visible,false);
}]]

t[#t+1] = Def.ActorFrame {
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,0);
	StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.4;linear,.1;diffusealpha,1);
	OnCommand=cmd(playcommand,'CurrentSongChanged');
	OffCommand=cmd(stoptweening;visible,false);
	CurrentSongChangedMessageCommand=function(self)
		local cur_song = GAMESTATE:GetCurrentSong();
		if not cur_song then
			self:visible(false);
			return;
		end;
		
		self:visible(true);
		
		local bpm1;
		local bpm2;
		local bpm_size;
		local bpm_number = self:GetChild("bpm_number");
		local bpm_text = self:GetChild("bpm_text");
		local artist = self:GetChild("artist");
		local title = self:GetChild("title");
		
		if( cur_song:IsDisplayBpmSecret() ) then
			bpm_number:settext("???");
		else
			bpm1 = cur_song:GetDisplayBpmsText()[1];
			bpm2 = cur_song:GetDisplayBpmsText()[2];
			if( bpm1 ~= bpm2 ) then
				bpm_number:settext(bpm1.."-"..bpm2);
			else
				bpm_number:settext(bpm1);
			end;
		end;
		bpmW = math.floor(bpm_number:GetZoomedWidth());
		bpm_text:x(148-bpmW-4);
		
		artist:maxwidth( (296-bpmW-30)*(1/.6) );
		artist:settext( cur_song:GetDisplayArtist() );
		
		local group = SCREENMAN:GetTopScreen():GetCurrentGroup();

		if( group == "SO_RANDOM" ) then
			title:settext( "???" );
		else
			title:settext( cur_song:GetDisplayMainTitle() );
		end;
	end;
	PlayableStepsChangedMessageCommand=function(self)
		local cur_song = GAMESTATE:GetCurrentSong();
		if not cur_song then
			self:visible(false);
			return;
		end;
		
		self:visible(true);
		local duration = self:GetChild("duration");
		local currentsurvivalseconds = 0;
		local highestsurvivalseconds = 0;
		local formattedtime = "";
		local aSteps = SCREENMAN:GetTopScreen():GetPlayableSteps();
		local numSteps = #aSteps;
		for i=1,numSteps do
			local HighScoresList = PROFILEMAN:GetMachineProfile():GetHighScoreListIfExists(cur_song,aSteps[i]);
			if HighScoresList ~= nil then
				local HighScores = HighScoresList:GetHighScores();
				if HighScores ~= nil then
					local BestScore = HighScores[1];
					if BestScore ~= nil then
						currentsurvivalseconds = BestScore:GetSurvivalSeconds();
						if currentsurvivalseconds ~= nil and currentsurvivalseconds > highestsurvivalseconds then
							highestsurvivalseconds = currentsurvivalseconds;
						end;
					end;
				end;
			end;
		end;
		if highestsurvivalseconds > 0 then formattedtime = FormatTime(highestsurvivalseconds) end;
		local group = SCREENMAN:GetTopScreen():GetCurrentGroup();
		if( group == "SO_RANDOM" ) then
			duration:settext( "??:??" );
		else
			duration:settext( formattedtime );
		end;
	end;
	children = {
		LoadFont("_karnivore lite white")..{
			Name="duration";
			InitCommand=cmd(stoptweening;horizalign,right;y,66;x,148;zoom,.66;shadowlength,0;settext,"";diffuse,0,1,1,1;maxwidth,180);
		};
		--LoadFont("_karnivore lite Bold white")..{
		LoadFont("_karnivore lite white")..{
			Name="bpm_text";
			InitCommand=cmd(stoptweening;horizalign,right;y,80;x,0;zoom,.4;shadowlength,0;settext,"BPM";diffuse,0,1,1,1);
		};
		--LoadFont("_karnivore lite Bold white")..{
		LoadFont("_karnivore lite white")..{
			Name="bpm_number";
			InitCommand=cmd(stoptweening;horizalign,right;y,78;x,148;zoom,.66;shadowlength,0;settext,"";diffuse,0,1,1,1;maxwidth,180);
		};
		--artist
		LoadFont("_myriad pro 20px")..{
			Name="artist";
			InitCommand=cmd(stoptweening;horizalign,left;y,79;x,-148;zoom,.6;shadowlength,0;diffuse,0,1,1,1;maxwidth,403);
		};
		--song title
		LoadFont("_myriad pro 20px")..{
			Name="title";
			InitCommand=cmd(stoptweening;horizalign,left;y,65;x,-148;zoom,.6;shadowlength,0;maxwidth,423);
		};
	};
}

return t