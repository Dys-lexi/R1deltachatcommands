function main() {
    Globalize(Lswitchteam)
    // !name, adminlevel (0 is everyone), should block the original message (non functional) function to run, description in !help, requires a sender (set this to true if the command uses player arg in any way)
    Lregistercommand(["switch","s"],0,false,Lswitchteam,"switch your team",true)
   
}

function Lswitchteam(player,args,outputless = false){
    local forceSwitch = true
    if ( !IsLobby() && !ShouldAutoBalancePlayer( player, forceSwitch )) {
        LSendChatMsg(player,0,"Cannot switch at this time",false,false,outputless)
        return true
    }
    LSendChatMsg(true,0,player.GetPlayerName() +" Switched teams",false,false,outputless)
    AutoBalancePlayer( player, forceSwitch )
    return true
}
