//
//  CoreDataProvider.swift
//  TodoApplication
//
//  Created by Mohamed Shafai on 13/05/2025.
//

import Foundation
import CoreData

struct CoreDataProvider {
    let presistentContaner : NSPersistentContainer
    
    var viewContext : NSManagedObjectContext {
        presistentContaner.viewContext
    }
    
    static var preview : CoreDataProvider {
        
        let provider = CoreDataProvider(inMemory: true)
        let viewContext = provider.viewContext
        
        for index in 1..<10 {
            let todo = TodoItem(context: viewContext)
            todo.title = "Todo Item\(index)"
        }
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
        
        return provider
    }
        
    init(inMemory: Bool = false){
        presistentContaner = NSPersistentContainer(name: "CoredataModel")
        
        if inMemory {
            presistentContaner.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        presistentContaner.loadPersistentStores { _, error in
            if let error {
                fatalError("core data loading error\(error)")
            }
        }
    }
}
