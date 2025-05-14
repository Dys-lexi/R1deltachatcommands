function main() {
    Globalize(Lextend)
    ::timeextend <- 10  // TIME TO EXTEND MAP
    // !name, adminlevel (0 is everyone), should block the original message (non functional) function to run, description in !help, requires a sender (set this to true if the command uses player arg in any way)
    Lregistercommand(["extend","ex"],0,false,Lextend,"vote to extend the current map",true)
    Lregistervote("extend",0.3,1,0,120,0)
   
}

function Lextend(player,args,outputless = false){
    local response = Lvote("extend",player)
    // PrintTable(response)
        if (!response.voteispossible) {
         SendChatMsg(player,0,Lprefix()+"not enough people online to pass vote ("+response.votesneeded+" needed)",false,false)
    }
    else if (response.message == "voted") {
        SendChatMsg(true,0,Lprefix()+ player.GetPlayerName() +" has voted to extend the map ("+response.votes+"/"+response.votesneeded+" votes)",false,false)
        if (response.votepassed) {
            SendChatMsg(true,0,Lprefix()+ "Map extended for "+timeextend+" minutes!",false,false)
            level.matchTimeLimitSeconds <- (level.matchTimeLimitSeconds - Time() +timeextend  * 60.0 ).tofloat()
        }
    }
    else if (response.alreadyvoted) {
        SendChatMsg(true,0,Lprefix()+ player.GetPlayerName() +" really wants to extend the map! ("+response.votes+"/"+response.votesneeded+" votes)",false,false)
    }
    else if (response.oncooldown) {
        SendChatMsg(player,0,Lprefix()+"Extend is on cooldown for " + (response.extendcooldown).tointeger()+ " more seconds",false,false)
    }
    
    return true
}
