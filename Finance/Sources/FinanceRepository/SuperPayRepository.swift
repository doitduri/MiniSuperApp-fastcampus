//
//  SuperPayRepository.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/23.
//

import Foundation
import Combine
import CombineUtil
import Network

public protocol SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error>
}

public final class SuperPayRepositoryImp: SuperPayRepository {

    public var balance: ReadOnlyCurrentValuePublisher<Double> { balaceSubject }
    private let balaceSubject = CurrentValuePublisher<Double>(0)
    
    public func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error> {
        let request = TopupRequest(baseURL: baseURL, amount: amount, paymentMethodID: paymentMethodID)
        return network.send(request)
            .handleEvents(
                receiveSubscription: nil,
                receiveOutput: { [weak self] _ in
                    let newBalance = (self?.balaceSubject.value).map { $0 + amount }
                    newBalance.map { self?.balaceSubject.send($0) }
            },
                receiveCompletion: nil,
                receiveCancel: nil,
                receiveRequest: nil
            )
            .map( { _ in })
            .eraseToAnyPublisher()
    }
    
    /* backend api 흉내내고자, delay를 둠
    public func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            self?.bgQueue.async {
                Thread.sleep(forTimeInterval: 2)
                promise(.success(()))
                // balance update 
                let newBalance = (self?.balaceSubject.value).map { $0 + amount }
                newBalance.map { self?.balaceSubject.send($0) }
            }
        }.eraseToAnyPublisher()
    }*/
    
    private let bgQueue = DispatchQueue(label: "topup.repository.queue")
    
    private let network: Network
    private let baseURL: URL
    
    public init(network: Network, baseURL: URL) {
        self.network = network
        self.baseURL = baseURL
    }
}
