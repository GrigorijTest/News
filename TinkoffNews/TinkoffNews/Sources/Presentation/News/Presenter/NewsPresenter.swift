 //
//  NewsPresenter.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 09.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation

protocol NewsViewOutput: BaseViewOutput {
    func downloadMoreNews()
}

protocol NewsInteractorOutput: AnyObject {
    func allNewsDidObtain()
    func newsDidObtain(model: NewsModel)
    func updateWithError()
}

final class NewsPresenter {
    
    // MARK: - Properties
    
    weak var view: NewsViewInput?
    var interactor: NewsInteractorInput?
    var router: NewsRouterInput?
    
    private var downloaderCounter = 0
    private var isDownloading = false
    
    private func downloadNews() {
        if isDownloading {
            return
        }
        isDownloading = true
        interactor?.downloadNews(startParametr: downloaderCounter)
        downloaderCounter += 20
    }
    
}


// MARK: - NewsViewOutput
extension NewsPresenter: NewsViewOutput {
    
    func viewIsReady() {
        downloadNews()
    }
    
    func downloadMoreNews() {
        downloadNews()
    }
    
}


// MARK: - NewsInteractorOutput
extension NewsPresenter: NewsInteractorOutput {
    
    func newsDidObtain(model: NewsModel) {
        isDownloading = false
        view?.updateView(withModel: model)
    }
    
    func updateWithError() {
        isDownloading = false
        downloaderCounter -= 20
    }
    
    func allNewsDidObtain() {
        view?.showFooter()
    }
    
}
