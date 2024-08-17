-- Loop through matches
for _, o in ipairs({0, 3}) do
  local skill = matches[2 + o]
  local status = matches[3 + o]
  if skill ~= nil then
    local tskill = translate_skill_name(skill)
    if status == "Mastered" or status == "Boosted" or status == "Supreme" then
      Player.Skills.Mastered[tskill] = true
    end
    if status == "Supreme" then
      Player.Skills.Supreme[tskill] = true
      Player.Skills.Boosted[tskill] = true
    elseif stats == "Boosted" then
      Player.Skills.Boosted[tskill] = true
    end
    Player.Skills.Learned[tskill] = true
    table.insert(Player.Skills.section, tskill)
  end
end