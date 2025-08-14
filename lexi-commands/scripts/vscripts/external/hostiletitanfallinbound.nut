function main() {
    Globalize(Lhostiletf)
    Lregistercommand(["hostiletf", "ht"], 1, true, Lhostiletf, "Play titanfall warning sound for a player. Args: [playername]", true, false)
}

function Lhostiletf(player, args, returnfunc) {
    function checkTitans(players) {
        local playersranon = ""
        local notatitan = 0
        foreach (pl in players) {
            if (!pl.IsTitan()) {
                notatitan += 1
                continue
            }
            playersranon += pl.GetPlayerName() + ", "
            Remote.CallFunction_NonReplay(pl, "ServerCallback_TitanFallWarning", true)
        }

        if (playersranon == "") {
            return "Everyone was a pilot (" + notatitan + ")"
        }

        playersranon = playersranon.slice(0, playersranon.len() - 2)
        return "Ran on " + playersranon + " (" + (players.len() - notatitan) + "/" + players.len() + ")"
    }

    if (args.len() < 1) {
        returnfunc("Invalid argument count")
        return
    }

    if (GetMapName() == "mp_lobby") {
        returnfunc("Cannot run in lobby")
        return
    }

    local playerstothrow = Lgetentitysfromname(args[0])
    local stringout = checkTitans(playerstothrow)

    if (playerstothrow.len() == 1) {
        returnfunc(stringout)
        return
    } else if (playerstothrow.len() == 0) {
        returnfunc("No one was found matching " + args[0])
        return
    } else if (playerstothrow.len() > 1) {
        returnfunc(stringout)
        return
    }
}
