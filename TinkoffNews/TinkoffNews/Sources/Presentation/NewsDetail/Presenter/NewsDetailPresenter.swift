//
//  NewsDetailPresenter.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 10.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation

protocol NewsDetailInteractorOuput: AnyObject {
    func newsDetailDidObtain(model: NewsDetailModel)
    func updateWithError()
}

final class NewsDetailPresenter {
    
    // MARK: - Properties
   
    weak var view: NewsDetailViewInput?
    var interactor: NewsDetailInteractorInput?
    
}


// MARK: - BaseViewOutput
extension NewsDetailPresenter: BaseViewOutput {
    
    func viewIsReady() {
        interactor?.downloadDetailInfo()
    }
    
}


// MARK: - NewsDetailInteractorOuput
extension NewsDetailPresenter: NewsDetailInteractorOuput {
    
    func newsDetailDidObtain(model: NewsDetailModel) {
        view?.updateView(withModel: model)
    }
    
    func updateWithError() {
         view?.showError()
    }
    
}
