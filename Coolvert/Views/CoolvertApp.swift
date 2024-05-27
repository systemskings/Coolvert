//
//  CoolvertApp.swift
//  Coolvert
//
//  Created by Alysson Reis on 10/05/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn


@main
struct CoolvertApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    class AppDelegate: UIResponder, UIApplicationDelegate {

        var window: UIWindow?

        func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            FirebaseApp.configure()
            return true
        }

        func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            return GIDSignIn.sharedInstance.handle(url)
        }
    }

    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
            }
        }
    }
}

