@objc(SpotifySDKPlugin) class SpotifySDKPlugin: CDVPlugin {
    @objc(runAuth:) func runAuth(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "The Plugin Failed");

        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The Plugin Succeeded");

        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
}