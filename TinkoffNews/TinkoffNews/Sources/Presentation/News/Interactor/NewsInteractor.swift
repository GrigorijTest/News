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
}

final class NewsInteractor {
    
    // MARK: - Properties
    
    weak var presenter: NewsInteractorOutput?

    let downloadService: DownloadNewsService
    let paginationStep: Int
    
    // MARK: - Init
    
    init(downloadService: DownloadNewsService, paginationStep: Int) {
        self.downloadService = downloadService
        self.paginationStep = paginationStep
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
    
    private func downloadNews(page: Int, completionHandler: @escaping (ApiResult<[CoreDataNews?]>) -> Void)  {
        
        guard let savedContext = CoreDataClient.coreDataStack?.saveContext else {
            return
        }
 
        
        downloadService.downloadNews(startParameter: page, endParameters: page + paginationStep) { result in
            
            switch result {
            case .succes(let value):
                var resultNetworkArray: [CoreDataNews?] = []
                    
                for element in value.payload {
                    resultNetworkArray.append(CoreDataNews.findOrInsertNews(id: element.id, date: Int64(element.milliseconds), title: element.name, subtitle: element.text, counter: 0, context: savedContext))
                }
                
                completionHandler(.succes(resultNetworkArray))
               
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
                case .succes(var value):
                    value = value.compactMap { $0 }
                    DispatchQueue.main.async {
                    self?.presenter?.newsDidObtain(model: value as! [CoreDataNews])
                    }
                case .failure(_): self?.presenter?.updateWithError()
                }
                
            }
            return
        }
        let startIndex = startParametr
        let endIndex = startParametr + paginationStep - 1
        
        var resultArray = [CoreDataNews]()
        
        for index in startIndex..<endIndex {
            resultArray.append(cashArray[index])
        }
        
        presenter?.newsDidObtain(model: resultArray)
        
    }
    
}
