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
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    public static let myNotificationKey = Notification.Name(rawValue: "myNotificationKey")
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        // facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        StripeAPI.defaultPublishableKey = "pk_test_51HPptWKjKY5Kxs7I3kWutaPDTOcXabFEq6bBU54GsUH6h1SJPdZrdjOl7D6AD71wRohVdKoarDOKtWBoQPVlPdAH00tX6AJv7c"
        
        // google
        // GIDSignIn.sharedInstance().clientID = "995626688633-npat1k40q8mrroia4b3vg5rs4t22pf4o.apps.googleusercontent.com"
        
        
        /*//MARK:- REGISTER FOR PUSH NOTIFICATION -
        //register fot push notification
          if #available(iOS 10, *) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in

                    guard error == nil else {
                        //Display Error.. Handle Error.. etc..
                        return
                    }

                    if granted {
                        //Do stuff here..

                        //Register for RemoteNotifications. Your Remote Notifications can display alerts now :)
                        DispatchQueue.main.async {
                            application.registerForRemoteNotifications()
                        }
                    }
                    else {
                        //Handle user denying permissions..
                    }
                }

                //Register for remote notifications.. If permission above is NOT granted, all notifications are delivered silently to AppDelegate.
            
                application.registerForRemoteNotifications()
        }
        else {
               let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
               application.registerUserNotificationSettings(settings)
               application.registerForRemoteNotifications()
           }
        
        
        UNUserNotificationCenter.current().delegate = self
        
        if let option = launchOptions {
            let info = option[UIApplication.LaunchOptionsKey.remoteNotification]
            if (info != nil) {
                 //goAnotherVC()
                let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .actionSheet)
                           let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                   UIAlertAction in
                                   NSLog("OK Pressed")
                               }
                           let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel) {
                                   UIAlertAction in
                                   NSLog("Cancel Pressed")
                               }
                           alertController.addAction(okAction)
                           alertController.addAction(cancelAction)
                           self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                           
        }}*/
         
        // firebase notification
        self.registerForRemoteNotifications(application)
        
        // get firebase token
        self.firebaseTokenIs()
        
        return true
    }

    @objc func registerForRemoteNotifications(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            
          // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
            
        } else {
            
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
            
        }

        application.registerForRemoteNotifications()

    }
    
    @objc func firebaseTokenIs() {
        /*InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
            
            let defaults = UserDefaults.standard
            defaults.set("\(result.token)", forKey: "deviceFirebaseToken")
            // self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
          }
        }*/
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error = ",error.localizedDescription)
    }
    
    // MARK: UISceneSession Lifecycle

    /*func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

         let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
         print(deviceTokenString)

        UserDefaults.standard.set(deviceTokenString, forKey: "keyMyDeviceTokenId")
     }*/
     
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        switch UIApplication.shared.applicationState {
        case .active:
            //app is currently active, can update badges count here
            
            print("=========>AppIsActive<========")
            
            break
        case .inactive:
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
            
            print("=========>AppIsInActive<========")
            
            break
        case .background:
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            
            print("=========>AppIsBackground<========")
            
            break
        default:
            break
        }
        
    }
    
    func handlePushNotification(userInfo: NSDictionary) {
        
        guard UIApplication.shared.applicationState == .active else {
            showAlertForPushNotification(userInfoGet: userInfo)
            return
        }
        
    }
    
    @objc func showAlertForPushNotification(userInfoGet:NSDictionary) {
        
    }
    
    // MARK:- WHEN APP IS IN FOREGROUND - ( after click popup ) -
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //print("User Info = ",notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
        
        print("User Info dishu = ",notification.request.content.userInfo)
        
        let dict = notification.request.content.userInfo
        
        
        
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
