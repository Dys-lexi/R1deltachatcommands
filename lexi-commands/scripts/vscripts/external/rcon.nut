function main() {
    Globalize(Lrcon)
    // !name, adminlevel (0 is everyone), should block the original message (non functional) function to run, description in !help, requires a sender (set this to true if the command uses player arg in any way)
    Lregistercommand(["rcon","r"],1,true,Lrcon,"run a server command",true,true)
   
}

function Lrcon(player,args,outputless = false){
    
    if (args.len() == 0){
        return false
    }
    local command = ""
    foreach (arg in args){
        command += arg + " "
    }
    LSendChatMsg(player,0,"running "+ command,false,false,outputless)
    ServerCommand(command)
    return true
}
