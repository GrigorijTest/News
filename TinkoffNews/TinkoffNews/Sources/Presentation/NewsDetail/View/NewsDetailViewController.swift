//
//  NewsDetailViewController.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 10.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import UIKit

protocol NewsDetailViewInput: AnyObject {
    func updateView(withModel model: NewsDetailModel)
    func showError()
}

final class NewsDetailViewController: BaseViewController {
    
    // MARK: - Initilize
    
    var presenter: BaseViewOutput?
    
    private var textField = UITextView()
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady()
        showActivityIndicator()
    }
    
    
    // MARK: - Private methods
    
    private func setup() {
        title = "Детали новости"
        navigationController?.navigationBar.tintColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        textField.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        initializeIndecator()
        initializeRefreshViews()
        refreshButton?.addTarget(self, action: #selector(download), for: .touchUpInside)
    }
    
    // MARK: - Action
    
    @objc private func download() {
        presenter?.viewIsReady()
        showActivityIndicator()
    }
    
}


// MARK: - NewsDetailViewInput
extension NewsDetailViewController: NewsDetailViewInput {
    
    func updateView(withModel model: NewsDetailModel) {
        textField.text = model.content
        stopActivityIndecator()
    }
    
    func showError() {
        showErrorScreen()
    }
    
}
