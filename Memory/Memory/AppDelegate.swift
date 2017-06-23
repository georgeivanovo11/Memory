//
//  AppDelegate.swift
//  Memory
//
//  Created by Георгий Мамардашвили on 20.06.17.
//  Copyright © 2017 Георгий Мамардашвили. All rights reserved.
//

import UIKit

var activeUser: [String:String]?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        /*
        activeUser = UserDefaults.standard.value(forKey: "savedUser") as? [String:String]
        if(activeUser != nil && activeUser!["username"] != nil)
        {
            window?.rootViewController = UINavigationController(rootViewController: ProfileVC())
        }
        else
        {
            window?.rootViewController = UINavigationController(rootViewController: LoginVC())
        }
        */
        
        window?.rootViewController = UINavigationController(rootViewController: AddSegmentVC())
        return true
    }
    
    func login()
    {
        
    }
}

