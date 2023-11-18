local PersonalP1, MachineP1, PersonalP2, MachineP2

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

local function GetPersonalGrade(pn, i)
	if GAMESTATE:IsSideJoined(pn) and GAMESTATE:HasProfile(pn) then
		local HighScores = PROFILEMAN:GetProfile(pn):GetHighScoreList(GAMESTATE:GetCurrentSong(), GAMESTATE:GetCurrentSteps(pn)):GetHighScores()
		if #HighScores ~= 0 and HighScores[i] ~= nil then
			local GradeTier = HighScores[i]:GetGrade()
			local Grade = (GradeTier == "Grade_Failed" and "F" or GradeLetters[GradeTier])
			if Grade == "G" and HighScores[i]:GetTapNoteScore('TapNoteScore_W5') > 0 then
				return "S"
			elseif Grade == "A" and ( HighScores[i]:GetTapNoteScore('TapNoteScore_Miss') + HighScores[i]:GetTapNoteScore('TapNoteScore_CheckpointMiss') ) > 20 then
				return "A_Red"
			elseif Grade == "A" and ( HighScores[i]:GetTapNoteScore('TapNoteScore_Miss') + HighScores[i]:GetTapNoteScore('TapNoteScore_CheckpointMiss') ) > 10 then
				return "A"
			elseif Grade == "A" and ( HighScores[i]:GetTapNoteScore('TapNoteScore_Miss') + HighScores[i]:GetTapNoteScore('TapNoteScore_CheckpointMiss') ) > 5 then
				return "A_Blue"
			elseif Grade == "A" and ( HighScores[i]:GetTapNoteScore('TapNoteScore_Miss') + HighScores[i]:GetTapNoteScore('TapNoteScore_CheckpointMiss') ) <= 5 then
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

local function GetMachineGrade(pn, i)
	if GAMESTATE:IsSideJoined(pn) then
		local HighScores = PROFILEMAN:GetMachineProfile():GetHighScoreList(GAMESTATE:GetCurrentSong(), GAMESTATE:GetCurrentSteps(pn)):GetHighScores()
		if #HighScores ~= 0 and HighScores[i] ~= nil then
			local GradeTier = HighScores[i]:GetGrade()
			local Grade = (GradeTier == "Grade_Failed" and "F" or GradeLetters[GradeTier])
			if Grade == "G" and HighScores[i]:GetTapNoteScore('TapNoteScore_W5') > 0 then
				return "S"
			elseif Grade == "A" and ( HighScores[i]:GetTapNoteScore('TapNoteScore_Miss') + HighScores[i]:GetTapNoteScore('TapNoteScore_CheckpointMiss') ) > 20 then
				return "A_Red"
			elseif Grade == "A" and ( HighScores[i]:GetTapNoteScore('TapNoteScore_Miss') + HighScores[i]:GetTapNoteScore('TapNoteScore_CheckpointMiss') ) > 10 then
				return "A"
			elseif Grade == "A" and ( HighScores[i]:GetTapNoteScore('TapNoteScore_Miss') + HighScores[i]:GetTapNoteScore('TapNoteScore_CheckpointMiss') ) > 5 then
				return "A_Blue"
			elseif Grade == "A" and ( HighScores[i]:GetTapNoteScore('TapNoteScore_Miss') + HighScores[i]:GetTapNoteScore('TapNoteScore_CheckpointMiss') ) <= 5 then
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
	OnCommand=function(self)
	end,
	
	Def.Sprite {
		Name="PersonalP1",
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X - 175, SCREEN_CENTER_Y + 118)
			self:zoom(0.65)
		end,
		OnCommand=function(self)
			self:sleep(0.5)
			self:queuecommand("FirstGrade")
			self:sleep(3.9)
			self:queuecommand("SecondGrade")
		end,
		FirstGradeCommand=function(self) 
			local NewScoreP1 = SCREENMAN:GetTopScreen():PlayerHasNewRecord(PLAYER_1)
			PersonalP1 = GetPersonalGrade(PLAYER_1, (NewScoreP1 and 2 or 1)) 
			self:playcommand("Refresh")
		end,
		SecondGradeCommand=function(self) 
			PersonalP1 = GetPersonalGrade(PLAYER_1, 1) 
			self:playcommand("Refresh")
		end,
		RefreshCommand=function(self) self:Load(PersonalP1 ~= nil and THEME:GetPathG("", "RecordGrades/R_" .. PersonalP1 .. " (doubleres).png") or nil) end
	},
	
	Def.Sprite {
		Name="MachineP1",
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X - 175, SCREEN_CENTER_Y + 148)
			self:zoom(0.65)
		end,
		OnCommand=function(self)
			self:sleep(0.5)
			self:queuecommand("FirstGrade")
			self:sleep(3.9)
			self:queuecommand("SecondGrade")
		end,
		FirstGradeCommand=function(self) 
			local NewScoreP1 = SCREENMAN:GetTopScreen():PlayerHasNewMachineRecord(PLAYER_1)
			local NewScoreP2 = SCREENMAN:GetTopScreen():PlayerHasNewMachineRecord(PLAYER_2)
			local NewMachineScore = (NewScoreP1 or NewScoreP2)
			MachineP1 = GetMachineGrade(PLAYER_1, (NewMachineScore and 2 or 1)) 
			self:playcommand("Refresh")
		end,
		SecondGradeCommand=function(self) 
			MachineP1 = GetMachineGrade(PLAYER_1, 1) 
			self:playcommand("Refresh")
		end,
		RefreshCommand=function(self)
			self:Load(MachineP1 ~= nil and THEME:GetPathG("", "RecordGrades/R_" .. MachineP1 .. " (doubleres).png") or nil)
		end
	},
	
	Def.Sprite {
		Name="PersonalP2",
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X + 239, SCREEN_CENTER_Y + 118)
			self:zoom(0.65)
		end,
		OnCommand=function(self)
			self:sleep(0.5)
			self:queuecommand("FirstGrade")
			self:sleep(3.9)
			self:queuecommand("SecondGrade")
		end,
		FirstGradeCommand=function(self) 
			local NewScoreP2 = SCREENMAN:GetTopScreen():PlayerHasNewRecord(PLAYER_2)
			PersonalP2 = GetPersonalGrade(PLAYER_2, (NewScoreP2 and 2 or 1)) 
			self:playcommand("Refresh")
		end,
		SecondGradeCommand=function(self) 
			PersonalP2 = GetPersonalGrade(PLAYER_2, 1) 
			self:playcommand("Refresh")
		end,
		RefreshCommand=function(self) self:Load(PersonalP2 ~= nil and THEME:GetPathG("", "RecordGrades/R_" .. PersonalP2 .. " (doubleres).png") or nil) end
	},
	
	Def.Sprite {
		Name="MachineP2",
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X + 239, SCREEN_CENTER_Y + 148)
			self:zoom(0.65)
		end,
		OnCommand=function(self)
			self:sleep(0.5)
			self:queuecommand("FirstGrade")
			self:sleep(3.9)
			self:queuecommand("SecondGrade")
		end,
		FirstGradeCommand=function(self) 
			local NewScoreP1 = SCREENMAN:GetTopScreen():PlayerHasNewMachineRecord(PLAYER_1)
			local NewScoreP2 = SCREENMAN:GetTopScreen():PlayerHasNewMachineRecord(PLAYER_2)
			local NewMachineScore = (NewScoreP1 or NewScoreP2)
			MachineP2 = GetMachineGrade(PLAYER_2, (NewMachineScore and 2 or 1)) 
			self:playcommand("Refresh")
		end,
		SecondGradeCommand=function(self) 
			MachineP2 = GetMachineGrade(PLAYER_2, 1) 
			self:playcommand("Refresh")
		end,
		RefreshCommand=function(self)
			self:Load(MachineP2 ~= nil and THEME:GetPathG("", "RecordGrades/R_" .. MachineP2 .. " (doubleres).png") or nil)
		end
	}
}

return t
