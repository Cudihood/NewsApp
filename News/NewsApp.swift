//
//  NewsApp.swift
//  News
//
//  Created by Даниил Циркунов on 02.05.2024.
//

import SwiftUI

@main
struct NewsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NewsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
