//
//  Persistence.swift
//  News
//
//  Created by Даниил Циркунов on 02.05.2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "News")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            #if DEBUG
                fatalError("Unresolved error \(error), \(error.userInfo)")
            #else
                print("Unresolved error \(error), \(error.userInfo)")
            #endif
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
