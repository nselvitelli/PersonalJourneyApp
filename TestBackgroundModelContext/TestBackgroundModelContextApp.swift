//
//  TestBackgroundModelContextApp.swift
//  TestBackgroundModelContext
//
//  Created by Nick Selvitelli on 11/8/23.
//

import SwiftUI

@main
struct TestBackgroundModelContextApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(BackgroundSingleton.shared.container)
        }
    }
}
