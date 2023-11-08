function Sprite:LoadFromSongBanner(song)
	if song then
		local Path = song:GetBannerPath()
		if not Path then
			Path = THEME:GetPathG("Common","fallback banner")
		end

		self:LoadBanner( Path )
	else
		self:LoadBanner( THEME:GetPathG("Common","fallback banner") )
	end
end

function Sprite:LoadFromSongBackground(song)
	if( song:HasBackground() ) then
		local Path = song:GetBackgroundPath();
	else
		local Path = THEME:GetPathG("","BackGround/bga.avi");
	end

	self:LoadBackground( Path );
	self:FullScreen();
end

function LoadSongBackground()
	return Def.Sprite {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;FullScreen),
		BeginCommand=cmd(LoadFromSongBackground,GAMESTATE:GetCurrentSong();FullScreen)
	}
end

function Sprite:LoadFromCurrentSongBackground()
	local song = GAMESTATE:GetCurrentSong()
	if not song then
		local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber())
		local e = trail:GetTrailEntries()
		if #e > 0 then
			song = e[1]:GetSong()
		end
	end

	if not song then return end

	self:LoadFromSongBackground(song)
	self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT);
end

function Sprite:position( f )
	self:GetTexture():position( f )
end

function Sprite:loop( f )
	self:GetTexture():loop( f )
end

function Sprite:rate( f )
	self:GetTexture():rate( f )
end

function Sprite.LinearFrames(NumFrames, Seconds)
	local Frames = {}
	for i = 0,NumFrames-1 do
		Frames[#Frames+1] = {
			Frame = i,
			Delay = (1/NumFrames)*Seconds
		}
	end
	return Frames
end

--xMAx - SetCustomImageRectByPixeles	:D
function Sprite:SetCustomImageRectByPixeles(left,top,right,bottom) 
	local h = self:GetHeight();
	local w = self:GetWidth();
	self:customtexturerect( (left/w), (top/h), (right/w), (bottom/h) );
	self:SetHeight(bottom-top);
	self:SetWidth(right-left);
end

function Sprite:SetCustomImageRectByPixelesN(left,top,right,bottom) 
	local h = self:GetHeight();
	local w = self:GetWidth();
	self:customtexturerect( (left/w), (top/h), (right/w), (bottom/h) );
	self:SetHeight(bottom-top);
	--self:SetWidth(right-left);
end

-- command aliases:
function Sprite:cropto(w,h) self:CropTo(w,h) end

function Sprite:UpdateSPRFrame( dir )
	-- no hay un arrwegle de frames
	if self.frames == nil then
		return;
	end;
	
	if dir < 0 then	--negativo
		if self.index == 1 then
			self.index = self.num_frames;
		else
			self.index = self.index + dir;
		end;
	elseif dir > 0 then -- positivo
		if self.index == self.num_frames then
			self.index = 1;
		else
			self.index = self.index + dir;
		end;
	else -- 0
		return;
	end;
	
	self:Load(self.frames[self.index].file_name);
	local h = self:GetHeight();
	local w = self:GetWidth();
	self:customtexturerect( (self.frames[self.index].P1_x/w), (self.frames[self.index].P1_y/h), (self.frames[self.index].P2_x/w), (self.frames[self.index].P2_y/h) );
	self:SetHeight(self.frames[self.index].f_h);
	self:SetWidth(self.frames[self.index].f_w);
end;

function Sprite:LoadFromSPRFile( path )
	local file = lua.ReadFile( path );
	
	if file == nil then
		error("File: "..path.." couldn't be read.");
		return;
	end;
	
	-- path for graphic
	local sub_dirs = split("/",path);
	local dir = string.gsub( path,sub_dirs[#sub_dirs],"" );
	
	local lines = split("\n",string.gsub(file,string.char(13),""));
		
	local num_frames = string.gsub(lines[2],"NUM ","")+0; -- no soporta animaciones
	local frames = {};
	
	for i=1,num_frames do
		local frame = {};-- file_name = "", f_w = 0, f_h = 0, P1_x = 0, P1_y = 0, P2_x = 0, P2_y = 0 };
		local data = split(" ",lines[2+i]);
		
		frame.file_name = (dir.."/"..string.gsub(data[2],"tga","png"));
		frame.f_w = data[5];
		frame.f_h = data[6];
		frame.P1_x = data[7];
		frame.P1_y = data[8];
		frame.P2_x = data[9];
		frame.P2_y = data[10];
		
		frames[#frames+1] = frame;
	end;

	if num_frames > 1 then
		self.num_frames = num_frames;
		self.frames = frames;
		self.index = 1;
	else
		self.frames = nil;
		self.index = nil;
	end;
	
	self:Load(frames[1].file_name);

	local h = self:GetHeight();
	local w = self:GetWidth();
	
	self:customtexturerect( (frames[1].P1_x/w), (frames[1].P1_y/h), (frames[1].P2_x/w), (frames[1].P2_y/h) );
	
	self:SetHeight(frames[1].f_h);
	self:SetWidth(frames[1].f_w);
end;

-- (c) 2005 Glenn Maynard
-- All rights reserved.
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, and/or sell copies of the Software, and to permit persons to
-- whom the Software is furnished to do so, provided that the above
-- copyright notice(s) and this permission notice appear in all copies of
-- the Software and that both the above copyright notice(s) and this
-- permission notice appear in supporting documentation.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
-- THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
-- INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
-- OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
-- OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
-- OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
-- PERFORMANCE OF THIS SOFTWARE.
