//
//  testRealmServerApp.swift
//  testRealmServer
//
//  Created by chenzhizs on 2023/12/15.
//  test git 2023/12/15.

import SwiftUI

@main
struct testRealmServerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(EnvironmentModel())
        }
    }
}
