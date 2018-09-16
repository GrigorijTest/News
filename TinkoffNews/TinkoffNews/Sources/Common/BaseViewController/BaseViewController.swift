//
//  BaseViewController.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 10.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Properties
    
    var refreshButton: UIButton?
    
    private var refreshLabel: UILabel?
    private var activityIndicator: UIActivityIndicatorView?
    
    
    // MARK: - Initilize methods
    
    func initializeRefreshViews() {
        
        let refreshLabel = UILabel()
        refreshLabel.isHidden = true
        refreshLabel.textAlignment = .center
        refreshLabel.translatesAutoresizingMaskIntoConstraints = false
        refreshLabel.text = "Что-то пошло не так, попробуйте еще раз"
        view.addSubview(refreshLabel)
        refreshLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        refreshLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        refreshLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        refreshLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.refreshLabel = refreshLabel
        
        let refreshButton = UIButton(type: .system)
        refreshButton.isHidden = true
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.layer.cornerRadius = 3
        refreshButton.layer.masksToBounds = true
        refreshButton.layer.borderWidth = 1
        refreshButton.setTitleColor(.black, for: .normal)
        refreshButton.setTitle("Перезагрузить", for: .normal)
        view.addSubview(refreshButton)
        refreshButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        refreshButton.centerYAnchor.constraint(equalTo: refreshLabel.bottomAnchor, constant: 45).isActive = true
        self.refreshButton = refreshButton
        
    }
    
    func initializeIndecator() {
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.activityIndicator = indicator
        
    }
    
    
    // MARK: - Show methods
    
    func stopActivityIndecator() {
        activityIndicator?.stopAnimating()
    }
    
    func showActivityIndicator() {
        refreshButton?.isHidden = true
        refreshLabel?.isHidden = true
        activityIndicator?.startAnimating()
    }
    
    func showErrorScreen() {
        activityIndicator?.stopAnimating()
        refreshButton?.isHidden = false
        refreshLabel?.isHidden = false
    }
    
}
