@objc(SpotifySDKPlugin) class SpotifySDKPlugin: CDVPlugin {
    @objc(runAuth:) func runAuth(command: CDVInvokedUrlCommand) {
        var result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "The Plugin Failed");
        let args = command.arguments;
        if(args != nil) {
            result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Success")
            var config = STPConfiguration(
            clientID: args[0],
            redirectURL: args[1])
        }
        
        self.commandDelegate!.send(result, callbackId: command.callbackId);
    }
}