//
//  ApiManager.swift
//  MVVM+Combine
//
//  Created by MacBookPro on 01.02.2022.
//
import Foundation
import Combine

class ApiManager {
    
    private var subscribers = Set<AnyCancellable>()
    
    func fetchItems<T: Decodable>(url: URL, completion: @escaping (Result<[T], Error>)-> Void) {
        URLSession.shared.dataTaskPublisher(for: url)
            .map{ $0.data }
            .decode(type: [T].self, decoder: JSONDecoder())
            .sink { resultCompletion in
                switch resultCompletion {
                case .finished:
                    break
                case .failure(let error):
                    completion(.failure(error))
                }
            } receiveValue: { resultArray in
                completion(.success(resultArray))
            }.store(in: &subscribers)
    }
}
