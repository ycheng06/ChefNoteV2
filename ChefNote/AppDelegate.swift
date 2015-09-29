//
//  AppDelegate.swift
//  ChefNote
//
//  Created by Jason Cheng on 9/25/15.
//  Copyright (c) 2015 Jason. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //    let host:String = "http://localhost:3000/"
    let host:String = "https://murmuring-inlet-5627.herokuapp.com/"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // background color of navigation bar
        UINavigationBar.appearance().barTintColor = UIColor(red:
            231.0/255.0, green: 95.0/255.0, blue: 53.0/255.0, alpha: 0.3)
        
        // set the font and color of navigation bar font
        if let barFont = UIFont(name: "AvenirNextCondensed-DemiBold",
            size: 22.0) {
                UINavigationBar.appearance().titleTextAttributes =
                    [NSForegroundColorAttributeName:UIColor.whiteColor(),
                        NSFontAttributeName:barFont]
        }
        
        // back button color
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()

        
        Parse.setApplicationId("CsE2VoUmCpgWhctEQ8xik6ARfbkb6Xqfj85Sz5LD", clientKey: "0AB4px5a5GQrp55NIBSe99oTfUo5baDYh5FRS5vA")
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        return true
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

