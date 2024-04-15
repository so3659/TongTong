import UIKit
import Flutter
import FirebaseMessaging
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate { // MessagingDelegate 추가
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if FirebaseApp.app() == nil {
    FirebaseApp.configure()
    }

    UNUserNotificationCenter.current().delegate = self
    
    UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .sound, .badge, .providesAppNotificationSettings]) { didAllow, error  in
        print("Notification Authorization : \(didAllow)")
    }
    
    application.registerForRemoteNotifications()
    
    Messaging.messaging().delegate = self
    
    return true
  }

  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }

  override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print(error)
  }
}
