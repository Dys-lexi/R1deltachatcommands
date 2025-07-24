function main() {
    Globalize(Lhostiletf)
    Lregistercommand(["hostiletf", "ht"], 1, true, Lhostiletf, "Play titanfall warning sound for a player. Args: [playername]", true, false)
}

function Lhostiletf(player, args, outputless = false) {
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
        return "Invalid argument count"
    }

    if (GetMapName() == "mp_lobby") {
        return "Cannot run in lobby"
    }

    local playerstothrow = Lgetentitysfromname(args[0])
    local stringout = checkTitans(playerstothrow)

    if (playerstothrow.len() == 1) {
        return stringout
    } else if (playerstothrow.len() == 0) {
        return "No one was found matching " + args[0]
    } else if (playerstothrow.len() > 1) {
        return stringout
    }
}
