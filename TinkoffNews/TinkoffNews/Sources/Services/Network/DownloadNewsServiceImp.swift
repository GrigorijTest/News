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
    
    func downloadNews(completionHandler: @escaping (ApiResult<NewsModel>) -> Void) {
        networkClient.request(endPoint: "news?first=0&last=20", completion: completionHandler)
    }
    
}
