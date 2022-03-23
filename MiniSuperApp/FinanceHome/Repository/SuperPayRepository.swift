//
//  SuperPayRepository.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/23.
//

import Foundation
import Combine

protocol SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error>
}

final class SuperPayRepositoryImp: SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> { balaceSubject }
    private let balaceSubject = CurrentValuePublisher<Double>(0)
    
    // backend api 흉내내고자, delay를 둠
    func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            self?.bgQueue.async {
                Thread.sleep(forTimeInterval: 2)
                promise(.success(()))
                // balance update 
                let newBalance = (self?.balaceSubject.value).map { $0 + amount }
                newBalance.map { self?.balaceSubject.send($0) }
            }
        }.eraseToAnyPublisher()
    }
    
    private let bgQueue = DispatchQueue(label: "topup.repository.queue")
}
