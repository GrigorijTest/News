//
//  NewsInteractor.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 09.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation
import CoreData

protocol NewsInteractorInput {
    func downloadNews(startParametr: Int)
    func updateCounter(withId id: String, andIndexpath indexPath: IndexPath)
}

final class NewsInteractor {
    
    // MARK: - Properties
    
    weak var presenter: NewsInteractorOutput?

    let downloadService: DownloadNewsService
    let paginationStep: Int
    let storage: StorageClient
    
    
    // MARK: - Init
    
    init(downloadService: DownloadNewsService, paginationStep: Int, storage: StorageClient) {
        self.downloadService = downloadService
        self.paginationStep = paginationStep
        self.storage = storage
    }
    
    
    // MARK: - Private methods
    
    private func obtainСachingData() -> [CoreDataNews]? {
        
        guard let saveContext = CoreDataClient.coreDataStack?.mainContext else {
            return nil
        }
        
        if let model = saveContext.persistentStoreCoordinator?.managedObjectModel {
            do {
                
                guard let allStoredNewsRequest = CoreDataNews.fetchRequestStored(model: model) else {
                    return nil
                }
                
                let cashData = try saveContext.fetch(allStoredNewsRequest)
                
                return cashData.sorted { $0.milliseconds > $1.milliseconds }
            } catch {
                return nil
            }
        } else {
            return nil
        }
        
    }
    
    private func downloadNews(page: Int, completionHandler: @escaping (ApiResult<[ItemOfNews]>) -> Void)  {
        
        downloadService.downloadNews(startParameter: page, endParameters: page + paginationStep) { [weak self] result in
            
            switch result {
            case .succes(let value):
                self?.storage.save(elements: value.payload)
                
                completionHandler(.succes(value.payload))
               
            case .failure(_):
                 completionHandler(.failure(.connectionError))
            }
                
            
            
        }
        
    }
    
}


// MARK: - NewsInteractor
extension NewsInteractor: NewsInteractorInput {
    
    func downloadNews(startParametr: Int) {
        
        let cashData = obtainСachingData()
        
        guard var cashArray = cashData , cashArray.count >= startParametr + paginationStep - 1 else {
            downloadNews(page: startParametr) { [weak self] result in
                
                switch result {
                case .succes(let  value):
                    DispatchQueue.main.async {
                    self?.presenter?.newsDidObtain(model: value)
                    }
                case .failure(_): self?.presenter?.updateWithError()
                }
                
            }
            return
        }
        
        let startIndex = startParametr
        let endIndex = startParametr + paginationStep - 1
        
        var resultArray = [ItemOfNews]()
        
        for index in startIndex..<endIndex {
            let cashItem = cashArray[index]
            guard let id = cashItem.id,
                  let title = cashItem.title,
                  let text = cashItem.subtitle else {
                    continue
                  }
            
            let newsItem = ItemOfNews(bankInfoTypeId: 1, id: id, name: title, text: text, milliseconds: Int(cashItem.milliseconds), counter: cashItem.counter)
            resultArray.append(newsItem)
        }
        
        presenter?.newsDidObtain(model: resultArray)
        
    }
    
    func updateCounter(withId id: String, andIndexpath indexPath: IndexPath) {
        storage.increaseCount(id: id)
        let updateNews = storage.getNews(id: id)
        guard let id = updateNews?.id,
              let name = updateNews?.title,
              let text = updateNews?.subtitle,
              let counter = updateNews?.counter else {
                return
        }
        
        let news = ItemOfNews(bankInfoTypeId: 1, id: id, name: name, text: text, milliseconds: Int(updateNews?.milliseconds ?? 0), counter: counter)
        presenter?.didObtainNews(news, indexPath: indexPath)
    }
    
}
