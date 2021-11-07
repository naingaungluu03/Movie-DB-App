//
//  CoreDataStack.swift
//  Hello World
//
//  Created by Harry Jason on 21/08/2021.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    let persistentContainer : NSPersistentContainer
    
    var context : NSManagedObjectContext {
        get {
            persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            return persistentContainer.viewContext
        }
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "MovieDB")
        
        persistentContainer.loadPersistentStores { NSEntityDescription, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func saveContext() {
        let context = self.context
        if context.hasChanges {
            do {
                try context.save()
            }
            catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
}
