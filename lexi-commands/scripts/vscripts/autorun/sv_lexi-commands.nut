function main() {

    local modfilenames = [
    "switchteam",
    // "lexi-chatbridge",
    "gravitymod",
    "throw",
    "nominate",
    "extend",
    "skip",
    "titanfall",
    "rcon"
    ]

    ::adminenabled <- false //CHANGE THE PASSWORDS :) (then enable)
    ::adminpasswords <- {}
    adminpasswords.adminlevel1 <- "level1AUTH"
    adminpasswords.adminlevel2 <- "level2AUTH"
    adminpasswords.adminlevel3 <- "level3AUTH"





    // ^settings^ 





    // printt("OQMIOFQWNIOFNQWOQNWIF")
    ::registeredcommands <- {}
    // ::matchid <- "ID<"+Daily_GetCurrentTime()+"/>ID"
    // ::registercommandsasconvar <- true // don't change this to true, unless you know what it does it does nothing now, but keep it false
    // if it's true and you don't know what it does, make it false
    // print("LOADDDED WOOOOOP WOOOP")
    // thread Iwanttorepeatthismessage ()
    ::registeredvotes <- {}
    ::version <- "v0.1.11"
    Globalize(Lregistercommand)
    Globalize(Lprefix)
    Globalize(Lgetentitysfromname)
    Globalize(Lrconcommand)
    Globalize(Laddusedcommandtotable)
    Globalize(Lregistervote)
    Globalize(Loutputtable)
    Globalize(Lvote)
    Globalize(LSendChatMsg)
    Globalize(Lgetplayersadminlevel)
    AddCallback_OnClientChatMsg(onmessage)
    AddCallback_OnClientConnected(Lonjoin)
    ::adminlist <- {}
    adminlist.adminlevel1 <- []
    adminlist.adminlevel2 <- []
    adminlist.adminlevel3 <- []
    Lregistercommand("help",0,false,helpfunction,"get help",true)
    Lregistercommand("auth",0,true,authfunction,"become an admin args: [password]",true,true)
    AddCallback_OnClientDisconnected(authremove)
    // printt("BOOOOP"+GetConVarString("autocvar_Lcommandreader"))
    AutoCVar("Lcommandreader", "")
    AutoCVar("matchid","ID<"+Daily_GetCurrentTime()+"/>ID")
    // AddCallback_OnPlayerKilled
    // ServerCommand("matchid "+ "ID<"+Daily_GetCurrentTime()+"/>ID")
    AddClientCommandCallback( "l", commandrunner )
    foreach (mod in modfilenames) {
        printt("loading commandfile "+mod)
        IncludeFile(format("external/%s", mod))
    }
   
}

// if (Lcommandcheck(["switch","st"],0,command))
function Lregistervote(votename,percentageaccept,minaccept,timelimit = 0, cooldown = 0, extendtimelimitonvote = 30){
    local newvote = {}
    if (timelimit == 0){
        timelimit = 99999
    }
    newvote.percentageaccept <- percentageaccept
    newvote.minaccept <- minaccept
    newvote.functionpass <- false
    newvote.timelimit <- timelimit
    newvote.functionnopass <- false
    newvote.extendtimelimitonvote <- extendtimelimitonvote
    // newvote.currentvotes <- 0
    newvote.endsat <- 0
    newvote.voted <- {}
    newvote.cooldown <- cooldown
    newvote.nextvotetime <- 0
    registeredvotes [votename] <- newvote
}

function Lvote(votename,player, voteweight = 1, forcenewvote = false ,args = []){  
    local ispossible = true  
    local needed = (GetPlayerArray().len()*registeredvotes[votename].percentageaccept).tointeger()
    if (needed == 0) {
        needed = 1
    } else if (needed <registeredvotes[votename].minaccept) {
        needed = registeredvotes[votename].minaccept
    }
    if (needed > GetPlayerArray().len()) {
     
        local output = {}
        output.votepassed <- false
        output.votes <- 0
        output.votesneeded <- needed
        output.timeleft <-  0
        output.message <- "not possible"
        output.oncooldown <- true
        output.alreadyvoted <- false
        output.extendcooldown <- registeredvotes[votename].nextvotetime - Time()
        output.voteispossible <- false
        return output
    }
    // local newvote = registeredvotes[votename].currentvotes == 0
    if (Time() < registeredvotes[votename].nextvotetime){
        local output = {}
        output.votepassed <- false
        output.votes <- 0
        output.votesneeded <- needed
        output.timeleft <-  0
        output.message <- "on cooldown"
        output.oncooldown <- true
        output.alreadyvoted <- false
        output.extendcooldown <- registeredvotes[votename].nextvotetime - Time()
        output.voteispossible <- ispossible
        return output
    }
    if (registeredvotes[votename].voted.len() == 0 || forcenewvote || registeredvotes[votename].endsat < Time()) {
        // registeredvotes[votename].currentvotes = 0
        registeredvotes[votename].voted = {}
        registeredvotes[votename].endsat =  Time() +  registeredvotes[votename].timelimit
    }
    else {
        registeredvotes[votename].endsat += registeredvotes[votename].extendtimelimitonvote
    }
    // registeredvotes[votename].currentvotes += voteweight
    if (args.len() != 0){
        if (args[0] == "force" && Lgetplayersadminlevel(player) > 0) {
            voteweight*=100
        }
    }
    // printt("VOTEWEIT"+voteweight)
    local alreadyvoted = ArrayContains(TableKeysToArray(registeredvotes[votename].voted),player.GetUserId())
    registeredvotes[votename].voted [player.GetUserId()] <- voteweight

    // add up votes

    local totalvote = 0
    local entitytable = []
    foreach (entindex in GetPlayerArray()){
        entitytable.append(entindex.GetUserId())
    }
    foreach( key, val in registeredvotes[votename].voted){
        // printt("HERE"+key+val)
        if (ArrayContains(entitytable,key)) {
            // printt("HEREeee  "+val)
            totalvote += val
        }
    }
    local output = {}
    if (totalvote >= needed) {
         registeredvotes[votename].nextvotetime <- Time() +   registeredvotes[votename].cooldown
         
    }
    local message = "voted"
    if (alreadyvoted) {
        message = "already voted"
    }
    // PrintTable(registeredvotes)
    output.votepassed <- totalvote >= needed
    output.votes <- totalvote
    output.votesneeded <- needed
    output.oncooldown <- false
    output.timeleft <-  (registeredvotes[votename].endsat - Time()).tointeger()
    output.message <- message
    output.alreadyvoted <- alreadyvoted
    output.voteispossible <- ispossible
        if (totalvote >= needed) {
        registeredvotes[votename].voted = {}
         
    }
    return output
}

function Lrconcommand(keyword,args = [],id = RandomInt( 0, 10000 )){
    // print(matchid)
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
                                 return false
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
                        print("FUNCRETURN<")
                        if (val.requiressender) {
                          output = val.inputfunction(player,args,true)}
                        else {
                             output = val.inputfunction(args,true)
                        }
                        print("/>FUNCRETURN")
                        print("BEGINMAINOUT")
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
        
        local outputarg = "!" +args
        // foreach(arg in args){
        //     outputarg+= " " + arg
        // }
        printt("outputaaarg"+outputarg)
        onmessage(player.GetEntIndex(),outputarg,false)
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
function authfunction(player,args,outputless = false) {
    if (args.len() == 0) {
        LSendChatMsg(player,0, "include a password!!!",false,false,outputless)
        return
    }
    else if (!adminenabled) {
        LSendChatMsg(player,0, "admin is disabled",false,false,outputless)
        return
    }
    local sucsess = false
    foreach (key,password in adminpasswords) {
        if (password == args[0]) {
            sucsess = true
            adminlist[key].append(player.GetPlayerName()+player.GetUserId())
        }
    }
    if (!sucsess){
        LSendChatMsg(player,0, "wrong pass",false,false,outputless)
        return
    }
    LSendChatMsg(player,0, "correct pass!",false,false,outputless)
    // PrintTable(adminlist)
}
function LSendChatMsg(who = true,from = 0, text = "", isteam = false, isdead = false, outputless = false){
    if (!outputless){
         SendChatMsg(who,from,Lprefix(typeof who != "bool")+ text,isteam,isdead)
    }
    print("CMDLINE<"+text+"/>CMDLINE")
}
function authremove(player){
    // printt("HERE")
    // PrintTable(adminlist)
    foreach (key,value in adminlist){
        local keyoffset = 0
        local originallen = value.len()
        for (local index = 0 ;index < originallen; index++) {
            local name = value[keyoffset+index]
            if (name == player.GetPlayerName()+player.GetUserId()) {
                adminlist[key].remove(index+keyoffset)
                keyoffset -= 1
                // printt("REMOVED" + player.GetPlayerName()+player.GetEntIndex() )
            }
        }
    }
    //     printt("HERE2")
    // PrintTable(adminlist)
}

function Lgetplayersadminlevel(player){
    local levelw = 0
    local actuallevel = 0
    foreach (key,value in adminlist){
        levelw+=1
        if (ArrayContains(value,player.GetPlayerName()+player.GetUserId())) {
            actuallevel = levelw
        }
    }
    return actuallevel
}
function helpfunction(player,args,outputless = false) {
    LSendChatMsg(player,0, "help menu! ("+version+")",false,false)
    local sentids = []
    foreach( key, val in registeredcommands) {
        if (val.adminlevel > Lgetplayersadminlevel(player) || ArrayContains(sentids,val.id)) {
            continue
        }
        sentids.append(val.id)
        LSendChatMsg(player,0,"\x1b[38;5;201m" +val.Aliases+": \x1b[38;5;254m "+ val.description ,false,false)
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
function Lonjoin(player) {
    LSendChatMsg(player,0,"Welcome "+player.GetPlayerName() +", type !help for commands" ,false,false)
}

function Lprefix(private = false){
    if (!private){
    return "\x1b[38;5;190m[Lexicmd]\x1b[38;5;254m "}
    else{
        return "\x1b[38;5;213m[Lexicmd]\x1b[38;5;254m "
    }
}

function onmessage(whosentit, message, isteamchat)
{
        local output = "**"+GetEntByIndex(whosentit).GetPlayerName() + "**: " + message
        // if (registercommandsasconvar) {
        // Laddusedcommandtotable(output,"chat_message")}
        
        // printt("chat message sent by" + whosentit + " length of getplayerarray is " +GetPlayerArray().len())
        // "inspired" very heavily from kcommands
        // printt("here" + typeof whosentit)
        local found = false
        if ((format("%c", message[0]) == "!" && message.len() > 1 ) || (message.len() > 2 && format("%c", message[0]) == "t"  &&format("%c", message[1]) == "!" ) ) {
            // if (format("%c", message[0]) == "t") {}
            printt("Found chat command " + message)
            local message2 = message
                if  ( typeof whosentit == "integer" ) {
                    whosentit = GetEntByIndex(whosentit)
                    if (format("%c", message[0]) == "t") { message2 = message.slice(2,message.len())} else {
                     message2 = message.slice(1,message.len())}
                }
    
                // local id = RandomInt( 0, 10000 )
                local msgArr = split(message2, " ")
                     local cmd = msgArr[0].tolower() 

                msgArr.remove(0)

                foreach( key, val in registeredcommands) {
                    // printt("HEREEREREERE"+ key + " |" + cmd + "|  woa")
                    if (cmd == key && Lgetplayersadminlevel(whosentit) >= val.adminlevel) {
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
            // printt("Here")
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



function Loutputtable( tbl, indent = 0, maxDepth = 4, replacechar = "☻" )
{   
    local output = ""
	output += ( TableIndent( indent ) )
	output += PrintObjectt( tbl, indent, 0, maxDepth, output,replacechar )
    return output
}


function TableIndent( indent )
{
	return ("                                            ").slice( 0, indent )
}


function PrintObjectt( obj, indent, depth, maxDepth ,output,replacechar )
{
	if ( IsTable( obj ) )
	{
		if ( depth >= maxDepth )
		{
			output += ( "{...}" )
			return
		}

		output += ( "{" )
		foreach ( k, v in obj )
		{
			output += ( TableIndent( indent + 2 ) + replacechar+ k +replacechar+ " : " )
			output = PrintObjectt( v, indent + 2, depth + 1, maxDepth ,output,replacechar )
            output += ","
		}
        output = output.slice(0,output.len()-1)
		output += ( TableIndent( indent ) + "}" )
	}
	else if ( IsArray( obj ) )
	{
		if ( depth >= maxDepth )
		{
			output += ( "[...]" )
			return
		}

		output += ( "[" )
		foreach ( v in obj )
		{
			output += ( TableIndent( indent + 2 ) )
			output = PrintObjectt( v, indent + 2, depth + 1, maxDepth ,output,replacechar )
            output += ","
		}
        output = output.slice(0,output.len()-1)
		output += ( TableIndent( indent ) + "]" )
	}
    else if ( typeof obj == "string") 
    {
        // local quote = replacechar
        output += ( "" + replacechar+ obj + replacechar  )
    }
	else if ( obj != null )
	{
		output += ( "" + obj )
	}
	else
	{
		output += ( "<null>" )
	}
    return output
}



main()