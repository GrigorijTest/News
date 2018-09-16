//
//  ViewController.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 07.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import UIKit

protocol NewsViewInput: AnyObject {
    func updateView(withModel model: [ItemOfNews])
    func updateCell(withNews news: ItemOfNews, andIndexPath indexPath: IndexPath)
    func showError()
}

final class NewsViewController: BaseViewController {

    // MARK: - Properties
    
    var presenter: NewsViewOutput?
    
    private let tableView = UITableView()
    private let tableViewRefreshControl = UIRefreshControl()
    private let footer = NewsFooterView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120))
    
    private var viewModel: [ItemOfNews]? = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        showActivityIndicator()
        presenter?.viewIsReady()
    }

    
    // MARK: - Methods
    
    private func setup() {
        title = "Новости"
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
    
        initializeIndecator()
        initializeRefreshViews()
        
        refreshButton?.addTarget(self, action: #selector(download), for: .touchUpInside)
        
        tableViewRefreshControl.tintColor = #colorLiteral(red: 0.9960784314, green: 0.8705882353, blue: 0.1647058824, alpha: 1)
        tableViewRefreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.addSubview(tableViewRefreshControl)
    }
    
    
    // MARK: - Action
    
    @objc private func download() {
        viewModel = nil
        presenter?.updateData()
        showActivityIndicator()
    }
    
    @objc private func handleRefresh() {
        viewModel = nil
        presenter?.updateData()
        tableViewRefreshControl.endRefreshing()
    }
    
}


// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel?[indexPath.row] else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)
        (cell as? Setupable)?.setup(model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModelCount = viewModel?.count else {
            return
        }
        
        if indexPath.row == viewModelCount - 1 {
            footer.startDownload()
            presenter?.downloadMoreNews()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footer
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = viewModel?[indexPath.row].id else {
            return
        }
        
        presenter?.openDetailNewsViewController(id: model, indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


// MARK: - NewsViewInput
extension NewsViewController: NewsViewInput {
    
    func updateView(withModel model: [ItemOfNews]) {
        if self.viewModel == nil {
            self.viewModel = model
        } else {
            self.viewModel?.append(contentsOf: model)
        }
        stopActivityIndecator()
        footer.stopDownload()
    }
    
    func showError() {
        if viewModel != nil {
            footer.isHidden = false
            footer.showErrorFooter()
        } else {
            footer.isHidden = true
            showErrorScreen()
        }
    }
    
    func updateCell(withNews news: ItemOfNews, andIndexPath indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        viewModel?[indexPath.row] = news
        (cell as? Setupable)?.setup(news)
        tableView.reloadRows(at: [indexPath], with: .middle)
    }
    
    
}
