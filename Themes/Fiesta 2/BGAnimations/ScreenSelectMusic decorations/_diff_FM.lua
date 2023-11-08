local t = Def.ActorFrame {}

if GAMESTATE:IsSideJoined(PLAYER_1) then
t[#t+1] = GetBallLevel(PLAYER_1,true)..{InitCommand=cmd(basezoom,.67;x,cx-90);};
end;

if GAMESTATE:IsSideJoined(PLAYER_2) then
t[#t+1] = GetBallLevel(PLAYER_2,true)..{InitCommand=cmd(basezoom,.67;x,cx+90);};
end;

return t;