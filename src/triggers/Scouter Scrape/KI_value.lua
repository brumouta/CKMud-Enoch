if PromptFlags.scouterself and Player.KI == 100 then
Player.MAXKI = tonumber(string.trim(string.gsub(matches[2], ",", "")))
end