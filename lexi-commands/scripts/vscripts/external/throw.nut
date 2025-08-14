function main() {
    Globalize(Lthrow)
    Lregistercommand("throw",1,true,Lthrow,"throw a player into the air args: [playername]",true,false)
   
}


function Lthrow(player,args,returnfunc){
    function makesuretheyarethrown(player){
        local tries = 10
        while (tries > 0) {
            if (IsAlive(player)) {
                player.SetVelocity( Vector(0,0,10000))
                wait(0.05)
                // printt(player.GetVelocity().z+"woa")
                if (player.GetVelocity().z > 2500) {
                    break
                }
                
            }
            tries -=1
            wait 0.5
        }
}


    if (args.len() < 1){
        returnfunc("invalid argument count")
        return
    }
    if (GetMapName() == "mp_lobby") {
        returnfunc("Cannot throw in the lobby")
        return
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

            returnfunc(player2.GetPlayerName() +" thrown", true)
        thread makesuretheyarethrown(player2)
    }
    if (playerstothrow.len() == 1){

    returnfunc(playerstothrow[0].GetPlayerName() +" thrown")
    return}
    else if (playerstothrow.len() == 0){
    returnfunc("no one was found matching "+args[0])
    return}
      else if (playerstothrow.len() > 1){
    returnfunc("threw "+playerstothrow.len() + " players")
    return}
}

