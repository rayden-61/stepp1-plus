-- Convenience aliases:
left = "HorizAlign_Left"
center = "HorizAlign_Center"
right = "HorizAlign_Right"
top = "VertAlign_Top"
middle = "VertAlign_Middle"
bottom = "VertAlign_Bottom"

-- Hide if b is true, but don't unhide if b is false.
function Actor:hide_if(b)
	if b then
		self:visible(false)
	end
end

function Actor:player(p)
	self:visible( GAMESTATE:IsHumanPlayer(p) )
end

-- Shortcut for alignment.
--   cmd(align,0.5,0.5)  -- align center
--   cmd(align,0.0,0.0)  -- align top-left
--   cmd(align,0.5,0.0)  -- align top-center
function Actor:align(h, v)
	self:halign( h )
	self:valign( v )
end

function Actor:FullScreen()
	self:stretchto( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT )
end

function Actor:scale_or_crop_background()
	self:scaletocover(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
end

function Actor:CenterX() self:x(SCREEN_CENTER_X) end
function Actor:CenterY() self:y(SCREEN_CENTER_Y) end
function Actor:Center() self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y) end

-- MaskSource([clearzbuffer])
-- Sets an actor up as the source for a mask. Clears zBuffer by default.
function Actor:MaskSource(noclear)
	if noclear == true then
		self:clearzbuffer(true)
	end
	self:zwrite(true)
	self:blend('BlendMode_NoEffect')
end

-- MaskDest()
-- Sets an actor up to be masked by anything with MaskSource().
function Actor:MaskDest()
	self:ztest(true)
end

-- Stroke(color)
-- Sets the text's stroke color.
function BitmapText:Stroke(c)
	self:strokecolor( c )
end

-- NoStroke()
-- Removes any stroke.
function BitmapText:NoStroke()
	self:strokecolor( color("0,0,0,0") )
end

-- Set Text With Format (contributed by Daisuke Master)
-- this function is my hero - shake
function BitmapText:settextf(...)
	self:settext(string.format(...))
end

-- DiffuseAndStroke(diffuse,stroke)
-- Set diffuse and stroke at the same time.
function BitmapText:DiffuseAndStroke(diffuseC,strokeC)
	self:diffuse(diffuseC)
	self:strokecolor(strokeC)
end;
--[[ end BitmapText commands ]]

-- Play the sound on the given player's side. Must set SupportPan = true
-- on load.
function ActorSound:playforplayer(pn)
	local fBalance = SOUND:GetPlayerBalance(pn)
	self:get():SetProperty("Pan", fBalance)
	self:play()
end

function PositionPerPlayer(player, p1X, p2X)
	return player == PLAYER_1 and p1X or p2X
end

-- command aliases:
function Actor:SetSize(w,h) self:setsize(w,h) end

-- Simple draworder mappings
DrawOrder = {
  Background	= -100,
  Underlay		= 0,
  Decorations	= 100,
  Content		= 105,
  Screen		= 120,
  Overlay		= 200
};

-- function Actor:SetDrawOrder

-- deprecated aliases:
function Actor:hidden(bHide)
	Warn("hidden is deprecated, use visible instead. (used on ".. self:GetName() ..")")
	self:visible(not bHide)
end

-- (c) 2006-2012 Glenn Maynard, the Spinal Shark Collective, et al.
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