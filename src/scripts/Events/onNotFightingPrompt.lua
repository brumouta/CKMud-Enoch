

function onNotFightingPrompt()
  Toggles.EnemyLineComboTest = true
  Toggles.skip_fight = nil
  if false and is_state(State.NORMAL, true) and not Player.SUPPRESSED then
    send("suppress 69")
  end
  -- Remove when we have repair logic
  if is_state(State.REPAIR) then
    echoc("Set state Normal")
    set_state(State.NORMAL)
  end
  -- Botmode Auto Sleep
  if Toggles.learning and is_state(State.NORMAL) and (Player.KI <= 20 and Player.FATIGUE >= 90) or Toggles.go_rest then
    set_state(State.REST)
    Toggles.wakeok = true
    Toggles.go_rest = false

    -- One Shot Event Register
    registerAnonymousEventHandler(
      "sysSpeedwalkFinished",
      function()
        send("sleep")
      end,
      true
    )
    speedwalk(sleepwalk_target, false, 0.5)

  end
  -- Botmode Auto Wake
  if Toggles.wakeok and Toggles.learning and is_state(State.REST) and (Player.KI >= 100 and Player.FATIGUE <= 0) then
    send("wake")
    Toggles.wakeok = false

    registerAnonymousEventHandler(
      "sysSpeedwalkFinished",
      function()
        set_state(State.NORMAL)
      end,
      true
    )
    speedwalk(sleepwalk_target, true, 0.5)

  end
  
  if Toggles.training and is_state(State.REST) and (Player.KI >= 99 and Player.FATIGUE <= 3) then
    send("wake")
    send("drink fountain")
    --send("eat nugget")
    send("east")
    --send("south")
    do_train()
    set_state(State.NORMAL)
  end
  -- After a copy over we might just be sitting there.
  if
    Toggles.training and
    is_state(State.NORMAL) and
    last(Times.lastxpgain) > 60 and
    Player.KI == 100 and
    Player.FATIGUE == 0
  then
    send("east")
    --send("east")
    do_train()
  end
  if is_state(State.NORMAL, true) and last(Times.laststatus) > 120 then
    send("status")
    Times.laststatus = getEpoch()
  end
  if is_state(State.NORMAL, true) and last(Times.lastscore) > 240 then
    send("score")
    Times.lastscore = getEpoch()
  end
  if false and is_state(State.NORMAL, true) and last(Times.lasttrain) > 120 then
    send("train")
    Times.lasttrain = getEpoch()
  end
  if is_state(State.NORMAL, true) and Player.KI == 100 and last(Times.lastscouterself) > 900 then
    send("analyze self")
    Times.lastscouterself = getEpoch()
  end
  -- Handle Send Queue
  SendQueue.trySendNow()
  if not SendQueue.hasnext() then
    -- Handle Action Queue
    ActionQueue.doAction()
  end
end