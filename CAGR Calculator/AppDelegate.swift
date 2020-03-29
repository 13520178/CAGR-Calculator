//
//  AppDelegate.swift
//  CAGR Calculator
//
//  Created by Phan Nhat Dang on 3/14/20.
//  Copyright © 2020 Phan Nhat Dang. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }

}

