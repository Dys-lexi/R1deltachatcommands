function main() {
    Globalize(Lskip)
    Lregistercommand("skip",0,false,Lskip,"vote to skip the current map",true)
    Lregistervote("skip",0.5,1,0,120,0)
   
}

function Lskip(player,args,outputless = false){
    local response = Lvote("skip",player)
    // PrintTable(response)
    function skipmap() {
    wait 5
    SetGameState( eGameState.Postmatch )
}
    if (!response.voteispossible) {
         SendChatMsg(player,0,Lprefix()+"not enough people online to pass vote ("+response.votesneeded+" needed)",false,false)
    }
    else if (response.message == "voted") {
        SendChatMsg(true,0,Lprefix()+ player.GetPlayerName() +" Has voted to skip the map ("+response.votes+"/"+response.votesneeded+" votes)",false,false)
        if (response.votepassed) {
            SendChatMsg(true,0,Lprefix()+ "Skipping the map!",false,false)
            // level.matchTimeLimitSeconds <- (level.matchTimeLimitSeconds - Time() +timeextend  * 60.0 ).tofloat()
            thread skipmap()
        }
    }
    else if (response.alreadyvoted) {
        SendChatMsg(true,0,Lprefix()+ player.GetPlayerName() +" Really wants to skip the map! ("+response.votes+"/"+response.votesneeded+" votes)",false,false)
    }
    else {
        SendChatMsg(player,0,Lprefix()+"error with voting",false,false)
    }
    // else if (response.oncooldown) {
    //     SendChatMsg(player,0,Lprefix()+"Extend is on cooldown for " + (response.extendcooldown).tointeger()+ " more seconds",false,false)
    // }
    
    return true
}

