//
//  ItemOfNews.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 09.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation
import CoreData

struct ItemOfNews: Decodable {
    
    let bankInfoTypeId: Int
    let id: String
    let name: String
    let text: String
    let milliseconds: Int
    
    enum CodingKeys: String, CodingKey {
        case bankInfoTypeId
        case id
        case name
        case text
        case publicationDate
    }
    
    enum DateKeys: String, CodingKey {
        case milliseconds
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        bankInfoTypeId = try container.decode(Int.self, forKey: .bankInfoTypeId)
        name = try container.decode(String.self, forKey: .name)
        text = try container.decode(String.self, forKey: .text)
        
        let dateContainer = try container.nestedContainer(keyedBy: DateKeys.self, forKey: .publicationDate)
        
        milliseconds = try dateContainer.decode(Int.self, forKey: .milliseconds)
    }
    
}


// MARK: - CoreData
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
        
        CoreDataClient.save()
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
    
    @discardableResult
    static func updateNews(in context: NSManagedObjectContext, id: String, counter: Int) -> Bool {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Unable to get model")
            return false
        }
        
        guard let fetchRequest = CoreDataNews.fetchRequsetNews(id: id, model: model) else {
            return false
        }
        
        do {
            if let news = try context.fetch(fetchRequest).first {
                news.counter = Int32(counter)
            }
        } catch {
            print("Failed to update News: \(error)")
            return false
        }
        
        CoreDataClient.save()
        return true
    }
    
    // FETCH
    
    static func fetchRequsetNews(id: String, model: NSManagedObjectModel) -> NSFetchRequest<CoreDataNews>? {
        return model.fetchRequestFromTemplate(withName: "FetchNewsWithID", substitutionVariables: ["id" : id]) as? NSFetchRequest<CoreDataNews>
    }
    
    static func fetchRequestStored(model: NSManagedObjectModel) -> NSFetchRequest<CoreDataNews>? {
        return model.fetchRequestTemplate(forName: "FetchNews") as? NSFetchRequest<CoreDataNews>
    }
}
