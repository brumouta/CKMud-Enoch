if is_connected() and (Toggles.botmode or Toggles.training) then
if last(Times.lastprompt) > 8 then
  send("\n")
end
end