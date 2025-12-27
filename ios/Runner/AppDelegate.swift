import UIKit
import Flutter
import NetworkExtension

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private var vpnManager: NETunnelProviderManager?
    private var methodChannel: FlutterMethodChannel?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller = window?.rootViewController as! FlutterViewController
        methodChannel = FlutterMethodChannel(
            name: "com.zen.security/vpn",
            binaryMessenger: controller.binaryMessenger
        )
        
        methodChannel?.setMethodCallHandler { [weak self] call, result in
            switch call.method {
            case "connect":
                if let args = call.arguments as? [String: Any],
                   let config = args["config"] as? [String: Any] {
                    self?.connectVPN(config: config, result: result)
                } else {
                    result(FlutterError(code: "INVALID_CONFIG", message: "Config is required", details: nil))
                }
            case "disconnect":
                self?.disconnectVPN(result: result)
            case "checkPermission":
                result(true) // iOS always has permission, just needs user approval
            case "requestPermission":
                result(true)
            case "getTrafficStats":
                result(["rx": 0, "tx": 0])
            case "isConnected":
                self?.checkConnectionStatus(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        
        // Load existing VPN configuration
        loadVPNConfiguration()
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func loadVPNConfiguration() {
        NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, error in
            if let error = error {
                print("Error loading VPN config: \(error)")
                return
            }
            self?.vpnManager = managers?.first ?? NETunnelProviderManager()
        }
    }
    
    private func connectVPN(config: [String: Any], result: @escaping FlutterResult) {
        guard let manager = vpnManager else {
            result(FlutterError(code: "NO_MANAGER", message: "VPN manager not initialized", details: nil))
            return
        }
        
        // Configure the VPN
        let tunnelProtocol = NETunnelProviderProtocol()
        tunnelProtocol.providerBundleIdentifier = "com.zen.security.PacketTunnel"
        tunnelProtocol.serverAddress = config["server"] as? String ?? "VPN Server"
        tunnelProtocol.providerConfiguration = config
        
        manager.protocolConfiguration = tunnelProtocol
        manager.localizedDescription = "Zen Security"
        manager.isEnabled = true
        
        manager.saveToPreferences { [weak self] error in
            if let error = error {
                result(FlutterError(code: "SAVE_ERROR", message: error.localizedDescription, details: nil))
                return
            }
            
            manager.loadFromPreferences { error in
                if let error = error {
                    result(FlutterError(code: "LOAD_ERROR", message: error.localizedDescription, details: nil))
                    return
                }
                
                do {
                    try manager.connection.startVPNTunnel()
                    result(true)
                } catch {
                    result(FlutterError(code: "START_ERROR", message: error.localizedDescription, details: nil))
                }
            }
        }
    }
    
    private func disconnectVPN(result: @escaping FlutterResult) {
        vpnManager?.connection.stopVPNTunnel()
        result(true)
    }
    
    private func checkConnectionStatus(result: @escaping FlutterResult) {
        let status = vpnManager?.connection.status ?? .invalid
        result(status == .connected)
    }
}

