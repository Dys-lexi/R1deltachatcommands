// requires lexi-commands to work

function main() {

    local modfilenames = [
    "playing",
    "privatemessage",
    "stats"
    "bansystem"
    "lexitone"
    ]
    foreach (mod in modfilenames) {
        printt("loading commandfileb "+mod)
        IncludeFile(format("external/%s", mod))
    }

    Globalize(Lsendmessage)
    Globalize(helpdc)
    Lregistercommand("sendmessage",4,true,Lsendmessage,"send a chat message",false)
    Lregistercommand("helpdc",0,true,helpdc,"get the discord help list",true)
    AddCallback_OnClientConnected(Lconnect)
    AddCallback_OnClientDisconnected(Ldisconnect)
    AddCallback_OnClientChatMsg(LBonmessage)
    thread nextmap()
}
function helpdc(a,b,c){
    return true
}

function LBonmessage(whosentit, message, isteamchat) {
    
    if ((message.len() > 1 && format("%c", message[0]) == "!" ) || (message.len() > 2 && format("%c", message[0]) == "t"  &&format("%c", message[1]) == "!" ) ) {
        local output = message
        local metadata = {}
        local messagee = {}
        metadata.pfp <- (GetEntByIndex(whosentit).GetTeam() == TEAM_MILITIA)+" "+GetEntByIndex(whosentit).GetModelName()
        metadata.uid <- GetEntByIndex(whosentit).GetPlatformUserId()
        metadata.entid <- whosentit
        metadata.teamtype <- "not team"
        metadata["type"] <- "tf1command"
        messagee["overridechannel"] <- "commandlogchannel"
        messagee.globalmessage <- true
        messagee.messagecontent <- output+""
        messagee.player <- GetEntByIndex(whosentit).GetPlayerName() 
        messagee.timestamp <- Daily_GetCurrentTime()
        messagee["type"] <- 3
        messagee["metadata"] <- metadata
        // Laddusedcommandtotable(output,"command_message",Loutputtable(metadata,0,4,"♥"))
        Laddusedcommandtotablev2(messagee,"msg")
        return
    }
        local messagee = {}
        local output = "**"+GetEntByIndex(whosentit).GetPlayerName() + "**: " + message
        local metadata = {}
        metadata.ismuted <-  GetEntByIndex(whosentit).GetUserId() + "" in Lgetmutes()
        metadata.pfp <- (GetEntByIndex(whosentit).GetTeam() == TEAM_MILITIA)+" "+GetEntByIndex(whosentit).GetModelName()
        metadata.uid <- GetEntByIndex(whosentit).GetPlatformUserId()
        metadata.teamtype <- "not team"
        metadata["type"] <- "usermessagepfp"
        messagee.messagecontent <- message+""
        messagee.player <- GetEntByIndex(whosentit).GetPlayerName()
        messagee["type"] <- 1
        
        messagee["metadata"] <- metadata
        Laddusedcommandtotablev2(messagee,"msg")
        // Laddusedcommandtotable(output+" "+GetEntByIndex(whosentit).GetModelName(),"chat_message",false)  OLD SYSTEM PFPLESS
        // Laddusedcommandtotable(message,"usermessagepfp",Loutputtable(metadata,0,4,"♥"))
        return

    
    
}
function nextmap(){
    // wait 10
    local MAPS = {}
    MAPS.mp_airbase          <- "Airbase"
    MAPS.mp_angel_city       <- "Angel City"
    MAPS.mp_boneyard         <- "Boneyard"
    MAPS.mp_colony           <- "Colony"
    MAPS.mp_corporate        <- "Corporate"
    MAPS.mp_fracture         <- "Fracture"
    MAPS.mp_lagoon           <- "Lagoon"
    MAPS.mp_nexus            <- "Nexus"
    MAPS.mp_outpost_207      <- "Outpost 207"
    MAPS.mp_overlook         <- "Overlook"
    MAPS.mp_relic            <- "Relic"
    MAPS.mp_rise             <- "Rise"
    MAPS.mp_smugglers_cove   <- "Smuggler's Cove"
    MAPS.mp_training_ground  <- "Training Ground"
    MAPS.mp_wargames         <- "War Games"
    MAPS.mp_runoff           <- "Runoff"
    MAPS.mp_swampland        <- "Swampland"
    MAPS.mp_haven            <- "Haven"
    MAPS.mp_switchback       <- "Export"
    MAPS.mp_backwater        <- "Backwater"
    MAPS.mp_sandtrap         <- "Sand Trap"
    MAPS.mp_harmony_mines    <- "Dig Site"
    MAPS.mp_zone_18          <- "Zone 18"
    MAPS.mp_mia              <- "M.I.A"
    MAPS.mp_nest2            <- "Nest 2"
    MAPS.mp_box              <- "Box"
    MAPS.mp_npe              <- "Training"
    MAPS.mp_o2               <- "Demeter"
    MAPS.mp_lobby            <- "Lobby"
    // local current = MAPS[GetMapName()]
    if (MAPS[GetMapName()] != "Lobby") {
    Laddusedcommandtotablev2("Map has changed to: "+MAPS[GetMapName()],"smsg")}
    else
    {
        Laddusedcommandtotablev2("Game moving to lobby","smsg")
    }
}

function requeststats (player){
    wait 0
    local playerdata = {}
    playerdata.playeruid <- player.GetEntIndex()
    playerdata.uid <- player.GetPlatformUserId()
    playerdata.name <- player.GetPlayerName()
    Laddusedcommandtotablev2(playerdata,"stats")
    // Laddusedcommandtotable(Loutputtable(playerdata,0,4,"♥"),"sendcommand","stats")
}

function requestnatterforcoolperks(player){
    if ((!Lgetnatterforcoolperks) || (MAPS[GetMapName()] != "Lobby")){
        return
    }
    local playerdata = {}
    playerdata.playeruid <- player.GetEntIndex()
    playerdata.uid <- player.GetPlatformUserId()
    playerdata.name <- player.GetPlayerName()
    Laddusedcommandtotablev2(playerdata,"natterforcoolperks")

}

function Lconnect (player){
    // printt("THIS SHOULD HOPEFULLY WORK")

    thread requeststats(player)
    thread requestnatterforcoolperks(player)
    if (Time() < 15) {
        return
    }
    // printt("I AM HERE NOW")
    local output = player.GetPlayerName() + " has joined the server (" + GetPlayerArray().len() + " Connected)"
    // Laddusedcommandtotable(output,"connect_message")
    Laddusedcommandtotablev2(output,"smsg")
}

function Ldisconnect (player){
    local players = GetPlayerArray().len()-1
    local output = player.GetPlayerName() + " has left the server (" + players + " Connected)"
    Laddusedcommandtotablev2(output,"smsg")
}


function Lsendmessage(args,returnfunc){
    local who = args[0]
    args.remove(0)
    local player = true
    // printt("who "+who)
    if ( GetPlayerArray().len() == 0) {
        returnfunc("failed! 0 playing")
        return
    }
    if (who != "placeholder"){
        foreach(person in GetPlayerArray()){
            if (StringContains(who,person.GetPlatformUserId())){
                player = person
            }
        }
        if (player == true){
            returnfunc("failed! person not found")
            return
        }
    }

    local output = ""

        foreach(arg in args) {
            output += arg + " "
        }
    
    SendChatMsg(player,0,output,false,false)
    returnfunc("sent!")
    return true
}

