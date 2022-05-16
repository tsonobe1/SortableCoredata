//
//  SortedApp.swift
//  Sorted
//
//  Created by 薗部拓人 on 2022/05/17.
//

import SwiftUI

@main
struct SortedApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
