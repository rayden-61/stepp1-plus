------------------------------------------------------------------------------------------------------------------------------------
-- 00 init.lua
Trace = lua.Trace
Warn = lua.Warn
print = Trace

-- Use MersenneTwister in place of math.random and math.randomseed.
if MersenneTwister then
	math.random = MersenneTwister.Random
	math.randomseed = MersenneTwister.Seed
end

PLAYER_1 = "PlayerNumber_P1"
PLAYER_2 = "PlayerNumber_P2"
NUM_PLAYERS = #PlayerNumber
OtherPlayer = { [PLAYER_1] = PLAYER_2, [PLAYER_2] = PLAYER_1 }

------------------------------------------------------------------------------------------------------------------------------------
-- 03 Actor.lua
function Actor:player(p)
	self:visible( GAMESTATE:IsHumanPlayer(p) )
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



------------------------------------------------------------------------------------------------------------------------------------
-- 02 ActorDef.lua
-- 03 Gameplay.lua

------------------------------------------------------------------------------------------------------------------------------------
-- 03 CustomSpeedMods.lua

-- Hook called during profile load
function LoadProfileCustom(profile, dir)
end

-- Hook called during profile save
function SaveProfileCustom(profile, dir)
end
