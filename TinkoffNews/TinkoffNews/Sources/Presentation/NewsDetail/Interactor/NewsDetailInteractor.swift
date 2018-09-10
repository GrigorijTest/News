//
//  NewsDetailInteractor.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 10.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation

protocol NewsDetailInteractorInput {
    func downloadDetailInfo()
}

final class NewsDetailInteractor {
    
    // MARK: - Properties
    
    weak var presenter: NewsDetailInteractorOuput?
    
    private let id: String
    private let downloadService: DownloadNewsDetailService
    
    // MARK: - Initilize

    init(id: String, downloadService: DownloadNewsDetailService) {
        self.id = id
        self.downloadService = downloadService
    }
    
}


// MARK: - NewsDetailInteractorInput
extension NewsDetailInteractor: NewsDetailInteractorInput {
    
    func downloadDetailInfo() {
        downloadService.downloadNews(withId: id) { [weak self] result in
            switch result {
            case .succes(let value):
                self?.presenter?.newsDetailDidObtain(model: value)
            case .failure(_):
                self?.presenter?.updateWithError()
            }
        }
    }
    
}
