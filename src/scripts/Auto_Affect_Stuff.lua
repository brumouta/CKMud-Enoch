local list_of_affects =
  {
    "celestial shield",
    "celestial drain",
    "demonic will",
    "energy shield",
    "barrier",
    "hasshuken",
    "herculean force",
    "resonance",
    "zanzoken",
    "kino tsurugi",
    "regenerate",
  }

function handleBuffs(seen)
  for _, affect in ipairs(skill_filter_only_learned(list_of_affects)) do
    if not seen[affect] and is_state(State.NORMAL, true) then
      echoc("\n<cyan>Need Rebuff: " .. affect)
      focus_buff(affect)
    end
  end
end

function focus_buff(affect)
  send("focus '" .. affect .. "'")
end