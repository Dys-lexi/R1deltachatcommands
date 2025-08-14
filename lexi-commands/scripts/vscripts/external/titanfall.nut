function main() {
    Globalize(Ltitanfall)
    // !name, adminlevel (0 is everyone), should block the original message (non functional) function to run, description in !help, requires a sender (set this to true if the command uses player arg in any way)
    Lregistercommand(["titanfall","tf"],1,true,Ltitanfall,"drop a titan args: [playername]",true)
   
}

function Ltitanfall(player,args,returnfunc){
    function Ddroptitan( player,sender,returnfunc )
    {
        // if ( !IsReplacementTitanAvailable( player ) )
        // {
        // 	printt( "ClientCommand_ReplacementTitan", player, player.entindex(), "failed", "IsReplacementTitanAvailable was false" )
        // 	return true
        // }

        local titan = GetPlayerTitanInMap( player )
        if ( IsAlive( titan ) )
        {
            returnfunc("ClientCommand_ReplacementTitan "+ player+" " + player.entindex()+ " failed GetPlayerTitanInMap was true")
            // printt( "ClientCommand_ReplacementTitan", player, player.entindex(), "failed", "GetPlayerTitanInMap was true" )
            return true
        }

        if ( !IsAlive( player ) )
        {
            // printt( "ClientCommand_ReplacementTitan", player, player.entindex(), "failed", "IsAlive( player ) was false" )
            returnfunc("ClientCommand_ReplacementTitan "+ player+ " "+ player.entindex()+ " failed GetPlayerTitanInMap was true")
            return true
        }

        // if ( player in file.warpFallDebounce )
        // {
        //     if ( Time() - file.warpFallDebounce[ player ] < 3.0 )
        //     {
        //         LSendChatMsg(sender,0,"ClientCommand_ReplacementTitan "+ player+ " "+ player.entindex()+ " failed player in file.warpFallDebounce was true",false,false,outputless)
        //         // printt( "ClientCommand_ReplacementTitan", player, player.entindex(), "failed", "player in file.warpFallDebounce was true" )
        //         return
        //     }
        // }

        local spawnPoint = GetTitanReplacementPoint( player, false )
        local origin = spawnPoint.origin
        Assert( origin )

        // TitanBuild Progress Reset
        TitanDeployed( player )

        thread DropReplacementTitan( player, spawnPoint )

        SetUpNPCTitanCurrentMode( player, eNPCTitanMode.WAIT )
        return true
    }

    if (args.len() == 0){
         returnfunc("No arguments (need a player)")
        return false
    }
    local playerstothrow = Lgetentitysfromname(args[0])
    if (playerstothrow.len() == 0){
        returnfunc("No matches to that name")}
    foreach (person in playerstothrow)
    {
        returnfunc("Attempting drop titan for "+person.GetPlayerName())
        Ddroptitan(person,player,returnfunc)
        
    }
    
    return true
}


