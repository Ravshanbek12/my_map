import UIKit
import Flutter
import YandexMapsMobile
import GoogleMaps


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyC7cr2hQ_WJzj3Auuwn7F-3vUeVlLfzhZo")
    YMKMapKit.setApiKey("e57033e8-ce9f-4410-9bb6-729ef8327d76")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
