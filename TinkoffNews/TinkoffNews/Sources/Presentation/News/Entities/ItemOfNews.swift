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
    var counter: Int32 = 0
    
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
    
    init(bankInfoTypeId: Int, id: String, name: String, text: String, milliseconds: Int, counter: Int32) {
        self.bankInfoTypeId = bankInfoTypeId
        self.id = id
        self.name = name
        self.text = text
        self.milliseconds = milliseconds
        self.counter = counter
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
