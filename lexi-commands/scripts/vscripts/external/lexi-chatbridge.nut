// requires lexi-commands to work

function main() {
    Globalize(Lsendmessage)
    Lregistercommand("sendmessage",10,false,Lsendmessage,"send a chat message",false)
    AddCallback_OnClientConnected(onconnect)
    AddCallback_OnClientDisconnected(disconnect)
    AddCallback_OnClientChatMsg(onmessage)
}
// function onmessage(whosentit, message, isteamchat) {
//     local output = "**"+GetEntByIndex(whosentit).GetPlayerName() + "**: " + message
//     Laddusedcommandtotable(output,"chat_message")
//     return message
    
    
// }

function onconnect (player){
    if (Time() < 15) {
        return
    }
    local output = player.GetPlayerName() + " has joined the server (" + GetPlayerArray().len() + " Connected)"
    Laddusedcommandtotable(output,"connect_message")
}

function disconnect (player){
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