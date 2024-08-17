function onFightingPrompt(val)
  
  if last(Times.lastfight) > 4 and PromptFlags.fighting then
    if not Toggles.no_fight then

        fight(nil)


    end
  end
  if
    is_state(State.CRAFTING, true) or is_state(State.BUFFING, true) or is_state(State.SENSE, true)
  then
    set_state(State.NORMAL)
  end
end