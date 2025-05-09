function main() {
    Globalize(Lgravity)
    // !name, adminlevel (0 is everyone), should block the original message (non functional) function to run, description in !help, requires a sender (set this to true if the command uses player arg in any way)
    Lregistercommand("gravity",0,false,Lgravity,"change the gravity",false)
   
}

function Lgravity(args,outputless){
    if (args.len() == 0 ){
        return false
    }
    SendChatMsg(true,0,Lprefix()+ "Gravity is now "+ args[0],false,false)
    ServerCommand("sv_cheats 1; sv_gravity "+args[0]+"; sv_cheats 0")
    return true
}

