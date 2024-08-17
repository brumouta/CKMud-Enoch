-- Gating the regex with a substring
local matches = multimatches[2]

-- [Pl: 1,090,158 | Ki: 100% | Fatigue: 0%][FLY]
Times.lastprompt = getEpoch()
Toggles.firstprompt = true
-- Extract Info from Prompt
Player.KI = tonumber(matches.KI)
Player.GK = tonumber(matches.GK or 100)
Player.MAXGK = 500 + 50 * (Player.RemortLevel or 0)
Player.FATIGUE = tonumber(matches.FATIGUE)
Player.PL = tonumber(string.trim(string.gsub(matches.PL, ",", "")))
Player.HT = matches.HT == " [HT]"
Player.FLYING = matches.FLYING == "[FLY]"
echoc("[<green>" .. pretty_state() .. "<white>]")
echoc("[<red>" .. (max_gravity or 32) .. "x G<white>]")
if Toggles.training then
  echoc("[<green>AutoTrain<white>]")
elseif Toggles.botmode then
  echoc("[<green>BotMode<white>]")
end
-- Get the color of PL, if its green is zero we are suppressing PL
selectString(matches.PL, 1)
local r
local g
local b
r, g, b = getFgColor()
deselect()
if g == 0 then
  Player.SUPPRESSED = true
else
  Player.SUPPRESSED = false
end
if not Player.SUPPRESSED then
Player.HEALTH = math.floor((Player.PL / (Player.MAXPL or Player.PL)) * 100)
else
Player.HEALTH = 100
end
echoc("\n[Health: <green>" .. Player.HEALTH .. "<white>%]")
if Toggles.EnemyLineComboTest then
  Player.COMBO = nil
else
  echoc("[<red>IN COMBO<white>]")
end
raiseEvent("onPrompt")

-- Add stuff to the event dude