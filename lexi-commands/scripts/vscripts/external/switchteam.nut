function main() {
    Globalize(Lswitchteam)
    // !name, adminlevel (0 is everyone), should block the original message (non functional) function to run, description in !help, requires a sender (set this to true if the command uses player arg in any way)
    Lregistercommand(["switch","s"],0,false,Lswitchteam,"switch your team",true)
   
}

function Lswitchteam(player,args,outputless = false){
    LSendChatMsg(true,0,player.GetPlayerName() +" Switched teams",false,false,outputless)
    player.TrueTeamSwitch()
    return true
}
