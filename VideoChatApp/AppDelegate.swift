//
//  AppDelegate.swift
//  VideoChatApp
//
//  Created by Apple on 28/04/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import IQKeyboardManagerSwift
import Firebase
import UserNotifications
import PushKit
import CallKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate{

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.voipRegistration()
        
        IQKeyboardManager.shared.enable = true
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        FirebaseApp.configure()
        Messaging.messaging().delegate = self as MessagingDelegate
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self as! UNUserNotificationCenterDelegate

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
        
        
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        return true
    }
    
    
    func voipRegistration() {
        
        // Create a push registry object
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
    }
    
    
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
        
        
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      print("Firebase registration token: \(fcmToken)")
        Constants.shared.currentFCM = fcmToken
        print("")
//      let dataDict:[String: String] = ["token": fcmToken]
//      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
        
        var user = userInfo as? NSDictionary
        let userId = user?["user"] as? String
        let userMsgCountKey = "msg_count_"+userId!
        print("user", userId)
        print(user)
        var tabMsgCounter = UserDefaults.standard.array(forKey: "tab_msg_counter") as? [String]
        if tabMsgCounter != nil {
            print("tabMsgCounter")
            print(tabMsgCounter)
            for i in tabMsgCounter! {
                if i == userId {
                    
                } else {
                    tabMsgCounter?.append(userId!)
                }
            }
            
            UserDefaults.standard.set(tabMsgCounter, forKey: "tab_msg_counter")
        }
        if UserDefaults.standard.integer(forKey: userMsgCountKey) != nil {
            var msgCount = UserDefaults.standard.integer(forKey: userMsgCountKey)
            if msgCount == 0 {
                if userId != "follow" {
                    if UserDefaults.standard.integer(forKey: "message_count") != nil {
                        var msgCount = UserDefaults.standard.integer(forKey: "message_count")
                        msgCount = msgCount + 1
                        UserDefaults.standard.set(msgCount, forKey: "message_count")
                        NotificationCenter.default.post(name: .messageCounter, object: nil)
                    }
                }
                
            }
            
            msgCount = msgCount + 1
            UserDefaults.standard.set(msgCount, forKey: userMsgCountKey)
            NotificationCenter.default.post(name: .userMessageCounter, object: nil)
            
            
        }
        
      }

      // Print full message.
        print("userinfo : ")
      print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
        
        var user = userInfo as? NSDictionary
        let userId = user?["user"] as? String
        let userMsgCountKey = "msg_count_"+userId!
        print(userMsgCountKey)
        print("user", userId)
        print(user)
        var tabMsgCounter = UserDefaults.standard.array(forKey: "tab_msg_counter") as? [String]
        if tabMsgCounter != nil {
            print("tabMsgCounter")
            print(tabMsgCounter)
            for i in tabMsgCounter! {
                if i == userId {
                    
                } else {
                    tabMsgCounter?.append(userId!)
                }
            }
            
            UserDefaults.standard.set(tabMsgCounter, forKey: "tab_msg_counter")
        }
        UserDefaults.standard.set(userId, forKey: "last_msg_user")
        
        if UserDefaults.standard.integer(forKey: userMsgCountKey) != nil {
            var msgCount = UserDefaults.standard.integer(forKey: userMsgCountKey)
            if msgCount == 0 {
                if userId != "follow" {
                    if UserDefaults.standard.integer(forKey: "message_count") != nil {
                        var msgCount = UserDefaults.standard.integer(forKey: "message_count")
                        msgCount = msgCount + 1
                        UserDefaults.standard.set(msgCount, forKey: "message_count")
                        NotificationCenter.default.post(name: .messageCounter, object: nil)
                    }
                }
            }
            msgCount = msgCount + 1
            UserDefaults.standard.set(msgCount, forKey: userMsgCountKey)
            NotificationCenter.default.post(name: .userMessageCounter, object: nil)
        }
        
      }

      // Print full message.
        print("userinfo : ")
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
      //  self.saveContext()
    }
    
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "VideoChatApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


extension AppDelegate : PKPushRegistryDelegate,CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        print("i am here")
        }
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        
        
       /* let rootViewController = self.window!.rootViewController as! UINavigationController
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainController") as! MainController
        rootViewController.pushViewController(profileViewController, animated: true)*/
        
        
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewControlleripad : MainController = mainStoryboardIpad.instantiateViewController(withIdentifier: "MainController") as! MainController
        
        initialViewControlleripad.isFromAppDelegate = true
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = initialViewControlleripad
                    self.window?.makeKeyAndVisible()
        
            action.fulfill()
        }
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewControlleripad : MainController = mainStoryboardIpad.instantiateViewController(withIdentifier: "MainController") as! MainController
        
        initialViewControlleripad.isFromAppDelegate=true
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = initialViewControlleripad
                    self.window?.makeKeyAndVisible()
        
            action.fulfill()
        
          
        }
    
    
    // Handle updated push credentials
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print(credentials.token)
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        Constants.shared.deviceToken=deviceToken
        print("pushRegistry -> deviceToken :\(deviceToken)")
    }
        
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("pushRegistry:didInvalidatePushTokenForType:")
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
         print(payload.dictionaryPayload)
        
        if let aps = payload.dictionaryPayload["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let message = alert["message"] as? NSString {
                   //Do stuff
                }
            } else if let alert = aps["alert"] as? NSString {
                
                let provider = CXProvider(configuration: CXProviderConfiguration(localizedName: "VideoChatApp"))
                provider.setDelegate(self, queue: nil)
                let update = CXCallUpdate()
                update.remoteHandle = CXHandle(type: .generic, value: alert as String)
                provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
            }
        }
        
        
        
        
    }
}
