//
//  NewsPresenter.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 09.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation

protocol NewsViewOutput: BaseViewOutput {
    
}

protocol NewsInteractorOutput: AnyObject {
    func newsDidObtain(model: NewsModel)
    func updateWithError()
}

final class NewsPresenter {
    
    // MARK: - Properties
    
    weak var view: NewsViewInput?
    var interactor: NewsInteractorInput?
    var router: NewsRouterInput?
    
}


// MARK: - NewsViewOutput
extension NewsPresenter: NewsViewOutput {
    
    func viewIsReady() {
        interactor?.downloadNews()
    }
}


// MARK: - NewsInteractorOutput
extension NewsPresenter: NewsInteractorOutput {
    
    func newsDidObtain(model: NewsModel) {
        view?.updateView(withModel: model)
    }
    
    func updateWithError() {
    
    }
    
}
