function main() {
    Globalize(Lskip)
    Lregistercommand("skip",0,false,Lskip,"vote to skip the current map",true)
    Lregistervote("skip",0.5,1,0,120,0)
   
}

function Lskip(player,args,outputless = false){
    local response = Lvote("skip",player,1,false,args)
    // PrintTable(response)
    function skipmap() {
    wait 5
    SetGameState( eGameState.Postmatch )
}
    if (!response.voteispossible) {
         LSendChatMsg(player,0,"not enough people online to pass vote ("+response.votesneeded+" needed)",false,false,outputless)
    }
    else if (response.message == "voted") {
        LSendChatMsg(true,0, player.GetPlayerName() +" has voted to skip the map ("+response.votes+"/"+response.votesneeded+" votes)",false,false)
        if (response.votepassed) {
            LSendChatMsg(true,0, "Skipping the map!",false,false)
            // level.matchTimeLimitSeconds <- (level.matchTimeLimitSeconds - Time() +timeextend  * 60.0 ).tofloat()
            thread skipmap()
        }
    }
    else if (response.alreadyvoted) {
        LSendChatMsg(true,0, player.GetPlayerName() +" Really wants to skip the map! ("+response.votes+"/"+response.votesneeded+" votes)",false,false)
    }
    else {
        LSendChatMsg(player,0,"error with voting",false,false,outputless)
    }
    // else if (response.oncooldown) {
    //     LSendChatMsg(player,0,"Extend is on cooldown for " + (response.extendcooldown).tointeger()+ " more seconds",false,false)
    // }
    
    return true
}

