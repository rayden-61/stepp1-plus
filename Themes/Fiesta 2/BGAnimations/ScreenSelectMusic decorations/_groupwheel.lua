local t = Def.ActorFrame {
	OnCommand=cmd(fov,62;zbuffer,true;vanishpoint,cx,cy);
}

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- esto ayuda al movimento de la wheel cuando la cantidad de grupos disponibles es menor que 7
local bUseLocalIndex = false;
-- usado para el indice mostrado en la selección de grupos
local iRealNumGroups = 0;

-- Regresa la cantidad de grupos, para q sea mayor o igual a 7
local function GetAllGroups()
	local temp = SONGMAN:GetSongGroupNamesAvailables();
	iRealNumGroups = #temp;
	
	if( #temp < 7 ) then
		bUseLocalIndex = true;
	end;
		
	local lengh = #temp;
	local vector = {};
	for i=1,lengh do
		vector[i]= temp[i];	--nombre
	end;
	
	while #vector < 7 do
		local templengh = #vector;
		for i=1,(#temp) do
			vector[i+templengh] = temp[i];
		end;
	end;
	
	return vector;
end;

local AllGroups = GetAllGroups();
local NumGroups = #AllGroups;

--Como máximo, el vector de AllGroups() debe tener 7 lugares
local function GetBanners(curGroup)
	local toReturn = {};
	
	if curGroup == 4 then
		toReturn = { NumGroups , 1 , 2 , 3 , 4 , 5 , 6,  7,  8 };
	elseif curGroup == 3 then
		toReturn = { NumGroups-1, NumGroups , 1 , 2 , 3 , 4 , 5 , 6,  7 };
	elseif curGroup == 2 then
		toReturn = { NumGroups-2, NumGroups-1 , NumGroups , 1 , 2 , 3 , 4 , 5, 6 };
	elseif curGroup == 1 then
		toReturn = { NumGroups-3, NumGroups-2 , NumGroups-1 , NumGroups , 1 , 2 , 3 , 4, 5 };
	elseif curGroup == NumGroups then
		toReturn = { NumGroups-4, NumGroups-3 , NumGroups-2 , NumGroups-1 , NumGroups , 1 , 2 , 3, 4 };
	elseif curGroup == (NumGroups - 1) then
		toReturn = { NumGroups-5 , NumGroups-4 , NumGroups-3 , NumGroups-2 , NumGroups-1 , NumGroups , 1 , 2, 3 };
	elseif curGroup == (NumGroups - 2) then
		toReturn = { NumGroups-6 , NumGroups-5 , NumGroups-4 , NumGroups-3 , NumGroups-2 , NumGroups-1 , NumGroups , 1, 2 };
	elseif curGroup == (NumGroups - 3) then
		toReturn = { NumGroups-7 , NumGroups-6 , NumGroups-5 , NumGroups-4 , NumGroups-3 , NumGroups-2 , NumGroups-1 , NumGroups, 1 };
	else
		toReturn = { curGroup-4 , curGroup-3 , curGroup-2 , curGroup-1 , curGroup , curGroup+1, curGroup+2 , curGroup+3, curGroup+4 };
	end;
	
	return toReturn;
end;

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Posiciones iniciales
local InitPos = {
	(cmd(x,-420;rotationy,-90;zoom,.8;diffusealpha,0)),
	(cmd(x,-328;rotationy,-90;zoom,.8;diffusealpha,.2)),
	(cmd(x,-252;rotationy,-92;zoom,.8;diffusealpha,.4)),
	(cmd(x,-186;rotationy,-92;zoom,.8;diffusealpha,.6)),
	(cmd(x,0;z,0;zoom,1;rotationy,0;diffusealpha,1)),--center
	(cmd(x,186;rotationy,92;zoom,.8;diffusealpha,.6)),
	(cmd(x,252;rotationy,92;zoom,.8;diffusealpha,.4)),
	(cmd(x,328;rotationy,90;zoom,.8;diffusealpha,.2)),
	(cmd(x,420;rotationy,90;zoom,.8;diffusealpha,0)),
};

-- Posiciones de comienzo
local StartPos = {
	(cmd(diffusealpha,0;sleep,.2;linear,.1;diffusealpha,0;zoom,1)),
	(cmd(diffusealpha,0;sleep,.2;linear,.1;diffusealpha,.4;zoom,1;linear,.05;zoom,.9;linear,.05;zoom,1)),
	(cmd(diffusealpha,0;sleep,.2;linear,.1;diffusealpha,.6;zoom,1;linear,.05;zoom,.9;linear,.05;zoom,1)),
	(cmd(diffusealpha,0;sleep,.1;linear,.05;diffusealpha,1;zoom,1;sleep,.15;linear,.05;zoom,.95;linear,.05;zoom,1)),--center
	(cmd(diffusealpha,0;sleep,.2;linear,.1;diffusealpha,.6;zoom,1;linear,.05;zoom,.9;linear,.05;zoom,1)),
	(cmd(diffusealpha,0;sleep,.2;linear,.1;diffusealpha,.4;zoom,1;linear,.05;zoom,.9;linear,.05;zoom,1)),
	(cmd(diffusealpha,0;sleep,.2;linear,.1;diffusealpha,0;zoom,1)),
};

-- Posiciones de salida
local OutPos = {
	(cmd(diffusealpha,.7;sleep,.05;linear,.24;diffusealpha,0)),
	(cmd(diffusealpha,1;sleep,.29;linear,.01;diffusealpha,0)),--center
};


--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Funciones e Indice de grupo
local CurrentGroupNumber = -1;
local Banners = {};

-- Para cambiar el indice
local a = Def.ActorFrame {
	InitCommand=cmd(x,cx;y,cy-17);
	GoBackSelectingGroupMessageCommand=function(self)
		--(cmd(stoptweening;x,-20;sleep,.1;linear,.2;x,cx))(self);
		local index = SCREENMAN:GetTopScreen():GetCurrentGroupIndex();
		if (CurrentGroupNumber ~= index) then
			CurrentGroupNumber = index;
			Banners = GetBanners( CurrentGroupNumber );
			self:playcommand("RefreshPositions");
		end;
		self:playcommand("OpenPositions");
	end;
	--StartSelectingSongMessageCommand=cmd(stoptweening;x,cx;linear,.3;x,-150);
	ChangeGroupMessageCommand=function(self,params)
		if not bUseLocalIndex then
			CurrentGroupNumber = SCREENMAN:GetTopScreen():GetCurrentGroupIndex();
		else
			CurrentGroupNumber = CurrentGroupNumber + params.Dir;
			
			if( CurrentGroupNumber <= 0 ) then
				CurrentGroupNumber = NumGroups;
			elseif ( CurrentGroupNumber > NumGroups ) then
				CurrentGroupNumber = 1;
			end;
		end;
		Banners = GetBanners( CurrentGroupNumber );
		--self:playcommand("Move");
		MESSAGEMAN:Broadcast("Move",{ ["Dir"] = params.Dir }); --cambio para el ActorFrame "b"
	end;
}

a[#a+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/groupwheel_br") )..{
	InitCommand=cmd(blend,'BlendMode_Add';z,-160;y,-4;basezoom,.66;zoom,1.25;diffusealpha,0);
	StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,1;linear,.2;diffusealpha,0;zoom,1.5);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,0;zoom,1.25;sleep,.2;linear,.2;diffusealpha,1;queuecommand,'Loop');
	LoopCommand=cmd(stoptweening;diffusealpha,1;rotationx,0;linear,.4;diffusealpha,.6;linear,.4;diffusealpha,1;queuecommand,'Loop');
	MoveMessageCommand=cmd(finishtweening;diffusealpha,1;rotationx,0;linear,.2;rotationx,180;queuecommand,'Loop')
};

for i=1,#AllGroups do
	local path = ChannelsSoundsFiles[AllGroups[i]];
	if( path ) then
		a[#a+1] = Def.Sound {
			BeginCommand=function(self)
				local path = ChannelsSoundsFiles[AllGroups[i]];
				if path ~= "" then
					self:load(path);
				--	self.pos = i;
				end;
			end;
			GoBackSelectingGroupMessageCommand=cmd(stoptweening;sleep,.1;queuecommand,'Play');
			MoveMessageCommand=cmd(stoptweening;stop;sleep,.5;queuecommand,'Play');
			TimerOutSelectingSongCommand=cmd(stoptweening;stop);
			OffCommand=cmd(stoptweening;stop);
			PlayCommand=function(self)
				if i == SCREENMAN:GetTopScreen():GetCurrentGroupIndex() then
					self:play();
				end;
			end;
			StartSelectingSongMessageCommand=function(self)
				local index = SCREENMAN:GetTopScreen():GetCurrentGroupIndex();
				local group = AllGroups[index];
				if( group == "06-PRO~PRO2" or group == "07-INFINITY" or group == "05-JUMP" or group == "19-STEPF2" ) then
					self:stoptweening();
					self:stop();
				end;
			end;
		}
	end;
end;

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Banners XD
for i=1,NumGroups do 
a[#a+1] = Def.Sprite {
	BeginCommand = function(self)
		(cmd(stoptweening;diffusealpha,0;zbuffer,true))(self);
		local gname = AllGroups[i];
		--self:scaletoclipped(340,340);
		self:scaletoclipped(226,226);
		local dir = ChannelsGraphics[gname];
		local scale = ChannelsToScale[gname];
		if( dir ~= nil or scale ~= nil ) then
			self:scaletoclipped(340,340);
			
			--if string.find( dir, "C_LV_" ) then
				--self:scaletoclipped(460,460);
			--elseif gname == "SO_JMUSIC" then
			--	self:scaletoclipped(350,350);
			--end;
			if dir ~= nil then
				self:Load(THEME:GetPathG("","/ChannelsGraphics/"..dir));
				return;
			end;
		end;
		if i then
			if SONGMAN:GetSongGroupBannerPath(gname) == "" then
				self:scaletoclipped(340,340);
				self:Load(THEME:GetPathG("","/ChannelsGraphics/C_NO_BANNER.PNG"));
			else
				self:Load(SONGMAN:GetSongGroupBannerPath(gname));	-- se generan los actores
			end;
		end;
	end;
	RefreshPositionsCommand = function(self)
		self:stoptweening(); 
		if 	    i==Banners[1] then (InitPos[1])(self);
		elseif 	i==Banners[2] then (InitPos[2])(self);
		elseif 	i==Banners[3] then (InitPos[3])(self);
		elseif 	i==Banners[4] then (InitPos[4])(self);
		elseif 	i==Banners[5] then (InitPos[5])(self); --center
		elseif 	i==Banners[6] then (InitPos[6])(self);
		elseif 	i==Banners[7] then (InitPos[7])(self);
		elseif 	i==Banners[8] then (InitPos[8])(self);
		elseif 	i==Banners[9] then (InitPos[9])(self);
		else (cmd(stoptweening;diffusealpha,0))(self);
		end;
		self:diffusealpha(1);
	end;
	MoveMessageCommand=function(self,params)
		self:finishtweening(); --detiene todas las animaciones
		if 	    i==Banners[1] then if params.Dir == 1 then self:linear(.2); end; (InitPos[1])(self);
		elseif 	i==Banners[2] then self:linear(.2);(InitPos[2])(self);
		elseif 	i==Banners[3] then self:linear(.2);(InitPos[3])(self);
		elseif 	i==Banners[4] then self:linear(.2);(InitPos[4])(self);
		elseif 	i==Banners[5] then self:linear(.2);(InitPos[5])(self); --center
		elseif 	i==Banners[6] then self:linear(.2);(InitPos[6])(self);
		elseif 	i==Banners[7] then self:linear(.2);(InitPos[7])(self);
		elseif 	i==Banners[8] then self:linear(.2);(InitPos[8])(self);
		elseif 	i==Banners[9] then if params.Dir == -1 then self:linear(.2); end; (InitPos[9])(self);
		else (cmd(stoptweening;diffusealpha,0))(self);
		end;
	end;
	StartSelectingSongMessageCommand=function(self,params)
		self:finishtweening();	
		if 	    i==Banners[1] then (InitPos[1])(self);
		elseif 	i==Banners[2] then (InitPos[2])(self);self:sleep(.0);self:linear(.15);self:x(-550);self:sleep(0);self:diffusealpha(0);
		elseif 	i==Banners[3] then (InitPos[3])(self);self:sleep(.1);self:linear(.15);self:x(-550);self:sleep(0);self:diffusealpha(0);
		elseif 	i==Banners[4] then (InitPos[4])(self);self:sleep(.2);self:linear(.15);self:x(-550);self:sleep(0);self:diffusealpha(0);
		elseif 	i==Banners[5] then (InitPos[5])(self);self:sleep(.25);self:linear(.1);self:zoom(0);self:sleep(0);self:diffusealpha(0); --center
		elseif 	i==Banners[6] then (InitPos[6])(self);self:sleep(.2);self:linear(.15);self:x(550);self:sleep(0);self:diffusealpha(0);
		elseif 	i==Banners[7] then (InitPos[7])(self);self:sleep(.1);self:linear(.15);self:x(550);self:sleep(0);self:diffusealpha(0);
		elseif 	i==Banners[8] then (InitPos[8])(self);self:sleep(.0);self:linear(.15);self:x(550);self:sleep(0);self:diffusealpha(0);
		elseif 	i==Banners[9] then (InitPos[9])(self);
		else (cmd(stoptweening;diffusealpha,0))(self);
		end;
	end;
	OpenPositionsCommand=function(self)	--comienza la seleccion de grupos
		self:stoptweening();
		if 	    i==Banners[1] then (InitPos[1])(self);self:diffusealpha(0);self:x(-550);self:linear(.4);(InitPos[1])(self);
		elseif 	i==Banners[2] then (InitPos[2])(self);self:diffusealpha(1);self:x(-550);self:sleep(.3);self:linear(.15);(InitPos[2])(self);
		elseif 	i==Banners[3] then (InitPos[3])(self);self:diffusealpha(1);self:x(-550);self:sleep(.2);self:linear(.15);(InitPos[3])(self);
		elseif 	i==Banners[4] then (InitPos[4])(self);self:diffusealpha(1);self:x(-550);self:sleep(.1);self:linear(.15);(InitPos[4])(self);
		elseif 	i==Banners[5] then (InitPos[5])(self);self:zoom(0);self:linear(.15);(InitPos[5])(self); --center
		elseif 	i==Banners[6] then (InitPos[6])(self);self:diffusealpha(1);self:x(550);self:sleep(.1);self:linear(.15);(InitPos[6])(self);
		elseif 	i==Banners[7] then (InitPos[7])(self);self:diffusealpha(1);self:x(550);self:sleep(.2);self:linear(.15);(InitPos[7])(self);
		elseif 	i==Banners[8] then (InitPos[8])(self);self:diffusealpha(1);self:x(550);self:sleep(.3);self:linear(.15);(InitPos[8])(self);
		elseif 	i==Banners[9] then (InitPos[9])(self);self:diffusealpha(0);self:x(550);self:linear(.4);(InitPos[9])(self);
		else (cmd(stoptweening;diffusealpha,0))(self);
		end;
	end;
	OffCommand=cmd(stoptweening;Load,nil);
}
end;

t[#t+1] = a;

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

local lang = GetLanguageText();

-- Descripciones
t[#t+1] = LoadFont("_myriad pro blue Bold")..{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-100;zoom,.54;settext,'';vertalign,'VertAlign_Top');
	MoveMessageCommand=function(self,params)
		self:settext('');
		local gname = AllGroups[CurrentGroupNumber];
		local desc = Descriptions[lang][gname];
		
		if( desc == nil ) then 
			if lang == "es" then
				self:settext("En este canal, puedes jugar canciones del\npack personalizado '"..string.upper(RenameGroup(gname)).."'.");
			else
				self:settext("In this channel, you can play songs of\nthe custom pack '"..string.upper(RenameGroup(gname)).."'.");
			end;
		else
			self:settext( desc );
		end;
		(cmd(stoptweening;zoom,.54;zoomy,.6;shadowlength,0;diffusealpha,0;sleep,.25;linear,.2;diffusealpha,1))(self);--;
	end;
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;sleep,.2;queuecommand,'Move');
	StartSelectingSongMessageCommand=cmd(stoptweening;settext,'');
	OffCommand=cmd(stoptweening;settext,'');
}

-- Arrow izquierdo
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/_arrow_to_left.png") )..{
	InitCommand=cmd(blend,'BlendMode_Add';y,cy-12;x,cx-125;basezoom,.40;diffusealpha,0;z,200);
	GoBackSelectingGroupMessageCommand=cmd(finishtweening;zoom,0;linear,.15;zoom,1;x,cx-125;diffusealpha,1;linear,.1;diffusealpha,1;queuecommand,'Loop');
	StartSelectingSongMessageCommand=cmd(finishtweening;zoom,1;linear,.15;zoom,0;queuecommand,'Loop');
	NextGroupMessageCommand=cmd(finishtweening;linear,.02;x,cx-125;sleep,.18;queuecommand,'Loop');
	PrevGroupMessageCommand=cmd(finishtweening;linear,.02;x,cx-125;linear,.15;x,cx-132;linear,.08;x,cx-125;queuecommand,'Loop');
	LoopCommand=cmd(finishtweening;x,cx-125;linear,.45;x,cx-130;linear,.45;x,cx-125;queuecommand,'Loop');
};

-- Arrow derecho
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/_arrow_to_left.png") )..{
	InitCommand=cmd(blend,'BlendMode_Add';y,cy-12;x,cx+125;basezoom,.40;rotationz,180;diffusealpha,0;z,200);
	GoBackSelectingGroupMessageCommand=cmd(finishtweening;zoom,0;linear,.15;zoom,1;x,cx+125;diffusealpha,1;linear,.1;diffusealpha,1;queuecommand,'Loop');
	StartSelectingSongMessageCommand=cmd(finishtweening;zoom,1;linear,.15;zoom,0;queuecommand,'Loop');
	NextGroupMessageCommand=cmd(finishtweening;linear,.02;x,cx+125;linear,.15;x,cx+132;linear,.08;x,cx+125;queuecommand,'Loop');
	PrevGroupMessageCommand=cmd(finishtweening;linear,.02;x,cx+125;sleep,.18;queuecommand,'Loop');
	LoopCommand=cmd(finishtweening;x,cx+125;linear,.45;x,cx+130;linear,.45;x,cx+125;queuecommand,'Loop');
};

-- Indice
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,cx;y,cy+102;diffusealpha,0);
	MoveMessageCommand=function(self)
		local index = SCREENMAN:GetTopScreen():GetCurrentGroupIndex();
		local numitems = iRealNumGroups;
		local total_d3 = self:GetChild("TOTAL_D3");
		local total_d2 = self:GetChild("TOTAL_D2");
		local total_d1 = self:GetChild("TOTAL_D1");
		local curindex_d3 = self:GetChild("CURINDEX_D3");
		local curindex_d2 = self:GetChild("CURINDEX_D2");
		local curindex_d1 = self:GetChild("CURINDEX_D1");
		if numitems < 999 then
			local total_centenas = math.floor((numitems)/100)*100;
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
			local curindex_centenas = math.floor((index)/100)*100;
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
	StartSelectingSongMessageCommand=cmd(finishtweening;diffusealpha,1;y,cy+102;linear,.25;y,cy+160;diffusealpha,0);
	GoBackSelectingGroupMessageCommand=cmd(playcommand,'Move';finishtweening;diffusealpha,0;y,cy+160;linear,.25;y,cy+102;diffusealpha,1);
	children = {
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_counter_channels_bg") )..{
			InitCommand=cmd(y,2;basezoom,0.67);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/SongIndexNumber 10x1") )..{
			Name="TOTAL_D3";
			InitCommand=cmd(pause;x,10;basezoom,.70);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/SongIndexNumber 10x1") )..{
			Name="TOTAL_D2";
			InitCommand=cmd(pause;x,18;basezoom,.70);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/SongIndexNumber 10x1") )..{
			Name="TOTAL_D1";
			InitCommand=cmd(pause;x,26;basezoom,.70);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/SongIndexNumber 10x1") )..{
			Name="CURINDEX_D3";
			InitCommand=cmd(pause;x,-26;basezoom,.70);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/SongIndexNumber 10x1") )..{
			Name="CURINDEX_D2";
			InitCommand=cmd(pause;x,-18;basezoom,.70);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/SongIndexNumber 10x1") )..{
			Name="CURINDEX_D1";
			InitCommand=cmd(pause;x,-10;basezoom,.70);
		};
	};
}

-- Cursor
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,cx;y,cy+126;diffusealpha,0);
	MoveMessageCommand=function(self)
		local index = SCREENMAN:GetTopScreen():GetCurrentGroupIndex();
		local numitems = iRealNumGroups;
	
		local ball = self:GetChild("BALL");
		ball:x( -155 + 310*((index-1)/numitems) );
	end;
	StartSelectingSongMessageCommand=cmd(finishtweening;diffusealpha,0);
	GoBackSelectingGroupMessageCommand=cmd(playcommand,'Move';finishtweening;diffusealpha,0;sleep,.4;diffusealpha,1);
	children = {
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_cursor_line") )..{
			InitCommand=cmd(basezoom,0.67);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_cursor_ball") )..{
			Name="BALL";
			InitCommand=cmd(x,-155;basezoom,0.67);
		};
	};
}

return t;