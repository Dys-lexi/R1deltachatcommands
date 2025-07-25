function main() {
    Lregistercommand("playing",4,false,Lplaying,"get who is playing",false)
    Lregistercommand("playingpoll",4,false,Lplayingidentitys,"poll players",false)
    Globalize(Lplaying)
    ::peoplejointimes <- {}
    AddCallback_OnClientConnected(Lonjoinplaying)
}
function Lonjoinplaying(player) {
    peoplejointimes[player.GetUserId()] <-  GetUnixTimestamp()
}
function Lplayingidentitys(args,outputless = false){
    local stats = {}
    foreach (player in GetPlayerArray()){
        local playerstat = []
        playerstat.append(player.GetPlayerName())
        // playerstat.playerip <- player.GetPlayerIP() not used anywhere, removed to save space
        playerstat.append(UpdateScore(player))
        // playerstat.team <- player.GetTeam() == TEAM_IMC ? "imc" : "militia" not used anywhere, save space
        playerstat.append(UpdateKills(player))
        playerstat.append(UpdateDeaths(player))
        playerstat.append(UpdateTitanKills(player))
        playerstat.append(UpdateNPCKills(player))
        if (ArrayContains(TableKeysToArray(peoplejointimes),player.GetUserId())){
        playerstat.append(peoplejointimes[player.GetUserId()])}
        else{
            Lonjoinplaying(player)
             playerstat.append(peoplejointimes[player.GetUserId()])
        }
        stats[player.GetPlatformUserId()] <- playerstat   
    }
    local meta = {}
    meta.map <- GetMapName()
    meta.matchid <- GetConVarString("autocvar_matchid")
    stats.meta <- meta
    return Loutputtable(stats)
}
function Lplaying(args,outputless = false) {
        local MAPS = {}
    MAPS.mp_airbase          <- "Airbase"
    MAPS.mp_angel_city       <- "Angel City"
    MAPS.mp_boneyard         <- "Boneyard"
    MAPS.mp_colony           <- "Colony"
    MAPS.mp_corporate        <- "Corporate"
    MAPS.mp_fracture         <- "Fracture"
    MAPS.mp_lagoon           <- "Lagoon"
    MAPS.mp_nexus            <- "Nexus"
    MAPS.mp_outpost_207      <- "Outpost 207"
    MAPS.mp_overlook         <- "Overlook"
    MAPS.mp_relic            <- "Relic"
    MAPS.mp_rise             <- "Rise"
    MAPS.mp_smugglers_cove   <- "Smuggler's Cove"
    MAPS.mp_training_ground  <- "Training Ground"
    MAPS.mp_wargames         <- "War Games"
    MAPS.mp_runoff           <- "Runoff"
    MAPS.mp_swampland        <- "Swampland"
    MAPS.mp_haven            <- "Haven"
    MAPS.mp_switchback       <- "Export"
    MAPS.mp_backwater        <- "Backwater"
    MAPS.mp_sandtrap         <- "Sand Trap"
    MAPS.mp_harmony_mines    <- "Dig Site"
    MAPS.mp_zone_18          <- "Zone 18"
    MAPS.mp_mia              <- "M.I.A"
    MAPS.mp_nest2            <- "Nest 2"
    MAPS.mp_box              <- "Box"
    MAPS.mp_npe              <- "Training"
    MAPS.mp_o2               <- "Demeter"
    MAPS.mp_lobby            <- "Lobby"

    //  LSendChatMsg(player,0,"Include a map name! eg: !nm angel" ,false,false,outputless)
    local stats = {}
    foreach (player in GetPlayerArray()) {
   
        stats[player.GetPlayerName()] <- [UpdateScore(player),player.GetTeam() == TEAM_IMC ? "imc" : "militia",UpdateKills(player),UpdateDeaths(player)]
        // else{
        //     stats[player.GetPlayerName()] <- [0,player.GetTeam() == TEAM_IMC ? "imc" : "militia",0,0]
        // }
    }
    if (GetGameState() == eGameState.Playing){
    stats.meta <- [ MAPS[GetMapName()],level.nv.gameEndTime-Time()]
    }
    else{
    stats.meta <- [ MAPS[GetMapName()],0] 
    }
    return Loutputtable(stats)

}

