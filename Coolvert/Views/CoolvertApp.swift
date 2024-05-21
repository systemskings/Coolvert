//
//  CoolvertApp.swift
//  Coolvert
//
//  Created by Alysson Reis on 10/05/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth


@main
struct CoolvertApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            FirebaseApp.configure()
            
            return true
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .containerRelativeFrame([.horizontal, .vertical])
                    .background(Gradient(colors: [Color.color2, Color.color3, Color.color4]).opacity(0.6))
            }
            
        }
    }
}

