//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/22.
//

import Foundation
import Combine
import FinanceEntity
import CombineUtil
import MiniSuperApp

public protocol CardOnFileRepository {
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
    func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error> // 비동기일 것을 고려, AnyPublisher로 return
    func fetch()
}


public final class CardOnFileRepositoryImp: CardOnFileRepository {
    
    public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { paymentMethodsSubject }
    private var cancellables: Set<AnyCancellable>
    
    private let paymentMethodsSubject = CurrentValuePublisher<[PaymentMethod]>([
        PaymentMethod(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
        PaymentMethod(id: "0", name: "신한카드", digits: "0987", color: "#3478f6ff", isPrimary: false),
//        PaymentMethod(id: "0", name: "현대카드", digits: "6121", color: "#78c5f5ff", isPrimary: false),
//        PaymentMethod(id: "0", name: "국민은행", digits: "2812", color: "#65c466ff", isPrimary: false),
//        PaymentMethod(id: "0", name: "카카오뱅크", digits: "8751", color: "#ffcc00ff", isPrimary: false),
    ])
    
    public func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error> {
        let request = AddCardRequest(baseURL: BaseURL, info: info)
        
        return network.send(request).map(\.ouput.card).eraseToAnyPublisher()
            .map(\.output.card)
            .handleEvents(
                receiveSubscription: nil,
                receiveOutput: { [weak self] method in
                    guard let this = self else {
                        return
                    }
                    
                    this.paymentMethodsSubject.send(this.paymentMethodsSubject.value + [method])
                },
                receiveCompletion: nil,
                receiveCancel: nil,
                receiveRequest: nil
            )
            .eraseToAnyPublisher()
        /*
        let paymentMethod = PaymentMethod(
            id: "00",
            name: "New Card",
            digits: "\(info.number.suffix(4))",
            color: "",
            isPrimary: false
        )
        
        // 카드 리스트(subject) update
        var new = paymentMethodsSubject.value
        new.append(paymentMethod)
        paymentMethodsSubject.send(new)
        
        return Just(paymentMethod).setFailureType(to: Error.self).eraseToAnyPublisher()*/
    }
    
    public func fetch() {
        let request = CardOnFileRequest(BaseURL: baseURL)
        network.send(request).map(\.output.cards)
            .sink(receiveCompletion: {_ in },
                  receiveValue: {[weak self] cards in
                self.paymentMethodsSubject.send(cards)
                
            }).store(in: &cancellables)
    }
    private let network: Network
    private let baseURL: URL
    
    public init(network: Network, baseURL: URL) {
        self.network = network
        self.baseURL = baseURL
        self.cancellables = .init()
    }
}
