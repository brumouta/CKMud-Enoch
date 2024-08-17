local matches = multimatches[2]
Player.Name = matches[2]

PromptFlags.scorecard = true
Times.lastscore = getEpoch()

if Player.BaseStats == nil then
  Player.BaseStats = {}
end

if Player.Stats == nil then
  Player.Stats = {}
end