import UIKit
import Flutter
import GoogleMaps
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
    
  // Override the method with the 'override' keyword
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Google Maps with your API Key
    GMSServices.provideAPIKey("AIzaSyA0U_ddvL7t0gRdteVw_9MpVER1N0oqfY8")
    
    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)
    
    // Request notification permissions
    requestNotificationPermissions(application)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Request notification permissions for iOS
  func requestNotificationPermissions(_ application: UIApplication) {
    let center = UNUserNotificationCenter.current()
    center.delegate = self  // Set delegate to handle notifications in foreground and background
    
    // Request permission to show notifications
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if granted {
        DispatchQueue.main.async {
          application.registerForRemoteNotifications()  // Register for remote notifications
        }
      } else {
        print("Notification permission not granted: \(String(describing: error?.localizedDescription))")
      }
    }
  }
  
  // Override this method for when the device successfully registers for push notifications
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Convert the device token to string format
    let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    print("Device Token: \(token)")
    // You can send the token to your server if necessary
  }

  // Override this method for when the app fails to register for push notifications
  override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register for remote notifications: \(error.localizedDescription)")
  }

  // Handle foreground notifications (when the app is open)
  override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .sound])  // Use .banner for iOS 14.0 and newer
    } else {
      completionHandler([.alert, .sound])   // Fallback to .alert for older iOS versions
    }
  }
  
  // Handle when the user interacts with a notification (background/foreground)
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    // Handle notification tap here (e.g., navigate to specific screen)
    completionHandler()
  }
}
