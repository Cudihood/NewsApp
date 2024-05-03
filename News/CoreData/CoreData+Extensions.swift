//
//  CoreData+Extensions.swift
//  News
//
//  Created by Даниил Циркунов on 03.05.2024.
//

import CoreData

extension NSManagedObjectContext {
    func saveContext() {
        guard self.hasChanges else { return }
        do {
            try self.save()
        } catch {
            let nsError = error as NSError
        #if DEBUG
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        #else
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        #endif
        }
    }
}

extension News {
    public var id: UUID {
        get { id_ ?? UUID() }
        set { id_ = newValue }
    }

    static func fetch(predicate: NSPredicate? = nil) -> NSFetchRequest<News> {
        let request = NSFetchRequest<News>(entityName: "News")
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(keyPath: \News.title, ascending: true)]
        return request
    }
}
