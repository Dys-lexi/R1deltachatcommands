function main() {
    Globalize(Lswitchteam)
    Lregistercommand("switch",0,false,Lswitchteam,"switch your team")
   
}

function Lswitchteam(player,args,outputless = false){
    SendChatMsg(true,0,Lprefix()+ player.GetPlayerName() +" Switched teams",false,false)
    player.TrueTeamSwitch()
    return true
}

