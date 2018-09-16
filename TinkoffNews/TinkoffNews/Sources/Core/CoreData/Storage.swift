//
//  Storage.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 16.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation
import CoreData

protocol StorageClient {
    func save(elements: [ItemOfNews])
    func increaseCount(id: String)
    func getNews(id: String) -> CoreDataNews?
}

final class Storage {
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
}


// MARK: - StorageClient
extension Storage: StorageClient {
    
    func save(elements: [ItemOfNews]) {
        guard let context = coreDataStack.saveContext else {
            return
        }
        
        for element in elements {
            _ = CoreDataNews.findOrInsertNews(id: element.id, date: Int64(element.milliseconds), title: element.name, subtitle: element.text, counter: 0, context: context)
        }
        
        
        coreDataStack.performSave(context: context)
    }
    
    func increaseCount(id: String) {
        guard let context = coreDataStack.saveContext else {
            return
        }
        
        guard let news = CoreDataNews.findNews(id: id, context: context) else {
            return
        }
        
        news.counter += 1
        coreDataStack.performSave(context: context)
    }
    
    func getNews(id: String) -> CoreDataNews? {
        guard let context = coreDataStack.saveContext else {
            return nil
        }
        
        guard let news = CoreDataNews.findNews(id: id, context: context) else {
            return nil
        }
        
        return news
    }
    
}
