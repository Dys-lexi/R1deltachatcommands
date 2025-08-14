function main() {
    Globalize(Lgravity)
    Lregistercommand("gravity",1,true,Lgravity,"change the gravity args: [gravity]",false)
   
}

function Lgravity(args,returnfunc){
    if (args.len() == 0 ){
        return false
    }
    returnfunc("Gravity is now "+ args[0], true)
    ServerCommand("sv_cheats 1; sv_gravity "+args[0]+"; sv_cheats 0")
    return true
}

