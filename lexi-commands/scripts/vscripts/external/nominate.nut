function main() {
    Globalize(Lnominate)
    Globalize(Lmaps)
    // !name, adminlevel (0 is everyone), should block the original message (non functional) function to run, description in !help, requires a sender (set this to true if the command uses player arg in any way)
    Globalize(LGetnextmap)
       Globalize(Loutputmapnominate)
   ::allowedmaps <- []
   ::initedmaps <- {}
   initedmaps.idkglobals <- false
   AutoCVar("nominates", "b")
    if (GetCurrentPlaylistName() == "campaign_carousel") {
        return
    }
    Lregistercommand(["nominate","nm"],0,false,Lnominate,"Vote for the next map args: [map]",true)
    Lregistercommand(["maps"],0,true,Lmaps,"Display all maps in rotation",true)
    
    if ( GetMapName() != "mp_lobby") {
        // ServerCommand("autocvar_nominates "+ '""')
        ServerCommand("autocvar_nominates b")
        // ServerCommand('autocvar_nominates "}"')
        // printt("I DID NOT RUN THIS WOA LOOK AT ME :(")
        
    }
    else{
        // printt("I RAN THIS WOA LOOK AT ME")
        thread Loutputmapnominate("pleasewait")
    }


//    local playlist = GetCurrentPlaylistName()

}

function Lmaps(player,args,outputless = false){
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


    local counter = 0
    local output = ""
    LSendChatMsg(player,0, "Maps currently in rotation:" ,false,false)
    foreach(map in MAPS){
        
        if (!ArrayContains(GetPlaylistUniqueMaps(GetCurrentPlaylistName()),map)){
            counter+=1
            output += map+", "
            counter+=1
        }
        if (counter%5 == 0){
            LSendChatMsg(player,0, " " + output.slice(0,output.len()-2) ,false,false)
            output = ""
        }
    }
    if (output != "") {
        LSendChatMsg(player,0, " " + output.slice(0,output.len()-2) ,false,false)
    }
}


function Lnominate(player,args,outputless = false){
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


    if (args.len() == 0){
        LSendChatMsg(player,0,"Include a map name! eg: !nm angel" ,false,false,outputless)
        return false
    }
    local newarg = ""
    foreach (arg in args){
        newarg+=arg+" "
    }

    args = [newarg.slice(0,newarg.len()-1)]
    local wantedmap = args[0]
    local containedmaps = []
    foreach (key, value in MAPS) {
        // printt("WHAT"+value+" "+wantedmap)
        if (StringContains(value.tolower(),wantedmap.tolower())) {
            containedmaps.append(key)
        }
    }
    if (containedmaps.len() == 0){
        LSendChatMsg(player,0,wantedmap+" does not match any maps!" ,false,false,outputless)

        return false
    }
    if (containedmaps.len() > 1) {
        local matchedmaps = MAPS[containedmaps[0]]
        local maxcount = 3
        containedmaps.remove(0)
        foreach (map in containedmaps) {
            if (maxcount == 0){
                break
            }
            maxcount -=1
            matchedmaps += ", "+ MAPS[map]
        }

        // printt("BOOOP"+matchedmaps)
        LSendChatMsg(player,0,"Map name is matched by multiple maps! ("+matchedmaps+")" ,false,false,outputless)
        return false
    }
    if ( containedmaps[0] ==  GetMapName()) {
        LSendChatMsg(player,0,"You cannot vote for the current map!" ,false,false,outputless)
        return false
    }
    if (!ArrayContains(GetPlaylistUniqueMaps(GetCurrentPlaylistName()), containedmaps[0])){
        LSendChatMsg(player,0,MAPS[containedmaps[0]]+" Is not in the map pool!" ,false,false,outputless)
        return false
    }
    local noms = GetConVarString("autocvar_nominates")
    // printt("NOMS1"+noms)
    noms = noms.slice(0,noms.len()-1)
    // printt("NOMS2"+noms)
    noms = player.GetPlayerName()+"{"+containedmaps[0]+"}" + noms
    // printt("NOMS3"+noms)
    // printt("NOMSsstr"+noms+"LEN"+noms.len())
    ServerCommand("autocvar_nominates "+ noms+"b")

   thread Loutputmapnominate(noms)
}

function Loutputmapnominate(noms = "NOTHING"){
    //  SendChatMsg(true,0,"boop" ,false,false)
    initedmaps.idkglobals = true

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

    // wait 0.1
    // local noms = GetConVarString("autocvar_nominates")
    if (noms == "NOTHING") {
        noms =  GetConVarString("autocvar_nominates")
          noms = noms.slice(0,noms.len()-1)
    } else if (noms == "pleasewait") {
        wait 10
        noms =  GetConVarString("autocvar_nominates")
        noms = noms.slice(0,noms.len()-1)
    } 
     local matchednames = []
    local nominates = []
    local nominatecounts = []
    noms = split( noms, "}" )
    // print("LEN" + noms.len())
    // printt("NOMSsstr"+noms+"LEN"+noms.len())
    foreach (index, nom in noms){
        // printt("WOA"+nom)
        nom = split( nom, "{" )
        // printt("WOA"+nom.len())
        if (Lgetentitysfromname(nom[0]).len() > 0 && !ArrayContains(matchednames,nom[0])) {
            matchednames.append(nom[0])
            if (!ArrayContains(nominates,nom[1])) {
                nominates.append(nom[1])
                nominatecounts.append(1)
                // printt("NOMS"+nominates[index]+" "+nominatecounts[index])
            }
            else{
                foreach (key, value in nominates) {
                    if (value == nom[1]){
                        nominatecounts[key] +=1 
                        // printt("NOMS"+nominates[key]+" "+nominatecounts[key])
                    }
                }
            }
        }
        
    }
    local totaloutputs = 3
    local output = "MAP VOTES: "
    local popularitymax = 0
    local popularitymaxindex = 0
    local maxvote = 0
    local potentialmaps = []
    while (totaloutputs != 0) {
        popularitymax = 0
        popularitymaxindex = 0
        foreach (key, val in nominates) {
            // printt("OUTPUT"+val+nominatecounts[key])
            if (nominatecounts[key] > popularitymax)
            {popularitymax = nominatecounts[key] 
            if (totaloutputs == 3){
                maxvote =  nominatecounts[key]
            }
         
            popularitymaxindex = key}
        }
        if (popularitymax == 0){
            break
        }
        if (totaloutputs == 3) {
               if (popularitymax == maxvote) {
 
                potentialmaps.append(nominates[popularitymaxindex])
            }
            output += "\x1b[38;5;226m"+MAPS[nominates[popularitymaxindex]] +"-("+popularitymax+") "
        }
        if (totaloutputs == 2) {
               if (popularitymax == maxvote) {
       
                potentialmaps.append(nominates[popularitymaxindex])
            }
            output += "\x1b[38;5;251m"+MAPS[nominates[popularitymaxindex]] +"-("+popularitymax+") "
        }
        if (totaloutputs == 1) {
               if (popularitymax == maxvote) {
    
                potentialmaps.append(nominates[popularitymaxindex])
            }
            output += "\x1b[38;5;208m"+MAPS[nominates[popularitymaxindex]] +"-("+popularitymax+") "
        }     
        nominates.remove(popularitymaxindex)
        nominatecounts.remove(popularitymaxindex)
        totaloutputs -=1
    
    }
    // printt("HERE"+output)
    if (output != "MAP VOTES: "){
     LSendChatMsg(true,0,output ,false,false)}
    //  printt("POTENTIALMAPS"+potentialmaps.len())
    //  RandomInt( 2 )
    // if (potentialmaps.len() > 0){
        if (allowedmaps.len() != 1 || !ArrayContains(allowedmaps[0],potentialmaps)){
            if (potentialmaps.len() != 0){
        allowedmaps = [potentialmaps[ RandomInt( potentialmaps.len() )]]}
        
         if ( GetMapName() == "mp_lobby") {
        SelectNextMap()}
        }
        // foreach(map in potentialmaps) {
        //     print("MAPPPPP"+map)
        // }
    // level.ui.privatematch_map = getconsttable().ePrivateMatchMaps[potentialmaps[ RandomInt( potentialmaps.len() )]]}
    // LGetnextmap()
    

}

function LGetnextmap(){
    // print("HRE HERE HERE HERE HERE")
    if (!initedmaps.idkglobals) {
    wait 5
    Loutputmapnominate()}
    if (allowedmaps.len()  == 0) {
        // printt("FALSE FALSE FALSE FALSE")
        return false
    }
    local nextmap = allowedmaps[ RandomInt( allowedmaps.len() )]
    // printt("NEXT MAP PLEASE"+nextmap)
    local NEXTTmap = {}
    NEXTTmap.index <-LGetMapIndex(nextmap)
    NEXTTmap.modeName <-GetCurrentPlaylistName()
    NEXTTmap.mapName <- nextmap
    NEXTTmap.score <- 10000
    // printt("TRYING TO FORCE MAP "+nextmap)
    // PrintTable(NEXTTmap)
    
    
    if (type(NEXTTmap) == "table"){
        local includesname = false
        foreach (key,value in NEXTTmap) {
            if (key == "mapName") {
                includesname = true
                break
            }
        }
        if (!includesname) {
            print("here")
            return false
        }
    return NEXTTmap}
    else{
        return false
    }
}

function LGetMapIndex( mapName )
{
    
	local playlist = GetCurrentPlaylistName()
	local playlistMaps = GetPlaylistCombos( playlist )

	local index = 0
	foreach( map in playlistMaps )
	{
        // PrintTable(map)
		if ( map.mapName == mapName )
			return index

		index++
	}

	printt( "Map not found in playlist!" )
}
