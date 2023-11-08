-- Regresa "es" o "en" dependiendo del lenguaje que se esté usando
function GetLanguageText()
	local lang = PREFSMAN:GetPreference("Language");
	if lang == "es" or lang == "en" then
		return lang;
	else
		return "en";
	end;
end;

-- Setea las condiciones iniciales del juego
function SetInitConditions()
	LoadChannelsSounds();
end;


