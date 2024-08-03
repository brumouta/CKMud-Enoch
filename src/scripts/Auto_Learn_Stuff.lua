fullname_to_cmd =
  {
    ["whirlwind"] = "whirl",
    ["scatter shot"] = "scatter",
    ["mach punch"] = "machpunch",
    ["mach kick"] = "machkick",
    ["super big bang"] = "superbb",
    ["super kamehameha"] = "superk",
    ["spirit blast"] = "sblast",
    ["rage saucer"] = "rage",
    ["disruptor beam"] = "disrupt",
    ["braver strike"] = "braver",
    ["big bang"] = "bigbang",
    ["eye beam"] = "eyebeam",
    ["photon wave"] = "photon",
    ["dragon punch"] = "dpunch",
    ["renzokou energy dan"] = "renzo",
    ["final flash"] = "final",
    ["final kamehameha"] = "finalk",
    ["warp kamehameha"] = "warp",
    ["instant trans"] = "instant",
    ["hellsflash"] = "hells",
    ["justice blitz"] = "justice",
    ["cyclone kick"] = "cyclone",
    ["super godfist"] = "supergodfist",
    ["heel stomp"] = "heel",
    ["wolf fang fist"] = "wolf",
    ["chou kamehameha"] = "chou",
    ["spirit bomb"] = "genki",
    ["dynamite kick"] = "dynamite",
    ["taiyoken"] = "solarflare",
    ["suppression"] = "sup",
    ["kamehameha"] = "kame",
    ["makankosappo"] = "makan",
    ["unravel defense"] = "unravel",
    ["void wave"] = "void",
    ["evil blast"] = "evilblast",
    ["ethereal blade"] = "ethereal",
  }

function toggle_learningmode(target)
  if Toggles.learning then
    -- disable it
    Toggles.learning = false
    echo("Learning Mode Disabled!!!")
    disableTimer("Learning")
  else
    Toggles.learning = true
    Toggles.training = false
    Toggles.botmode = false
    Toggles.timer_ok = true
    local tparts = string.split(target or "child", " ")
    autolearn_target = tparts[1]
    sleepwalk_target = tparts[2] or "s3w1s"  
    
    echo("Learning Mode Enabled!!!")
    send("learn")
    enableTimer("Learning")
  end
end

function do_learn()
  -- This is executed by a timer
  local ran = math.random()
  if PromptCounters.timer_ok == nil or (PromptCounters.timer_ok <= 15 and not Toggles.fighting) then
    Toggles.timer_ok = true
  end
  Counters = Counters or {}
  Counters.timer_trainer = Counters.timer_trainer or 0
  local starting_melee = skill_filter({"sweep", "punch", "kick", "roundhouse", "uppercut"}, true)
  local starting_ki = skill_filter({"kishot", "evilblast"}, true)
  local learned_melee_skills =
    skill_filter(
      {
        "wolf",
        "braver",
        "machpunch",
        "heel",
        "dpunch",
        "rage",
        "godfist",
        "machkick",
        "cyclone",
        "justice",
        "supergodfist",
        "dynamite",
      },
      true
    )
  local learned_ki_skills =
    skill_filter(
      {
        "sblast",
        "superk",
        "warp",
        "kame",
        "kienzan",
        "superbb",
        "makan",
        "stonespit",
        "bigbang",
        "eyebeam",
        "finalk",
        "genki",
        "chou",
      },
      true
    )
  local new_buffs =
    skill_filter(
      {
        "resonance",
        "herculean force",
        "demonic will",
        "hasshuken",
        "zanzoken",
        "energy shield",
        "kino tsurugi",
        "barrier",
        "ethereal",
        "heal",
        "revitalize",
      },
      true
    )

  local function get_learn_triggers(type)
    local new_dict
    if type == "ki" then
      new_dict =
        {
          ["scatter"] = {"kishot"},
          ["warp"] = {"superk", "instant"},
          ["superbb"] = {"bigbang"},
          ["superk"] = {"kame"},
        }
      if Player.BASEPL > 125000000 then
        new_dict["finalk"] = {"warp", "final"}
      end
    else
      new_dict = {
        ["machkick"] = {"kick"},
        ["machpunch"] = {"punch"},
      }
      if Player.BASEPL > 125000000 then
        new_dict["justice"] = {"cyclone", "dynamite", "rage"}
        new_dict["supergodfist"] = {"godfist", "wolf", "dpunch"}
      end
    end
    return new_dict
  end

  local UBSLBSSKILLS = {}
  if Player.UBS < 100 then
    UBSLBSSKILLS = {"punch"}
  end
  if Player.LBS < 100 then
    table.insert(UBSLBSSKILLS, "kick")
  end
  local ki_ok = Player.KI > 20 and Player.FATIGUE < 99
  local melee_ok = Player.FATIGUE < 90
  local new_learnable_melee = filter_learn_triggers(get_learn_triggers())
  local new_learnable_ki = filter_learn_triggers(get_learn_triggers("ki"))
  local new_other = skill_filter({"powersense", "scan"}, true)
  local new_aoe = skill_filter({"void", "final", "renzo", "scatter"}, true)
  local new_targeted_focus = skill_filter({"unravel", "solarflare"}, true)
  local new_goku_target = skill_filter({"instant", "portal"}, true)
  local target = {"gine", "roshi", "teragon", "malak", "bubbles", "cypher"}
  if is_state(State.NORMAL) and PromptFlags.timertrainer == nil then
    PromptFlags.timertrainer = true
    --Toggles.timer_ok = false
    ---fight("name")
    if Toggles.timer_ok then
      --(Player.FATIGUE <= 90 and Player.KI > 20) then
      if melee_ok and #starting_melee > 0 then
        Toggles.timer_ok = false
        PromptCounters.timer_ok = 20
        fsend{starting_melee[1], autolearn_target}
      elseif ki_ok and #starting_ki > 0 then
        Toggles.timer_ok = false
        PromptCounters.timer_ok = 20
        fsend{starting_ki[1], autolearn_target}
      elseif melee_ok and #learned_melee_skills > 0 then
        Toggles.timer_ok = false
        PromptCounters.timer_ok = 20
        fsend{learned_melee_skills[1], autolearn_target}
      elseif ki_ok and #learned_ki_skills > 0 then
        Toggles.timer_ok = false
        PromptCounters.timer_ok = 20
        fsend{learned_ki_skills[1], autolearn_target}
      elseif melee_ok and #new_other > 0 then
        Toggles.timer_ok = true
        fsend{new_other[1], autolearn_target}
      elseif ki_ok and #new_targeted_focus > 0 then
        Toggles.timer_ok = true
        fsend{new_targeted_focus[1], autolearn_target}
      elseif #new_learnable_ki > 0 and ki_ok then
        Toggles.timer_ok = false
        PromptCounters.timer_ok = 20
        fsend{new_learnable_ki[1], autolearn_target}
      elseif #new_learnable_melee > 0 and melee_ok then
        Toggles.timer_ok = false
        PromptCounters.timer_ok = 20
        fsend{new_learnable_melee[1], autolearn_target}
      elseif #new_buffs > 0 and ki_ok then
        Toggles.timer_ok = true
        PromptCounters.timer_ok = 20
        focus_buff(new_buffs[1])
      elseif #new_aoe > 0 and ki_ok then
        Toggles.timer_ok = false
        PromptCounters.timer_ok = 20
        send(random_list_elem(new_aoe))
      elseif Player.Mastered["whirl"] == nil and Player.Learned["whirl"] and melee_ok then
        Toggles.timer_ok = false
        PromptCounters.time_ok = 20
        send("whirl")
      elseif #new_goku_target > 0 and ki_ok then
        Toggles.timer_ok = true
        fsend{random_list_elem(new_goku_target), random_list_elem(target)}
      elseif melee_ok and Player.Mastered["sup"] == nil then
        local alist = skill_filter({"sup"})
        if #alist > 0 then
          send("sup 10")
          send("sup")
        end
      elseif melee_ok and Player.Mastered["scan"] == nil then
        send("scan")
      elseif
        ki_ok and
        melee_ok and
        Player.Mastered["powerup"] == nil or
        Player.Mastered["powerup"] == nil
      then
        send("powerdown")
        send("powerup")
      elseif melee_ok and #UBSLBSSKILLS > 0 then
        local lfight = random_list_elem(UBSLBSSKILLS)
        fsend{lfight, autolearn_target}
      elseif not melee_ok or not ki_ok then
        Toggles.go_rest = true
      end
    end
  end
end

function translate_skill_name(raw)
  local lraw = string.lower(raw)
  local cmd_name = fullname_to_cmd[lraw]
  if cmd_name ~= nil then
    return cmd_name
  end
  return lraw
end

function filter_learn_triggers(adict)
  local nlist = {}
  -- k = skill to learn,  v is table each element must be mastered but first item is learn command
  for k, v in pairs(adict) do
    if Player.Learned[k] ~= true then
      local all_reqs = true
      for _, v1 in ipairs(v) do
        if Player.Mastered[v1] ~= true then
          all_reqs = false
          break
        end
      end
      if all_reqs then
        table.insert(nlist, v[1])
      end
    end
  end
  return nlist
end

function skill_filter(alist, must_be_learned)
  if must_be_learned == nil then
    must_be_learned = false
  end
  local nlist = {}
  for i, v in ipairs(alist) do
    if Player.Mastered[v] ~= true and (not must_be_learned or Player.Learned[v] == true) then
      table.insert(nlist, v)
    end
  end
  return nlist
end

function skill_filter_only_learned(alist)
  local nlist = {}
  for i, v in ipairs(alist) do
    if Player.Learned[v] then
      table.insert(nlist, v)
    end
  end
  return nlist
end

function known_skills()
  local nlist = {}
  for k, _ in pairs(Player.Learned or {}) do
    table.insert(nlist, k)
  end
  return nlist
end