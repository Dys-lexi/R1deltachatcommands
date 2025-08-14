// requires discord to work

function main() {
    Globalize(Lenforcemute)
    AddCallback_OnClientConnected(onconnecting)
    Lregistercommand("muteplayer",4,false,Lenforcemute,"enforce a mute",false)
}


function onconnecting (player){
    local playerdata = {}
    playerdata.ip <- player.GetPlayerIP()
    playerdata.name <- player.GetPlayerName()
    playerdata.uid <- player.GetPlatformUserId()
    playerdata.kickid <- player.GetUserId()
    Laddusedcommandtotablev2(playerdata,"checkbantf1")
    // Laddusedcommandtotable(Loutputtable(playerdata,0,4,"♥"),"sendcommand","checkbantf1")
}

function Lenforcemute(args,returnfunc){
    local expiry = ""
    local reason = ""
    local hasseasonreason = false
    for (local i = 1; i < args.len() ;i++){
        if (args[i] == "rsn"){
            hasseasonreason = true
        }
        else if (!hasseasonreason){
            expiry += args[i] + " "
        }
        else {
            reason += args[i] + " "
        }
    }
    Laddmute(args[0],expiry,reason)
}

