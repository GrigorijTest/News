//
//  NewsInteractor.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 09.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation

protocol NewsInteractorInput {
    func downloadNews()
}

final class NewsInteractor {
    
    // MARK: - Properties
    
    weak var presenter: NewsInteractorOutput?
    
    let downloadService: DownloadNewsService
    
    
    // MARK: - Init
    
    init(downloadService: DownloadNewsService) {
        self.downloadService = downloadService
    }
    
}


// MARK: - NewsInteractor
extension NewsInteractor: NewsInteractorInput {
    
    func downloadNews() {
        downloadService.downloadNews() { [weak self] result in
            switch result {
            case .succes(let value):
                self?.presenter?.newsDidObtain(model: value)
            case .failure(_):
                self?.presenter?.updateWithError()
            }
        }
    }
    
}
