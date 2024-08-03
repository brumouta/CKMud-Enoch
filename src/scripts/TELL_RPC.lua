--[[
This parses !cmd from tell messages and handles replies
]]
local fried = require("CKMud-Enoch.fried")

local rpc_methods =
  {
    ["!help"] =
      function(who, args)
        tell_reply(who, "FriedBot Commands: !version, !maxpl, !zenni, !aoe, !stats, !prompt, !auction senzu [token]")
      end,
    ["!disconnect"] =
      function(who, args)
        local allow_list = string.split(fried:read_constant("alt_list"), ",")
        if table.contains(allow_list, who) then
          tell_reply(who, "Sure Thing Buddy!")
          send("quit")
          registerAnonymousEventHandler("sysDisconnectionEvent", disconnect, true)
        else
          tell_reply(who, "Nice Try "..who)
        end
      end,
    ["!version"] =
      function(who, args)
        tell_reply(who, "__PKGNAME__ v__VERSION__ by Fried")
      end,
    ["!maxpl"] =
      function(who, args)
        tell_reply(who, "Current Max PL is " .. reformatInt(Player.MAXPL))
      end,
    ["!zenni"] =
      function(who, args)
        tell_reply(who, "Current Zenni: " .. reformatInt(Player.MONEY))
      end,
    ["!aoe"] =
      function(who, args)
        local supreme = Player.Supreme["void"] or false
        local boosted = Player.Boosted["void"] or false
        local tdamage = math.floor(ki_dam(supreme, boosted) * .75)
        if Player.HT then
          tdamage = math.floor(tdamage * 1.20)
        end
        tell_reply(who, "Approximate 'Void Wave' dmg: " .. reformatInt(tdamage))
      end,
    ["!stats"] =
      function(who, args)
        tell_reply(
          who,
          string.format(
            "Hitroll: %d  Damroll: %d; UBS/LBS: %d/%d; Strength: %d (%d)  Speed: %d (%d)  Wisdom: %d (%d)  Intellect: %d (%d)",
            Player.HITROLL,
            Player.DAMROLL,
            Player.UBS,
            Player.LBS,
            Player.BaseStats.STR,
            Player.Stats.STR,
            Player.BaseStats.SPD,
            Player.Stats.SPD,
            Player.BaseStats.WIS,
            Player.Stats.WIS,
            Player.BaseStats.INT,
            Player.Stats.INT
          )
        )
      end,
    ["!prompt"] =
      function(who, args)
        tell_reply(
          who,
          string.format(
            "[PL: %d%% | Ki: %d%% | Fatigue: %d%%] %s%s",
            Player.HEALTH,
            Player.KI,
            Player.FATIGUE,
            Player.HT and "[HT]" or "",
            Player.FLYING and "[FLY]" or ""
          )
        )
      end,
    ["!auction"] =
      function(who, args)
        if args == "senzu" then
          send("get bean bag", false)
          send("auction bean 125000", false)  
        elseif args == "senzu token" then
          send("get bean bag", false)
          send("auction bean token 1", false)
        end
      end,
  }

function tell_reply(who, msg)
  send("tell " .. who .. " " .. msg, false)
end

function handle_tell_rpc(who, what)
  local expanded_args = what:split(" ")
  local cmd = expanded_args[1]
  local rpc = rpc_methods[cmd]
  if rpc then
    rpc(who, table.concat(expanded_args, " ", 2))
  end
end