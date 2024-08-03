function sense(target)
  set_state(State.SENSE)
  state_extra(target)
  sense_target = target
  send("sense " .. target)
  Times.lastsense = getEpoch()
end