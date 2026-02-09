//
//  AionApp.swift
//  Aion
//
//  Created by 정지민 on 1/15/26.
//

import SwiftUI
import CoreData

@main
struct AionApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
