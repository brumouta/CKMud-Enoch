
function toggle_trainingmode()
  if Toggles.training then
    -- disable it
    Toggles.training = false
    echo("Training Mode Disabled!!!")
  else
    Toggles.training = true
    Toggles.botmode = false
    echo("Training Mode Enabled!!!")
    do_train()
  end
end

function do_train()
  -- Lie fix later
  Times.lastxpgain = getEpoch()
  if Player.FLYING then
    send("land")
  end
  local g = math.min(math.floor((1/5000)*0.06*Player.MAXPL), (max_gravity or 2) - 1)
  send("adjust "..g)
  
  --[[
  send("focus 'multiform'")
  send("focus 'multiform'")
  send("focus 'multiform'")
  
  send("chou enoch")
  send("chou enoch")
  send("chou enoch")
  ]]
  
  random_train()
  --send("adjust 1")
  --send("meditate")
  --send("study")
  --send("situp")
  --send("pushup")
  --Toggles.jog_east = false
  --send("jog")
  --send("down")
end

function rand_stat()
  -- Find the smallest stat
  local stat = nil
  for id, value in pairs(Player.BaseStats) do
    if not stat or Player.BaseStats[stat] > Player.BaseStats[id] then
      stat = id
    end
  end
  return stat
end

function random_train()
  local trains =
    {
      ["STR"] =
        function()
          if (Player.UBS < 100 or Player.LBS < 100) then
            -- Do exercise based on UBS/LBS
            if Player.UBS < Player.LBS then
              send("pushup")
            else
              send("situp")
            end
          elseif math.random() < 0.5 then
            -- Pick one at random since we at 100 for UBS/LBS
            send("situp")
          else
            send("pushup")
          end
        end,
      ["SPD"] =
        function()
          Toggles.jog_east = false
          send("jog")
          send("down")
        end,
      ["INT"] =
        function()
          send("study")
        end,
      ["WIS"] =
        function()
          send("meditate")
        end,
    }
  local stat = rand_stat()
  trains[stat]()
end

function do_rest()
  local avg_inc = total / xp_count
  echoc("<red> Avg_inc " .. avg_inc)
  total = nil
  xp_count = nil
  if false and avg_inc < 450 and gravity < max_gravity - 1 then
    echoc("<green>Increasing Gravity")
    gravity = gravity + 1
  end
  set_state(State.REST)
  send("west")
  send("drink fountain")
  --send("heal")
  --send("revitalize")
  --send("north")
  send("sleep")
end