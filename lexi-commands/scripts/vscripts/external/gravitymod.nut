function main() {
    Globalize(Lgravity)
    Lregistercommand("gravity",10,false,Lgravity,"change the gravity",false)
   
}

function Lgravity(args,outputless){
    if (args.len() == 0 ){
        return false
    }
    SendChatMsg(true,0,Lprefix()+ "Gravity is now "+ args[0],false,false)
    ServerCommand("sv_cheats 1; sv_gravity "+args[0]+"; sv_cheats 0")
    return true
}

