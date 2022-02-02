//
//  UsersViewModel.swift
//  MVVM+Combine
//
//  Created by MacBookPro on 01.02.2022.
//

import Foundation
import Combine

enum EndPoint {
    case userFetch
    case commentFetch
    var urlString: String {
        switch self {
        case .userFetch:
            return "https://jsonplaceholder.typicode.com/users"
        case .commentFetch:
            return "https://jsonplaceholder.typicode.com/comments"
        }
    }
}

class UsersViewModel {
    
    private let apiManager: ApiManager
    private let endPoint: EndPoint
    
    var userSubject = PassthroughSubject<[User], Error>()
    
    init(apiManager: ApiManager, endPoint: EndPoint) {
        self.apiManager = apiManager
        self.endPoint = endPoint
    }
    
    func fetchUser() {
        guard let url = URL(string: endPoint.urlString) else { return }
        apiManager.fetchItems(url: url) { [weak self] (result: Result<[User], Error>) in
            switch result {
            case .success(let users):
                self?.userSubject.send(users)
            case .failure(let error):
                self?.userSubject.send(completion: .failure(error))
            }
        }
    }
}
