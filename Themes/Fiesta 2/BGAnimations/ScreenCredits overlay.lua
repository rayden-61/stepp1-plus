local function Fooled()
	local phrases = {
		"hornswaggled",
		"bamboozled",
		"hoodwinked",
		"swindled",
		"duped",
		"hoaxed",
		"fleeced",
		"shafted",
		"caboodled",
		"beguiled",
		"finagled",
		"two-timed",
		"suckered",
		"flimflammed"
	}
	return phrases[math.random(#phrases)]
end

local ssc = {
	"AJ Kelly as freem",
	"Jonathan Payne (Midiman)",
	"Colby Klein (shakesoda)",
}

local sm_ssc = {
	"Jason Felds (wolfman2000)", -- Timing Segments, Split Timing, optimization
	"Thai Pangsakulyanont (theDtTvB)", -- BMS, Split Timing, optimization
	"Alberto Ramos (Daisuke Master)",
	"Jack Walstrom (FSX)",
}

local stepmania = {
	"Chris Danford",
	"Glenn Maynard",
	"Steve Checkoway",
	-- and various other contributors
}

local oitg = {
	"infamouspat",
	"Mark Cannon (vyhd)",
}

local contrib = {
	"Aldo Fregoso (Aldo_MX)", -- delays and much more. StepMania AMX creator
	"A.C/@waiei", -- custom scoring fixes + Hybrid scoring
	"cerbo", -- lua bindings and other fun stuff
	"cesarmades", -- pump/cmd* noteskins
	"Chris Eldridge (kurisu)", -- dance-threepanel stepstype support
	"Christophe Goulet-LeBlanc (Kommisar)", -- songs
	"corec", -- various fixes
	"galopin", -- piu PlayStation2 usb mat support
	"gholms", -- automake 1.11 support
	"juanelote", -- SongManager:GetSongGroupByIndex, JumpToNext/PrevGroup logic mods
	"Kaox", -- pump/default noteskin
	"NitroX72", -- pump/frame noteskin
	"Petriform", -- default theme music
--	"桜為小鳩/Sakurana-Kobato (@sakuraponila)", -- custom scoring fixes
	"Sakurana-Kobato (@sakuraponila)", -- custom scoring fixes
	"Samuel Kim (1a2a3a2a1a)", -- various beat mode fixes
	"hanubeki (@803832)", -- beginner helper fix, among various other things
	"v1toko", -- x-mode from StepNXA
	"Alfred Sorenson", -- new lua bindings
}

local translators = {
	"John Reactor (Polish)",
	"DHalens (Spanish)",
	"@Niler_jp (Japanese)",
	"Deamon007 (Dutch)"
}

local thanks = {
	"A Pseudonymous Coder", -- support
	"Bill Shillito (DM Ashura)", -- Music (not yet though)
	"cpubasic13", -- testing (a lot)
	"Dreamwoods",
	"Jason Bolt (LightningXCE)",
	"Jousway", -- Noteskins
	"Luizsan", -- creator of Delta theme
	"Matt1360", -- Automake magic + oitg bro
	"Renard",
	"Ryan McKanna (Plaguefox)",
	"Sta Kousin", --help with Japanese bug reports
}

local shoutout = {
	"The Lua team", -- lua project lead or some shit. super nerdy but oh hell.
	"Mojang AB", -- minecraft forever -freem
	"Wolfire Games", -- piles of inspiration
	"NAKET Coder",
	"Ciera Boyd", -- you bet your ass I'm putting my girlfriend in the credits
	--Image(), -- we should have some logos probably to look super pro
	"#KBO",
	"Celestia Radio", -- LOVE AND TOLERANCE
	"You showed us...\nyour ultimate dance",
}

local copyright = {
	"StepMania is released under the\nterms of the MIT license.",
	"If you paid for the program you've\nbeen " .. Fooled() .. ".",
	"All content is the sole property\nof their respectful owners."
}

local stepf2 = {
	"I want to thanks Wreighn2, NicklessGuy, DK, Nirvash for their inconditional support. Also everyone who helped to develop this game, whether",
	"testing the game, or giving suggestions or just playing this game. Special thanks to Funbox for leading his Nostalgia charts and Crevolous for",
	"leading his Pump Pro+ charts and everyone who contributed with them. Also to the testers of SF2 and SP1 :D thank you guys!",
	"Goodbye and thanks to everyone!! :D, xMAx",
	"(P.S by Rayden61: Additional credits to SheepyChris and Team CrackItUp for 1.0.1 to 1.0.3 versions and myself for StepP1 Plus)",
	"",
	"(here below I leave the credits of StepMania, thanks for this simulator!)"
}


local sections = {
	{ "The Spinal Shark Collective (Project Lead)", ssc },
	{ "sm-ssc Team", sm_ssc },
	{ "StepMania Team", stepmania },
	{ "OpenITG Team", oitg },
	{ "Translators", translators },
	{ "Other Contributors", contrib },
	{ "Special Thanks", thanks },
	{ "Shoutouts", shoutout },
	{ "Copyright", copyright },
	{ "STEPF2/STEPP1", stepf2 },
}

local t = Def.ActorFrame {}
local ypos = 0;
--for i=1,1 do
function GetTextSection(i,zooming,xpos,ypos,green)
	local t = Def.ActorFrame {
		OnCommand=cmd(x,xpos;y,ypos;zoom,zooming);
	}
	t[#t+1]=LoadFont("Common normal")..{
		Text = text or "";
		OnCommand = function(self)
			self:settext(sections[i][1]);
			self:horizalign(0);
			self:vertalign(0);
			if green then
				self:diffuse(.2,1,0,1);
			else
				self:diffuse(0,.2,1,1);
			end;
		end;
	}
	local textt="\n";
	for j=1,#sections[i][2] do
		textt = textt..sections[i][2][j].."\n";
	end;
	t[#t+1]=LoadFont("Common normal")..{
		Text = textt or "";
		OnCommand=cmd(horizalign,0;vertalign,0);
	}
	return t;
end

local def_zoom = .3;
t[#t+1]=GetTextSection(1,def_zoom,20,200,false);
t[#t+1]=GetTextSection(2,def_zoom,20,245,false);
t[#t+1]=GetTextSection(3,def_zoom,20,310,false);
t[#t+1]=GetTextSection(4,def_zoom,20,360,false);
t[#t+1]=GetTextSection(5,def_zoom,20,395,false);
t[#t+1]=GetTextSection(6,def_zoom,250,200,false);
t[#t+1]=GetTextSection(7,def_zoom,470,200,false);
t[#t+1]=GetTextSection(8,def_zoom,470,335,false);
t[#t+1]=GetTextSection(9,def_zoom,250,390,false);
t[#t+1]=GetTextSection(10,.5,20,20,true);

-- To add people or sections modify the above.
--[[
local lineOn = cmd(zoom,0.875;strokecolor,color("#444444");shadowcolor,color("#444444");shadowlength,3)
local sectionOn = cmd(diffuse,color("#88DDFF");strokecolor,color("#446688");shadowcolor,color("#446688");shadowlength,3)
local item_padding_start = 4;

local creditScroller = Def.ActorScroller {
	SecondsPerItem = 0.5;
	NumItemsToDraw = 40;
	TransformFunction = function( self, offset, itemIndex, numItems)
		self:y(30*offset)
	end;
	OnCommand = cmd(scrollwithpadding,item_padding_start,15);
}

local function AddLine( text, command )
	local text = Def.ActorFrame{
		LoadFont("Common normal")..{
			Text = text or "";
			OnCommand = command or lineOn;
		}
	}
	table.insert( creditScroller, text )
end

-- Add sections with padding.
for section in ivalues(sections) do
	AddLine( section[1], sectionOn )
	for name in ivalues(section[2]) do
		AddLine( name )
	end
	AddLine()
	AddLine()
end

creditScroller.BeginCommand=function(self)
	SCREENMAN:GetTopScreen():PostScreenMessage( 'SM_MenuTimer', (creditScroller.SecondsPerItem * (#creditScroller + item_padding_start) + 10) );
end;


return Def.ActorFrame{
	creditScroller..{
		InitCommand=cmd(CenterX;y,SCREEN_BOTTOM-64),
	}
};
]]--

return t;