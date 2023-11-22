local GradeLetters = { 
	["Grade_Tier01"] = "SSS", 
	["Grade_Tier02"] = "X", 
	["Grade_Tier03"] = "G", 
	["Grade_Tier04"] = "A", 
	["Grade_Tier05"] = "B", 
	["Grade_Tier06"] = "C", 
	["Grade_Tier07"] = "D", 
	["Grade_Tier08"] = "F" 
}

local function GetPersonalGrade(pn)
	if GAMESTATE:IsSideJoined(pn) and GAMESTATE:HasProfile(pn) then
		local HighScores = PROFILEMAN:GetProfile(pn):GetHighScoreList(GAMESTATE:GetCurrentSong(), GAMESTATE:GetCurrentSteps(pn)):GetHighScores()
		if #HighScores ~= 0 then
			local GradeTier = HighScores[1]:GetGrade()
			local Grade = (GradeTier == "Grade_Failed" and "F" or GradeLetters[GradeTier])
			if Grade == "G" and HighScores[1]:GetTapNoteScore('TapNoteScore_W5') > 0 then
				return "S"
			elseif Grade == "A" and ( HighScores[1]:GetTapNoteScore('TapNoteScore_Miss') + HighScores[1]:GetTapNoteScore('TapNoteScore_CheckpointMiss') ) > 20 then
				return "A_Red"
			elseif Grade == "A" and ( HighScores[1]:GetTapNoteScore('TapNoteScore_Miss') + HighScores[1]:GetTapNoteScore('TapNoteScore_CheckpointMiss') ) > 10 then
				return "A"
			elseif Grade == "A" and ( HighScores[1]:GetTapNoteScore('TapNoteScore_Miss') + HighScores[1]:GetTapNoteScore('TapNoteScore_CheckpointMiss') ) > 5 then
				return "A_Blue"
			elseif Grade == "A" and ( HighScores[1]:GetTapNoteScore('TapNoteScore_Miss') + HighScores[1]:GetTapNoteScore('TapNoteScore_CheckpointMiss') ) <= 5 then
				return "A_Gold"
			else
				return Grade
			end
		else
			return nil
		end
	else
		return nil
	end
end

local function GetMachineGrade(pn)
	if GAMESTATE:IsSideJoined(pn) then
		local HighScores = PROFILEMAN:GetMachineProfile():GetHighScoreList(GAMESTATE:GetCurrentSong(), GAMESTATE:GetCurrentSteps(pn)):GetHighScores()
		if #HighScores ~= 0 then
			local GradeTier = HighScores[1]:GetGrade()
			local Grade = (GradeTier == "Grade_Failed" and "F" or GradeLetters[GradeTier])
			if Grade == "G" and HighScores[1]:GetTapNoteScore('TapNoteScore_W5') > 0 then
				return "S"
			elseif Grade == "A" and ( HighScores[1]:GetTapNoteScore('TapNoteScore_Miss') + HighScores[1]:GetTapNoteScore('TapNoteScore_CheckpointMiss') ) > 20 then
				return "A_Red"
			elseif Grade == "A" and ( HighScores[1]:GetTapNoteScore('TapNoteScore_Miss') + HighScores[1]:GetTapNoteScore('TapNoteScore_CheckpointMiss') ) > 10 then
				return "A"
			elseif Grade == "A" and ( HighScores[1]:GetTapNoteScore('TapNoteScore_Miss') + HighScores[1]:GetTapNoteScore('TapNoteScore_CheckpointMiss') ) > 5 then
				return "A_Blue"
			elseif Grade == "A" and ( HighScores[1]:GetTapNoteScore('TapNoteScore_Miss') + HighScores[1]:GetTapNoteScore('TapNoteScore_CheckpointMiss') ) <= 5 then
				return "A_Gold"
			else
				return Grade
			end
		else
			return nil
		end
	else
		return nil
	end
end

local t = Def.ActorFrame {
	InitCommand=function(self) self:visible(false) end,
	ChangeStepsMessageCommand=function(self) self:playcommand("Refresh") end,
	StartSelectingStepsMessageCommand=function(self) self:sleep(0.25) self:queuecommand("Visible") self:queuecommand("Refresh") end,
	
	VisibleCommand=function(self) self:visible(true) end,
	RefreshCommand=function(self)
		local PersonalP1 = GetPersonalGrade(PLAYER_1)
		if PersonalP1 ~= nil then
			self:GetChild("PersonalP1"):Load(THEME:GetPathG("", "RecordGrades/R_" .. PersonalP1 .. " (doubleres).png"))
		else
			self:GetChild("PersonalP1"):Load(nil)
		end
		
		local MachineP1 = GetMachineGrade(PLAYER_1)
		if MachineP1 ~= nil then
			self:GetChild("MachineP1"):Load(THEME:GetPathG("", "RecordGrades/R_" .. MachineP1 .. " (doubleres).png"))
		else
			self:GetChild("MachineP1"):Load(nil)
		end
		
		local PersonalP2 = GetPersonalGrade(PLAYER_2)
		if PersonalP2 ~= nil then
			self:GetChild("PersonalP2"):Load(THEME:GetPathG("", "RecordGrades/R_" .. PersonalP2 .. " (doubleres).png"))
		else
			self:GetChild("PersonalP2"):Load(nil)
		end
		
		local MachineP2 = GetMachineGrade(PLAYER_2)
		if MachineP2 ~= nil then
			self:GetChild("MachineP2"):Load(THEME:GetPathG("", "RecordGrades/R_" .. MachineP2 .. " (doubleres).png"))
		else
			self:GetChild("MachineP2"):Load(nil)
		end
	end,
	
	GoBackSelectingSongMessageCommand=function(self) self:stoptweening() self:visible(false) end,
	OffCommand=function(self) self:visible(false) end,
	
	Def.Sprite {
		Name="PersonalP1",
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X - 175, SCREEN_CENTER_Y + 138)
			self:zoom(0.65)
		end
	},
	
	Def.Sprite {
		Name="MachineP1",
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X - 175, SCREEN_CENTER_Y + 168)
			self:zoom(0.65)
		end
	},
	
	Def.Sprite {
		Name="PersonalP2",
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X + 239, SCREEN_CENTER_Y + 138)
			self:zoom(0.65)
		end
	},
	
	Def.Sprite {
		Name="MachineP2",
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X + 239, SCREEN_CENTER_Y + 168)
			self:zoom(0.65)
		end
	}
}

return t
