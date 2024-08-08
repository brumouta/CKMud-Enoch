

local function item_tier()
  -- Thanks Vorrac
  local base_pl = Player.BASEPL
  local tier = 0
  if base_pl >= 3000000000 then
    tier = 8
  elseif base_pl >= 1500000000 then
    tier = 7
  elseif base_pl >= 500000000 then
    tier = 6
  elseif base_pl >= 250000000 then
    tier = 5
  elseif base_pl >= 125000000 then
    tier = 4
  elseif base_pl >= 75000000 then
    tier = 3
  elseif base_pl >= 25000000 then
    tier = 2
  elseif base_pl >= 1000000 then
    tier = 1
  end
  return tier
end

if PromptFlags.scorecard then
  echo("\n")
  Player.KI_DAM = ki_dam()
  Player.PHY_DAM = phy_dam()
  echoc(
    string.format(
      '<dim_gray>PHY DAM<white>:         <yellow>%-18s<dim_gray>KI DAM<white>:    <yellow>%s\n',
      reformatInt(Player.PHY_DAM),
      reformatInt(Player.KI_DAM)
    )
  )
  echoc(
    string.format(
      '<dim_gray>PHY DAM(B)<white>:      <yellow>%-18s<dim_gray>KI DAM(B)<white>: <yellow>%s\n',
      reformatInt(phy_dam(false, true)),
      reformatInt(ki_dam(false, true))
    )
  )
  echoc(
    string.format(
      '<dim_gray>PHY DAM(S)<white>:      <yellow>%-18s<dim_gray>KI DAM(S)<white>: <yellow>%s\n',
      reformatInt(phy_dam(true)),
      reformatInt(ki_dam(true))
    )
  )
  echoc(string.format('<dim_gray>Item Tier<white>: <green>%7s\n', item_tier()))
end