//
//  AppDelegate.swift
//  Melbourne-Tourist
//
//  Created by Muhammad Hasan on 23/8/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
//app delegate takes care of the geofencing for this application. Both in appliocation notifications and local background notificaytions for geofence entry are dealt with here.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var databaseController: DatabaseProtocol?
    let locationManager = CLLocationManager()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //UI Customisation Code from UI lecture
        let uiNavbarProxy = UINavigationBar.appearance()
        uiNavbarProxy.barTintColor = UIColor(red: 0.7, green: 0.2, blue: 0.31, alpha: 1.0)
        uiNavbarProxy.tintColor = UIColor.white
        uiNavbarProxy.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        //coredata
        databaseController = CoreDataController()
        
        //geofence Code
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if !granted {
                print("Permission not granted")
            }
        }
        
        
        return true
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
    
    //removes existing pending notifications. Code taken from raywenderlich's tutorial on geofencing: https://www.raywenderlich.com/5470-geofencing-with-core-location-getting-started#toc-anchor-005
    func applicationDidBecomeActive(_ application: UIApplication) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //geofence event handler
}

//This extension chekc sif app is running in background or foreground to decide what type of notification to trigger. Sends an in application alert if geofence entry triggered while app is running otherwise sends a background local notification. Code taken from raywenderlich's tutorial on geofencing cited above.
extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            if UIApplication.shared.applicationState == .active {
                let alert = UIAlertController(title: "Movement Detected!", message: "You have entered \(region.identifier)'s geofence", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            } else {
                let center = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                content.title = "Welcome to \(region.identifier)"
                content.body = "Melbourne-Tourist has sent a notfication."
                content.sound = UNNotificationSound.default
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
                let request = UNNotificationRequest(identifier: "location-change", content: content, trigger: trigger)
                center.add(request)
                
            }
        }
    }
}
