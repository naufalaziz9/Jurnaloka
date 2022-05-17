//
//  JurnalokaApp.swift
//  Jurnaloka
//
//  Created by naufalazizz on 28/12/21.
//

import SwiftUI
import UserNotifications

@main
struct JurnalokaApp: App {

    let persistenceContainer = CDManager.shared
    
    var body: some Scene {
        WindowGroup {
            TabBar()
                .environment(\.managedObjectContext,persistenceContainer.persistentContainer.viewContext)
            
//            OnboardingPage()
//                .environment(\.managedObjectContext,persistenceContainer.persistentContainer.viewContext)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()

            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }

        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)

        print(deviceToken.description)
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            print(uuid)
        }
        UserDefaults.standard.setValue(token, forKey: "ApplicationIdentifier")
        UserDefaults.standard.synchronize()


    }
    
}
