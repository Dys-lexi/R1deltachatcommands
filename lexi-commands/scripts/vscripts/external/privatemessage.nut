function main() {
    Globalize(privatemessage)
    // !name, adminlevel (0 is everyone), should block the original message (non functional) function to run, description in !help, requires a sender (set this to true if the command uses player arg in any way)
    Lregistercommand(["privatemessage","pm"],4,false,privatemessage,"private message somone",false)
   
}

function privatemessage(args,outputless = false){
    // local players = Lgetentitysfromname(args[0])
    // printt("xyzabc "+ args.len()+ "   "+args[0])
    // PrintTable(args)
    local player = GetEntByIndex(args[0].tointeger())
    local chatmessage = ""
    args.remove(0)

    foreach (word in args){
        chatmessage += word + " "}
    LSendChatMsg(player,0,chatmessage,false,false,false)
    // LSendChatMsg(player,0,"blurp",false,false,false)
    return true
 
}
