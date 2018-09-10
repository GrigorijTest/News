//
//  NewsDetailModel.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 10.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation

struct NewsDetailModel: Decodable {
    
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case payload
    }
    
    enum ContentKeys: String, CodingKey {
        case content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let contentContainer = try container.nestedContainer(keyedBy: ContentKeys.self, forKey: .payload)
        
        content = try contentContainer.decode(String.self, forKey: .content)
        
    }
}
