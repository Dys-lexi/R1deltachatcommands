function main() {
    return
    Globalize(stats)
    Lregistercommand("stats",0,false,stats,"Get somones stats - needs discord linked args: [name]",true,false)
   
}


function stats(player,args,outputless = false){
    local playerdata = {}
    playerdata.playeruid <- player.GetEntIndex()
    // playerdata.playerdiscorduid <- player.GetPlatformUserId()
    if (args.len() == 0){
    playerdata.playername <- player.GetPlayerName()}
    else{
    //         local chatmessage = ""


    // foreach (word in args){
    //     chatmessage += word + " "}
    //     playerdata.playername <- chatmessage.remove(chatmessage.len() -1)
     playerdata.playername <- args[0]
    }
    Laddusedcommandtotable(Loutputtable(playerdata,0,4,"♥"),"stats")
    return true
}
