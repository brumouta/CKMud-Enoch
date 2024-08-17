if matches[2] then
gauntlet_level = tonumber(matches[2])
if gauntlet_level > 6 then
  Toggles.no_fight = false
end
else
gauntlet_level = 0
end