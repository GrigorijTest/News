//
//  DownloadNewsServiceImp.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 09.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation

final class DownloadNewsServiceImp {
    
    let networkClient = NetworkClient()
    
}


// MARK: - DownloadNewsService
extension DownloadNewsServiceImp: DownloadNewsService {
    
    func downloadNews(startParameter: Int, endParameters: Int, completionHandler: @escaping (ApiResult<NewsModel>) -> Void) {
        
        networkClient.request(endPoint: "news", urlQuery: ["first" : "\(startParameter)", "last" : "\(endParameters)"], completion: completionHandler)
    }
    
}
