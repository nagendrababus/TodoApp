//
//  AppDelegate.swift
//  Todoey
//
//  Created by Nagendra Babu on 27/07/18.
//  Copyright © 2018 Nagendra Babu. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Location for UserDefaults file
       // print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last as? String)
        
        //Realm Database
        
        //Realm File Path
       // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
            let realm = try Realm()
        }catch{
            print("\(error) while initializing realm")
        }
    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }


}

