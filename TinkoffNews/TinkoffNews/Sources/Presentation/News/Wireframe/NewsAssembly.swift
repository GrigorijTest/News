//
//  NewsAssembly.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 09.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import UIKit

final class NewsAssembly {
    
    class func assembleModule() -> UIViewController {
        
        let paginationStep = 20
        let storage = Storage(coreDataStack: CoreDataStack())
        
        let view = NewsViewController()
        let presenter = NewsPresenter(paginationStep: paginationStep)
        let interactor = NewsInteractor(downloadService: DownloadNewsServiceImp(), paginationStep: paginationStep, storage: storage)
        let router = NewsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.transition = view 
        
        return view
    }
    
}
