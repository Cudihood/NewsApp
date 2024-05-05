//
//  NewsApp.swift
//  News
//
//  Created by Даниил Циркунов on 02.05.2024.
//

import SwiftUI

@main
struct NewsApp: App {

    var body: some Scene {
        WindowGroup {
            NewsView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
