import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      
      let METHOD_CHANNEL_NAME = "com.sabikrahat.flutter_method_channel_playground/battery"
      let batteryChannel = FlutterMethodChannel(
        name: METHOD_CHANNEL_NAME,
        binaryMessenger: controller.binaryMessenger
      )
      
      batteryChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method {
              
          case "getBatteryLevel":
              guard let args = call.arguments as? [String: String] else {return}
              let name = args["name"]!
              
              result("Hello, \(name)! Battery level is \(self.receiveBatterylevel())%.");
          default:
              result(FlutterMethodNotImplemented)
                
          }
      })
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func receiveBatterylevel() -> Int {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        
        if device.batteryState == UIDevice.BatteryState.unknown {
            return -1;
        } else {
            return Int(device.batteryLevel * 100)
        }
    }
}
