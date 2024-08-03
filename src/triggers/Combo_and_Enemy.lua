local wat = matches[2]
if wat == "Enemy" then
  -- Enemy line comes first
  Toggles.EnemyLineComboTest = true
else
  Toggles.EnemyLineComboTest = false
  local combos = string.trim(matches[3])
  Player.COMBO = string.split(combos, ", ")
  if last_combo ~= combos then
    COMBO_ID = {}
  end
  last_combo = combos
end