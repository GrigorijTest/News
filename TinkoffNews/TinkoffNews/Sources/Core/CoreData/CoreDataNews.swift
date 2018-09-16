//
//  CoreDataNews.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 16.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation
import CoreData

extension CoreDataNews {
    
    static func findOrInsertNews(id: String, date: Int64, title: String, subtitle: String, counter: Int32, context: NSManagedObjectContext) -> CoreDataNews? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            return nil
        }
        
        var news: CoreDataNews?
        guard let fetchRequest = CoreDataNews.fetchRequsetNews(id: id, model: model) else {
            return nil
        }
        
        do {
            if let obtainNews = try context.fetch(fetchRequest).first {
                news = obtainNews
            } else {
                news = insertItemNews(id: id, date: date, title: title, subtitle: subtitle, counter: counter, context: context)
            }
        } catch {
            return nil
        }
        
        return news
    }
    
    static func insertItemNews(id: String, date: Int64, title: String, subtitle: String, counter: Int32, context: NSManagedObjectContext) -> CoreDataNews? {
        if let news = NSEntityDescription.insertNewObject(forEntityName: "CoreDataNews", into: context) as? CoreDataNews {
            news.id = id
            news.milliseconds = date
            news.title = title
            news.subtitle = subtitle
            news.counter = 0
            
            return news
        } else {
            return nil
        }
    }
    
    static func findNews(id: String, context: NSManagedObjectContext) -> CoreDataNews? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("problem with context")
            return nil
        }
        
        var news: CoreDataNews?
        
        guard let request =  CoreDataNews.fetchRequsetNews(id: id, model: model) else {
            return nil
        }
        
        do {
            let results = try context.fetch(request)
            if let resultNews = results.first {
                news = resultNews
            }
        } catch {
            print("Error is \(error)")
        }
        
        return news
    }
    
    // FETCH
    
    static func fetchRequsetNews(id: String, model: NSManagedObjectModel) -> NSFetchRequest<CoreDataNews>? {
        return model.fetchRequestFromTemplate(withName: "FetchNewsWithID", substitutionVariables: ["id" : id]) as? NSFetchRequest<CoreDataNews>
    }
    
    static func fetchRequestStored(model: NSManagedObjectModel) -> NSFetchRequest<CoreDataNews>? {
        return model.fetchRequestTemplate(forName: "FetchNews") as? NSFetchRequest<CoreDataNews>
    }
    
}
