//
//  CoreDataStack.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 11.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    //static let sharedInstance: CoreDataStack = CoreDataStack()
    
    private var storeURL: URL {
        let documentsDirURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirURL.appendingPathComponent("Store.sqlite")
        
        return url
    }
    
    private let managedObjectModelName = "TinkoffNews"
    private var _managedObjectModel: NSManagedObjectModel?
    private var managedObjectModel: NSManagedObjectModel? {
        if _managedObjectModel == nil {
            guard let modelURL = Bundle.main.url(forResource: managedObjectModelName, withExtension: "momd") else {
                print("Empty model url!")
                return nil
            }
            
            _managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        }
        
        return _managedObjectModel
    }
    
    private var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        if _persistentStoreCoordinator == nil {
            guard let model = self.managedObjectModel else {
                print("Empty managed object model")
                return nil
            }
            
            _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
            
            do {
                try _persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                assert(false, "Error adding persistent store to coordinator: \(error)")
            }
        }
        
        return _persistentStoreCoordinator
    }
    
    private var _masterContext: NSManagedObjectContext?
    private var masterContext: NSManagedObjectContext? {
        if _masterContext == nil {
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            guard let persistentStoreCoordinator = self.persistentStoreCoordinator else {
                print("Empty persistent store coordinator")
                return nil
            }
            
            context.persistentStoreCoordinator = persistentStoreCoordinator
            context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            context.undoManager = nil
            _masterContext = context
        }
        
        return _masterContext
    }
    
    private var _mainContext: NSManagedObjectContext?
    public var mainContext: NSManagedObjectContext? {
        if _mainContext == nil {
            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            guard let parentContext = self.masterContext else {
                print("No master context")
                return nil
            }
            
            context.parent = parentContext
            context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            context.undoManager = nil
            _mainContext = context
        }
        
        return _mainContext
    }
    
    private var _saveContext: NSManagedObjectContext?
    public var saveContext: NSManagedObjectContext? {
        if _saveContext == nil {
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            guard let parentContext = self.mainContext else {
                print("No main context")
                return nil
            }
            
            context.parent = parentContext
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            context.undoManager = nil
            _saveContext = context
        }
        
        return _saveContext
    }
    
    func performSave(context: NSManagedObjectContext) {
        
        if context.hasChanges {
            context.perform { [weak self] in
                do {
                    try context.save()
                } catch {
                    print("Context save error: \(error)")
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent)
                }
                
            }
        }
        
    }
}
