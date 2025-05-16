function main() {
    Globalize(Lextend)
    ::timeextend <- 10  // TIME TO EXTEND MAP
    // !name, adminlevel (0 is everyone), should block the original message (non functional) function to run, description in !help, requires a sender (set this to true if the command uses player arg in any way)
    Lregistercommand(["extend","ex"],0,false,Lextend,"vote to extend the current map",true)
    Lregistervote("extend",0.3,1,0,120,0)
   
}

function Lextend(player,args,outputless = false){
    // PrintTable(level)
    if (GetGameState() != eGameState.Playing){
          LSendChatMsg(player,0,"You must be in a game!",false,false,outputless)
        return
    }
    local response = Lvote("extend",player,1,false,args)
    // PrintTable(response)
        if (!response.voteispossible) {
         LSendChatMsg(player,0,"not enough people online to pass vote ("+response.votesneeded+" needed)",false,false,outputless)
    }
    else if (response.message == "voted") {
        LSendChatMsg(true,0, player.GetPlayerName() +" has voted to extend the map ("+response.votes+"/"+response.votesneeded+" votes)",false,false)
        if (response.votepassed) {
            LSendChatMsg(true,0, "Map extended for "+timeextend+" minutes!",false,false)
            level.nv.gameEndTime +=(timeextend  * 60.0 ).tofloat()
        }
    }
    else if (response.alreadyvoted) {
        LSendChatMsg(true,0, player.GetPlayerName() +" really wants to extend the map! ("+response.votes+"/"+response.votesneeded+" votes)",false,false)
    }
    else if (response.oncooldown) {
        LSendChatMsg(player,0,"Extend is on cooldown for " + (response.extendcooldown).tointeger()+ " more seconds",false,false)
    }
    
    return true
}
