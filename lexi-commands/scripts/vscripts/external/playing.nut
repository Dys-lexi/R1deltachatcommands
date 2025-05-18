function main() {
    Lregistercommand("playing",0,false,Lplaying,"get who is playing",false)
    Globalize(Lplaying)
    Globalize(Loutputtable)
}
function Lplaying(args,outputless = false) {
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

    //  LSendChatMsg(player,0,"Include a map name! eg: !nm angel" ,false,false,outputless)
    local stats = {}
    foreach (player in GetPlayerArray()) {
   
        stats[player.GetPlayerName()] <- [UpdateScore(player),player.GetTeam() == TEAM_IMC ? "imc" : "militia",UpdateKills(player),UpdateDeaths(player)]
        // else{
        //     stats[player.GetPlayerName()] <- [0,player.GetTeam() == TEAM_IMC ? "imc" : "militia",0,0]
        // }
    }
    if (GetMapName() != "mp_lobby"){
    stats.meta <- [ MAPS[GetMapName()],level.nv.gameEndTime-Time()]
    }
    else{
    stats.meta <- [ MAPS[GetMapName()],0] 
    }
    return Loutputtable(stats)

}


function Loutputtable( tbl, indent = 0, maxDepth = 4 )
{   
    local output = ""
	output += ( TableIndent( indent ) )
	output += PrintObject( tbl, indent, 0, maxDepth, output )
    return output
}

function Bind( func )
{
	// If you want to run a file-scoped function from outside the file
	// you have to bind its environment when you store the variable.
	return func.bindenv( this )
}

function TableIndent( indent )
{
	return ("                                            ").slice( 0, indent )
}


function PrintObject( obj, indent, depth, maxDepth ,output )
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
			output += ( TableIndent( indent + 2 ) + "☻"+ k +"☻"+ " : " )
			output = PrintObject( v, indent + 2, depth + 1, maxDepth ,output )
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
			output = PrintObject( v, indent + 2, depth + 1, maxDepth ,output )
            output += ","
		}
        output = output.slice(0,output.len()-1)
		output += ( TableIndent( indent ) + "]" )
	}
    else if ( typeof obj == "string") 
    {
        // local quote = "☻"
        output += ( "" + "☻"+ obj + "☻"  )
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

