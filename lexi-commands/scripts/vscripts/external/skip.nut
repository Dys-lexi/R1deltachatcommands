function main() {
    Globalize(Lskip)
    Lregistercommand("skip",0,false,Lskip,"vote to skip the current map",true)
    Lregistervote("skip",0.5,1,0,120,0)
   
}

function Lskip(player,args,returnfunc){
    local response = Lvote("skip",player,1,false,args)
    // PrintTable(response)
    function skipmap() {
    wait 5
    SetGameState( eGameState.Postmatch )
}
    if (!response.voteispossible) {
         returnfunc("not enough people online to pass vote ("+response.votesneeded+" needed)")
    }
    else if (response.message == "voted") {
        returnfunc(player.GetPlayerName() +" has voted to skip the map ("+response.votes+"/"+response.votesneeded+" votes)", true)
        if (response.votepassed) {
            returnfunc("Skipping the map!", true)
            // level.matchTimeLimitSeconds <- (level.matchTimeLimitSeconds - Time() +timeextend  * 60.0 ).tofloat()
            thread skipmap()
        }
    }
    else if (response.alreadyvoted) {
        returnfunc(player.GetPlayerName() +" Really wants to skip the map! ("+response.votes+"/"+response.votesneeded+" votes)", true)
    }
    else {
        returnfunc("error with voting")
    }
    // else if (response.oncooldown) {
    //     LSendChatMsg(player,0,"Extend is on cooldown for " + (response.extendcooldown).tointeger()+ " more seconds",false,false)
    // }
    
    return true
}

