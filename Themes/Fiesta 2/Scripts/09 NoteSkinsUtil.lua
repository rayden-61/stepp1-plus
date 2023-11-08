--######################################################################################
--######################################################################################
function IsPlayerUsingSpecialNoteSkin(pn)
	local toret = false;
	
	if GAMESTATE:IsSideJoined(pn) then
		local curstep = GAMESTATE:GetCurrentSteps(pn);
	--	if curstep:GetMeter() == 99 then
		if curstep:HasNoteSkinPlayer() then
			toret = true;
		end;
	end;
			
	return toret;
end;

--######################################################################################
--######################################################################################
-- code by xMAx