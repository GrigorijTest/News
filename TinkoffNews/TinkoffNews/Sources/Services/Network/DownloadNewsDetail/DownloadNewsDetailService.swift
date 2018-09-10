//
//  DownloadNewsDetailService.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 10.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation

protocol DownloadNewsDetailService {
    func downloadNews(withId id: String, completionHandler: @escaping (ApiResult<NewsDetailModel>) -> Void)
}
