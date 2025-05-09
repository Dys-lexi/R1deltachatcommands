function main() {
    Globalize(Lswitchteam)
    // !name, adminlevel (0 is everyone), should block the original message (non functional) function to run, description in !help, requires a sender (set this to true if the command uses player arg in any way)
    Lregistercommand("switch",0,false,Lswitchteam,"switch your team",true)
   
}

function Lswitchteam(player,args,outputless = false){
    SendChatMsg(true,0,Lprefix()+ player.GetPlayerName() +" Switched teams",false,false)
    player.TrueTeamSwitch()
    return true
}

