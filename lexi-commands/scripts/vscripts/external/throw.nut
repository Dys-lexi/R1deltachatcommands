function main() {
    Globalize(Lthrow)
    Lregistercommand("throw",10,false,Lthrow,"throw a player into the air",true,false)
   
}

function Lthrow(player,args,outputless = false){
    if (args.len() != 1){
        return "invalid argument count"
    }
    // ServerCommand ("banid "+GetPlayerSlot(player)) 
    // local plusone = GetPlayerSlot(player) +1
    // local minusone = GetPlayerSlot(player)  -1
    // ServerCommand ("banid "+plusone) 
    // ServerCommand ("banid "+minusone) 
    // printt("OUTPUT BEGIN")
    // ServerCommand("status")
    // printt("OUTPUT HERE "+ GetPlayerSlot(player) + player.GetEntIndex()+ "boop "+ player.GetPlayerIndex())
    local playerstothrow = Lgetentitysfromname(args[0])
    foreach (player2 in playerstothrow){
    if (!outputless){
        SendChatMsg(true,0,Lprefix()+ player2.GetPlayerName() +" thrown",false,false)}
    player2.SetVelocity( Vector(0,0,50000))}
    if (playerstothrow.len() == 1){

    return playerstothrow[0].GetPlayerName() +" thrown"}
    else if (playerstothrow.len() == 0){
    return "no one was found matching "+name}
      else if (playerstothrow.len() > 1){
    return "threw "+playerstothrow.len() + " players"}
}
