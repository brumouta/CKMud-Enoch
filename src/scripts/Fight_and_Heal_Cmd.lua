
melee_attacks = {
    ["punch"] = 3,
    ["kick"] = 3,
    ["roundhouse"] = 4,
    ["sweep"] = 5,
    ["uppercut"] = 4,
    ["machpunch"] = 4,
    ["machkick"] = 4,
    ["dynamitekick"] = 5,
    ["braver"] = 6,
    ["heelstomp"] = 6,
    ["cyclone"] = 6,
    ["wolf"] = 6.1,
    ["rage"] = 8,
  ["dpunch"] = 8.1, -- 8
    ["godfist"] = 12,
    ["supergodfist"] = 12,
    ["justice"] = 12,

  }

energy_attacks = {
    ["kishot"] = 2,
    ["eyebeam"] = 3,
    ["kame"] = 20,
    ["stonespit"] = 40,
    ["evilblast"] = 30,
    ["kienzan"] = 30,
    ["superk"] = 50,
    ["bigbang"] = 60,
    ["makan"] = 60,
    ["chou"] = 60,
    ["sblast"] = 100,
    ["superbb"] = 160,
    ["warpk"] = 240,
    ["genki"] = 300,
    ["finalk"] = 1000,
  }

heal_kinds = {
  ["heal"] = {10, 0.30, 6}, -- Kami
  ["revitalize"] = {30, 0.60, 10.1},  -- Dende
--["restoration"] = {20, 0.45, 10},   -- Kami
}

function filter_known(atable)
  local ndict = {}
  for attack, cost in pairs(atable) do
    if Player.Learned[attack] then
      ndict[attack] = cost
    end
  end
  if ndict["supergodfist"] then
    ndict["godfist"] = nil
  end
  return ndict
end

-- table.pairsByValue

function melee_cost(cost)
  return (Player.FATIGUE + cost) <= 99
end

function energy_cost(cost)
  -- Use Player.MAXKI to find out the real cost
  local realcost = (cost / Player.MAXKI) * 100
  return (Player.KI - realcost) >= 1
end

function heal_cost(comp)
  local realcost = calc_heal_cost(comp)
  return (Player.KI - realcost) >= 1
end

function calc_heal_cost(comp)
  local cost
  local eff
  local seen_cost
  cost, eff, seen_cost = unpack(comp)
  local to_heal = math.floor(HEAL_FACTOR() * eff)
  extra_cost = math.floor(to_heal / 250000) * 10
  return seen_cost
  --return ((cost+extra_cost)/Player.MAXKI)*100
end

--- 7,643,151 healed
--- cost = 10% = 500
--- 340 cost.

function heal_sort(atable)
  function sort(a, b)
    return calc_heal_cost(atable[a]) > calc_heal_cost(atable[b])
  end

  return sort
end

function getAttacks(atable, testfunc, max, sortfunc)
  local a = {}
  local count = 1
  for attack, cost in attacksByValue(filter_known(atable), sortfunc) do
    if count > max then
      break
    end
    if cost == nil then
      echo("attack " .. attack .. " has nil cost")
    end
    if testfunc(cost) then
      count = count + 1
      table.insert(a, attack)
    end
  end
  return a
end

function heal(t)
  if t then
    send("focus 'revitalize' " .. t)
    return true
  else
    heal_pick = getAttacks(heal_kinds, heal_cost, 1, heal_sort(heal_kinds))
    if #heal_pick >= 1 then
      send("focus '" .. heal_pick[1] .. "'")
      return true
    else
      echo("Can't heal not enough KI")
      return false
    end
  end
end

function fight(who)
  --[[if not Toggles.standing then
    return nil
  end
  ]]
  Times.lastfight = getEpoch()
  local melee_ok = Toggles.meleefighting or not Player.FLYING
  local exhausted = Player.FATIGUE >= 99
  local HT_PREEMPT = Player.HT and not Toggles.NEXTHT and not Toggles.botmode
  local fights = {}
  local ran = math.random()
  -- 50% of the time its melee first
  local melee_first = ran < 3 / 4 or Toggles.botmode
  if melee_first then
    fights = getAttacks(melee_attacks, melee_cost, 3)
  else
    fights = getAttacks(energy_attacks, energy_cost, 3)
  end
  -- If not fights lets try the other side
  if #fights == 0 and (Player.KI > 0 or not exhausted) then
    if melee_first then
      fights = getAttacks(energy_attacks, energy_cost, 3)
    else
      fights = getAttacks(melee_attacks, melee_cost, 3)
    end
  end
  local ran = math.random()
  -- if no fights and we know who then kill them with autohits
  if #fights == 0 then
    if who then
      send("kill " .. string.lower(who))
    end
    return
  end
  if not HT_PREEMPT and (Player.COMBO or (ran < 0.25 and melee_first)) then
    if last_combo_id ~= COMBO_ID then
      last_combo_id = COMBO_ID
      send("--")
    end
    local next_fight = next_combo()
    if next_fight then
      echo("Next Combo " .. next_fight)
      if Player.Learned[next_fight] ~= nil then
        if melee_cost(melee_attacks[next_fight]) then
          fights = {next_fight}
        else
          echo("TOO Exhausted to complete Combo attack: " .. next_fight)
        end
      else
        echo("We don't know " .. next_fight .. " yet!")
      end
    else
      echo("WTF next_fight is empty")
    end
  end
  if HT_PREEMPT then
    -- Use the HT attack
    Toggles.NEXTHT = true
    send("--")
    local sattack = getAttacks(energy_attacks, energy_cost, 1)
    if #sattack == 1 then
      fights = sattack
    end
  elseif Player.HEALTH < 50 and Player.KI > 30 and not exhausted then
    -- Heal me
    heal()
    return
  end
  if #fights == 0 then
    echo("NO FIGHTS WTF")
    return
  end
  local pos = math.floor(math.random() * #fights) + 1
  if who == nil then
    send(fights[pos])
  else
    who = string.lower(who)
    send(fights[pos] .. " " .. who)
  end
end