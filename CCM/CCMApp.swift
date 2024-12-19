//
//  CCMApp.swift
//  CCM
//
//  Created by Rexxay on 2024-12-18.
//

import SwiftUI

@main
struct CCMApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
