import UIKit; import Flutter
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let method = FlutterMethodChannel(name: "hb_audio_control", binaryMessenger: controller.binaryMessenger)
    let event = FlutterEventChannel(name: "hb_audio_stream", binaryMessenger: controller.binaryMessenger)
    let audio = HBAudioEngine()
    method.setMethodCallHandler { call, result in
      switch call.method {
        case "start":
          let args = call.arguments as? [String:Any]; let sr = args?["sampleRate"] as? Int ?? 48000; let bs = args?["bufferSize"] as? Int ?? 4096
          audio.start(sampleRate: sr, bufferSize: bs) { _ in event.setStreamHandler(audio); result(true) }
        case "stop": audio.stop(); result(true)
        default: result(FlutterMethodNotImplemented)
      }
    }
    GeneratedPluginRegistrant.register(with: self); return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
