--///////////////////////////////////////////////////////////////////////////////////////////////////
-- LISTA LOS ARCHIVOS DE SONIDO DE LOS CANALES
ChannelsSoundsFiles = {};

local SortsSounds = {
	{"SO_ALLTUNES", 	"01_ALL_TUNES.MP3"};
	{"SO_FULLSONGS", 	"03_FULLSONGS.MP3"};
	{"SO_REMIX", 		"04_REMIX.MP3"};
	{"SO_SHORTCUT", 	"05_SHORTCUT.MP3"};
	{"SO_ORIGINAL", 	"02_ORIGINAL_TUNES.MP3"};
	{"SO_KPOP", 		"03_K-POP.MP3"};
	{"SO_WORLDMUSIC", 	"04_WORLD_MUSIC.MP3"};
	{"SO_UCS", 			"06_UCS.MP3"};
	{"SO_QUEST", 		"08_QUEST_ZONE.MP3"};
	{"SO_COOP", 		"43_COOP_PLAY.MP3"};
	{"SO_RANDOM", 	"02_RANDOM.MP3"};
	{"SO_JMUSIC", 	"18_J-MUSIC.MP3"};
	{"SO_LEVEL_1", 	"19_LEVEL1.MP3"};
	{"SO_LEVEL_2", 	"20_LEVEL2.MP3"};
	{"SO_LEVEL_3", 	"21_LEVEL3.MP3"};
	{"SO_LEVEL_4", 	"22_LEVEL4.MP3"};
	{"SO_LEVEL_5", 	"23_LEVEL5.MP3"};
	{"SO_LEVEL_6", 	"24_LEVEL6.MP3"};
	{"SO_LEVEL_7", 	"25_LEVEL7.MP3"};
	{"SO_LEVEL_8", 	"26_LEVEL8.MP3"};
	{"SO_LEVEL_9", 	"27_LEVEL9.MP3"};
	{"SO_LEVEL_10", "28_LEVEL10.MP3"};
	{"SO_LEVEL_11", "29_LEVEL11.MP3"};
	{"SO_LEVEL_12", "30_LEVEL12.MP3"};
	{"SO_LEVEL_13", "31_LEVEL13.MP3"};
	{"SO_LEVEL_14", "32_LEVEL14.MP3"};
	{"SO_LEVEL_15", "33_LEVEL15.MP3"};
	{"SO_LEVEL_16", "34_LEVEL16.MP3"};
	{"SO_LEVEL_17", "35_LEVEL17.MP3"};
	{"SO_LEVEL_18", "36_LEVEL18.MP3"};
	{"SO_LEVEL_19", "37_LEVEL19.MP3"};
	{"SO_LEVEL_20", "38_LEVEL20.MP3"};
	{"SO_LEVEL_21", "39_LEVEL21.MP3"};
	{"SO_LEVEL_22", "40_LEVEL22.MP3"};
	{"SO_LEVEL_23", "41_LEVEL23.MP3"};
	{"SO_LEVEL_24", "42_LEVEL24OVER.MP3"}
	--{"FAVORITES", "19_FAVORITES.WAV"}
}

ChannelsToScale = {
	["04-SKILLUP ZONE"] = 	true;
	["05-JUMP"] = 			true;
	["06-PRO~PRO2"] = 		true;
	["07-INFINITY"] = 		true;
	["08-1ST~3RD"] = 		true;
	["08-1ST~PERF"] = 		true;
	["09-S.E.~EXTRA"] = 	true;
	["09-EXTRA~PREX3"] = 	true;
	["10-REBIRTH~PREX 3"] = true;
	["11-EXCEED~ZERO"] = 	true;
	["12-NX-NX2"] = 		true;
	["12-NX-NXA"] = 		true;
	["13-NX ABSOLUTE"] = 	true;
	["14-FIESTA"] = 		true;
	["15-FIESTA EX"] = 		true;
	["16-FIESTA 2"] = 		true;
	["17-PRIME"] = 			true;
	["19-STEPF2"] =			true;
}

local ChannelsSounds = {
	["04-SKILLUP ZONE"] = 	"08_SKILL_UP_ZONE.MP3";
	--["05-JUMP"] = 			"07_JUMP.ogg";
	--["06-PRO~PRO2"] = 		"06_PRO.ogg";
	--["07-INFINITY"] = 		"07_INFINITY.ogg";
	["08-1ST~3RD"] = 		"11_1ST_TO_3RD.MP3";
	["08-1ST~PERF"] = 		"09_FIRST_TO_COLLECTION.MP3";
	["09-S.E.~EXTRA"] = 	"12_SE_TO_EXTRA.MP3";
	["09-EXTRA~PREX3"] = 	"10_EXTRA_TO_PREX3.MP3";
	["10-REBIRTH~PREX 3"] = "13_REBIRTH_TO_PREX3.MP3";
	["11-EXCEED~ZERO"] = 	"14_EXCEED_TO_ZERO.MP3";
	["12-NX-NX2"] = 		"15_NX&NX2.MP3";
	["12-NX-NXA"] = 		"12_NX_TO_NXA.MP3";
	["13-NX ABSOLUTE"] = 	"16_NXA.MP3";
	["14-FIESTA"] = 		"13_FIESTA.MP3";
	["15-FIESTA EX"] = 		"14_FIESTA_EX.MP3";
	["16-FIESTA 2"] = 		"16_FIESTA_2.MP3";
	["17-PRIME"] = 			"17_PRIME.MP3";
	--["19-STEPF2"] =			"19_STEPF2.MP3";
	--["17-U.C. STEP"] = "06_UCS.WAV";
}

local function GetChannelSoundDir( name )
	local fir = "Songs/"..name.."/info/";
	local ogg = fir..'sound.ogg';
	local mp3 = fir..'sound.mp3';
	local wav = fir..'sound.wav';

	if (FILEMAN:DoesFileExist(ogg)) then return ogg;
	elseif (FILEMAN:DoesFileExist(mp3)) then return mp3;
	elseif (FILEMAN:DoesFileExist(wav)) then return wav;
	else return ""; end;
	
end;

function LoadChannelsSounds()
	local AllGroups = SONGMAN:GetSongGroupNames();
	
	for i=1,#SortsSounds do
		local sortc = SortsSounds[i][1];
		ChannelsSoundsFiles[tostring(sortc)] = "Themes/Fiesta 2/Sounds/ChannelsSounds/"..SortsSounds[i][2];
	end;
	
	for i=1,#AllGroups do
		local cur_group = AllGroups[i];
		local sound = ChannelsSounds[cur_group];
		local dir = "";
		if( sound ) then
			dir = "Themes/Fiesta 2/Sounds/ChannelsSounds/"..sound;
		else
			dir = GetChannelSoundDir( cur_group );
		end;
		
		if( dir ~= "" )then
			ChannelsSoundsFiles[tostring(cur_group)] = tostring(dir);
		end;
	end;
end;

--///////////////////////////////////////////////////////////////////////////////////////////////////
-- LISTA DE GRAFICOS DE LOS CANALES AUTOMATICOS
ChannelsGraphics = {
	["SO_ALLTUNES"] = 	"C_ATUNES.PNG";
	["SO_RANDOM"] = 	"C_RD.PNG";
	["SO_FULLSONGS"] = 	"C_FSONG.PNG";
	["SO_REMIX"] = 		"C_RMX.PNG",
	["SO_SHORTCUT"] = 	"C_SC.PNG";
	["SO_ORIGINAL"] = 	"C_OT.PNG";
	["SO_KPOP"] = 		"C_KP.PNG";
	["SO_WORLDMUSIC"] = "C_WM.PNG";
	["SO_UCS"] = 		"C_UCS.PNG";
	["SO_QUEST"] = 		"C_MZ.PNG";
	["SO_COOP"] = 		"C_COOP.PNG";
	["SO_LEVEL_1"] = "C_LV_01.PNG";
	["SO_LEVEL_2"] = "C_LV_02.PNG";
	["SO_LEVEL_3"] = "C_LV_03.PNG";
	["SO_LEVEL_4"] = "C_LV_04.PNG";
	["SO_LEVEL_5"] = "C_LV_05.PNG";
	["SO_LEVEL_6"] = "C_LV_06.PNG";
	["SO_LEVEL_7"] = "C_LV_07.PNG";
	["SO_LEVEL_8"] = "C_LV_08.PNG";
	["SO_LEVEL_9"] = "C_LV_09.PNG";
	["SO_LEVEL_10"] = "C_LV_10.PNG";
	["SO_LEVEL_11"] = "C_LV_11.PNG";
	["SO_LEVEL_12"] = "C_LV_12.PNG";
	["SO_LEVEL_13"] = "C_LV_13.PNG";
	["SO_LEVEL_14"] = "C_LV_14.PNG";
	["SO_LEVEL_15"] = "C_LV_15.PNG";
	["SO_LEVEL_16"] = "C_LV_16.PNG";
	["SO_LEVEL_17"] = "C_LV_17.PNG";
	["SO_LEVEL_18"] = "C_LV_18.PNG";
	["SO_LEVEL_19"] = "C_LV_19.PNG";
	["SO_LEVEL_20"] = "C_LV_20.PNG";
	["SO_LEVEL_21"] = "C_LV_21.PNG";
	["SO_LEVEL_22"] = "C_LV_22.PNG";
	["SO_LEVEL_23"] = "C_LV_23.PNG";
	["SO_LEVEL_24"] = "C_LV_24O.PNG";
	["SO_JMUSIC"] = "C_JM.PNG";
--[[	
	["04-SKILLUP ZONE"] = 	"C_SU.PNG";
	["08-1ST~3RD"] = 		"C_LOGO1.PNG";
	["09-S.E.~EXTRA"] = 	"C_LOGO2.PNG";
	["10-REBIRTH~PREX 3"] = "C_LOGO3.PNG";
	["11-EXCEED~ZERO"] = 	"C_LOGO4.PNG";
	["12-NX-NX2"] = 		"C_LOGO5.PNG";
	["13-NX ABSOLUTE"] = 	"C_NXA.PNG";
	["14-FIESTA"] = 		"C_FIESTA.PNG";
	["15-FIESTA EX"] = 		"C_FIESTAEX.PNG";
	["16-FIESTA 2"] = 		"C_FIESTA2.PNG";
	["17-PRIME"] = 			"C_PR.PNG";
]]--	
	--["FAVORITES"] = "C_FVR.PNG";
}

--///////////////////////////////////////////////////////////////////////////////////////////////////
-- LISTA DE DESCRIPCIONES DE LOS CANALES
-- [left, top, right, bot]

local ChannelsTextCoordSpanish = {
	["SO_ALLTUNES"] = 		 "En este canal, puedes jugar todas las canciones estándar." ;
	["SO_ORIGINAL"] = 		 "En este canal, puedes jugar una variedad de las canciones\noriginales de PIU." ;
	["SO_KPOP"] =			 "En este canal, puedes jugar una variedad de canciones de K-POP." ;
	["SO_WORLDMUSIC"] = 	 "En este canal, puedes jugar una\nvariedad de canciones de todo el mundo." ;
	["SO_UCS"] = 			 "En este canal, puedes jugar tus steps personalizados." ;
	["SO_QUEST"] = 			 "En este canal, puedes jugar una recopilación de misiones." ;
	["SO_COOP"] = 			 "En este canal, puedes jugar canciones que requieren\nun juego cooperativo de dos o más jugadores." ;
	["SO_RANDOM"] = 		 "En este canal, puedes jugar una canción seleccionada\nal azar en una dificultad especifica." ;
	["SO_FULLSONGS"] = 		 "En este canal, puedes jugar canciones originales sin modificación." ;
	["SO_REMIX"] = 			 "En este canal, puedes jugar canciones mezcladas." ;
	["SO_SHORTCUT"] = 		 "En este canal, puedes jugar canciones que han sido\neditadas a un minuto de duración." ;
	["04-SKILLUP ZONE"] = 	 "En este canal, puedes jugar canciones para mejorar\ntus habilidades de baile." ;
	["05-JUMP"] =     		 "En este canal, puedes jugar las canciones de las versión JUMP." ;
	["06-PRO~PRO2"] = 		 "En este canal, puedes jugar las canciones típicas de las versiones\nPRO y PRO2." ; 
	["07-INFINITY"] = 		 "En este canal, puedes jugar las canciones de las versión INFINITY." ;
	["08-1ST~3RD"] = 		 "En este canal, puedes jugar las canciones típicas de las versiones\n1st hasta 3rd." ;
	["08-1ST~PERF"] = 		 "En este canal, puedes jugar las canciones típicas de las versiones\n1st hasta Perfect Collection." ;
	["09-S.E.~EXTRA"] = 	 "En este canal, puedes jugar las canciones típicas de las versiones\nSE hasta EXTRA." ;
	["09-EXTRA~PREX3"] = 	 "En este canal, puedes jugar las canciones típicas de las versiones\nEXTRA hasta PREX3." ;
	["10-REBIRTH~PREX 3"] =  "En este canal, puedes jugar las canciones típicas de las versiones\nREBIRTH hasta PREX3." ;
	["11-EXCEED~ZERO"] = 	 "En este canal, puedes jugar las canciones típicas de las versiones\nEXCEED hasta ZERO." ;
	["12-NX-NX2"] = 		 "En este canal, puedes jugar las canciones típicas de las versiones\nNX hasta NX2." ;
	["12-NX-NXA"] = 		 "En este canal, puedes jugar las canciones típicas de las versiones\nNX hasta NX Absolute." ;
	["13-NX ABSOLUTE"] = 	 "En este canal, puedes jugar las canciones de las versión NX Absolute." ;
	["14-FIESTA"] = 		 "En este canal, puedes jugar las canciones de las versión FIESTA." ;
	["15-FIESTA EX"] =	 	 "En este canal, puedes jugar las canciones de las versión FIESTA EX." ;
	["16-FIESTA 2"] = 		 "En este canal, puedes jugar las canciones de las versión FIESTA 2." ;
	["17-PRIME"] = 			 "En este canal, puedes jugar las canciones de las versión PRIME." ;
    ["18-PRIME 2"] = 	     "En este canal, puedes jugar las canciones de las versión PRIME 2." ;
    ["19-XX"] = 			 "En este canal, puedes jugar las canciones de las versión XX." ;
	["19-STEPF2"] =   		 "En este super canal, puedes jugar las canciones de STEPF2." ;
	["SO_LEVEL_1"] =  "En este canal, puedes jugar canciones de nivel 1." ;
	["SO_LEVEL_2"] =  "En este canal, puedes jugar canciones de nivel 2." ;
	["SO_LEVEL_3"] =  "En este canal, puedes jugar canciones de nivel 3." ;
	["SO_LEVEL_4"] =  "En este canal, puedes jugar canciones de nivel 4." ;
	["SO_LEVEL_5"] =  "En este canal, puedes jugar canciones de nivel 5." ;
	["SO_LEVEL_6"] =  "En este canal, puedes jugar canciones de nivel 6." ;
	["SO_LEVEL_7"] =  "En este canal, puedes jugar canciones de nivel 7." ;
	["SO_LEVEL_8"] =  "En este canal, puedes jugar canciones de nivel 8." ;
	["SO_LEVEL_9"] =  "En este canal, puedes jugar canciones de nivel 9." ;
	["SO_LEVEL_10"] =  "En este canal, puedes jugar canciones de nivel 10." ;
	["SO_LEVEL_11"] =  "En este canal, puedes jugar canciones de nivel 11." ;
	["SO_LEVEL_12"] =  "En este canal, puedes jugar canciones de nivel 12." ;
	["SO_LEVEL_13"] =  "En este canal, puedes jugar canciones de nivel 13." ;
	["SO_LEVEL_14"] =  "En este canal, puedes jugar canciones de nivel 14." ;
	["SO_LEVEL_15"] =  "En este canal, puedes jugar canciones de nivel 15." ;
	["SO_LEVEL_16"] =  "En este canal, puedes jugar canciones de nivel 16." ;
	["SO_LEVEL_17"] =  "En este canal, puedes jugar canciones de nivel 17." ;
	["SO_LEVEL_18"] =  "En este canal, puedes jugar canciones de nivel 18." ;
	["SO_LEVEL_19"] =  "En este canal, puedes jugar canciones de nivel 19." ;
	["SO_LEVEL_20"] =  "En este canal, puedes jugar canciones de nivel 20." ;
	["SO_LEVEL_21"] =  "En este canal, puedes jugar canciones de nivel 21." ;
	["SO_LEVEL_22"] =  "En este canal, puedes jugar canciones de nivel 22." ;
	["SO_LEVEL_23"] =  "En este canal, puedes jugar canciones de nivel 23." ;
	["SO_LEVEL_24"] =  "En este canal, puedes jugar canciones de nivel 24 o más." ;
	["SO_JMUSIC"] =  "En este canal, puedes jugar una variedad de canciones japonesas." ;
}

local ChannelsTextCoordEnglish = {
	["SO_ALLTUNES"] = 		 "In this channel, you can play all the standard songs." ;
	["SO_ORIGINAL"] = 		 "In this channel, you can play a variety of PIU original songs." ;
	["SO_KPOP"] =			 "In this channel, you can play a variety of K-POP songs." ;
	["SO_WORLDMUSIC"] = 	 "In this channel, you can play a variety of world music." ;
	["SO_UCS"] = 			 "In this channel, you can play your own steps." ;
	["SO_QUEST"] = 			 "In this special channel, you can the gathered Quests." ;
	["SO_COOP"] = 			 "In this channel, you can play song\nthat require co-op of two or more players." ;
	["SO_RANDOM"] = 		 "In this channel, you can play a certain song selected randomly\nwithin specific difficulties." ;
	["SO_FULLSONGS"] = 		 "In this channel, you can play the original songs that are not edited." ;
	["SO_REMIX"] = 			 "In this channel, you can play a various songs that are remixed." ;
	["SO_SHORTCUT"] = 		 "In this channel, you can play a various songs\nthat are edited around a 1 minute length." ;
	["04-SKILLUP ZONE"] = 	 "In this channel, you can play songs to improve you dancing skills." ;
	["05-JUMP"] =     		 "In this channel, there are typical songs of PIU JUMP ver." ;
	["06-PRO~PRO2"] = 		 "In this channel, there are typical songs\nof PIU PRO ver. and PIU PRO 2 ver." ; 
	["07-INFINITY"] = 		 "In this channel, there are typical songs of PIU INFINITY ver." ;
	["08-1ST~3RD"] = 		 "In this channel, there are typical songs\nfrom PIU 1st ver. to PIU 3rd ver." ;
	["08-1ST~PERF"] = 		 "In this channel, there are typical songs\nfrom PIU 1st ver. to PIU Perfect Collection ver." ;
	["09-S.E.~EXTRA"] = 	 "In this channel, there are typical songs\nfrom PIU SE ver. to PIU EXTRA ver." ;
	["09-EXTRA~PREX3"] = 	 "In this channel, there are typical songs\nfrom PIU EXTRA ver. to PIU Prex3 ver." ;
	["10-REBIRTH~PREX 3"] =  "In this channel, there are typical songs\nfrom PIU REBIRTH ver. to PIU Prex3 ver." ;
	["11-EXCEED~ZERO"] = 	 "In this channel, there are typical songs\nfrom PIU EXCEED ver. to PIU ZERO ver." ;
	["12-NX-NX2"] = 		 "In this channel, there are typical songs\nfrom PIU NX ver. to PIU NX2 ver." ;
	["12-NX-NXA"] = 		 "In this channel, there are typical songs\nfrom PIU NX ver. to PIU NXA ver." ;
	["13-NX ABSOLUTE"] = 	 "In this channel, there are typical songs of PIU NXA ver." ;
	["14-FIESTA"] = 		 "In this channel, there are typical songs of PIU FIESTA ver." ;
	["15-FIESTA EX"] =	 	 "In this channel, there are typical songs of\nPIU FIESTA EX ver." ;
	["16-FIESTA 2"] = 		 "In this channel, there are typical songs of PIU FIESTA 2 ver." ;
	["17-PRIME"] = 			 "In this channel, there are typical songs of PIU PRIME ver." ;
    ["18-PRIME 2"] = 		 "In this channel, there are typical songs of PIU PRIME 2 ver." ;
    ["19-XX"] = 			 "In this channel, there are typical songs of PIU XX ver." ;
	["19-STEPF2"] =   		 "In this super channel, there are typical songs of STEPF2 ver." ;
	["SO_LEVEL_1"] =  "In this channel, you can play level 1 difficulty songs." ;
	["SO_LEVEL_2"] =  "In this channel, you can play level 2 difficulty songs." ;
	["SO_LEVEL_3"] =  "In this channel, you can play level 3 difficulty songs." ;
	["SO_LEVEL_4"] =  "In this channel, you can play level 4 difficulty songs." ;
	["SO_LEVEL_5"] =  "In this channel, you can play level 5 difficulty songs." ;
	["SO_LEVEL_6"] =  "In this channel, you can play level 6 difficulty songs." ;
	["SO_LEVEL_7"] =  "In this channel, you can play level 7 difficulty songs." ;
	["SO_LEVEL_8"] =  "In this channel, you can play level 8 difficulty songs." ;
	["SO_LEVEL_9"] =  "In this channel, you can play level 9 difficulty songs." ;
	["SO_LEVEL_10"] =  "In this channel, you can play level 10 difficulty songs." ;
	["SO_LEVEL_11"] =  "In this channel, you can play level 11 difficulty songs." ;
	["SO_LEVEL_12"] =  "In this channel, you can play level 12 difficulty songs." ;
	["SO_LEVEL_13"] =  "In this channel, you can play level 13 difficulty songs." ;
	["SO_LEVEL_14"] =  "In this channel, you can play level 14 difficulty songs." ;
	["SO_LEVEL_15"] =  "In this channel, you can play level 15 difficulty songs." ;
	["SO_LEVEL_16"] =  "In this channel, you can play level 16 difficulty songs." ;
	["SO_LEVEL_17"] =  "In this channel, you can play level 17 difficulty songs." ;
	["SO_LEVEL_18"] =  "In this channel, you can play level 18 difficulty songs." ;
	["SO_LEVEL_19"] =  "In this channel, you can play level 19 difficulty songs." ;
	["SO_LEVEL_20"] =  "In this channel, you can play level 20 difficulty songs." ;
	["SO_LEVEL_21"] =  "In this channel, you can play level 21 difficulty songs." ;
	["SO_LEVEL_22"] =  "In this channel, you can play level 22 difficulty songs." ;
	["SO_LEVEL_23"] =  "In this channel, you can play level 23 difficulty songs." ;
	["SO_LEVEL_24"] =  "In this channel, you can play songs that are level 24 difficulty or higher." ;
	["SO_JMUSIC"] =  "In this channel, you can play a variety of Japanese musics." ;
}

Descriptions = {
	["es"] = ChannelsTextCoordSpanish;
	["en"] = ChannelsTextCoordEnglish;
}

--///////////////////////////////////////////////////////////////////////////////////////////////////
local numberss = { "1","2","3","4","5","6","7","8","9","0" };

function IsANumber( num )
	local toret = false;
	for i=1,#numberss do
		if num == numberss[i] then
			toret = true;
		end;
	end;
	return toret;
end;

function StringAt( str, i )
	return string.sub(str,i,i);
end;

local Renames = {
	["SO_ALLTUNES"] = 		"ALL TUNES";
	["SO_RANDOM"] = 		"RANDOM";
	["SO_ORIGINAL"] = 		"ORIGINAL";
	["SO_KPOP"] = 			"K-POP";
	["SO_WORLDMUSIC"] = 	"WORLD MUSIC";
	["SO_FULLSONGS"] = 		"FULL SONGS";
	["SO_REMIX"] = 			"REMIX",
	["SO_SHORTCUT"] = 		"SHORT CUT";
	["SO_UCS"] = 			"U.C. STEP";
	["SO_COOP"] = 			"CO-OP";
	["SO_QUEST"] = 			"MISSION ZONE";
	
	
	["04-SKILLUP ZONE"] = 	"SKILL UP ZONE";
	["05-JUMP"] = 			"JUMP";
	["06-PRO~PRO2"] = 		"PRO/PRO2";
	["08-1ST~3RD"] = 		"1ST~3RD";
	["08-1ST~PERF"] =		"1ST~PERF.";
	["09-EXTRA~PREX3"] = 	"EXTRA~PREX3";
	["09-S.E.~EXTRA"] = 	"S.E~EXTRA";
	["10-REBIRTH~PREX 3"] = "REBIRTH~PREX 3";
	["11-EXCEED~ZERO"] = 	"EXCEED~ZERO";
	["12-NX-NX2"] = 		"NX~NX2";
	["12-NX-NXA"] =			"NX~NXA";
	["13-NX ABSOLUTE"] = 	"NX ABSOLUTE";
	["14-FIESTA"] = 		"FIESTA";
	["15-FIESTA EX"] = 		"FIESTA EX";
	["16-FIESTA 2"] = 		"FIESTA 2";
	["17-PRIME"] = 			"PRIME";
	["19-STEPF2"] = 		"STEPF2";
	
	["SO_LEVEL_1"] = "LEVEL 1";
	["SO_LEVEL_2"] = "LEVEL 2";
	["SO_LEVEL_3"] = "LEVEL 3";
	["SO_LEVEL_4"] = "LEVEL 4";
	["SO_LEVEL_5"] = "LEVEL 5";
	["SO_LEVEL_6"] = "LEVEL 6";
	["SO_LEVEL_7"] = "LEVEL 7";
	["SO_LEVEL_8"] = "LEVEL 8";
	["SO_LEVEL_9"] = "LEVEL 9";
	["SO_LEVEL_10"] = "LEVEL 10";
	["SO_LEVEL_11"] = "LEVEL 11";
	["SO_LEVEL_12"] = "LEVEL 12";
	["SO_LEVEL_13"] = "LEVEL 13";
	["SO_LEVEL_14"] = "LEVEL 14";
	["SO_LEVEL_15"] = "LEVEL 15";
	["SO_LEVEL_16"] = "LEVEL 16";
	["SO_LEVEL_17"] = "LEVEL 17";
	["SO_LEVEL_18"] = "LEVEL 18";
	["SO_LEVEL_19"] = "LEVEL 19";
	["SO_LEVEL_20"] = "LEVEL 20";
	["SO_LEVEL_21"] = "LEVEL 21";
	["SO_LEVEL_22"] = "LEVEL 22";
	["SO_LEVEL_23"] = "LEVEL 23";
	["SO_LEVEL_24"] = "LEVEL 24~";
	
	["SO_JMUSIC"] = "J-MUSIC";
}

function RenameGroup( gName )
	local ReName = Renames[gName];
	if ( ReName ~= nil ) then
		return ReName;
	end;

	local cond = string.find( gName, "-" );
	local temp = "";
	local areAllNumbers = true;
	if cond ~= nil then
		for i=1,(cond-1) do
			if not IsANumber( StringAt(gName,i) ) then
				areAllNumbers = false;
			end;
		end;
		if areAllNumbers then
			temp = string.sub( gName , cond+1 );
			return temp;
		end;
		return gName;
	else
		return gName;
	end;
end;

--///////////////////////////////////////////////////////////////////////////////////////////////////