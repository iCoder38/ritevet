//
//  AppDelegate.swift
//  RiteVet
//
//  Created by Apple  on 26/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import UserNotifications

import Firebase

import GoogleSignIn
import FBSDKCoreKit
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate , MessagingDelegate {

    public static let myNotificationKey = Notification.Name(rawValue: "myNotificationKey")
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        // facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        StripeAPI.defaultPublishableKey = "pk_test_51HPptWKjKY5Kxs7I3kWutaPDTOcXabFEq6bBU54GsUH6h1SJPdZrdjOl7D6AD71wRohVdKoarDOKtWBoQPVlPdAH00tX6AJv7c"
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        self.fetchDeviceToken()
        
        return true
    }
    
    // MARK:- FIREBASE NOTIFICATION -
    @objc func fetchDeviceToken() {
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                // self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
                
                let defaults = UserDefaults.standard
                defaults.set("\(token)", forKey: "key_my_device_token")
                
                
            }
        }
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error = ",error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func registerForRemoteNotification() {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        let defaults = UserDefaults.standard
        // deviceToken
//                defaults.set("\(token)", forKey: "deviceToken")
        defaults.set("\(fcmToken!)", forKey: "key_my_device_token")
        
         print("\(fcmToken!)")
        
        
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    // MARK:- WHEN APP IS IN FOREGROUND - ( after click popup ) -
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //print("User Info = ",notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
        
        print("User Info dishu = ",notification.request.content.userInfo)
        
        let dict = notification.request.content.userInfo
        
        
        
        if (dict["type"] as! String) == "audiocall" {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
  
            let destinationController = storyboard.instantiateViewController(withIdentifier:"RoomViewControllerId") as? RoomViewController
                
            destinationController?.setSteps = "1"
            destinationController?.callerName = (dict["name"] as! String)
            destinationController?.callerImage = (dict["image"] as! String)
            destinationController?.roomName = (dict["channel"] as! String)
                
            let frontNavigationController = UINavigationController(rootViewController: destinationController!)

            let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

            let mainRevealController = SWRevealViewController()

            mainRevealController.rearViewController = rearViewController
            mainRevealController.frontViewController = frontNavigationController
            
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController = mainRevealController
            }
            
            window?.makeKeyAndVisible()
            
        } else if (dict["type"] as! String) == "videocall" {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

                // print(notification.request.content.userInfo as NSDictionary)
                
            let destinationController = storyboard.instantiateViewController(withIdentifier:"VideoChatViewControllerId") as? VideoChatViewController
                
            destinationController?.setSteps = "1"
            destinationController?.callerName = (dict["name"] as! String)
            destinationController?.callerImage = (dict["image"] as! String)
            destinationController?.roomName = (dict["channel"] as! String)
                
            let frontNavigationController = UINavigationController(rootViewController: destinationController!)

            let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

            let mainRevealController = SWRevealViewController()

            mainRevealController.rearViewController = rearViewController
            mainRevealController.frontViewController = frontNavigationController
            
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController = mainRevealController
            }
            
            window?.makeKeyAndVisible()
            
        } else {
            
        }
        
    }
    
    // MARK:- WHEN APP IS IN BACKGROUND - ( after click popup ) -
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info = ",response.notification.request.content.userInfo)
        
        let dict = response.notification.request.content.userInfo
        if (dict["message"] as! String) == "Incoming Audio call" {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
  
            let destinationController = storyboard.instantiateViewController(withIdentifier:"RoomViewControllerId") as? RoomViewController
                
            destinationController?.setSteps = "1"
            destinationController?.callerName = (dict["name"] as! String)
            destinationController?.callerImage = (dict["image"] as! String)
            destinationController?.roomName = (dict["channel"] as! String)
                
            let frontNavigationController = UINavigationController(rootViewController: destinationController!)

            let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

            let mainRevealController = SWRevealViewController()

            mainRevealController.rearViewController = rearViewController
            mainRevealController.frontViewController = frontNavigationController
            
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController = mainRevealController
            }
            
            window?.makeKeyAndVisible()
            
        } else if (dict["message"] as! String) == "Incoming Video call" {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

                // print(notification.request.content.userInfo as NSDictionary)
                
            let destinationController = storyboard.instantiateViewController(withIdentifier:"VideoChatViewControllerId") as? VideoChatViewController
                
            destinationController?.setSteps = "1"
            destinationController?.callerName = (dict["name"] as! String)
            destinationController?.callerImage = (dict["image"] as! String)
            destinationController?.roomName = (dict["channel"] as! String)
                
            let frontNavigationController = UINavigationController(rootViewController: destinationController!)

            let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

            let mainRevealController = SWRevealViewController()

            mainRevealController.rearViewController = rearViewController
            mainRevealController.frontViewController = frontNavigationController
            
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController = mainRevealController
            }
            
            window?.makeKeyAndVisible()
            
        } else {
            
        }
        
    }
    

    

}


/*// MARK: - Custom URL Schemes -
extension AppDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if GIDSignIn.sharedInstance().handle(url) ||
           ApplicationDelegate.shared.application(app, open: url, options: options) {
            return true
        }
        return false
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions as? [UIApplication.LaunchOptionsKey : Any])
    }
}*/
