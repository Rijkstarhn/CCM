//
//  CCMProApp.swift
//  CCMPro
//
//  Created by Rexxay on 2024-12-20.
//

import SwiftUI

@main
struct CCMProApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
