function main() {
    Globalize(Lextend)
    ::timeextend <- 10  // TIME TO EXTEND MAP
    // !name, adminlevel (0 is everyone), should block the original message (non functional) function to run, description in !help, requires a sender (set this to true if the command uses player arg in any way)
    Lregistercommand(["extend","ex"],0,false,Lextend,"vote to extend the current map",true)
    Lregistervote("extend",0.3,1,0,120,0)
   
}

function Lextend(player,args,returnfunc){
    // PrintTable(level)
             LSendChatMsg(true,0, GetRoundTimeLimit_ForGameMode()+"wdw"+GameTime.TimeLeftSeconds()+" "+GetServerVar( "gameEndTime" )+ " "+(GetCurrentPlaylistVarInt("AT_timelimit", 10)) ,false,false)
             
    if (GetGameState() != eGameState.Playing){
          returnfunc("You must be in a game!")
        return
    }
    local response = Lvote("extend",player,1,false,args)
    // PrintTable(response)
        if (!response.voteispossible) {
         returnfunc("not enough people online to pass vote ("+response.votesneeded+" needed)")
    }
    else if (response.message == "voted") {
        returnfunc(player.GetPlayerName() +" has voted to extend the map ("+response.votes+"/"+response.votesneeded+" votes)", true)
        if (response.votepassed) {
            returnfunc("Map extended for "+timeextend+" minutes!", true)
   
            level.nv.gameEndTime +=(timeextend  * 60.0 ).tointeger()
//             SetServerVar("gameEndTime",(GetServerVar( "gameEndTime" ) +timeextend*60) .tointeger() + "")
// SetPlaylistVarOverride("CP_timelimit", (GetCurrentPlaylistVarInt("CP_timelimit", 10) + timeextend) + "")
// SetPlaylistVarOverride("AT_timelimit", (GetCurrentPlaylistVarInt("AT_timelimit", 10) + timeextend) + "")
// SetPlaylistVarOverride("CTF_timelimit", (GetCurrentPlaylistVarInt("CTF_timelimit", 10) + timeextend) + "")
// SetPlaylistVarOverride("PS_timelimit", (GetCurrentPlaylistVarInt("PS_timelimit", 15) + timeextend) + "")
// SetPlaylistVarOverride("HEIST_timelimit", (GetCurrentPlaylistVarInt("HEIST_timelimit", 6) + timeextend) + "")
// SetPlaylistVarOverride("BB_timelimit", (GetCurrentPlaylistVarInt("BB_timelimit", 6) + timeextend) + "")
// SetPlaylistVarOverride("SCV_timelimit", (GetCurrentPlaylistVarInt("SCV_timelimit", 10) + timeextend) + "")
// SetPlaylistVarOverride("TDM_timelimit", (GetCurrentPlaylistVarInt("TDM_timelimit", 10) + timeextend) + "")

        }
    }
    else if (response.alreadyvoted) {
        returnfunc(player.GetPlayerName() +" really wants to extend the map! ("+response.votes+"/"+response.votesneeded+" votes)", true)
    }
    else if (response.oncooldown) {
        returnfunc("Extend is on cooldown for " + (response.extendcooldown).tointeger()+ " more seconds")
    }
    
    return true
}
