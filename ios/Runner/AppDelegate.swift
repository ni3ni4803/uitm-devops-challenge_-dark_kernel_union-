import UIKit
import Flutter
import GoogleMaps 

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 2. NEW CONFIGURATION: Register the Google Maps API Key
    //    *** REPLACE "YOUR_API_KEY_HERE" with your actual key ***
    GMSServices.provideAPIKey("YOUR_API_KEY_HERE") 
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}