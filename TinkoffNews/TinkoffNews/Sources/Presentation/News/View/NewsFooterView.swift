//
//  NewsFooterView.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 10.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import UIKit

final class NewsFooterView: UIView {
    
    // MARK: - Properties
    
    private let titleLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        drawSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions method 
    
    func startDownload() {
        activityIndicator.startAnimating()
        titleLabel.isHidden = true
    }
    
    func stopDownload() {
        activityIndicator.stopAnimating()
        titleLabel.isHidden = true
    }
    
    func showErrorFooter() {
        activityIndicator.stopAnimating()
        titleLabel.text = "При загрузке данных произошла ошибка"
        titleLabel.isHidden = false
    }
    
    
    // MARK: - Private methods
    
    private func drawSelf() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.isHidden = true
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
