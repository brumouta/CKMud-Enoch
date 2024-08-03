
if is_state(State.NORMAL) then
--[[
  if Toggles.jog_east then
     send("west")
     Toggles.jog_east = false
  else
     send("east")
     Toggles.jog_east = true
  end
]]--
  send("down")
end