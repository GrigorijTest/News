//
//  NewsDetailAssembly.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 10.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import UIKit

final class NewsDetailAssembly {
    
    class func assemleModule(withId id: String) -> UIViewController {
        
        let view = NewsDetailViewController()
        let presenter = NewsDetailPresenter()
        let interactor = NewsDetailInteractor(id: id, downloadService: DownloadNewsDetailServiceImp())
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
}
