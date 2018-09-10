//
//  NewsInteractor.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 09.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation

protocol NewsInteractorInput {
    func downloadNews(startParametr: Int)
    func updateDate()
}

final class NewsInteractor {
    
    // MARK: - Properties
    
    weak var presenter: NewsInteractorOutput?

    let downloadService: DownloadNewsService
    let paginationStep: Int
    
    
    // MARK: - Init
    
    init(downloadService: DownloadNewsService, paginationStep: Int) {
        self.downloadService = downloadService
        self.paginationStep = paginationStep
    }
    
}


// MARK: - NewsInteractor
extension NewsInteractor: NewsInteractorInput {
    
    func updateDate() {
        downloadService.downloadNews(startParameter: 0, endParameters: 20) { [weak self] result in
            
            switch result {
            case .succes(let value):
                self?.presenter?.newsDidObtain(model: value)
            case .failure(_):
                self?.presenter?.updateWithError()
            }
            
        }
    }
    
    func downloadNews(startParametr: Int) {
        downloadService.downloadNews(startParameter: startParametr,
                                     endParameters: startParametr + paginationStep) { [weak self] result in
                                        
            switch result {
            case .succes(let value):
                self?.presenter?.newsDidObtain(model: value)
            case .failure(_):
                self?.presenter?.updateWithError()
            }
                                        
        }
    }
    
}
