//
//  AppDelegate.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/11/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Siren
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [NSObject: AnyObject]?) -> Bool {

      // Google Analytics
      var configureError: NSError?
      GGLContext.sharedInstance().configureWithError(&configureError)
      assert(configureError == nil, "Error configuring Google services: \(configureError)")

      let gai = GAI.sharedInstance()
      gai.trackUncaughtExceptions = true  // Report uncaught exceptions.
      gai.trackerWithTrackingId("UA-69182247-4")

      // Fabric
      Fabric.with([Crashlytics.self])

      // Siren
      let siren = Siren.sharedInstance
      siren.appID = "991595932"
      siren.alertType = SirenAlertType.Force
      siren.checkVersion(.Immediately)

      // Register with Google Maps.
      GMSServices.provideAPIKey("AIzaSyBmxCispciOMZhn4FNbRPv_-Rcj8r_AtAk")

      if FirebaseConnection.service.ref.authData != nil {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("Main")
        if let tabBarVC = controller as? TabBarController {
          let user = User(id: FirebaseConnection.service.ref.authData.uid)
          tabBarVC.user = user
          self.window?.rootViewController = tabBarVC
        }
      }

      return FBSDKApplicationDelegate.sharedInstance()
        .application(application, didFinishLaunchingWithOptions: launchOptions)

  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for
    // certain types of temporary interruptions (such as an incoming phone call or SMS message) or
    // when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame
    // rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store
    // enough application state information to restore your application to its current state in case
    // it is terminated later.
    // If your application supports background execution, this method is called instead of
    // applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo
    // many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive.
    // If the application was previously in the background, optionally refresh the user interface.

    FBSDKAppEvents.activateApp()
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also
    // applicationDidEnterBackground:.
  }

  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?,
    annotation: AnyObject) -> Bool {
      return FBSDKApplicationDelegate.sharedInstance()
        .application(application, openURL: url,
          sourceApplication: sourceApplication, annotation: annotation)
  }

}
