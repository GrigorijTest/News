//
//  DownloadNewsDetailServiceImp.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 10.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation

final class DownloadNewsDetailServiceImp {
    
    let networkClient = NetworkClient()
    
}


// MARK: - DownloadNewsDetailService
extension DownloadNewsDetailServiceImp: DownloadNewsDetailService {
    
    func downloadNews(withId id: String, completionHandler: @escaping (ApiResult<NewsDetailModel>) -> Void) {
        networkClient.request(endPoint: "news_content", urlQuery: ["id" : id], completion: completionHandler)
    }
    
}
