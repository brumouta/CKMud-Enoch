function fsend(items)
  -- It is super common join items in a send by space lets do it very cleanly
  send(table.concat(items, " "), not items.silent)
end

local function dam(stat1, stat2, supreme, boosted)
  local supreme_multi = supreme and 7500 or 5000
  local boost_multi = (boosted or supreme) and 750 or 500
  return
    math.floor(
      (stat1 * supreme_multi) +
      (stat2 * supreme_multi) +
      (Player.DAMROLL * boost_multi) +
      (Player.HITROLL * boost_multi) +
      (Player.MAXPL / 100)
    )
end

function HEAL_FACTOR()
  return Player.Stats.INT * 15000 + Player.Stats.WIS * 15000 + Player.MAXPL / 100
end

function ki_dam(supreme, boosted)
  return dam(Player.Stats.INT, Player.Stats.WIS, supreme, boosted)
end

function phy_dam(supreme, boosted)
  return dam(Player.Stats.STR, Player.Stats.SPD, supreme, boosted)
end

function toggle_botmode()
  if Toggles.botmode then
    -- disable it
    Toggles.botmode = false
    echo("BOT Mode Disabled!!!")
    set_state(State.NORMAL)
  else
    Toggles.botmode = true
    Toggles.learning = false
    Toggles.training = false
    set_state(State.NORMAL)
    echo("BOT Mode Enabled!!!")
  end
end

function std_sort(atable)
  function sort(a, b)
    return atable[a] > atable[b]
  end

  return sort
end

function attacksByValue(atable, sortfunc)
  sortfunc = sortfunc or std_sort(atable)
  local a = {}
  -- Get all the keys in a
  for n in pairs(atable) do
    table.insert(a, n)
  end
  local shuffled = {}
  for i, v in ipairs(a) do
    local pos = math.random(1, #shuffled + 1)
    table.insert(shuffled, pos, v)
  end
  -- Sort the keys in a
  table.sort(shuffled, sortfunc)
  local i = 0
  -- iterator
  local iter =
    function()
      i = i + 1
      if shuffled[i] == nil then
        return nil
      else
        return shuffled[i], atable[shuffled[i]]
      end
    end
  return iter
end

function reformatInt(i)
  return tostring(i):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

function string:split(sSeparator, nMax, bRegexp)
  assert(sSeparator ~= '')
  assert(nMax == nil or nMax >= 1)
  local aRecord = {}
  if self:len() > 0 then
    local bPlain = not bRegexp
    nMax = nMax or -1
    local nField, nStart = 1, 1
    local nFirst, nLast = self:find(sSeparator, nStart, bPlain)
    while nFirst and nMax ~= 0 do
      aRecord[nField] = self:sub(nStart, nFirst - 1)
      nField = nField + 1
      nStart = nLast + 1
      nFirst, nLast = self:find(sSeparator, nStart, bPlain)
      nMax = nMax - 1
    end
    aRecord[nField] = self:sub(nStart)
  end
  return aRecord
end

function echoc(s)
  for colour, text in string.gmatch("<white>" .. s, "<([a-z_]+)>([^<>]+)") do
    fg(colour)
    echo(text)
  end
  resetFormat()
end

function last(ts, NOW)
  if NOW == nil then
    NOW = getEpoch()
  end
  if ts == nil then
    ts = 0
  end
  return NOW - ts
end

function random_elem(tb)
  local keys = {}
  for k, v in pairs(tb) do
    table.insert(keys, k)
  end
  return keys[math.random(#keys)]
end

function random_list_elem(tl)
  local pos = math.floor(math.random() * #tl) + 1
  return tl[pos]
end

function add_mob(mob)
  if AllowedMobs == nil then
    AllowedMobs = {}
  end
  AllowedMobs[mob] = true
end

function math.round(x, n)
  return tonumber(string.format("%." .. n .. "f", x))
end

function get_attack_name(mob)
  local name
  if mob == nil then
    return nil
  end
  if string.find(string.lower(mob), "turkey") then
    -- Cybernetic Turkeys
    name = "turkey"
  else
    -- Get the last word
    local words = string.split(mob, " ")
    name = words[#words]
  end
  return name
end

function list_append(list, item)
  list[#list + 1] = item
end

function list_extend(list, items)
  for _, item in ipairs(items) do
    list[#list + 1] = item
  end
end