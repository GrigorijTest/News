//
//  BasePresenterInput.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 09.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation

protocol BaseViewOutput: AnyObject {

    func viewIsReady()
    func viewWillAppear()
    func viewDidAppear()
    
}

extension BaseViewOutput {
    
    func viewIsReady() {
        
    }
    
    func viewWillAppear() {
        
    }
    
    func viewDidAppear() {
        
    }
    
}
