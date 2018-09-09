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
}

final class NewsViewController: UIViewController {

    // MARK: - Properties
    
    var presenter: NewsViewOutput?
    
    private let tableView = UITableView()
    private var viewModel: NewsModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady()
    }

    
    // MARK: - Methods
    
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
    
}


// MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsCell.rowHeight
    }
}


// MARK: - NewsViewInput
extension NewsViewController: NewsViewInput {
    
    func updateView(withModel model: NewsModel) {
        self.viewModel = model 
    }
    
}
