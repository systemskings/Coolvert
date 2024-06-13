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
    @StateObject private var viewModel = AuthenticationViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(viewModel)
            }
        }
    }
}

