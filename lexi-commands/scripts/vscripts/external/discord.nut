function main() {
    Globalize(Ldiscord)
    // !name, adminlevel (0 is everyone), should block the original message (non functional) function to run, description in !help, requires a sender (set this to true if the command uses player arg in any way)
    Lregistercommand(["discord","d"],0,false,Ldiscord,"Join the discord!",true)
   
}

function Ldiscord(player,args,outputless = false){
    LSendChatMsg(true,0,"Join the discord at: https://discord.gg/QghRYjSJ84",false,false,outputless)
}
