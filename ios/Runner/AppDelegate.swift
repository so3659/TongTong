import UIKit
import Flutter
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

	// GoogleSerice-info.plist에 File I/O 하는 기능
    FirebaseApp.configure()
    
    // 알림 delegate 설정
    UNUserNotificationCenter.current().delegate = self
    
    // 알림 허용 확인
    UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .sound, .badge, .providesAppNotificationSettings]) { didAllow, error  in
        print("Notification Authorization : \(didAllow)")
    }
    
    // 원격 알림에 앱 등록
    application.registerForRemoteNotifications()
    
    
    // Messaging delegate 설정
    Messaging.messaging().delegate = self
    
    
    return true
  }
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

   Messaging.messaging().apnsToken = deviceToken
 }
 func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print(error)
  }
}
