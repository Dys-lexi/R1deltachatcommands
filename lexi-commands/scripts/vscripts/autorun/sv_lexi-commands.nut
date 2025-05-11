function main() {

    local modfilenames = [
    "switchteam",
    // "lexi-chatbridge",
    "gravitymod",
    "throw"
    "nominate"
    ]



    // printt("OQMIOFQWNIOFNQWOQNWIF")
    ::registeredcommands <- {}
    ::registercommandsasconvar <- false // don't change this to true, unless you know what it does it does nothing now, but keep it false
    // if it's true and you don't know what it does, make it false
    // print("LOADDDED WOOOOOP WOOOP")
    // thread Iwanttorepeatthismessage ()
    Globalize(Lregistercommand)
    Globalize(Lprefix)
    Globalize(Lgetentitysfromname)
    Globalize(Lrconcommand)
    Globalize(Laddusedcommandtotable)
    AddCallback_OnClientChatMsg(onmessage)
    AddCallback_OnClientConnected(onjoin)

    Lregistercommand("help",0,false,helpfunction,"get help",true)
    // printt("BOOOOP"+GetConVarString("autocvar_Lcommandreader"))
    AutoCVar("Lcommandreader", "")
    // AddCallback_OnPlayerKilled
    AddClientCommandCallback( "l", commandrunner )
    foreach (mod in modfilenames) {
        printt("loading commandfile "+mod)
        IncludeFile(format("external/%s", mod))
    }
   
}

// if (Lcommandcheck(["switch","st"],0,command))

function Lrconcommand(keyword,args = [],id = RandomInt( 0, 10000 )){
    print("PING<PING/>PING")
    // ServerCommand("sv_cheats 0 ")
        // printt(args)
        // printt(Time() + "w")
         local foundsomething = false
        foreach( key, val in registeredcommands) {
           
                    // printt("HEREEREREERE|"+ key + "|" + keyword + "|  woa")
                    if (keyword == key) {
                        // printt("HERE2")
                        foundsomething = true
                        local player = 0
                        local match = "what"
                        if (typeof args == "string"){
                                args = [args]
                            }
                        if (val.requiressender){
                            if (args.len() == 0){
                                 printt("OUTPUT<Invalid params/>ENDOUTPUT")
                            }
                            match = Lgetentitysfromname(args[0])
                            if (match.len() > 1 && val.onlyonematch){
                                printt("OUTPUT<"+match.len()+" Player matches found. should only be one match."+"/>ENDOUTPUT")
                                return false
                            }
                            else if (match.len() == 0){
                                printt("OUTPUT<"+"No matches to the name "+args[0]+" found/>ENDOUTPUT")
                                return false
                            }
                            else{player = match[0]}
                        //    args.remove(0)
                            keyword = keyword.tolower() 
                            
                        }
                        // printt("HERE3")

                        // printt("running " + key + "For "+player.GetPlayerName())

                        // printt("HERE4")
                        
                        local output = false
                        if (val.requiressender) {
                          output = val.inputfunction(player,args,true)}
                        else {
                             output = val.inputfunction(args,true)
                        }
                        printt("OUTPUT<"+output+"/>ENDOUTPUT")
                        // Laddusedcommandtotable("auto","console_rcon", output, id)
                    }

            }
            if (!foundsomething) {
                printt("OUTPUT<Command not found/>ENDOUTPUT")
            }


}

function commandrunner(player, args) {
        printt("comamnd")
        
        local outputarg = args
        // foreach(arg in args){
        //     outputarg+= " " + arg
        // }
        printt("outputaaarg"+outputarg)
        onmessage(player,outputarg,false)
    }

function Lregistercommand(keywords,adminlevel,blockchatmessage,inputfunction,description,requiressender = true,onlyonematch = true){
    local Aliases = ""
    if (type(keywords) == "string"){
        Aliases = keywords
        keywords = [keywords]
 
    }
    else{
        Aliases = keywords[0]
        for (local i = 1; i < keywords.len() ;i++)
        {
            Aliases += "\x1b[38;5;254m, \x1b[38;5;201m"+keywords[i]
        }
    }
    
    local commandid = registeredcommands.len()
    foreach(keyword in keywords){
        local command = {}
        printt("registering command " + keyword)
        command.description <- description
        command.adminlevel <- adminlevel
        command.blockchatmessage <- blockchatmessage
        command.inputfunction <- inputfunction
        command.requiressender <- requiressender
        command.onlyonematch <- onlyonematch
        command.id <- commandid
        command.Aliases <- Aliases
        registeredcommands[ keyword ] <- command

        
    }
}

function helpfunction(player,args,outputless = false) {
    SendChatMsg(player,0,Lprefix()+ "help menu!",false,false)
    local sentids = []
    foreach( key, val in registeredcommands) {
        if (val.adminlevel != 0 || ArrayContains(sentids,val.id)) {
            continue
        }
        sentids.append(val.id)
        SendChatMsg(player,0,Lprefix()+"\x1b[38;5;201m" +val.Aliases+": \x1b[38;5;254m "+ val.description ,false,false)
    }
    return true
}

function Lgetentitysfromname(name) {
    local output = []
    if (name == "_") {
        return GetPlayerArray()
    }
    foreach(player in GetPlayerArray()){
        if (StringContains(player.GetPlayerName().tolower() ,name.tolower() )){
            output.append(player)
        }
    }

    return output
}
// function Iwanttorepeatthismessage() {
//     while (true) {
//         printt("hai" +helloworld)
//         SendChatMsg(true,0,"hello from the server",false,false)
//         wait 1
//     }
// }
function onjoin(player) {
    SendChatMsg(player,0,Lprefix()+"Welcome "+player.GetPlayerName() +", type !help for commands",false,false)
}

function Lprefix(){
    return "\x1b[38;5;190m[Lexicmd]\x1b[38;5;254m "
}

function onmessage(whosentit, message, isteamchat)
{
        local output = "**"+GetEntByIndex(whosentit).GetPlayerName() + "**: " + message
        if (registercommandsasconvar) {
        Laddusedcommandtotable(output,"chat_message")}
        
        // printt("chat message sent by" + whosentit + " length of getplayerarray is " +GetPlayerArray().len())
        // "inspired" very heavily from kcommands
        // printt("here" + typeof whosentit)
        local found = false
        if (format("%c", message[0]) == "!" || typeof whosentit != "integer" ) {
            
            printt("Found chat command " + message)
            local message2 = message
                if  ( typeof whosentit == "integer" ) {
                    whosentit = GetEntByIndex(whosentit)
                     message2 = message.slice(1,message.len())
                }
    
                // local id = RandomInt( 0, 10000 )
                local msgArr = split(message2, " ")
                     local cmd = msgArr[0].tolower() 

                msgArr.remove(0)

                foreach( key, val in registeredcommands) {
                    // printt("HEREEREREERE"+ key + " |" + cmd + "|  woa")
                    if (cmd == key && 0 == val.adminlevel) {
                        // SetConVarString("autocvar_Lcommandreader", cmd)
                        
                        printt("running " + key + " For "+whosentit.GetPlayerName())
                        if (val.requiressender) {
                        local output = val.inputfunction(whosentit,msgArr,false)}
                        else{
                            local output = val.inputfunction(msgArr,false)
                        }
                        found = val.blockchatmessage
                        // Laddusedcommandtotable(message,"chat_command",output)
                    }

            }
            // if (!found){
            //     Laddusedcommandtotable(message,"chat_command_not_valid")
            // }
        }
        // else {
        //     Laddusedcommandtotable(message,"chat_message")
        // }
        if (!found){
        return message}
        else{
            // printt("HERE")
            return ""
        }
}

function Laddusedcommandtotable(command, commandtype, output = false, id = RandomInt( 0, 10000 )){
    // if (!registercommandsasconvar){
    //     return
    // }
    local serveroutput = GetConVarString("autocvar_Lcommandreader")
    serveroutput += "☻"+id+"☻" + command + "☻" + output + "☻"+ commandtype + "☻X"
    ServerCommand("autocvar_Lcommandreader "+ serveroutput)
}
// GetPlayerArray()
// .len()
// .append()
// ArrayContains(ARAY, VALUE)
//  local table = {}
// table.xyz = what

// TrueTeamSwitch()

main()