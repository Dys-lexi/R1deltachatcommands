function main() {
    Globalize(Lthrow)
    Lregistercommand("throw",10,false,Lthrow,"throw a player into the air",true,false)
   
}

function Lthrow(player,args,outputless = false){
    if (args.len() != 1){
        return "invalid argument count"
    }
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
