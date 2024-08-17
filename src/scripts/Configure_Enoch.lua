local fried = require("__PKGNAME__.fried")

-- Initalize the used Tables
registerAnonymousEventHandler(
  "sysLoadEvent",
  fried:run_init(
  "__PKGNAME__ v__VERSION__",
  function()
    Counters = {}
    Player = {}
    Times = {}
    Timers = {}
    Toggles = {}
    PromptCounters = {}
    PromptFlags = {}
    -- Auto Learning / Mastery
    Player.Learned = {}
    Player.Mastered = {}
    Player.Boosted = {}
    Player.Supreme = {}
    
    -- Toggle Defaults
    Toggles.standing = true
    Toggles.no_fight = false
    Toggles.wakeok = true
  end
))