-- define Enoch_example_script() for use as an event handler
function Enoch_example_script(event, ...)
  echo("Received event " .. event .. " with arguments:\n")
  display(...)
end
