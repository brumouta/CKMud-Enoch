if PromptFlags.scorecard then
  local which = matches[2]
  local value = tonumber(matches[3])
  if which == "U" then
    Player.UBS = value
  elseif which == "L" then
    Player.LBS = value
  end

end