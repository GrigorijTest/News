//
//  ItemOfNews.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 09.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation

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
