//
//  ViewController.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 07.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import UIKit

protocol NewsViewInput: AnyObject {
    func updateView(withModel model: NewsModel)
    func showFooter() 
}

final class NewsViewController: UIViewController {

    // MARK: - Properties
    
    var presenter: NewsViewOutput?
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private var viewModel: NewsModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        activityIndicator.startAnimating()
        presenter?.viewIsReady()
    }

    
    // MARK: - Methods
    
    func setup() {
        self.title = "Новости"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9960784314, green: 0.8705882353, blue: 0.1647058824, alpha: 1)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.isHidden = false
    }
    
}


// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.payload.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel?.payload[indexPath.row] else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)
        (cell as? Setupable)?.setup(model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (viewModel?.payload.count)! - 1 {
            presenter?.downloadMoreNews()
        
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
        }
    }
    
}


// MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsCell.rowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsCell.rowHeight
    }
    
}


// MARK: - NewsViewInput
extension NewsViewController: NewsViewInput {
    
    func updateView(withModel model: NewsModel) {
        if self.viewModel == nil {
            self.viewModel = model
            activityIndicator.stopAnimating()
        } else {
            self.viewModel?.payload.append(contentsOf: model.payload)
        }
    }
    
    func showFooter() {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Все новости загружены"
        self.tableView.tableFooterView = label
        self.tableView.tableFooterView?.isHidden = false
    }
    
}
