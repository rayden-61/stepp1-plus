return Def.ActorFrame {
	OffCommand=function(self)
		local nextscr = SCREENMAN:GetTopScreen():GetNextScreenName();
		-- si la pantalla que viene es la de titlemenu, entonces expandir los exagonos. Sino, es
		--porque se fue a una pantalla de configuracion, no se expande nada. -xMAx
		if nextscr == "ScreenTitleMenu" then	
			MESSAGEMAN:Broadcast( "IncomingTitleMenu" );
			self:sleep(.4);
		end;
	end;
};
