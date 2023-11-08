--FROM 03 GAMEPLAY.LUA

-- shakesoda calls this pump.lua
local function CurGameName()
	return GAMESTATE:GetCurrentGame():GetName()
end

-- Check the active game mode against a string. Cut down typing this in metrics.
function IsGame(str) return CurGameName():lower() == str:lower() end

-- ScoreKeeperClass:
-- [en] Determines the correct ScoreKeeper class to use.
function ScoreKeeperClass()
	-- rave scorekeeper
	if GAMESTATE:GetPlayMode() == 'PlayMode_Rave' then return "ScoreKeeperRave" end
	if GAMESTATE:GetCurrentStyle() then
		local styleType = GAMESTATE:GetCurrentStyle():GetStyleType()
		if styleType == 'StyleType_TwoPlayersSharedSides' then return "ScoreKeeperShared" end
	end
	return "ScoreKeeperNormal"
end
