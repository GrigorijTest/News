//
//  DownloadNewsService.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 09.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation

protocol DownloadNewsService {
    func downloadNews(startParameter: Int, endParameters: Int, completionHandler: @escaping (ApiResult<NewsModel>) -> Void)
}
