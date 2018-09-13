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
    func updateDate()
    func openDetailNewsViewController(id: String)
}

protocol NewsInteractorOutput: AnyObject {
    func newsDidObtain(model: [CoreDataNews])
    func updateWithError()
}

final class NewsPresenter {
    
    // MARK: - Properties
    
    weak var view: NewsViewInput?
    var interactor: NewsInteractorInput?
    var router: NewsRouterInput?
    
    private var downloaderCounter = 0
    private var isDownloading = false
    private let paginationStep: Int
    
    
    // MARK: - Init
    
    init(paginationStep: Int) {
        self.paginationStep = paginationStep
    }
    
    
    // MARK: - Private methods
    
    private func downloadNews() {
        if isDownloading {
            return
        }
        isDownloading = true
        interactor?.downloadNews(startParametr: downloaderCounter)
        downloaderCounter += paginationStep
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
    
    func updateDate() {
        downloaderCounter = 0
        downloadNews()
    }
    
    func openDetailNewsViewController(id: String) {
        let newsDetailViewController = NewsDetailAssembly.assemleModule(withId: id)
        router?.showDetailViewController(newsDetailViewController)
        interactor?.updateCounter(withId: id)
    }
    
}


// MARK: - NewsInteractorOutput
extension NewsPresenter: NewsInteractorOutput {
    
    func newsDidObtain(model: [CoreDataNews]) {
        let sortModel = model.sorted { $0.milliseconds > $1.milliseconds }
        isDownloading = false
        view?.updateView(withModel: sortModel)
    }
    
    func updateWithError() {
        isDownloading = false
        downloaderCounter -= paginationStep
        view?.showError()
    }
    
}
