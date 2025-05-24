// requires lexi-commands to work

function main() {

    local modfilenames = [
    "playing"
    ]
    foreach (mod in modfilenames) {
        printt("loading commandfileb "+mod)
        IncludeFile(format("external/%s", mod))
    }

    Globalize(Lsendmessage)
    Lregistercommand("sendmessage",1,true,Lsendmessage,"send a chat message",false)
    AddCallback_OnClientConnected(Lconnect)
    AddCallback_OnClientDisconnected(Ldisconnect)
    AddCallback_OnClientChatMsg(LBonmessage)
    thread nextmap()
}
function LBonmessage(whosentit, message, isteamchat) {
    
    if ((message.len() > 1 && format("%c", message[0]) == "!" ) || (message.len() > 2 && format("%c", message[0]) == "t"  &&format("%c", message[1]) == "!" ) ) {
        local output = "**"+GetEntByIndex(whosentit).GetPlayerName() + "**: " + message
        Laddusedcommandtotable(output,"command_message")
        return
    }
        local output = "**"+GetEntByIndex(whosentit).GetPlayerName() + "**: " + message
        local metadata = {}
        metadata.pfp <- (GetEntByIndex(whosentit).GetTeam() == TEAM_MILITIA)+" "+GetEntByIndex(whosentit).GetModelName()
        metadata.name <- GetEntByIndex(whosentit).GetPlayerName()
        metadata.uid <- GetEntByIndex(whosentit).GetUserId()
        metadata.teamtype <- "not team"
        // Laddusedcommandtotable(output+" "+GetEntByIndex(whosentit).GetModelName(),"chat_message",false)  OLD SYSTEM PFPLESS
        Laddusedcommandtotable(message,"usermessagepfp",Loutputtable(metadata,0,4,"♥"))
        return

    
    
}
function nextmap(){
    wait 10
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
    Laddusedcommandtotable("Map has changed to: "+MAPS[GetMapName()],"connect_message")}
    else
    {
        Laddusedcommandtotable("Game moving to lobby","connect_message")
    }
}


function Lconnect (player){
    if (Time() < 15) {
        return
    }
    local output = player.GetPlayerName() + " has joined the server (" + GetPlayerArray().len() + " Connected)"
    Laddusedcommandtotable(output,"connect_message")
}

function Ldisconnect (player){
    local players = GetPlayerArray().len()-1
    local output = player.GetPlayerName() + " has left the server (" + players + " Connected)"
    Laddusedcommandtotable(output,"connect_message")
}

function Lsendmessage(args,outputless = false){
    if ( GetPlayerArray().len() == 0) {
        return "failed! 0 playing"
    }
    local output = ""

        foreach(arg in args) {
            output += arg + " "
        }
    
    SendChatMsg(true,0,output,false,false)
    return "sent!"
}

main()