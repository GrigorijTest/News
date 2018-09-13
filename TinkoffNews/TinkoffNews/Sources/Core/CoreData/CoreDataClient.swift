//
//  CoreDataClient.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 12.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataClient {
    
    private static var _coreDataStack: CoreDataStack?
    static var coreDataStack: CoreDataStack? {
        if _coreDataStack == nil {
            _coreDataStack = CoreDataStack()
        }
        
        return _coreDataStack
    }
    
    
    static func save() {
        guard let context = self.coreDataStack?.saveContext else {
            return
        }
        coreDataStack?.performSave(context: context)
    }
    
}
