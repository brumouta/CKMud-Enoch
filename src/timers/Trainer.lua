local ran = math.random()
if PromptCounters.timer_ok == nil or (PromptCounters.timer_ok <= 15 and not Toggles.fighting) then
  Toggles.timer_ok = true
end
Counters = Counters or {}
Counters.timer_trainer = Counters.timer_trainer or 0
local new_melee = {"justice", "supergodfist"}
local new_ki = {}
local new_other = {}
local new_aoe = {}
local new_goku_target = {}
local target = {"gine", "roshi", "teragon", "malak", "bubbles", "cypher"}
if is_connected() then
  if Toggles.botmode and is_state(State.NORMAL) and PromptFlags.timertrainer == nil then
    PromptFlags.timertrainer = true
    --Toggles.timer_ok = false
    ---fight("name")
    if true and Toggles.timer_ok then
      --(Player.FATIGUE <= 90 and Player.KI > 20) then
      if Player.FATIGUE <= 90 and #new_melee > 0 then
        Toggles.timer_ok = false
        PromptCounters.timer_ok = 20
        send(random_list_elem(new_melee) .. " child")
      elseif energy_cost(1000) and #new_ki > 0 then
        Toggles.timer_ok = false
        PromptCounters.timer_ok = 20
        send(random_list_elem(new_ki) .. " child")
      elseif #new_other > 0 and Player.FATIGUE < 90 and Player.KI > 20 then
        Toggles.timer_ok = false
        PromptCounters.timer_ok = 20
        send(random_list_elem(new_other) .. " child")
      elseif #new_aoe > 0 and Player.KI > 20 then
        Toggles.timer_ok = false
        PromptCounters.timer_ok = 20
        send(random_list_elem(new_aoe))
      elseif ran < 1 / 6 and #new_goku_target > 0 and Player.KI > 21 then
        Toggles.timer_ok = false
        PromptCounters.timer_ok = 20
        send(random_list_elem(new_goku_target) .. " " .. random_list_elem(target))
      end
    end
    if false and Toggles.timer_ok then
      Toggles.timer_ok = false
      -- do something here
      if Player.HEALTH < 75 and Player.KI > 15 then
        heal()
      end
      if not Toggles.fighting and Player.HEALTH < 95 and Player.KI > 20 then
        heal()
      end
      if not Toggles.fighting and last(Times.lastrip) > 600 then
        Times.lastrip = getEpoch()
        send("focus 'portal' lancer")
        --send("sense vision")
        --send("auto void vision")
      end
      if Player.HEALTH > 90 and Player.KI > 20 then
        if Player.FATIGUE < 90 then
          Counters.timer_trainer = Counters.timer_trainer + 1
          if Counters.timer_trainer >= 3 then
            send("sense lancer")
            Counters.timer_trainer = 0
          end
          send("void")
        end
      end
    end
  end
end