//
//  NewsRouter.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 09.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import UIKit

protocol NewsRouterInput {
    func showDetailViewController(_ view: UIViewController)
}

final class NewsRouter {
    
    weak var transition: UIViewController?
    
}


// MARK: - NewsRouterInput
extension NewsRouter: NewsRouterInput {
    
    func showDetailViewController(_ view: UIViewController) {
        transition?.navigationController?.pushViewController(view, animated: true)
    }
    
}
